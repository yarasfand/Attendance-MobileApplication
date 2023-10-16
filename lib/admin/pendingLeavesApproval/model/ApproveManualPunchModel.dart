import 'package:intl/intl.dart';

class ApproveManualPunchModel {
  final String cardNo;
  final DateTime punchDatetime;
  final String pDay;
  final String isManual;
  final String payCode;
  final String machineNo;
  final DateTime dateTime1;
  final int viewInfo;
  final int showData;
  final String remark;

  ApproveManualPunchModel({
    required this.cardNo,
    required this.punchDatetime,
    required this.pDay,
    required this.isManual,
    required this.payCode,
    required this.machineNo,
    required this.dateTime1,
    required this.viewInfo,
    required this.showData,
    required this.remark,
  });

  factory ApproveManualPunchModel.fromJson(Map<String, dynamic> json) {
    final format = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    return ApproveManualPunchModel(
      cardNo: json['cardNo'] ?? '',
      punchDatetime: format.parse(json['punchDatetime'] ?? '1970-01-01T00:00:00.000Z'),
      pDay: json['pDay'] ?? '',
      isManual: json['ismanual'] ?? '',
      payCode: json['payCode'] ?? '',
      machineNo: json['machineNo'] ?? '',
      dateTime1: format.parse(json['dateime1'] ?? '1970-01-01T00:00:00.000Z'),
      viewInfo: json['viewinfo'] ?? 0,
      showData: json['showData'] ?? 0,
      remark: json['remark'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cardNo': cardNo,
      'punchDatetime': punchDatetime.toIso8601String(),
      'pDay': pDay,
      'ismanual': isManual,
      'payCode': payCode,
      'machineNo': machineNo,
      'dateime1': dateTime1.toIso8601String(),
      'viewinfo': viewInfo,
      'showData': showData,
      'remark': remark,
    };
  }
}
