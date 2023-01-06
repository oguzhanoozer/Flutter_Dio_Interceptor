import 'package:dio/dio.dart';

import 'network_interceptor.dart';

class NetworkManager {
  static NetworkManager? _instance;
  static NetworkManager get instance {
    _instance ??= NetworkManager._init();
    return _instance!;
  }

  late Dio dio;
  NetworkManager._init() {
    dio = Dio(BaseOptions(baseUrl: servicePath.BASEURL.rawPath));
    dio.interceptors.add(NetworkInterceptor(dio));
  }
}

enum servicePath { BASEURL, REFRESHTOKEN, ALBUMS }

extension servicePathExtension on servicePath {
  String get rawPath {
    switch (this) {
      case servicePath.BASEURL:
        return "jsonplaceholder.typicode.com/";
      case servicePath.REFRESHTOKEN:
        return "/auth/refresh";
      case servicePath.ALBUMS:
        return "/albums";
      default:
        throw "Path Not Found";
    }
  }
}
