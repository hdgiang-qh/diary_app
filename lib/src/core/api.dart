
import 'package:diary/src/core/share_pref/app_key.dart';
import 'package:dio/dio.dart';
import 'const.dart';
import 'share_pref/share_pref.dart';

final dio = Dio()
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest:
          (RequestOptions options, RequestInterceptorHandler handler) async {
        print("#################################### Url: ${options.path}");
        return handler.next(options);
      },
      onResponse: (Response? response, ResponseInterceptorHandler handler) {
        // print("#################################### response: [${response?.statusCode}] >> ${response?.data}");
        // print("=================: ${response?.data["result"]}");
        return handler.next(response!);
      },
      onError: (e, handler) {
        print(
            "#################################### error: [${e.response?.statusCode}] >> ${e.response?.data}");
        ModelApiError err = ModelApiError();
        if (e.response == null) {
          err =
              ModelApiError(code: null, error: "Kết nối đến máy chủ thất bại");
        } else if (e.response?.statusCode == 400) {
          err =
              ModelApiError(code: e.response?.statusCode, error: "Lỗi cú pháp");
        } else if (e.response?.statusCode == 404) {
          err = ModelApiError(
              code: e.response?.statusCode, error: "Không tìm thấy tài nguyên");
        } else if (e.response?.statusCode == 500) {
          err = ModelApiError(
              code: e.response?.statusCode,
              error: "Có lỗi hệ thống, bạn quay lại sau");
        } else {
          err = ModelApiError(
              code: e.response?.statusCode,
              error: e.response?.data['message'] ?? e.message);
        }
        return handler.next(DioException(
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: err,
        ));
      },
    ),
  );

class Api {
  static checkErr(err) {
    if (err is DioException) {
      return err.error;
    } else {
      return err.toString();
    }
  }

  static postAsync({
    required String endPoint,
    required Map<String, dynamic> req,
    bool isToken = true,
    bool hasForm = false,
    String? domain,
  }) async {
    try {
      Map<String, dynamic> headers = Map();
      headers['Content-Type'] = "application/json";
      if (isToken) {
        var token = await SharedPrefs.readString(AppKey.userToken);
        headers['Authorization'] = "Bearer $token";
      }
      FormData formData = FormData.fromMap(req);
      var res = await dio.post(
        (domain ?? Const.api_host) + endPoint,
        data: hasForm ? formData : req,
        options: Options(
          headers: headers,
        ),
      );
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  static getAsync({required String endPoint, bool isToken = true}) async {
    try {
      Map<String, dynamic> headers = Map();
      headers['Content-Type'] = "application/json";

      if (isToken) {
        var token = await SharedPrefs.readString(AppKey.userToken);
        print(token);
        headers['Authorization'] = "Bearer $token";
      }

      var res = await dio.get(
        Const.api_host + endPoint,
        options: Options(
          headers: headers,
        ),
      );
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  static deleteAsync(
      {required String endPoint, bool isToken = true, String? domain}) async {
    try {
      Map<String, dynamic> headers = Map();
      headers['Content-Type'] = "application/json";

      if (isToken) {
        var token = await SharedPrefs.readString(AppKey.userToken);
        print(token);
        headers['Authorization'] = "Bearer $token";
      }

      var res = await dio.delete(
        (domain ?? Const.api_host) + endPoint,
        options: Options(
          headers: headers,
        ),
      );
      return res.data;
    } catch (e) {
      rethrow;
    }
  }

  static putAsync({
    required String endPoint,
    required Map<String, dynamic> req,
    bool isToken = true,
    bool hasForm = false,
    String? domain,
  }) async {
    try {
      Map<String, dynamic> headers = Map();
      headers['Content-Type'] = "application/json";
      if (isToken) {
        var token = await SharedPrefs.readString(AppKey.userToken);
        headers['Authorization'] = "Bearer $token";
      }
      FormData formData = FormData.fromMap(req);
      var res = await dio.put(
        (domain ?? Const.api_host) + endPoint,
        data: hasForm ? formData : req,
        options: Options(
          headers: headers,
        ),
      );
      return res.data;
    } catch (e) {
      rethrow;
    }
  }
}

class ModelApiError {
  String? error;
  int? code;

  ModelApiError({this.code, this.error = ""});
}
