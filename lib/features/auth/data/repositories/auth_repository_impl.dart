import 'package:exp_intern/core/storage/token_storage.dart';
import '../../domin/repositories/auth_repository.dart';
import '../data_source/auth_remote_data_source.dart';
import '../model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage = TokenStorage();

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> login({
    required String userName,
    required String password,
    bool rememberMe = true,
    String? autoFillCode,
  }) async {
    try {
      final response = await _remoteDataSource.login(
        userName: userName,
        password: password,
        rememberMe: rememberMe,
        autoFillCode: autoFillCode,
      );

      // بنحول الريسبونس مباشرة لـ UserModel مهما كان الـ HTTP Status Code (سواء 200 أو 201 أو غيره)
      final userModel = UserModel.fromJson(response.data);

      // الفحص هنا معتمد تماماً على الـ status الداخلية اللي باعتها الباك إند جوه الـ JSON للنجاح
      if (userModel.status == 200 && userModel.loginData != null) {
        final loginData = userModel.loginData!;
        final token = loginData.accessToken;

        if (token != null && token.isNotEmpty) {
          await _tokenStorage.saveTokens(token);
        }

        return {
          'success': true,
          'userEntity': userModel,
        };
      }

      // في حالة الفشل (الـ status مش كود النجاح الداخلي، زي الـ 500 اللي بيبعتها لما البيانات تكون غلط)
      // الكود هنا هيقرا الـ message اللي مبعوتة من الباك إند في الريسبونس بالظبط ويعرضها لليوزر
      return {
        'success': false,
        'message': userModel.message ?? 'حدث خطأ ما، يرجى المحاولة لاحقاً',
      };

    } catch (e) {
      return {
        'success': false,
        'message': 'مشكلة في الشبكة، تحقق من اتصالك بالإنترنت',
      };
    }
  }

  @override
  Future<void> logout() async {
    await _tokenStorage.clearTokens();
  }
}