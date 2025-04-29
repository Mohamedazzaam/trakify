import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../errors/error_handle_exeptions.dart';
import 'api_consumer.dart';
import 'api_endpoints.dart';
import 'api_interceptors.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer({required this.dio}) {
    dio.options.baseUrl = ApiEndPoints.apiBaseUrl;
    Duration timeOut = const Duration(seconds: 30);
    dio.options.connectTimeout = timeOut;
    dio.options.receiveTimeout = timeOut;

    dio.interceptors.add(ApiInterceptors(dio));
    dio.interceptors.add(PrettyDioLogger(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));
  }

  @override
  Future get(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    bool useHeaders = true, 
  }) async {
    try {
      final response = await dio.get(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(extra: {'useHeaders': useHeaders}), 
      );
      return response.data;
    } on DioException catch (e) {
      errorHandleExeptions(e);
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    bool useHeaders = true, 
  }) async {
    try {
      final response = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(extra: {'useHeaders': useHeaders}), 
      );
      return response.data;
    } on DioException catch (e) {
      errorHandleExeptions(e);
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    bool useHeaders = true,
  }) async {
    try {
      final response = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(extra: {'useHeaders': useHeaders}), 
      );
      return response.data;
    } on DioException catch (e) {
      errorHandleExeptions(e);
    }
  }

  @override
  Future delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    bool useHeaders = true, 
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: Options(extra: {'useHeaders': useHeaders}), 
      );
      return response.data;
    } on DioException catch (e) {
      errorHandleExeptions(e);
    }
  }
}
