// Alur end-to-end terhadap Firebase Emulator (Auth + Firestore + Functions):
// daftar → onboarding → assessment 7 langkah → konfirmasi target → beranda
// → keluar → masuk → hapus akun.
//
// Jalankan emulator dulu:  cd functions && npm run serve
// Lalu:                    fvm flutter test integration_test -d <device>
//   HP fisik:              tambahkan --dart-define=EMULATOR_HOST=<IP Mac di LAN>
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musclecoach/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('daftar → assessment → target → keluar → masuk → hapus akun', (tester) async {
    final email = 'e2e-${DateTime.now().millisecondsSinceEpoch}@example.com';
    const password = 'latihan123';

    // Pump tetap (bukan pumpAndSettle) agar indikator animasi tidak membuat tes menggantung.
    Future<void> settle() async {
      for (var i = 0; i < 8; i++) {
        await tester.pump(const Duration(milliseconds: 150));
      }
    }

    Future<void> waitFor(Finder finder, {int seconds = 30}) async {
      for (var i = 0; i < seconds * 4; i++) {
        await tester.pump(const Duration(milliseconds: 250));
        if (finder.evaluate().isNotEmpty) return;
      }
      fail('Tidak muncul: $finder');
    }

    Future<void> hideKeyboard() async {
      FocusManager.instance.primaryFocus?.unfocus();
      await settle();
    }

    Future<void> tapOn(Finder finder) async {
      await tester.ensureVisible(finder.first);
      await settle();
      await tester.tap(finder.first);
      await settle();
    }

    Future<void> tapText(String text) => tapOn(find.text(text));

    Finder field(String label) => find.widgetWithText(TextFormField, label);

    Future<void> type(String label, String value) async {
      await tester.ensureVisible(field(label));
      await settle();
      await tester.enterText(field(label), value);
      await hideKeyboard();
    }

    Future<void> next() => tapOn(find.widgetWithText(FilledButton, 'Lanjut'));

    Future<void> openProfileTab() =>
        tapOn(find.descendant(of: find.byType(NavigationBar), matching: find.text('Profil')));

    // bootstrap() memasang FlutterError.onError sendiri; kembalikan milik
    // test binding agar kegagalan dilaporkan dengan benar.
    final testErrorHandler = FlutterError.onError;
    await app.main();
    FlutterError.onError = testErrorHandler;
    // Sesi tersimpan dari run sebelumnya (data Emulator sudah ter-reset).
    await FirebaseAuth.instance.signOut();
    await waitFor(find.text('Buat akun baru'));

    // Daftar
    await tapText('Buat akun baru');
    await type('Email', email);
    await type('Kata sandi', password);
    await type('Ulangi kata sandi', password);
    await tapOn(find.widgetWithText(FilledButton, 'Daftar'));
    debugPrint('E2E: daftar dikirim');

    // Onboarding
    await waitFor(find.text('Mari kenali Anda dulu'));
    await tapText('Mulai assessment');
    await waitFor(find.text('Langkah 1 dari 7'));
    debugPrint('E2E: wizard terbuka');

    // 1. Profil dasar
    await tapText('Pilih tanggal');
    await tapText('OKE'); // tanggal awal = 25 tahun lalu
    await tapText('Laki-laki');
    await type('Tinggi badan', '175');
    await type('Berat badan saat ini', '70');
    await next();
    await waitFor(find.text('Langkah 2 dari 7'));

    // 2. Tujuan
    await tapText('Menambah massa otot');
    await type('Berat badan target (opsional)', '74');
    await type('Target waktu', '24');
    await next();
    await waitFor(find.text('Langkah 3 dari 7'));

    // 3. Pengalaman
    await tapText('Pemula');
    await tapText('< 6 bulan');
    await type('Frekuensi latihan saat ini', '2');
    await next();
    await waitFor(find.text('Langkah 4 dari 7'));

    // 4. Jadwal & peralatan
    for (final day in ['Sen', 'Rab', 'Jum']) {
      await tapText(day);
    }
    await tapText('60 menit');
    await tapText('Rumah');
    await tapText('Dumbbell');
    await next();
    await waitFor(find.text('Langkah 5 dari 7'));

    // 5. Aktivitas
    await tapText('Ringan');
    await tapText('Duduk');
    await type('Rata-rata tidur per malam', '7');
    await next();
    await waitFor(find.text('Langkah 6 dari 7'));

    // 6. Pola makan
    await tapText('Omnivora');
    await tapText('Campuran');
    await next();
    await waitFor(find.text('Langkah 7 dari 7'));

    // 7. Keselamatan & persetujuan
    await tapOn(find.textContaining('memberi estimasi edukatif'));
    await tapOn(find.textContaining('diproses untuk menghitung target'));
    await tapOn(find.widgetWithText(FilledButton, 'Hitung target saya'));
    debugPrint('E2E: assessment dikirim');

    // Ringkasan target (dihitung Cloud Function submitAssessment)
    await waitFor(find.text('Target realistis'));
    expect(find.text('Menambah massa otot'), findsOneWidget);
    await tapOn(find.widgetWithText(FilledButton, 'Konfirmasi target'));
    await waitFor(find.text('Target nutrisi harian'));
    expect(find.text('Target aktif'), findsOneWidget);
    debugPrint('E2E: target aktif & beranda tampil');

    // Profil → keluar
    await openProfileTab();
    await tester.scrollUntilVisible(
      find.widgetWithText(OutlinedButton, 'Keluar'),
      300,
      scrollable: find
          .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
          .first,
    );
    await tapOn(find.widgetWithText(OutlinedButton, 'Keluar'));
    await tapOn(find.widgetWithText(FilledButton, 'Keluar'));
    await waitFor(find.text('Buat akun baru'));
    debugPrint('E2E: keluar berhasil');

    // Masuk lagi → langsung ke beranda (onboarding sudah selesai)
    await type('Email', email);
    await type('Kata sandi', password);
    await tapOn(find.widgetWithText(FilledButton, 'Masuk'));
    await waitFor(find.text('Target nutrisi harian'));
    debugPrint('E2E: masuk lagi berhasil');

    // Hapus akun (Cloud Function deleteUserData)
    await openProfileTab();
    await tester.scrollUntilVisible(
      find.text('Hapus akun dan semua data'),
      300,
      scrollable: find
          .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
          .first,
    );
    await tapText('Hapus akun dan semua data');
    await type('Kata sandi untuk konfirmasi', password);
    await tapOn(find.widgetWithText(FilledButton, 'Hapus permanen'));
    await waitFor(find.text('Buat akun baru'));
    debugPrint('E2E: akun terhapus');

    // Akun sudah tidak ada → login gagal
    await type('Email', email);
    await type('Kata sandi', password);
    await tapOn(find.widgetWithText(FilledButton, 'Masuk'));
    await waitFor(find.text('Email atau kata sandi salah.'));
  });
}
