import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../errors/app_exception.dart';
import 'api_constants.dart';

class ApiClient {
  ApiClient({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options
      ..baseUrl = ApiConstants.baseUrl
      ..connectTimeout = ApiConstants.connectTimeout
      ..receiveTimeout = ApiConstants.receiveTimeout
      ..sendTimeout = ApiConstants.sendTimeout
      ..headers = const {
        Headers.acceptHeader: Headers.jsonContentType,
        Headers.contentTypeHeader: Headers.jsonContentType,
      };

    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
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
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response.data;
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
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
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response.data;
    } on DioException catch (error) {
      throw _mapDioException(error);
    } on FormatException catch (error) {
      throw ParsingException(cause: error);
    }
  }

  AppException _mapDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return RequestTimeoutException(cause: error);

      case DioExceptionType.connectionError:
        return NetworkException(cause: error);

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
        if (error.error is SocketException) {
          return NetworkException(cause: error);
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
        return ServerException(statusCode: statusCode, cause: error);

      default:
        return UnknownApiException(
          message: 'The request failed with status code $statusCode.',
          statusCode: statusCode,
          cause: error,
        );
    }
  }
}
