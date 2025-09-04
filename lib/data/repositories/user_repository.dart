import '../models/user_profile.dart';
import 'base_repository.dart';

class UserRepository extends BaseRepository<UserProfile> {
  UserRepository() : super('user_profiles');

  static const String currentUserKey = 'current_user';

  Future<UserProfile?> getCurrentUser() async {
    return await get(currentUserKey);
  }

  Future<void> saveCurrentUser(UserProfile user) async {
    await add(currentUserKey, user);
  }

  Future<void> updateCurrentUser(UserProfile user) async {
    await update(currentUserKey, user.copyWith(updatedAt: DateTime.now()));
  }

  Future<bool> hasCurrentUser() async {
    return await exists(currentUserKey);
  }
}
