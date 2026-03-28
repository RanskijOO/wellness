import '../../plans/domain/plan_models.dart';
import '../../products/domain/product_models.dart';
import '../../profile/domain/profile_models.dart';
import '../../trackers/domain/tracker_models.dart';

class DashboardSnapshot {
  const DashboardSnapshot({
    required this.profile,
    required this.activePlan,
    required this.todaysLog,
    required this.progress,
    required this.recommendedProducts,
    required this.highlightMessage,
  });

  final UserProfile profile;
  final WellnessPlan activePlan;
  final DailyLog todaysLog;
  final ProgressSnapshot progress;
  final List<Product> recommendedProducts;
  final String highlightMessage;
}
