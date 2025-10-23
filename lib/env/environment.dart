import 'package:http/http.dart';
import 'package:nuvei_sdk_flutter/env/base_config.dart';
import 'package:nuvei_sdk_flutter/env/dev_config.dart';
import 'package:nuvei_sdk_flutter/env/prod_config.dart';
import 'package:nuvei_sdk_flutter/helper/global_helper.dart';

class Environment {
  static final Environment _environment = Environment._internal();
  factory Environment() => _environment;

  Environment._internal();
  String _appCode = '';
  String _appKey = '';
  String _serverCode = '';
  String _serverKey = '';
  String _clientId = '';
  String _clientSecret = '';

  static const String dev = "DEV";
  static const String prod = "PROD";

  String get appCode => _appCode;
  String get appKey => _appKey;
  String get serverKey => _serverKey;
  String get serverCode => _serverCode;
  String get clientId => _clientId;
  String get clientSecret => _clientSecret;

  BaseConfig? baseConfig;

  initConfig({
    required String appCode,
    required String appKey,
    required String serveCode,
    required String serverKey,
    required bool testMode,
    required String clientId,
    required String clientSecret,
  }) {
    _appCode = appCode;
    _appKey = appKey;
    _serverCode = serveCode;
    _serverKey = serverKey;
    if (testMode) {
      baseConfig = _getConfig(Environment.dev);
    } else {
      baseConfig = _getConfig(Environment.prod);
    }
    _clientId = clientId;
    _clientSecret = clientSecret;
    GlobalHelper.logger.i('Envirnment configurated, $appCode');
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.dev:
        return DevConfig();
      case Environment.prod:
        return ProdConfig();
      default:
        return DevConfig();
    }
  }
}
