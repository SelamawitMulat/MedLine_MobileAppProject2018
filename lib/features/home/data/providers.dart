import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/core/providers.dart';
import 'package:med_line/features/home/data/datasources/home_local_datasource.dart';
import 'package:med_line/features/home/data/datasources/home_remote_datasource.dart';
import 'package:med_line/features/home/data/datasources/visit_summary_local_datasource.dart';
import 'package:med_line/features/home/data/datasources/visit_summary_remote_datasource.dart';
import 'package:med_line/features/home/data/repositories_impl/home_repository.dart';
import 'package:med_line/features/home/data/repositories_impl/visit_summary_repository.dart';
import 'package:med_line/features/home/domain/repositories/home_repository.dart';
import 'package:med_line/features/home/domain/repositories/visit_summary_repository.dart';

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSource(ref.watch(apiClientProvider));
});

final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSource(ref.watch(appDatabaseProvider));
});

final homeRepositoryProvider = Provider<IHomeRepository>((ref) {
  return HomeRepository(
    remote: ref.watch(homeRemoteDataSourceProvider),
    local: ref.watch(homeLocalDataSourceProvider),
  );
});

final visitSummaryLocalDataSourceProvider =
    Provider<VisitSummaryLocalDataSource>((ref) {
  return VisitSummaryLocalDataSource(ref.watch(appDatabaseProvider));
});

final visitSummaryRemoteDataSourceProvider =
    Provider<VisitSummaryRemoteDataSource>((ref) {
  return VisitSummaryRemoteDataSource(ref.watch(apiClientProvider));
});

final visitSummaryRepositoryProvider = Provider<IVisitSummaryRepository>((ref) {
  return VisitSummaryRepository(
    local: ref.watch(visitSummaryLocalDataSourceProvider),
    remote: ref.watch(visitSummaryRemoteDataSourceProvider),
  );
});
