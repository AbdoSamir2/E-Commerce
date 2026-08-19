import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import '../errors/app_exception.dart';
import 'api_constants.dart';

class ApiClient
{
  ApiClient({Dio? dio}) : _dio = dio ?? Dio()
  {
    if (!kIsWeb)
    {
      _dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          client.connectionTimeout = ApiConstants.connectTimeout;
          return client;
        },
      );
    }

    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = ApiConstants.connectTimeout
      ..receiveTimeout = ApiConstants.receiveTimeout
      ..sendTimeout = ApiConstants.sendTimeout
      ..headers = const {
        Headers.acceptHeader: Headers.jsonContentType,
        Headers.contentTypeHeader: Headers.jsonContentType,
      };

    if (kDebugMode)
    {
      _dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false,),
      );
    }
  }
  final Dio _dio;

  Future<dynamic> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try
    {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    }
    on DioException catch (error)
    {
      throw _mapDioException(error);
    }
    on FormatException catch (error)
    {
      throw ParsingException(cause: error);
    }
  }

  Future<dynamic> post(
      String path, {
        Object? data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
      }) async {
    try
    {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response.data;
    }
    on DioException catch (error) {
      throw _mapDioException(error);
    }
    on FormatException catch (error) {
      throw ParsingException(cause: error);
    }
  }

  AppException _mapDioException(DioException error)
  {
    debugPrint('Dio type: ${error.type}');
    debugPrint('Dio error: ${error.error}');
    debugPrint('Dio message: ${error.message}');
    debugPrint('Dio uri: ${error.requestOptions.uri}');

    switch (error.type)
    {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return RequestTimeoutException(cause: error);

      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'Could not connect to the API server.',
          cause: error,
        );

      case DioExceptionType.badCertificate:
        return NetworkException(
          message: 'A secure connection could not be established.',
          cause: error,
        );

      case DioExceptionType.badResponse:
        return _mapStatusCode(error);

      case DioExceptionType.cancel:
        return UnknownApiException(
          message: 'The request was cancelled.',
          cause: error,
        );

      case DioExceptionType.unknown:
        if (error.error is HandshakeException) {
          return NetworkException(
            message: 'TLS handshake failed while connecting to the API.',
            cause: error,
          );
        }

        if (error.error is SocketException) {
          return NetworkException(
            message: 'Network connection failed.',
            cause: error,
          );
        }

        return UnknownApiException(cause: error);
    }
  }

  AppException _mapStatusCode(DioException error) {
    final statusCode = error.response?.statusCode;

    switch (statusCode) {
      case 401:
      case 403:
        return UnauthorizedException(cause: error);

      case 404:
        return NotFoundException(cause: error);

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          statusCode: statusCode,
          cause: error,
        );

      default:
        return UnknownApiException(
          message: 'The request failed with status code $statusCode.',
          statusCode: statusCode,
          cause: error,
        );
    }
  }
}