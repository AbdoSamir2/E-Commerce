// <<<<<<< HEAD
// // // This is a basic Flutter widget test.
// // //
// // // To perform an interaction with a widget in your test, use the WidgetTester
// // // utility in the flutter_test package. For example, you can send tap and scroll
// // // gestures. You can also use WidgetTester to find child widgets in the widget
// // // tree, read text, and verify that the values of widget properties are correct.

// // import 'package:flutter/material.dart';
// // import 'package:flutter_test/flutter_test.dart';

// // import 'package:e_commerce_project/main.dart';

// // void main() {
// //   testWidgets('Counter increments smoke test', (WidgetTester tester) async {
// //     // Build our app and trigger a frame.
// //     await tester.pumpWidget(const SplashScreen());

// //     // Verify that our counter starts at 0.
// //     expect(find.text('0'), findsOneWidget);
// //     expect(find.text('1'), findsNothing);

// //     // Tap the '+' icon and trigger a frame.
// //     await tester.tap(find.byIcon(Icons.add));
// //     await tester.pump();

// //     // Verify that our counter has incremented.
// //     expect(find.text('0'), findsNothing);
// //     expect(find.text('1'), findsOneWidget);
// //   });
// // }
// =======
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:e_commerce_project/app.dart';
// import 'package:e_commerce_project/core/api/api_client.dart';
// import 'package:e_commerce_project/core/storage/local_storage_service.dart';

// class MockApiClient extends Mock implements ApiClient {}

// class MockLocalStorageService extends Mock implements LocalStorageService {}

// void main() {
//   testWidgets('app starts on the splash route', (tester) async {
//     await tester.pumpWidget(
//       EcommerceApp(
//         apiClient: MockApiClient(),
//         localStorageService: MockLocalStorageService(),
//       ),
//     );
//     await tester.pumpAndSettle();

//     expect(find.text('Splash'), findsWidgets);
//   });
// }
// >>>>>>> 94747cf18e33bea0fd4feb7744ad3819c115b64f
