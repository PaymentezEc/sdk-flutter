// To parse this JSON data, do
//
//     final cardResponseModel = cardResponseModelFromJson(jsonString);

import 'dart:convert';

CardResponseModel cardResponseModelFromJson(String str) => CardResponseModel.fromJson(json.decode(str));

String cardResponseModelToJson(CardResponseModel data) => json.encode(data.toJson());

class CardResponseModel {
    Card card;
    The3Ds? the3Ds;
    Transaction transaction;

    CardResponseModel({
        required this.card,
         this.the3Ds,
         required this.transaction,
    });

    factory CardResponseModel.fromJson(Map<String, dynamic> json) => CardResponseModel(
        card: Card.fromJson(json["card"]),
        the3Ds: json["3ds"] != null ?  The3Ds.fromJson(json["3ds"]) : null,
        transaction: Transaction.fromJson(json["transaction"]),
    );

    Map<String, dynamic> toJson() => {
        "card": card.toJson(),
        "3ds": the3Ds?.toJson(),
        "transaction": transaction.toJson(),
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
    String message;

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
        required this.message,
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
        message: json["message"],
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
        "message": message,
    };
}

class The3Ds {
    Authentication authentication;
    BrowserResponse browserResponse;
    SdkResponse sdkResponse;

    The3Ds({
        required this.authentication,
        required this.browserResponse,
        required this.sdkResponse,
    });

    factory The3Ds.fromJson(Map<String, dynamic> json) => The3Ds(
        authentication: Authentication.fromJson(json["authentication"]),
        browserResponse: BrowserResponse.fromJson(json["browser_response"]),
        sdkResponse: SdkResponse.fromJson(json["sdk_response"]),
    );

    Map<String, dynamic> toJson() => {
        "authentication": authentication.toJson(),
        "browser_response": browserResponse.toJson(),
        "sdk_response": sdkResponse.toJson(),
    };
}

class Authentication {
    String status;
    String returnMessage;
    String version;
    String xid;
    String referenceId;
    dynamic cavv;
    String returnCode;
    String eci;

    Authentication({
        required this.status,
        required this.returnMessage,
        required this.version,
        required this.xid,
        required this.referenceId,
        required this.cavv,
        required this.returnCode,
        required this.eci,
    });

    factory Authentication.fromJson(Map<String, dynamic> json) => Authentication(
        status: json["status"],
        returnMessage: json["return_message"],
        version: json["version"] ?? '',
        xid: json["xid"],
        referenceId: json["reference_id"]?? '',
        cavv: json["cavv"],
        returnCode: json["return_code"],
        eci: json["eci"] ?? '',
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

class Transaction {
    int statusDetail;

    Transaction({
        required this.statusDetail,
    });

    factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
        statusDetail: json["status_detail"],
    );

    Map<String, dynamic> toJson() => {
        "status_detail": statusDetail,
    };
}

class BrowserResponse {
    String challengeRequest;
    String hiddenIframe;

    BrowserResponse({
        required this.challengeRequest,
        required this.hiddenIframe,
    });

    factory BrowserResponse.fromJson(Map<String, dynamic> json) => BrowserResponse(
        challengeRequest: json["challenge_request"],
        hiddenIframe: json["hidden_iframe"],
    );

    Map<String, dynamic> toJson() => {
        "challenge_request": challengeRequest,
        "hidden_iframe": hiddenIframe,
    };
}

class SdkResponse {
    String acsTransId;
    String acsSignedContent;
    String acsReferenceNumber;

    SdkResponse({
        required this.acsTransId,
        required this.acsSignedContent,
        required this.acsReferenceNumber,
    });

    factory SdkResponse.fromJson(Map<String, dynamic> json) => SdkResponse(
        acsTransId: json["acs_trans_id"],
        acsSignedContent: json["acs_signed_content"] ?? '',
        acsReferenceNumber: json["acs_reference_number"],
    );

    Map<String, dynamic> toJson() => {
        "acs_trans_id": acsTransId,
        "acs_signed_content": acsSignedContent,
        "acs_reference_number": acsReferenceNumber,
    };
}
