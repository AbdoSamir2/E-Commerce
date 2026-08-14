import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:e_commerce_project/app.dart';
import 'package:e_commerce_project/core/api/api_client.dart';
import 'package:e_commerce_project/core/storage/local_storage_service.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  testWidgets('app starts on the splash route', (tester) async {
    await tester.pumpWidget(
      EcommerceApp(
        apiClient: MockApiClient(),
        localStorageService: MockLocalStorageService(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Splash'), findsWidgets);
  });
}
