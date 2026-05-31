import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:med_line/features/auth/presentation/providers/auth_provider.dart';

void main() {
  test('remote login works for known user', () async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final container = ProviderContainer();
    addTearDown(container.dispose);

    final loginUseCase = container.read(loginUserUseCaseProvider);
    final user = await loginUseCase.call('selam@gmail.com', 'seli2123');

    expect(user, isNotNull);
    expect(user!.email, 'selam@gmail.com');
  }, timeout: const Timeout(Duration(seconds: 30)));
}
