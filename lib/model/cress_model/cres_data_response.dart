import 'dart:convert'; CresDataResponse cresDataResponseFromJson(String str) => CresDataResponse.fromJson(json.decode(str)); String cresDataResponseToJson(CresDataResponse data) => json.encode(data.toJson());


class CresDataResponse {
  Data data;
  bool confirmed;

  CresDataResponse({
    required this.data,
    required this.confirmed,
  });

  factory CresDataResponse.fromJson(Map<String, dynamic> json) => CresDataResponse(
        data: (json["data"] != null && json["data"].isNotEmpty)
            ? Data.fromJson(json["data"])
            : Data.empty(),
        confirmed: json["confirmed"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "confirmed": confirmed,
      };
}

class Data {
  String? cres;
  String? transStatus;

  Data({
    this.cres,
    this.transStatus,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        cres: json["cres"],
        transStatus: json["transStatus"],
      );

  factory Data.empty() => Data(cres: null, transStatus: null);

  Map<String, dynamic> toJson() => {
        "cres": cres,
        "transStatus": transStatus,
      };
}
