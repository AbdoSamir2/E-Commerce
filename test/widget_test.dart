import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:e_commerce_project/app.dart';
import 'package:e_commerce_project/core/storage/local_storage_service.dart';

class MockLocalStorageService extends Mock implements LocalStorageService {}

void main() {
  testWidgets('unauthenticated app opens the login screen', (tester) async {
    await tester.pumpWidget(
      EcommerceApp(localStorageService: MockLocalStorageService()),
    );

    expect(find.text('E-Commerce App v1.0'), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.text('LOGIN'), findsOneWidget);
  });
}
