class GeoFenceModel {
  final String cardNo;
  final DateTime? punchDatetime;
  final String location;
  final String lan;
  final String long;
  final String? imageData; // Represented as List of bytes
  final String imeiNo;
  final String temp1;
  final String temp2;
  final int? attendanceType;
  final String remark1;
  final String imagePath;

  GeoFenceModel({
    required this.cardNo,
    this.punchDatetime,
    required this.location,
    required this.lan,
    required this.long,
    this.imageData,
    required this.imeiNo,
    required this.temp1,
    required this.temp2,
    this.attendanceType,
    required this.remark1,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "Cardno": cardNo,
      "Location": location,
      "Lan": lan,
      "Long": long,
      "ImeiNo": imeiNo,
      "Temp1": temp1,
      "Temp2": temp2,
      "Remark1": remark1,
      "Imagepath": imagePath,
    };

    if (punchDatetime != null) {
      data["PunchDatetime"] = punchDatetime!.toIso8601String();
    }

    if (imageData != null) {
      data["ImageData"] = imageData;
    }

    if (attendanceType != null) {
      data["AttendanceType"] = attendanceType;
    }

    return data;
  }
}
