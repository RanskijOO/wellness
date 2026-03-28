class ChecklistItem {
  const ChecklistItem({
    required this.id,
    required this.label,
    required this.isCompleted,
  });

  final String id;
  final String label;
  final bool isCompleted;

  ChecklistItem copyWith({String? id, String? label, bool? isCompleted}) {
    return ChecklistItem(
      id: id ?? this.id,
      label: label ?? this.label,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'isCompleted': isCompleted,
    };
  }

  static ChecklistItem fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      isCompleted: json['isCompleted'] as bool? ?? false,
    );
  }
}

class WellnessPlanDay {
  const WellnessPlanDay({
    required this.dayNumber,
    required this.title,
    required this.hydrationTask,
    required this.wellnessAction,
    required this.journalPrompt,
    required this.checklist,
    required this.suggestedProductIds,
  });

  final int dayNumber;
  final String title;
  final String hydrationTask;
  final String wellnessAction;
  final String journalPrompt;
  final List<ChecklistItem> checklist;
  final List<String> suggestedProductIds;

  WellnessPlanDay copyWith({
    int? dayNumber,
    String? title,
    String? hydrationTask,
    String? wellnessAction,
    String? journalPrompt,
    List<ChecklistItem>? checklist,
    List<String>? suggestedProductIds,
  }) {
    return WellnessPlanDay(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      hydrationTask: hydrationTask ?? this.hydrationTask,
      wellnessAction: wellnessAction ?? this.wellnessAction,
      journalPrompt: journalPrompt ?? this.journalPrompt,
      checklist: checklist ?? this.checklist,
      suggestedProductIds: suggestedProductIds ?? this.suggestedProductIds,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'dayNumber': dayNumber,
      'title': title,
      'hydrationTask': hydrationTask,
      'wellnessAction': wellnessAction,
      'journalPrompt': journalPrompt,
      'checklist': checklist
          .map((ChecklistItem item) => item.toJson())
          .toList(),
      'suggestedProductIds': suggestedProductIds,
    };
  }

  static WellnessPlanDay fromJson(Map<String, dynamic> json) {
    return WellnessPlanDay(
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 1,
      title: json['title']?.toString() ?? '',
      hydrationTask: json['hydrationTask']?.toString() ?? '',
      wellnessAction: json['wellnessAction']?.toString() ?? '',
      journalPrompt: json['journalPrompt']?.toString() ?? '',
      checklist: (json['checklist'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                ChecklistItem.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      suggestedProductIds:
          (json['suggestedProductIds'] as List<dynamic>? ?? <dynamic>[])
              .map((dynamic item) => item.toString())
              .toList(),
    );
  }
}

class WellnessPlan {
  const WellnessPlan({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.goalKeys,
    required this.startDate,
    required this.days,
  });

  final String id;
  final String title;
  final String description;
  final int durationDays;
  final List<String> goalKeys;
  final DateTime startDate;
  final List<WellnessPlanDay> days;

  double get adherenceScore {
    final int totalChecklist = days.fold<int>(
      0,
      (int value, WellnessPlanDay day) => value + day.checklist.length,
    );
    if (totalChecklist == 0) {
      return 0;
    }
    final int completedChecklist = days.fold<int>(
      0,
      (int value, WellnessPlanDay day) =>
          value +
          day.checklist.where((ChecklistItem item) => item.isCompleted).length,
    );
    return completedChecklist / totalChecklist;
  }

  int get completedDaysCount => days
      .where(
        (WellnessPlanDay day) =>
            day.checklist.isNotEmpty &&
            day.checklist.every((ChecklistItem item) => item.isCompleted),
      )
      .length;

  WellnessPlan copyWith({
    String? id,
    String? title,
    String? description,
    int? durationDays,
    List<String>? goalKeys,
    DateTime? startDate,
    List<WellnessPlanDay>? days,
  }) {
    return WellnessPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      durationDays: durationDays ?? this.durationDays,
      goalKeys: goalKeys ?? this.goalKeys,
      startDate: startDate ?? this.startDate,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'durationDays': durationDays,
      'goalKeys': goalKeys,
      'startDate': startDate.toIso8601String(),
      'days': days.map((WellnessPlanDay item) => item.toJson()).toList(),
    };
  }

  static WellnessPlan fromJson(Map<String, dynamic> json) {
    return WellnessPlan(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      durationDays: (json['durationDays'] as num?)?.toInt() ?? 7,
      goalKeys: (json['goalKeys'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(),
      startDate:
          DateTime.tryParse(json['startDate']?.toString() ?? '') ??
          DateTime.now(),
      days: (json['days'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                WellnessPlanDay.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}
