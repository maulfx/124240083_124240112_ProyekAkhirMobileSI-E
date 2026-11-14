import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking/theme/app_colors.dart';
import 'package:smart_parking/theme/app_theme.dart';
import 'package:smart_parking/core/services/theme_service.dart';
import 'package:smart_parking/widgets/category_pill.dart';
import 'package:smart_parking/widgets/bottom_dock_navigation.dart';
import 'package:smart_parking/features/profile/widgets/currency_selection_modal.dart';
import 'package:smart_parking/features/profile/widgets/parking_preference_modal.dart';
import 'package:smart_parking/features/map/utils/compass_sensor_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;

    // Mock sensors channel for headless test environment
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('dev.fluttercommunity.plus/sensors/method'),
      (MethodCall methodCall) async => null,
    );
  });

  group('Deep Logic & Null-Safety Verification', () {
    test('AppColors & ThemeService reactivity in both Light & Dark modes', () async {
      // 1. Light mode check
      await ThemeService.instance.setDarkMode(false);
      expect(AppColors.background, equals(AppColors.backgroundLight));
      expect(AppColors.surfaceCard, equals(AppColors.surfaceCardLight));
      expect(ThemeService.instance.bg, equals(AppColors.backgroundLight));
      expect(ThemeService.instance.card, equals(AppColors.surfaceCardLight));

      // 2. Dark mode check
      await ThemeService.instance.setDarkMode(true);
      expect(AppColors.background, equals(AppColors.backgroundDark));
      expect(AppColors.surfaceCard, equals(AppColors.surfaceCardDark));
      expect(ThemeService.instance.bg, equals(AppColors.backgroundDark));
      expect(ThemeService.instance.card, equals(AppColors.surfaceCardDark));

      // Reset to light mode
      await ThemeService.instance.setDarkMode(false);
    });

    test('AppTheme light and dark instances build without throwing', () {
      expect(AppTheme.light.scaffoldBackgroundColor, equals(AppColors.backgroundLight));
      expect(AppTheme.dark.scaffoldBackgroundColor, equals(AppColors.backgroundDark));
    });

    test('CompassSensorService initializes and disposes safely', () {
      final service = CompassSensorService();
      expect(service.heading, equals(0.0));
      // Should not throw even if no sensor hardware is attached in test environment
      service.startListening(onHeadingChanged: (_) {});
      service.dispose();
    });

    testWidgets('CategoryPill renders without overflow or null errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryPill(
              label: 'Terdekat',
              icon: Icons.near_me,
              active: true,
              onTap: () {},
            ),
          ),
        ),
      );
      expect(find.text('Terdekat'), findsOneWidget);
      expect(find.byIcon(Icons.near_me), findsOneWidget);
    });

    testWidgets('BottomDockNavigation renders without overflow', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BottomDockNavigation(activeTab: DockTab.home),
          ),
        ),
      );
      expect(find.byType(BottomDockNavigation), findsOneWidget);
    });

    testWidgets('ParkingPreferenceModal opens and closes safely', (tester) async {
      String selected = 'Mobil SUV';
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  ParkingPreferenceModal.show(
                    context,
                    currentPref: selected,
                    onSelected: (val) => selected = val,
                  );
                },
                child: const Text('Open Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Preferensi Parkir'), findsOneWidget);
      expect(find.text('Golongan Mobil SUV'), findsOneWidget);

      // Select another option
      await tester.tap(find.text('Motor Roda 2'));
      await tester.pumpAndSettle();

      expect(selected, equals('Motor Roda 2'));
    });

    testWidgets('CurrencySelectionModal renders without errors', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: ElevatedButton(
                onPressed: () {
                  CurrencySelectionModal.show(context);
                },
                child: const Text('Open Currency Modal'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Currency Modal'));
      await tester.pumpAndSettle();

      expect(find.text('Konversi Mata Uang'), findsOneWidget);
    });
  });
}
