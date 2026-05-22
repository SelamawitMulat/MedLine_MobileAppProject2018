import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';
import 'package:med_line/features/auth/data/auth_repository.dart';

final doctorNameProvider = Provider<String>((ref) {
  final user = ref.watch(authProvider).value;
  return user?.name ?? "Doctor";
});

final doctorDeleteProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final repo = ref.read(authRepositoryProvider);
    await repo.deleteAccount();
  };
});