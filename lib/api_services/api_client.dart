import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_task/config/environment.dart';
import 'package:flutter_task/data_models/rest_error.dart';

///
/// Created by Auro on 29/07/24
///

enum RequestMethod { get, create, patch, put, remove }

class ApiClient {
  static Future<Response<T>> _generalApiCall<T>(
      String path, RequestMethod requestMethod,
      {String id = '',
      String? basePath,
      Map<String, dynamic> query = const {},
      dynamic body = const {},
      bool isAuthNeeded = true,
      Options? extraOptions}) async {
    Dio dio = Dio();

    basePath ??= Environment.demoProductsURL;

    try {
      log('URL $requestMethod $basePath/$path/$id $query ${jsonEncode(body)} ');
      if (Platform.isIOS) {
        print(
            'URL $requestMethod $basePath/$path/$id $query ${jsonEncode(body)}');
      }

      Response<T> response;
      switch (requestMethod) {
        case RequestMethod.get:
          response =
              await dio.get<T>('$basePath/$path/$id', queryParameters: query);
          break;
        case RequestMethod.create:
          response = await dio.post<T>('$basePath/$path/$id',
              data: body, queryParameters: query, options: extraOptions);
          break;
        case RequestMethod.patch:
          response = await dio.patch<T>('$basePath/$path/$id',
              data: body, queryParameters: query, options: extraOptions);
          break;
        case RequestMethod.put:
          response = await dio.put<T>('$basePath/$path/$id',
              data: body, queryParameters: query, options: extraOptions);
          break;
        case RequestMethod.remove:
          response = await dio.delete<T>('$basePath/$path/$id',
              queryParameters: query, options: extraOptions);
          break;
        default:
          throw ArgumentError('Invalid RequestMethod $requestMethod');
      }
      return response;
    } on SocketException {
      log("...>>>>>>>>>> SocketException ERROR  ");
      throw NoInternetError();
    } catch (error, s) {
      log('ERROR URL $basePath/$path/$id ${dio.options.headers['Authorization']} ${jsonEncode(body)}',
          error: '$error', stackTrace: s);
      log("...>>>>>>>>>>  $error ::::$s ");
      if ((error as dynamic).response == null) {
        throw NoInternetError();
      }
      if (error is DioError) {
        if (error.response?.statusCode == 502) {
          throw 'Server unreachable';
        } else {
          final restError = RestError.fromJson(error.response!.data);
          if (restError.code == 401) {
            if (isAuthNeeded) {
              // Perform LogOut here
              // AuthHelper.logoutUser();
            }
          }
          throw restError;
        }
      } else {
        throw error.toString();
      }
    }
  }

  static Future<Response<T>> get<T>(String path,
      {String id = '',
      String? basePath,
      Map<String, dynamic> query = const {},
      bool isAuthNeeded = true,
      Options? extraOptions}) async {
    return _generalApiCall<T>(path, RequestMethod.get,
        id: id, basePath: basePath, query: query, isAuthNeeded: isAuthNeeded);
  }

  static Future<Response<T>> post<T>(String path,
      {String id = '',
      String? basePath,
      Map<String, dynamic> query = const {},
      dynamic body = const {},
      bool isAuthNeeded = true,
      Options? extraOptions}) async {
    return _generalApiCall<T>(path, RequestMethod.create,
        id: id,
        basePath: basePath,
        query: query,
        isAuthNeeded: isAuthNeeded,
        body: body,
        extraOptions: extraOptions);
  }

  static Future<Response<T>> patch<T>(
    String path, {
    String id = '',
    String? basePath,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
    bool isAuthNeeded = true,
    Options? extraOptions,
  }) async {
    return _generalApiCall<T>(path, RequestMethod.patch,
        id: id,
        basePath: basePath,
        query: query,
        isAuthNeeded: isAuthNeeded,
        extraOptions: extraOptions,
        body: body);
  }

  static Future<Response<T>> put<T>(
    String path, {
    String id = '',
    String? basePath,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
    bool isAuthNeeded = true,
    Options? extraOptions,
  }) async {
    return _generalApiCall<T>(path, RequestMethod.put,
        id: id,
        basePath: basePath,
        query: query,
        isAuthNeeded: isAuthNeeded,
        extraOptions: extraOptions,
        body: body);
  }

  static Future<Response<T>> delete<T>(String path,
      {String id = '',
      String? basePath,
      Map<String, dynamic> query = const {},
      Options? extraOptions}) async {
    return _generalApiCall<T>(path, RequestMethod.remove,
        id: id,
        basePath: basePath,
        query: query,
        isAuthNeeded: true,
        extraOptions: extraOptions);
  }

  /// Single file upload
  /// Single file upload
// static Future<dynamic> singleFileUpload(
//   File file, {
//   String path = ApiRoutes.upload,
//   bool isPdf = false,
//   String purpose = 'image',
//   int fileType = 1,
// }) async {
//   try {
//     print("$path : ${file.path}");
//     final Dio dio = Dio();
//     if (SharedPreferenceHelper.user != null) {
//       dio.options.headers['Authorization'] =
//           SharedPreferenceHelper.user!.accessToken;
//     }
//     final data = FormData.fromMap({
//       "purpose": purpose,
//       "fileType": fileType,
//       "photo": await MultipartFile.fromFile(file.path,
//           filename: file.path.split('/').last,
//           contentType: fileType == 9
//               ? p.MediaType('application', 'pdf')
//               : fileType == 2
//                   ? p.MediaType('video', 'mp4')
//                   : p.MediaType('image', 'jpeg'))
//     });
//
//     Response response = await dio.post(
//       '${ApiRoutes.baseUrl}/$path',
//       data: data,
//     );
//
//     log("base api log : $response");
//
//     return response.data[0];
//   } on SocketException {
//     throw NoInternetError();
//   } catch (error) {
//     if ((error as dynamic).response == null) {
//       throw NoInternetError();
//     }
//     if (error is DioError) {
//       if (error.response!.statusCode == 502) {
//         throw 'Server unreachable';
//       } else {
//         final restError = RestError.fromJson(error.response!.data);
//         if (restError.code == 401) {}
//         throw restError;
//       }
//     } else {
//       throw error.toString();
//     }
//   }
// }

//// Multiple file upload
// static Future<dynamic> multiFileUpload(List<File> files,
//     {String path = ApiRoutes.upload,
//     bool isPdf = false,
//     String purpose = 'blog',
//     int fileType = 1}) async {
//   try {
//     if (SharedPreferenceHelper.user == null ||
//         SharedPreferenceHelper.user!.accessToken == null) {
//       return null;
//     } else {
//       // log("-----------");
//       final Dio dio = Dio();
//       dio.options.headers['Authorization'] =
//           SharedPreferenceHelper.user!.accessToken;
//
//       Map<String, dynamic> body = {};
//
//       body['purpose'] = purpose;
//       body['fileType'] = fileType;
//
//       for (int i = 0; i < files.length; i++) {
//         body['photo$i'] = await MultipartFile.fromFile(files[i].path,
//             contentType: isPdf
//                 ? p.MediaType('application', 'pdf')
//                 : p.MediaType('image', 'jpeg'));
//       }
//       // body['purpose'] = purpose;
//
//       // log("====>>> UPLOAD BODY :: ${body}");
//
//       Response response = await dio.post('${ApiRoutes.baseUrl}/$path',
//           data: FormData.fromMap(body));
//       // log("====>>> UPLOAD RESPONSE---------$response");
//
//       return response.data is List ? response.data : ["${response.data}"];
//     }
//   } on SocketException {
//     throw NoInternetError();
//   } catch (error) {
//     if (error is DioError) {
//       if (error.response!.statusCode == 502) {
//         throw 'Server unreachable';
//       } else {
//         log("${error.response!.data}");
//         final restError = RestError.fromJson(error.response!.data);
//         if (restError.code == 401) {}
//         throw restError;
//       }
//     } else {
//       throw error.toString();
//     }
//   }
// }
}
