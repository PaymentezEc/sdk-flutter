import 'package:flutter/material.dart';
import 'package:nuvei_sdk_flutter/model/add_card_model/card_model.dart';
import 'package:nuvei_sdk_flutter/model/order_model.dart';
import 'package:nuvei_sdk_flutter/model/payment_model/debit_model.dart';
import 'package:nuvei_sdk_flutter/model/general_response.dart';
import 'package:nuvei_sdk_flutter/model/transaction_model.dart';
import 'package:nuvei_sdk_flutter/model/user_model.dart';
import 'package:nuvei_sdk_flutter/model/verify_model/otp_request_model.dart';
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter_method_transaction.dart';

abstract class NuveiSdkFlutterTransactionInterface {
  NuveiSdkFlutterTransactionInterface() : super();

  static NuveiSdkFlutterTransactionInterface _instance =
      NuveiSdkFlutterMethodTransaction();

  static NuveiSdkFlutterTransactionInterface get instance => _instance;

  static set instance(NuveiSdkFlutterTransactionInterface instance) {
    _instance = instance;
  }

  void initEnvironment(
    String appCode,
    String appKey,
    String serverCode,
    String serverKey,
    bool testMode,
    String clientId,
    String clientSecret
  ) {
    throw UnimplementedError('Delete card has not been implemented');
  }

  Future<GeneralResponse> deleteCard({
    required String userId,
    required String tokenCard,
  }) {
    throw UnimplementedError('Delete card has not been implemented');
  }

  Future<GeneralResponse> debit({
    required User userInformation,
    required Order ordeInformation,
    required CardModel cardInformation,
  }) async {
    throw UnimplementedError("Debit card has not been implemented");
  }

  Future<GeneralResponse> listCards({required String userId}) {
    throw UnimplementedError('Delete card has not been implemented');
  }

  Future<GeneralResponse> addCard(CardModel card, UserModel user, BuildContext context, String termId) {
    throw UnimplementedError('Delete card has not been implemented');
  }

  Future<GeneralResponse> refund({required TransactionModel transaction, Order? order, bool moreInfo  = true}){
    throw UnimplementedError('Delete card has not been implemented');
  }

  Future<GeneralResponse> verify(OtpRequest otpRequest)async{
    throw UnimplementedError('Delete card has not been implemented');
  }

}

