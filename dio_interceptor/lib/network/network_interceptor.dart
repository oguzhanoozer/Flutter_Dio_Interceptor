import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_interceptor/network/network_manager.dart';

class NetworkInterceptor implements Interceptor {
  final Dio dio;

  NetworkInterceptor(this.dio);
  @override
  void onError(DioError error, ErrorInterceptorHandler handler) async {
    if (error.response?.statusCode == 403 &&
        error.response?.statusCode == 401) {
      dio.interceptors.requestLock.lock();
      dio.interceptors.requestLock.lock();

      await _refreshToken();

      dio.interceptors.requestLock.unlock();
      dio.interceptors.requestLock.unlock();

      final data = await _retry(error.requestOptions);
      if (data != null) {
        return handler.resolve(data);
      } else {
        return null;
      }
    }
    return handler.next(error);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ///options.headers["Authorizaiton"] = SharedPref.instance.getToken();
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {}

  Future<void> _refreshToken() async {
    final refreshToken = ""; // await _storage.getToken(key:"RefreshToken");
    try {
      final response = await dio.post(servicePath.REFRESHTOKEN.rawPath,
          data: {"refreshToken": refreshToken});
      if (response.statusCode == HttpStatus.ok) {
        final accessToken = response.data;

        /// await _storage.setToken(key:"accessToken",data:accessToken);
      } else {
        /// await _storage.deleteAll();
        print(response.toString());

        /// LOGOUT
      }
    } catch (e) {
      print(e.toString());

      /// LOGOUT
    }
  }

  Future<Response<dynamic>>? _retry(
    RequestOptions options,
  ) async {
    var accessToken = "";

    /// SharedPref.instance.getToken();
    dio.options.headers["Authorization"] = "Bearer " + accessToken;
    dio.options.headers["Accept"] = "*/*";

    final _options = Options(method: options.method, headers: options.headers);
    return dio.request(options.path,
        data: options.data,
        cancelToken: options.cancelToken,
        onReceiveProgress: options.onReceiveProgress,
        queryParameters: options.queryParameters,
        options: _options);
  }
}
