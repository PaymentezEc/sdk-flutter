import 'package:nuvei_sdk_flutter/env/base_config.dart';

class ProdConfig extends BaseConfig {
  @override
  String get environment => "PROD";

  @override
  String get urlBase => "https://ccapi.paymentez.com";

@override
  String get urlCresBase => "https://nuvei-cres-dev-bkh4atahdegxa8dk.eastus-01.azurewebsites.net/";
  
}