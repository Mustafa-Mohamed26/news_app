import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:news_app/api/api_constants.dart';
import 'package:news_app/api/app_exception.dart';
import 'package:news_app/api/end_points.dart';
import 'package:news_app/model/news_response.dart';
import 'package:news_app/model/source_response.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioApiManager {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://newsapi.org',
      // queryParameters: {'apiKey': ApiConstants.apiKey},
    ),
  );

  DioApiManager._() {
    dio.interceptors.add(DioInterceptors());
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: true,
        // filter: (options, args) {
        //   // don't print requests with uris containing '/posts'
        //   if (options.path.contains('/posts')) {
        //     return false;
        //   }
        //   // don't print responses with unit8 list data
        //   return !args.isResponse || !args.hasUint8ListData;
        // },
      ),
    );
  }

  static DioApiManager? _dioApiManager;

  static DioApiManager getInstance() {
    return _dioApiManager ??= DioApiManager._();
  }

  Future<SourceResponse?> getSources(String categoryID) async {
    try {
      var response = await dio.get(
        EndPoints.sourceApi,
        queryParameters: {'category': categoryID},
      );
      var json = response.data; // json => object
      var sourceResponse = SourceResponse.fromJson(json);
      return sourceResponse;
      // return SourceResponse.fromJson(response.data);
    }
    // on DioException catch (e) {
    //   //e.message;
    //   print("Final error message => ${e.error}");
    // }
    catch (e) {
      rethrow; // rethrow the exception => this will be caught by the calling function
    }
  }

  // throw vs rethrow
  // throw =>
  // rethrow =>

  Future<NewsResponse?> getNewsBySourceId(String sourceId) async {
    try {
      var response = await dio.get(
        EndPoints.newsApi,
        queryParameters: {'sources': sourceId},
      );
      return NewsResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

class DioInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: implement onRequest
    print("onRequest ${options.baseUrl}");
    options.headers.addAll({'X-Api-Key': ApiConstants.apiKey});
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // TODO: implement onResponse
    print("onResponse ${response.statusCode}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    String message = "Something went wrong, Please try again";
    try {
      if (err.response != null &&
          err.response!.data is Map &&
          err.response!.data.containsKey("message")) {
        message = err.response!.data["message"];
      } else {
        // fallback message for other bad response types
        switch (err.type) {
          case DioException.connectionTimeout:
          case DioException.connectionError:
          case DioException.receiveTimeout:
          case DioException.sendTimeout:
            message =
                "Connection time out. Please check your internet connection";
            break;
          case DioExceptionType.badResponse:
            message =
                "Failed to load data. status code: ${err.response?.statusCode}";
            break;
          case DioExceptionType.cancel:
            message = "Request was cancelled";
            break;
          case DioExceptionType.unknown:
            message = "An unknown network error occurred";
            break;
          default:
            message = "An unknown error occurred";
            break;
        }
      }
    } catch (e) {
      // if parsing fails , fall back to a generic message
      message = "An unexpected error occurred : ${e.toString()}";
    }
    //super.onError(err, handler);
    handler.next(
      // reject before
      DioException(
        requestOptions: err.requestOptions,
        message: message,
        error: AppException(message: message),
        type: err.type,
        response: err.response,
      ),
    );

    // handler.next(
    //   // reject before
    //   DioException(
    //     requestOptions: err.requestOptions,
    //     //message: message,
    //     error: message,
    //     type: err.type,
    //     response: err.response,
    //   ),
    // );
  }
}

// class DioInterceptors implements Interceptor{
//   @override
//   void onError(DioException err, ErrorInterceptorHandler handler) {
//     // TODO: implement onError
//     handler.next(err); // pass the exception to the next interceptor
//   }

//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     // TODO: implement onRequest
//     handler.next(options); // pass the request to the next interceptor
//   }

//   @override
//   void onResponse(Response response, ResponseInterceptorHandler handler) {
//     // TODO: implement onResponse
//     handler.next(response); // pass the response to the next interceptor
//   }
// }
