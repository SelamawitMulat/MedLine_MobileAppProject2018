import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/core/network/api_client.dart';
import 'package:med_line/core/database/app_database.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());
final appDatabaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
