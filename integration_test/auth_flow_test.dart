// Alur auth end-to-end terhadap Firebase Emulator (Auth + Firestore + Functions).
//
// Jalankan emulator dulu:  cd functions && npm run serve
// Lalu:                    fvm flutter test integration_test -d <device>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musclecoach/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('daftar → beranda → keluar → masuk → hapus akun', (tester) async {
    final email = 'e2e-${DateTime.now().millisecondsSinceEpoch}@example.com';
    const password = 'latihan123';

    // Pump tetap (bukan pumpAndSettle) agar indikator animasi tidak membuat tes menggantung.
    Future<void> settle() async {
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 150));
      }
    }

    Future<void> waitFor(Finder finder, {int seconds = 20}) async {
      for (var i = 0; i < seconds * 4; i++) {
        await tester.pump(const Duration(milliseconds: 250));
        if (finder.evaluate().isNotEmpty) return;
      }
      fail('Tidak muncul: $finder');
    }

    Finder field(String label) => find.widgetWithText(TextFormField, label);

    // bootstrap() memasang FlutterError.onError sendiri; kembalikan milik
    // test binding agar kegagalan dilaporkan dengan benar.
    final testErrorHandler = FlutterError.onError;
    await app.main();
    FlutterError.onError = testErrorHandler;
    await waitFor(find.text('Buat akun baru'));

    // Daftar
    await tester.tap(find.text('Buat akun baru'));
    await settle();
    await tester.enterText(field('Email'), email);
    await tester.enterText(field('Kata sandi'), password);
    await tester.enterText(field('Ulangi kata sandi'), password);
    await tester.tap(find.widgetWithText(FilledButton, 'Daftar'));
    debugPrint('E2E: daftar dikirim');
    await waitFor(find.text('Selamat datang!'));

    debugPrint('E2E: beranda tampil');
    // Profil → keluar
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('Profil')),
    );
    await settle();
    expect(find.text(email), findsOneWidget);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Keluar'));
    await settle();
    await tester.tap(find.widgetWithText(FilledButton, 'Keluar'));
    await waitFor(find.text('Buat akun baru'));

    debugPrint('E2E: keluar berhasil');
    // Masuk lagi
    await tester.enterText(field('Email'), email);
    await tester.enterText(field('Kata sandi'), password);
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await waitFor(find.text('Selamat datang!'));

    debugPrint('E2E: masuk lagi berhasil');
    // Hapus akun (Cloud Function deleteUserData)
    await tester.tap(
      find.descendant(of: find.byType(NavigationBar), matching: find.text('Profil')),
    );
    await settle();
    await tester.tap(find.text('Hapus akun dan semua data'));
    await settle();
    await tester.enterText(field('Kata sandi untuk konfirmasi'), password);
    await tester.tap(find.widgetWithText(FilledButton, 'Hapus permanen'));
    await waitFor(find.text('Buat akun baru'));

    debugPrint('E2E: akun terhapus');
    // Akun sudah tidak ada → login gagal
    await tester.enterText(field('Email'), email);
    await tester.enterText(field('Kata sandi'), password);
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await waitFor(find.text('Email atau kata sandi salah.'));
  });
}
