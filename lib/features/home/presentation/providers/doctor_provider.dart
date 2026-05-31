import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';

final doctorNameProvider = Provider<String>((ref) {
  final user = ref.watch(authProvider).value;
  return user?.name ?? "Doctor";
});

final doctorIdProvider = Provider<String>((ref) {
  final user = ref.watch(authProvider).value;
  if (user != null && user.role.toLowerCase() == 'doctor') {
    return user.id;
  }
  final doctorName = ref.watch(doctorNameProvider);
  final normalized = doctorName
      .replaceFirst(RegExp(r'^dr\.?\s*', caseSensitive: false), '')
      .trim()
      .toLowerCase();
  return md5.convert(utf8.encode(normalized)).toString();
});

final doctorDeleteProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    await ref.read(deleteAccountUseCaseProvider).call();
  };
});
