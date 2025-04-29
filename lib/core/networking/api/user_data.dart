import 'package:trakify/core/cache/cache_helper.dart';
import 'package:trakify/core/constants/app_constants.dart';
import 'package:trakify/core/di/dependency_injection.dart';
import 'package:trakify/core/networking/api/api_endpoints.dart';

Future<String?> getToken() async {
  return await getIt<CacheHelper>().getSecuredData(key: ApiKey.token);
}

Future<String?> getUserId() async {
  return await getIt<CacheHelper>().getSecuredData(key: AppConstants.userId);
}

Future<void> saveToken(String token) async {
  await getIt<CacheHelper>().saveSecuredData(key: ApiKey.token, value: token);
}

Future<void> saveUserId(String userId) async {
  await getIt<CacheHelper>().saveSecuredData(
    key: AppConstants.userId,
    value: userId,
  );
}

Future<void> removeUserData() async {
  await getIt<CacheHelper>().removeSecuredData(key: ApiKey.token);
  await getIt<CacheHelper>().removeSecuredData(key: AppConstants.userId);
}
