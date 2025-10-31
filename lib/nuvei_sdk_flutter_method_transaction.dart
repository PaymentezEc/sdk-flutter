import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nuvei_sdk_flutter/env/environment.dart';
import 'package:nuvei_sdk_flutter/helper/card_helper.dart';
import 'package:nuvei_sdk_flutter/helper/global_helper.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/card_model.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/card_response_model.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/extra_params_model.dart';
import 'package:nuvei_sdk_flutter/model/list_card_model/card_item_model.dart';
import 'package:nuvei_sdk_flutter/model/order_model.dart';
import 'package:nuvei_sdk_flutter/model/payment_model/debit_model.dart';
import 'package:nuvei_sdk_flutter/model/error_model.dart';
import 'package:nuvei_sdk_flutter/model/general_response.dart';
import 'package:nuvei_sdk_flutter/model/list_card_model/list_card_model.dart';
import 'package:nuvei_sdk_flutter/model/refund_payment_model/refund_model.dart';
import 'package:nuvei_sdk_flutter/model/refund_payment_model/refund_response_model.dart';
import 'package:nuvei_sdk_flutter/model/transaaction_response.dart';
import 'package:nuvei_sdk_flutter/model/transaction_model.dart';
import 'package:nuvei_sdk_flutter/model/user_model.dart';
import 'package:nuvei_sdk_flutter/model/verify_model/otp_request_model.dart';
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter_transaction_interface.dart';
import 'package:nuvei_sdk_flutter/services/interceptor_http.dart';

class NuveiSdkFlutterMethodTransaction
    extends NuveiSdkFlutterTransactionInterface {
  InterceptorHttp interceptorHttp = InterceptorHttp();
  Environment env = Environment();

  @override
  void initEnvironment(
    String appCode,
    String appKey,
    String serverCode,
    String serverKey,
    bool testMode,
    String clientId,
    String clientSecret,
  ) {
    env.initConfig(
      appCode: appCode,
      appKey: appKey,
      serveCode: serverCode,
      serverKey: serverKey,
      testMode: testMode,
      clientId: clientId,
      clientSecret: clientSecret
    );
  }

  @override
  Future<GeneralResponse> deleteCard({
    required String userId,
    required String tokenCard,
  }) async {
    final urlEndpoint = '/v2/card/delete/';
    try {
      final response = await interceptorHttp.request(
        'POST',
        urlEndpoint,
        env.serverCode,
        env.serverKey,
        {
          "card": {"token": tokenCard},
          "user": {"id": userId},
        },
      );
      if (!response.error) {
        String message = response.data["message"];
        return GeneralResponse(error: response.error, data: message);
      }

      return GeneralResponse(error: true);
    } catch (e) {
      return GeneralResponse(
        error: true,
        data: ErrorResponseModel(
          error: Error(type: 'Exception', help: '', description: '$e'),
        ),
      );
    }
  }

  @override
  Future<GeneralResponse> listCards({required String userId}) async {
    final urlEndpoint = "/v2/card/list";
    try {
      final response = await interceptorHttp.request(
        'GET',
        urlEndpoint,
        env.serverCode,
        env.serverKey,
        null,
        queryParameters: {"uid": userId},
      );
      GlobalHelper.logger.w("aqui llego esto : ${jsonEncode(response)}");
      if (!response.error) {
        ListCardModel listCards = listCardModelFromJson(
          jsonEncode(response.data),
        );

       final List<CardItemModel> validCards  = listCards.cards.where((card) => card.status == 'valid')
       .map((card){
        GlobalHelper.logger.w('type card: ${card.type}');
        card.icon = CardHelper().getCardInfoBytipe(card.type ?? '').icon;
        return card;
       }).toList();

        listCards.cards = validCards;

        return GeneralResponse(error: false, data: listCards);
      }
      return response;
    } catch (e) {
      GlobalHelper.logger.e('ERROOOR: $e');
       return GeneralResponse(
        error: true,
        data: ErrorResponseModel(
          error: Error(type: 'Exception', help: '', description: '$e'),
        ),
      );
    }
  }

  @override
  Future<GeneralResponse> addCard(
    CardModel card,
    UserModel user,
    BuildContext context,
    String termId,
  ) async {
    final urlEndpoint = "/v2/card/add";
    try {
      GlobalHelper.logger.w('entry in this point');

      final extraParams = ExtraParamsModel(
        threeDs2Data: ThreeDs2Data(
          termUrl: 'https://nuvei-cres-dev-bkh4atahdegxa8dk.eastus-01.azurewebsites.net/api/cres/save/$termId',
          deviceType: 'browser',
        ),
        browserInfo: await GlobalHelper().getBrowserInfo(context),
      );

      final data = {"user": user, "card": card, "extra_params": extraParams};

      final response = await interceptorHttp.request(
        'POST',
        urlEndpoint,
        env.appCode,
        env.appKey,
        data,
      );

      if (!response.error) {
        CardResponseModel cardResponse = cardResponseModelFromJson(
          jsonEncode(response.data),
        );
        return GeneralResponse(error: false, data: cardResponse);
      }
      return GeneralResponse(error: true, data: response.data);
    } catch (e) {
      GlobalHelper.logger.e('ERROOOR: $e');
       return GeneralResponse(
        error: true,
        data: ErrorResponseModel(
          error: Error(type: 'Exception', help: '', description: '$e'),
        ),
      );
    }
  }

  @override
  Future<GeneralResponse> debit({
    required User userInformation,
    required Order ordeInformation,
    required CardModel cardInformation,
  }) async {
    final urlEndpoint = '/v2/transaction/debit/';
    try {
      CreditCardTransaction transaction = CreditCardTransaction(
        order: ordeInformation,
        user: userInformation,
        card: cardInformation,
      );
      final response = await interceptorHttp.request(
        'POST',
        urlEndpoint,
        env.serverCode,
        env.serverKey,
        transaction,
      );
      GlobalHelper.logger.w('request error: ${response.error}');
      if (!response.error) {
        TransactionResponse data = transactionResponseFromJson(
          jsonEncode(response.data),
        );
        return GeneralResponse(error: false, data: data);
      }
      return response;
    } catch (e) {
      GlobalHelper.logger.e('ERROOOR: $e');
       return GeneralResponse(
        error: true,
        data: ErrorResponseModel(
          error: Error(type: 'Exception', help: '', description: '$e'),
        ),
      );
    }
  }

  @override
  Future<GeneralResponse> refund({
    required TransactionModel transaction,
    Order? order,
    bool moreInfo = true,
  }) async {
    try {
      final urlEndpoint = '/v2/transaction/refund/';
      RefundModel refundBody = RefundModel(
        transaction: transaction,
        order: order,
        moreInfo: moreInfo,
      );
      final response = await interceptorHttp.request(
        'POST',
        urlEndpoint,
        env.serverCode,
        env.serverKey,
        refundBody,
      );
      if (!response.error) {
        RefundResponseModel data = refundResponseModelFromJson(
          jsonEncode(response.data),
        );
        return GeneralResponse(error: false, data: data);
      }
      return response;
    } catch (e) {
       return GeneralResponse(
        error: true,
        data: ErrorResponseModel(
          error: Error(type: 'Exception', help: '', description: '$e'),
        ),
      );
    }
  }


  @override
  Future<GeneralResponse> verify(OtpRequest otpRequest) async {

    try {
    final urlEndPoint = '/v2/transaction/verify';
    final response = await interceptorHttp.request(
      'POST',
      urlEndPoint,
      env.serverCode,
      env.serverKey,
      otpRequest,
    );
      
      return response;
    } catch (e) {
       return GeneralResponse(
        error: true,
        data: ErrorResponseModel(
          error: Error(type: 'Exception', help: '', description: '$e'),
        ),
      );
    }
  }
}
