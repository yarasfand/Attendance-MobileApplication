import 'package:flutter/material.dart';
import '../models/AdminDashBoard_model.dart';

class AdminCloudStorageInfo {
  final String? imageSrc, title;
  final int? numOfEmployees;
  final Color? color;

  AdminCloudStorageInfo({
    this.imageSrc,
    this.title,
    this.numOfEmployees,
    this.color,
  });
}

List<AdminCloudStorageInfo> createDemoMyFiles(AdminDashBoard? adminData) {
  final List<AdminCloudStorageInfo> demoMyFiles = [];

  if (adminData != null) {
    demoMyFiles.add(AdminCloudStorageInfo(
      title: "Total Employee",
      numOfEmployees: adminData.totalEmployeeCount,
      imageSrc: "assets/icons/employees.png",
      color: Colors.red,
    ));
    demoMyFiles.add(AdminCloudStorageInfo(
      title: "Present Employee",
      numOfEmployees: adminData.presentCount,
      imageSrc: "assets/icons/present.png",
      color: const Color(0xFFFFA113),
    ));
    demoMyFiles.add(AdminCloudStorageInfo(
      title: "Absent Employee",
      numOfEmployees: adminData.absentCount,
      imageSrc: "assets/icons/absent.png",
      color: const Color(0xFFA4CDFF),
    ));
    demoMyFiles.add(AdminCloudStorageInfo(
      title: "Late Employee",
      numOfEmployees: adminData.lateCount,
      imageSrc: "assets/icons/late.png",
      color: const Color(0xFF007EE5),
    ));
  } else {
    // If adminData is null or not available, provide default values
    demoMyFiles.add(AdminCloudStorageInfo(
      title: "Total Employee",
      numOfEmployees: 0,
      imageSrc: "assets/icons/employees.png",
      color: Colors.red,
    ));
    demoMyFiles.add(AdminCloudStorageInfo(
      title: "Present Employee",
      numOfEmployees: 0,
      imageSrc: "assets/icons/present.png",
      color: const Color(0xFFFFA113),
    ));
    demoMyFiles.add(AdminCloudStorageInfo(
      title: "Absent Employee",
      numOfEmployees: 0,
      imageSrc: "assets/icons/absent.png",
      color: const Color(0xFFA4CDFF),
    ));
    demoMyFiles.add(AdminCloudStorageInfo(
      title: "Late Employee",
      numOfEmployees: 0,
      imageSrc: "assets/icons/late.png",
      color: const Color(0xFF007EE5),
    ));
  }

  return demoMyFiles;
}
