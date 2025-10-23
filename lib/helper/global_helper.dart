import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:nuvei_sdk_flutter/env/environment.dart';
import 'package:nuvei_sdk_flutter/helper/three_ds_handler.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/extra_params_model.dart';
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter.dart';
import 'package:nuvei_sdk_flutter/services/cres_services.dart';
import 'package:nuvei_sdk_flutter/widget/filled_button_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GlobalHelper {
    static var logger = Logger(
    printer: PrettyPrinter(methodCount: 0, printEmojis: false),
  );

  String _uniqueToken(String timeStamp, String key) {
    var uniqueToken = utf8.encode('$key$timeStamp');
    String uniqueTokenString = sha256.convert(uniqueToken).toString();
    return uniqueTokenString;
  }

  String generateToken(String code, String key) {
    String timeStamp =
        (DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000).toString();
    log('Tiempoo $timeStamp');
    String uniqueToken = _uniqueToken(timeStamp, key);
    String token = '$code;$timeStamp;$uniqueToken';
    String tokenFinal = base64Encode(utf8.encode(token));
    return tokenFinal;
  }

  static dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  Future<String> _getAgent() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    if (deviceInfo is AndroidDeviceInfo) {
      return deviceInfo.model;
    } else if (deviceInfo is IosDeviceInfo) {
      return deviceInfo.utsname.machine;
    } else {
      return "Mozilla/5.0 (iPhone; CPU iPhone OS 18_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148";
    }
  }

  Future<BrowserInfo?> getBrowserInfo(BuildContext context) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org/?format=json'),
      );
      final ip = jsonDecode(response.body)['ip'];
      String language = View.of(context).platformDispatcher.locale.languageCode;
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;
      int timezoneOffset = DateTime.now().timeZoneOffset.inHours;

      logger.w(language);
      logger.w(ip);
      return BrowserInfo(
        ip: ip,
        language: language,
        javaEnabled: false,
        jsEnabled: true,
        colorDepth: 24,
        screenHeight: screenHeight.round(),
        screenWidth: screenWidth.round(),
        timezoneOffset: timezoneOffset,
        acceptHeader: "text/html",
        userAgent:
            'Mozilla/5.0 (iPhone; CPU iPhone OS 18_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      );
    } catch (e) {
      GlobalHelper.logger.e('Error info browser, $e');
      return null;
    }
  }

  showModalWebView(context, Function(String) onClose, String challengueHtml, String token, String idCress)async {

    CresServices serviceCres = CresServices();


    ThreeDsHandler _handler = ThreeDsHandler();

    _handler.startPolling(()=>serviceCres.cresGetData(token, idCress),onClose);

    GlobalHelper.logger.w('ENTRA AL CHALLENGUE');
    final controller = WebViewController()

  
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: ( request) {
          // if(request.url.contains('nuvei-cres-dev-bkh4atahdegxa8dk.')){
          //   Navigator.pop(context);
          //   // onClose();

          // }
          return NavigationDecision.navigate;
        },
      )
      
    )
    ..loadHtmlString(challengueHtml)
    ;


   await showGeneralDialog(
  barrierDismissible: false,
  transitionDuration: const Duration(milliseconds: 500),
  context: context,
  pageBuilder: (context, _, __) {
    return Scaffold(
      body: Center( // <- Para centrar el contenido
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width * 0.9, // opcional, limitar ancho
          child: Column(
            children: [
              Expanded(
                child: WebViewWidget(controller: controller),
              ),
              // Si quieres un botón al final:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButtonWidget(
                  onPressed: () {
                    Navigator.pop(context);
                    _handler.stopPolling();
                    // onClose();
                  },
                  text: 'Close',
                ),
              )
            ],
          ),
        ),
      ),
    );
  },
);
  }

  int completeYear(int twoDigitYear) {
    final now = DateTime.now();
    final currentYear = now.year; // e.g., 2025
    final currentCentury = (currentYear ~/ 100) * 100; // e.g., 2000

    if (twoDigitYear < currentYear % 100) {
      return currentCentury + 100 + twoDigitYear;
    } else {
      return currentCentury + twoDigitYear;
    }
  }
}
