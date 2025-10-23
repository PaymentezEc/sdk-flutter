import 'dart:convert';

import 'package:nuvei_sdk_flutter/helper/global_helper.dart';
import 'package:nuvei_sdk_flutter/model/cress_model/cres_consulting_response.dart';
import 'package:nuvei_sdk_flutter/model/cress_model/cres_data_response.dart';
import 'package:nuvei_sdk_flutter/model/cress_model/cres_login_response.dart';
import 'package:nuvei_sdk_flutter/model/general_response.dart';
import 'package:nuvei_sdk_flutter/services/interceptor_http.dart';

class CresServices {
  InterceptorHttp interceptorHttp = InterceptorHttp();
  Future<GeneralResponse<CresLoginResponse>> loginCres(
    String clientId,
    String clientSecret,
  ) async {
    try {
      final urlEndPoint = 'api/auth/login';
      final response = await interceptorHttp.request(
        'POST',
        urlEndPoint,
        '',
        '',
        {"clientId": clientId, "clientSecret": clientSecret},
        isCress: true,
      );
      CresLoginResponse? cresLoginResponse;
      if (!response.error) {
        cresLoginResponse = cresLoginResponseFromJson(
          jsonEncode(response.data),
        );
      }
      return GeneralResponse(error: response.error, data: cresLoginResponse);
    } catch (e) {
      GlobalHelper.logger.w('Error to login cres');
      return GeneralResponse(error: true);
    }
  }

  Future<GeneralResponse<CresConsultingResponse>> createReferenceCres(
    String token,
  ) async {
    try {
      final urlEndPoint = 'api/cres/createreference';
      final response = await interceptorHttp.request(
        'POST',
        urlEndPoint,
        '',
        '',
        null,
        isCress: true,
        tokenCress: token,
      );
      CresConsultingResponse? cresConsultingResponse;
      if (!response.error) {
        cresConsultingResponse = cresConsultingResponseFromJson(
          jsonEncode(response.data),
        );
      }
      return GeneralResponse(
        error: response.error,
        data: cresConsultingResponse,
      );
    } catch (e) {
      GlobalHelper.logger.w('Error to genterate reference');
      return GeneralResponse(error: true);
    }
  }


    Future<GeneralResponse<CresConsultingResponse>> saveDataCres(
    String token,
    String id,
  ) async {
    try {
      final urlEndPoint = 'api/cres/save/$id';
      final response = await interceptorHttp.request(
        'POST',
        urlEndPoint,
        '',
        '',
        null,
        isCress: true,
        tokenCress: token,
      );
      CresConsultingResponse? cresConsultingResponse;
      if (!response.error) {
        cresConsultingResponse = cresConsultingResponseFromJson(
          jsonEncode(response.data),
        );
      }
      return GeneralResponse(
        error: response.error,
        data: cresConsultingResponse,
      );
    } catch (e) {
      GlobalHelper.logger.w('Error to save cres data');
      return GeneralResponse(error: true);
    }
  }




      Future<GeneralResponse<CresDataResponse>> cresGetData(
    String token,
    String id,
  ) async {
    try {
      final urlEndPoint = 'api/cres/get/$id';
      final response = await interceptorHttp.request(
        'GET',
        urlEndPoint,
        '',
        '',
        null,
        isCress: true,
        tokenCress: token,
      );
      CresDataResponse? cresDataResponse;
      if (!response.error) {
        cresDataResponse = cresDataResponseFromJson(
          jsonEncode(response.data),
        );
      }
      return GeneralResponse(
        error: response.error,
        data: cresDataResponse,
      );
    } catch (e) {
      GlobalHelper.logger.w('Error to get cress information');
      return GeneralResponse(error: true);
    }
  }


    Future<GeneralResponse<CresDataResponse>> confirmCres(
    String token,
    String id,
  ) async {
    try {
      final urlEndPoint = 'api/cres/confirm';
      final response = await interceptorHttp.request(
        'POST',
        urlEndPoint,
        '',
        '',
        {
          "id": id
        },
        isCress: true,
        tokenCress: token,
      );
      CresDataResponse? cresDataResponse;
      if (!response.error) {
        cresDataResponse = cresDataResponseFromJson(
          jsonEncode(response.data),
        );
      }
      return GeneralResponse(
        error: response.error,
        data: cresDataResponse,
      );
    } catch (e) {
      GlobalHelper.logger.w('Error to get cress information');
      return GeneralResponse(error: true);
    }
  }
}
