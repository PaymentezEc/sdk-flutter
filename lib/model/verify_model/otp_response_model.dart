// To parse this JSON data, do
//
//     final otpResponse = otpResponseFromJson(jsonString);

import 'dart:convert';

OtpResponse otpResponseFromJson(String str) => OtpResponse.fromJson(json.decode(str));

String otpResponseToJson(OtpResponse data) => json.encode(data.toJson());
class OtpResponse {
  Transaction transaction;
  Card card;
  ThreeDsData? threeDs; // <-- AGREGADO

  OtpResponse({
    required this.transaction,
    required this.card,
    this.threeDs,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) => OtpResponse(
        transaction: Transaction.fromJson(json["transaction"]),
        card: Card.fromJson(json["card"]),
        threeDs: json["3ds"] != null
            ? ThreeDsData.fromJson(json["3ds"])
            : null, // <-- Manejo seguro
      );

  Map<String, dynamic> toJson() => {
        "transaction": transaction.toJson(),
        "card": card.toJson(),
        if (threeDs != null) "3ds": threeDs!.toJson(),
      };
}
class Card {
    String number;
    String bin;
    String type;
    String transactionReference;
    String status;
    String token;
    String expiryYear;
    String expiryMonth;
    String origin;
    String? bankName;

    Card({
        required this.number,
        required this.bin,
        required this.type,
        required this.transactionReference,
        required this.status,
        required this.token,
        required this.expiryYear,
        required this.expiryMonth,
        required this.origin,
         this.bankName,
    });

    factory Card.fromJson(Map<String, dynamic> json) => Card(
        number: json["number"],
        bin: json["bin"],
        type: json["type"],
        transactionReference: json["transaction_reference"],
        status: json["status"],
        token: json["token"],
        expiryYear: json["expiry_year"],
        expiryMonth: json["expiry_month"],
        origin: json["origin"],
        bankName: json["bank_name"],
    );

    Map<String, dynamic> toJson() => {
        "number": number,
        "bin": bin,
        "type": type,
        "transaction_reference": transactionReference,
        "status": status,
        "token": token,
        "expiry_year": expiryYear,
        "expiry_month": expiryMonth,
        "origin": origin,
        "bank_name": bankName,
    };
}

class Transaction {
    String id;
    String status;
    String currentStatus;
    int statusDetail;
    dynamic paymentDate;
    double amount;
    int installments;
    String carrierCode;
    String message;
    dynamic authorizationCode;
    String devReference;
    String carrier;
    String productDescription;
    String paymentMethodType;
    String installmentsType;

    Transaction({
        required this.id,
        required this.status,
        required this.currentStatus,
        required this.statusDetail,
        required this.paymentDate,
        required this.amount,
        required this.installments,
        required this.carrierCode,
        required this.message,
        required this.authorizationCode,
        required this.devReference,
        required this.carrier,
        required this.productDescription,
        required this.paymentMethodType,
        required this.installmentsType,
    });

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        id: json["id"],
        status: json["status"],
        currentStatus: json["current_status"],
        statusDetail: json["status_detail"],
        paymentDate: json["payment_date"],
        amount: json["amount"]?.toDouble(),
        installments: json["installments"],
        carrierCode: json["carrier_code"],
        message: json["message"],
        authorizationCode: json["authorization_code"],
        devReference: json["dev_reference"],
        carrier: json["carrier"],
        productDescription: json["product_description"],
        paymentMethodType: json["payment_method_type"],
        installmentsType: json["installments_type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "current_status": currentStatus,
        "status_detail": statusDetail,
        "payment_date": paymentDate,
        "amount": amount,
        "installments": installments,
        "carrier_code": carrierCode,
        "message": message,
        "authorization_code": authorizationCode,
        "dev_reference": devReference,
        "carrier": carrier,
        "product_description": productDescription,
        "payment_method_type": paymentMethodType,
        "installments_type": installmentsType,
    };

}


class ThreeDsData {
  SdkResponse? sdkResponse;
  AuthenticationData? authentication;
  BrowserResponse? browserResponse;

  ThreeDsData({
    this.sdkResponse,
    this.authentication,
    this.browserResponse,
  });

  factory ThreeDsData.fromJson(Map<String, dynamic> json) => ThreeDsData(
        sdkResponse: json["sdk_response"] != null
            ? SdkResponse.fromJson(json["sdk_response"])
            : null,
        authentication: json["authentication"] != null
            ? AuthenticationData.fromJson(json["authentication"])
            : null,
        browserResponse: json["browser_response"] != null
            ? BrowserResponse.fromJson(json["browser_response"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        if (sdkResponse != null) "sdk_response": sdkResponse!.toJson(),
        if (authentication != null) "authentication": authentication!.toJson(),
        if (browserResponse != null)
          "browser_response": browserResponse!.toJson(),
      };
}

class SdkResponse {
  String? acsTransId;
  String? acsSignedContent;
  String? acsReferenceNumber;

  SdkResponse({
    this.acsTransId,
    this.acsSignedContent,
    this.acsReferenceNumber,
  });

  factory SdkResponse.fromJson(Map<String, dynamic> json) => SdkResponse(
        acsTransId: json["acs_trans_id"],
        acsSignedContent: json["acs_signed_content"],
        acsReferenceNumber: json["acs_reference_number"],
      );

  Map<String, dynamic> toJson() => {
        "acs_trans_id": acsTransId,
        "acs_signed_content": acsSignedContent,
        "acs_reference_number": acsReferenceNumber,
      };
}

class AuthenticationData {
  String? status;
  String? returnMessage;
  String? version;
  String? xid;
  String? referenceId;
  String? cavv;
  String? returnCode;
  String? eci;

  AuthenticationData({
    this.status,
    this.returnMessage,
    this.version,
    this.xid,
    this.referenceId,
    this.cavv,
    this.returnCode,
    this.eci,
  });

  factory AuthenticationData.fromJson(Map<String, dynamic> json) =>
      AuthenticationData(
        status: json["status"],
        returnMessage: json["return_message"],
        version: json["version"],
        xid: json["xid"],
        referenceId: json["reference_id"],
        cavv: json["cavv"],
        returnCode: json["return_code"],
        eci: json["eci"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "return_message": returnMessage,
        "version": version,
        "xid": xid,
        "reference_id": referenceId,
        "cavv": cavv,
        "return_code": returnCode,
        "eci": eci,
      };
}

class BrowserResponse {
  String? hiddenIframe;
  String? challengeRequest;

  BrowserResponse({
    this.hiddenIframe,
    this.challengeRequest,
  });

  factory BrowserResponse.fromJson(Map<String, dynamic> json) =>
      BrowserResponse(
        hiddenIframe: json["hidden_iframe"],
        challengeRequest: json["challenge_request"],
      );

  Map<String, dynamic> toJson() => {
        "hidden_iframe": hiddenIframe,
        "challenge_request": challengeRequest,
      };
}

