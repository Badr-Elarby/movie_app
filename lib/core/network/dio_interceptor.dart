import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor();

  static const String _token =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyYTQ3YWY1YTdkMzUzNjMwZDM4M2I3MzI3MzM2ZTY1YiIsIm5iZiI6MTc2MTkyNTI2OC40ODgsInN1YiI6IjY5MDRkODk0ODJmMDQwMmZiMWUxMjIwNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Vhh1f73qBTGSSaxSdxyXx5Kom6eR6N7H9zuColWuSxE';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.addAll(<String, String>{
      'Accept': 'application/json',
      'Authorization': 'Bearer $_token',
    });
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Forward error after potential logging/hook.
    super.onError(err, handler);
  }
}

Dio createDio(AuthInterceptor authInterceptor) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3/',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );
  dio.interceptors.add(authInterceptor);
  return dio;
}
