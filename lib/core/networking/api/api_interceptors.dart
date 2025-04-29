import 'package:dio/dio.dart';
import 'package:trakify/core/helpers/extensions.dart';
import 'package:trakify/core/networking/api/api_endpoints.dart';
import 'package:trakify/core/networking/api/user_data.dart';

class ApiInterceptors extends Interceptor {
  final Dio dio;

  ApiInterceptors(this.dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final useAuthHeaders = options.extra['useHeaders'] ?? true;

    Map<String, String> headers = {};

    if (useAuthHeaders) {
      headers = await HeaderHelper.getAuthHeaders();
    }

    options.headers.addAll(headers);
    super.onRequest(options, handler);
  }
}

class HeaderHelper {
  static Future<Map<String, String>> getAuthHeaders() async {
    String token = await getToken() ?? '';

    final headers = <String, String>{};

    if (!token.isNullOrEmpty()) {
      headers[ApiKey.authorization] = ApiKey.bearer + token;
    }

    return headers;
  }
}
