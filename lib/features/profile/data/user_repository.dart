import '../../../core/api/api_client.dart';
import '../../../core/api/api_constants.dart';
import '../models/user_model.dart';

class UserRepository
{
  const UserRepository(this._apiClient);
  final ApiClient _apiClient;

  Future<UserModel> getUserById(int userId,) async
  {
    final data = await _apiClient.get(ApiConstants.userById(userId),);

    if (data is! Map) {
      throw const FormatException('Invalid user response.',);
    }

    return UserModel.fromJson(Map<String, dynamic>.from(data),);
  }
}