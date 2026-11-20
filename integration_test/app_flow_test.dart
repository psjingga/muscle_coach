// Alur end-to-end di perangkat (data lokal SQLite, tanpa server):
// onboarding → assessment 7 langkah → konfirmasi target → beranda → program
// latihan → catat set → riwayat → hapus semua data.
//
//   fvm flutter test integration_test -d <device>
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musclecoach/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('onboarding → assessment → target → program → sesi → hapus data', (tester) async {
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

    Future<void> openProfileAndWipe() async {
      await openProfileTab();
      await tester.scrollUntilVisible(
        find.text('Hapus semua data'),
        300,
        scrollable: find
            .descendant(of: find.byType(ListView), matching: find.byType(Scrollable))
            .first,
      );
      await tapText('Hapus semua data');
      await tapOn(find.widgetWithText(FilledButton, 'Hapus permanen'));
      await waitFor(find.text('Mari kenali Anda dulu'));
    }

    // Sisa data dari run sebelumnya → hapus lewat Profil.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 250));
      if (find.text('Mari kenali Anda dulu').evaluate().isNotEmpty) break;
      if (find.byType(NavigationBar).evaluate().isNotEmpty) {
        await openProfileAndWipe();
        break;
      }
    }

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
    // Penanda khusus Beranda (kartu target nutrisi juga ada di layar ringkasan).
    await waitFor(find.textContaining('Belum ada program latihan'));
    await waitFor(find.text('Target nutrisi harian'));
    debugPrint('E2E: target aktif & beranda tampil');

    // Program latihan awal (Cloud Function createStarterPlan → activateWorkoutPlan)
    await tapOn(find.descendant(of: find.byType(NavigationBar), matching: find.text('Latihan')));
    await waitFor(find.text('Buat program awal'));
    await tapText('Buat program awal');
    await waitFor(find.text('Aktifkan program'));
    expect(find.text('Goblet Squat'), findsWidgets);
    await tapText('Aktifkan program');
    // Kartu jadwal di tab Latihan (judul yang sama juga ada di layar pratinjau).
    final mondayCard = find.widgetWithText(ListTile, 'Senin · Seluruh tubuh A');
    await waitFor(mondayCard);
    debugPrint('E2E: program aktif');

    // Sesi: catat satu set lalu selesaikan
    await tapOn(mondayCard);
    await waitFor(find.text('Mulai sesi'));
    await tapText('Mulai sesi');
    await waitFor(find.byKey(const ValueKey('log-0')));
    await tester.enterText(find.byKey(const ValueKey('weight-0')), '16');
    await tester.enterText(find.byKey(const ValueKey('reps-0')), '10');
    await hideKeyboard();
    await tapOn(find.byKey(const ValueKey('log-0')));
    await waitFor(find.text('Set 1 · 16 kg × 10'));
    expect(find.textContaining('Istirahat 2:'), findsOneWidget);
    await tapText('Selesaikan sesi');
    await waitFor(find.text('Simpan & selesai'));
    await tapText('Simpan & selesai');
    await waitFor(mondayCard);
    await tapOn(find.byTooltip('Riwayat'));
    await waitFor(find.text('Seluruh tubuh A'));
    await tapText('Seluruh tubuh A');
    await waitFor(find.text('Set 1 · 16 kg × 10'));
    debugPrint('E2E: sesi tercatat di riwayat');
    // Kembali ke shell utama.
    for (var i = 0; i < 4 && find.byType(NavigationBar).evaluate().isEmpty; i++) {
      await tapOn(find.byType(BackButton));
    }

    // Program dari Gemini (opsional: --dart-define=GEMINI_API_KEY=...).
    const geminiKey = String.fromEnvironment('GEMINI_API_KEY');
    if (geminiKey.isNotEmpty) {
      await openProfileTab();
      await tapText('AI Coach (Gemini)');
      await tester.enterText(find.byKey(const ValueKey('ai-key')), geminiKey);
      await hideKeyboard();
      await tapText('Simpan & uji');
      await waitFor(find.textContaining('Key tersimpan'));
      await tapOn(find.byKey(const ValueKey('ai-consent')));
      await waitFor(find.text('Siap dipakai'));
      await tapOn(find.byType(BackButton));
      debugPrint('E2E: API key Gemini tersimpan');

      await tapOn(find.descendant(of: find.byType(NavigationBar), matching: find.text('Latihan')));
      await tapOn(find.widgetWithText(OutlinedButton, 'Program aktif'));
      await tapOn(find.byTooltip('Buat ulang program'));
      await tapText('Susun dengan AI');
      await waitFor(find.text('Aktifkan program'), seconds: 150);
      expect(find.textContaining('Estimasi AI'), findsOneWidget);
      debugPrint('E2E: draft program AI tampil');
      await tapText('Aktifkan program');
      await tapOn(find.widgetWithText(FilledButton, 'Ganti'));
      await waitFor(find.byType(NavigationBar));
      debugPrint('E2E: program AI aktif');
    }

    // Pengingat lokal: aktifkan, cek jadwal, kirim notifikasi uji.
    await openProfileTab();
    await tapText('Pengingat');
    await tapOn(find.byKey(const ValueKey('reminders-master')));
    if (find.text('Izinkan notifikasi?').evaluate().isNotEmpty) {
      await tapText('Izinkan');
    }
    final scheduledFinder = find.byWidgetPredicate(
      (w) => w is Text && RegExp(r'^[1-9]\d* pengingat terjadwal').hasMatch(w.data ?? ''),
    );
    await waitFor(scheduledFinder);
    final scheduledText = tester.widget<Text>(scheduledFinder).data;
    debugPrint('E2E: $scheduledText');
    await tapText('Kirim notifikasi uji');
    debugPrint('E2E: pengingat aktif — jeda untuk verifikasi adb');
    for (var i = 0; i < 80; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    await tapOn(find.byType(BackButton));

    // Hapus semua data → kembali ke onboarding (pengingat ikut dibatalkan)
    await openProfileAndWipe();
    debugPrint('E2E: data terhapus, kembali ke onboarding');
  });
}
