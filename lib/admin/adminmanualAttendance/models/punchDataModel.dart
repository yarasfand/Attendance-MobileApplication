class PunchData {
  final String cardNo;
  final String punchDatetime;
  final String pDay;
  final String isManual;
  final String payCode;
  final String machineNo;
  final String datetime1;
  final int viewInfo;
  final int showData;
  final String remark;

  PunchData({
    required this.cardNo,
    required this.punchDatetime,
    required this.pDay,
    required this.isManual,
    required this.payCode,
    required this.machineNo,
    required this.datetime1,
    required this.viewInfo,
    required this.showData,
    required this.remark,
  });

  factory PunchData.fromJson(Map<String, dynamic> json) {
    return PunchData(
      cardNo: json['CardNo'],
      punchDatetime: json['PunchDatetime'],
      pDay: json['PDay'],
      isManual: json['Ismanual'],
      payCode: json['PayCode'],
      machineNo: json['MachineNo'],
      datetime1: json['Dateime1'],
      viewInfo: json['Viewinfo'],
      showData: json['ShowData'],
      remark: json['Remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CardNo': cardNo,
      'PunchDatetime': punchDatetime,
      'PDay': pDay,
      'Ismanual': isManual,
      'PayCode': payCode,
      'MachineNo': machineNo,
      'Dateime1': datetime1,
      'Viewinfo': viewInfo,
      'ShowData': showData,
      'Remark': remark,
    };
  }
}
