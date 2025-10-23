
import 'dart:convert';

CresConsultingResponse cresConsultingResponseFromJson(String str) => CresConsultingResponse.fromJson(json.decode(str));

String cresConsultingResponseToJson(CresConsultingResponse data) => json.encode(data.toJson());

class CresConsultingResponse {
    bool status;
    String id;
    String message;

    CresConsultingResponse({
        required this.status,
        this.id = '',
        this.message = '',
    });

    factory CresConsultingResponse.fromJson(Map<String, dynamic> json) => CresConsultingResponse(
        status: json["status"],
        id: json["id"] ?? '',
        message: json["message"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "id": id,
        "message": message,
    };
}
