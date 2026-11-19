import '../../../core/network/functions_client.dart';
import '../domain/account_repository.dart';

/// Nama callable harus sama dengan ekspor di `functions/src/index.ts`.
class FunctionsAccountRepository implements AccountRepository {
  FunctionsAccountRepository(this._client);

  final FunctionsClient _client;

  @override
  Future<void> ensureUserProfile() async {
    await _client.call('createUserProfile');
  }

  @override
  Future<void> deleteUserData() async {
    await _client.call('deleteUserData', data: {'confirm': true});
  }
}
