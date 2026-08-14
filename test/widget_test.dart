import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:e_commerce_project/app.dart';
import 'package:e_commerce_project/core/api/api_client.dart';
import 'package:e_commerce_project/core/constants/storage_keys.dart';
import 'package:e_commerce_project/core/storage/local_storage_service.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  testWidgets('unauthenticated app opens the login screen', (tester) async {
    final localStorageService = MockLocalStorageService();
    when(
      () => localStorageService.getString(StorageKeys.authToken),
    ).thenAnswer((_) async => null);

    await tester.pumpWidget(
      EcommerceApp(
        apiClient: MockApiClient(),
        localStorageService: localStorageService,
      ),
    );

    expect(find.text('E-Commerce App v1.0'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN'), findsOneWidget);
    verify(
      () => localStorageService.getString(StorageKeys.authToken),
    ).called(1);
  });
}
