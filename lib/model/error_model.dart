// To parse this JSON data, do
//
//     final errorResponseModel = errorResponseModelFromJson(jsonString);

import 'dart:convert';

ErrorResponseModel errorResponseModelFromJson(String str) => ErrorResponseModel.fromJson(json.decode(str));

String errorResponseModelToJson(ErrorResponseModel data) => json.encode(data.toJson());

class ErrorResponseModel {
    Error error;

    ErrorResponseModel({
        required this.error,
    });

    factory ErrorResponseModel.fromJson(Map<String, dynamic> json) => ErrorResponseModel(
        error: Error.fromJson(json["error"]),
    );

    Map<String, dynamic> toJson() => {
        "error": error.toJson(),
    };
}

class Error {
    String type;
    String help;
    String description;

    Error({
        required this.type,
        required this.help,
        required this.description,
    });

    factory Error.fromJson(Map<String, dynamic> json) => Error(
        type: json["type"],
        help: json["help"],
        description:(json["description"] is String)
      ? json["description"]
      : jsonEncode(json["description"] ?? ''),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "help": help,
        "description": description,
    };
}
