import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:musclecoach/core/notifications/local_notification_service.dart';

void main() {
  String payload(String route) =>
      jsonEncode({'route': route, 'channel': 'check_in', 'title': 't', 'body': 'b'});

  test('tanggal check-in dibaca dari rute payload', () {
    expect(checkInDateOf(payload('/check-in/2026-11-23')), '2026-11-23');
  });

  test('payload lain / rusak → null', () {
    expect(checkInDateOf(payload('/nutrition')), isNull);
    expect(checkInDateOf(payload('/check-in/2026-11-23/x')), isNull);
    expect(checkInDateOf('/check-in/2026-11-23'), '2026-11-23'); // payload lama (rute saja)
    expect(checkInDateOf(null), isNull);
    expect(checkInDateOf('{rusak'), isNull);
  });
}
