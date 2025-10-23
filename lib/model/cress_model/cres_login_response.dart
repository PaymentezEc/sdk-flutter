
import 'dart:convert';

CresLoginResponse cresLoginResponseFromJson(String str) => CresLoginResponse.fromJson(json.decode(str));

String cresLoginResponseToJson(CresLoginResponse data) => json.encode(data.toJson());

class CresLoginResponse {
    String accessToken;
    String tokenType;
    int expiresIn;
    String name;

    CresLoginResponse({
        required this.accessToken,
        required this.tokenType,
        required this.expiresIn,
        required this.name,
    });

    factory CresLoginResponse.fromJson(Map<String, dynamic> json) => CresLoginResponse(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
        "name": name,
    };
}
