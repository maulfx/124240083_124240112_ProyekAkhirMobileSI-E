import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_parking/features/parking_notes/add_parking_note_screen.dart';
import 'package:smart_parking/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Set Waktu opens DatePicker then TimePicker and updates reminder state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const AddParkingNoteScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada pengingat'), findsOneWidget);
    expect(find.text('Set Waktu'), findsOneWidget);

    await tester.ensureVisible(find.text('Set Waktu'));
    await tester.tap(find.text('Set Waktu'));
    await tester.pumpAndSettle();

    // DatePicker should show LANJUT button
    expect(find.text('LANJUT'), findsOneWidget);
    await tester.tap(find.text('LANJUT'));
    await tester.pumpAndSettle();

    // TimePicker should show visible SET WAKTU button (24-hour mode)
    expect(find.text('SET WAKTU'), findsOneWidget);
    await tester.tap(find.text('SET WAKTU'));
    await tester.pumpAndSettle();

    // Reminder should now be active
    expect(find.text('Pengingat Aktif'), findsOneWidget);
    expect(find.text('Ubah'), findsOneWidget);
  });
}
