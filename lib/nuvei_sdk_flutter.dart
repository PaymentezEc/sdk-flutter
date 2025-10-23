// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'package:nuvei_sdk_flutter/model/add_card_model/card_model.dart';
import 'package:nuvei_sdk_flutter/model/order_model.dart';
import 'package:nuvei_sdk_flutter/model/payment_model/debit_model.dart';
import 'package:nuvei_sdk_flutter/model/general_response.dart';
import 'package:nuvei_sdk_flutter/model/transaction_model.dart';
import 'package:nuvei_sdk_flutter/nuvei_sdk_flutter_transaction_interface.dart';

class NuveiSdkFlutter {
  static final NuveiSdkFlutter _nuveiSdkFlutter = NuveiSdkFlutter._internal();

  factory NuveiSdkFlutter() => _nuveiSdkFlutter;

  NuveiSdkFlutter._internal();

  Future<GeneralResponse> deleteCard({
    required String userId,
    required String tokenCard,
  }) async {
    return NuveiSdkFlutterTransactionInterface.instance.deleteCard(
      tokenCard: tokenCard,
      userId: userId,
    );
  }

  Future<GeneralResponse> listCards({required String userId}) async {
    return NuveiSdkFlutterTransactionInterface.instance.listCards(
      userId: userId,
    );
  }

  Future<GeneralResponse> debit({
    required User userInformation,
    required Order ordeInformation,
    required CardModel cardInformation,
  }) async {
    return NuveiSdkFlutterTransactionInterface.instance.debit(
      userInformation: userInformation,
      ordeInformation: ordeInformation,
      cardInformation: cardInformation,
    );
  }

  Future<GeneralResponse> refund({
    required TransactionModel transaction,
    Order? order,
    bool moreInfo = true,
  }) async {
    return NuveiSdkFlutterTransactionInterface.instance.refund(
      transaction: transaction,
      order: order,
      moreInfo: moreInfo,
    );
  }

  void initEnvironment(
    String appCode,
    String appKey,
    String serverCode,
    String serverKey,
    bool testMode,
    String clientId,
    String clientSecret,
  ) {
    return NuveiSdkFlutterTransactionInterface.instance.initEnvironment(
      appCode,
      appKey,
      serverCode,
      serverKey,
      testMode,
      clientId,
      clientSecret
    );
  }
}
