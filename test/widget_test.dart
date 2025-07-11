// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bike_rental_app/main.dart';

void main() {
  testWidgets('App launches with splash screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpinIslandApp());

    // Verify that our app starts with the splash screen
    expect(find.text('Get Start'), findsOneWidget);
    expect(find.byIcon(Icons.directions_bike), findsOneWidget);
  });

  testWidgets('Navigate from splash to login screen', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpinIslandApp());

    // Find and tap the "Get Start" button
    await tester.tap(find.text('Get Start'));
    await tester.pumpAndSettle();

    // Verify that we're now on the login screen
    expect(find.text('Username'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login to Dashboard'), findsOneWidget);
  });

  testWidgets('Navigate to register screen from login', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SpinIslandApp());

    // Navigate to login screen
    await tester.tap(find.text('Get Start'));
    await tester.pumpAndSettle();

    // Find and tap the register link
    await tester.tap(find.text('Don\'t have an account? Register'));
    await tester.pumpAndSettle();

    // Verify that we're now on the register screen
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
  });
}
