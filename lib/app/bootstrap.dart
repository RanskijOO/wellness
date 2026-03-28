import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'providers.dart';
import '../core/config/app_environment.dart';
import '../core/services/app_services.dart';

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppEnvironment environment = await AppEnvironment.load();
  final SharedPreferences preferences = await SharedPreferences.getInstance();
  const FlutterSecureStorage secureStorage = FlutterSecureStorage();

  SupabaseClient? supabaseClient;
  if (environment.shouldEnableSupabase) {
    await Supabase.initialize(
      url: environment.supabaseUrl,
      anonKey: environment.supabaseAnonKey,
    );
    supabaseClient = Supabase.instance.client;
  }

  final AppServices services = await AppServices.create(environment);

  runApp(
    ProviderScope(
      overrides: [
        appEnvironmentProvider.overrideWithValue(environment),
        appServicesProvider.overrideWithValue(services),
        sharedPreferencesProvider.overrideWithValue(preferences),
        secureStorageProvider.overrideWithValue(secureStorage),
        supabaseClientProvider.overrideWithValue(supabaseClient),
      ],
      child: const AloeWellnessCoachApp(),
    ),
  );
}
