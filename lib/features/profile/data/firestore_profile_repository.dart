import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/entities/user_profile.dart';
import '../domain/profile_repository.dart';

class FirestoreProfileRepository implements ProfileRepository {
  FirestoreProfileRepository(this._db);

  final FirebaseFirestore _db;

  @override
  Stream<UserProfile?> watch(String uid) => _db
      .doc('users/$uid/profile/current')
      .snapshots()
      .map((s) => s.exists ? UserProfile.fromJson(s.data()!) : null);
}
