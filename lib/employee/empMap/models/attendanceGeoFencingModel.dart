class GeofenceModel {
  String? cardno;
  DateTime? punchDatetime; // Keep it as DateTime
  String? location;
  String? lan;
  String? long;
  String? imageData;
  String? imeiNo;
  String? temp1;
  String? temp2;
  String? attendanceType;
  String? remark1;
  String? imagepath;

  GeofenceModel(
      {this.cardno,
        this.punchDatetime,
        this.location,
        this.lan,
        this.long,
        this.imageData,
        this.imeiNo,
        this.temp1,
        this.temp2,
        this.attendanceType,
        this.remark1,
        this.imagepath});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Cardno'] = this.cardno;
    data['PunchDatetime'] = this.punchDatetime?.toIso8601String(); // Convert DateTime to ISO 8601 string
    data['Location'] = this.location;
    data['Lan'] = this.lan;
    data['Long'] = this.long;
    data['ImageData'] = this.imageData;
    data['ImeiNo'] = this.imeiNo;
    data['Temp1'] = this.temp1;
    data['Temp2'] = this.temp2;
    data['AttendanceType'] = this.attendanceType;
    data['Remark1'] = this.remark1;
    data['Imagepath'] = this.imagepath;
    return data;
  }

  // Deserialize DateTime from ISO 8601 string
  factory GeofenceModel.fromJson(Map<String, dynamic> json) {
    return GeofenceModel(
      cardno: json['Cardno'],
      punchDatetime: json['PunchDatetime'] != null
          ? DateTime.parse(json['PunchDatetime'])
          : null,
      location: json['Location'],
      lan: json['Lan'],
      long: json['Long'],
      imageData: json['ImageData'],
      imeiNo: json['ImeiNo'],
      temp1: json['Temp1'],
      temp2: json['Temp2'],
      attendanceType: json['AttendanceType'],
      remark1: json['Remark1'],
      imagepath: json['Imagepath'],
    );
  }
}
