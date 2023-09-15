import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

Dio dio() {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  // TODO: Get baseUrl from Environment variables
  String baseUrl = 'http://10.0.2.2/api';

  Map<String, dynamic>? headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  var dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: headers,
  ));

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (
      RequestOptions options,
      RequestInterceptorHandler handler,
    ) async {
      String? token = await storage.read(key: 'token');

      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      late String? deviceIdentifier;

      // TODO: Save device identifier
      // TODO: Check if this is the right way
      if (Platform.isAndroid) {
        final info = await deviceInfoPlugin.androidInfo;
        deviceIdentifier = info.fingerprint;
      } else if (Platform.isIOS) {
        final info = await deviceInfoPlugin.iosInfo;
        deviceIdentifier = info.identifierForVendor;
      }

      if (deviceIdentifier != null) {
        options.queryParameters.addAll({
          'device_name': deviceIdentifier,
        });
      }

      if (token != null && token.isNotEmpty) {
        options.headers.addAll({
          'Authorization': 'Bearer $token',
        });
      }

      return handler.next(options);
    },
  ));

  return dio;
}
