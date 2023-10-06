
import 'package:flutter/material.dart';

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

List demoMyFiles = [
  AdminCloudStorageInfo(
    title: "Total Employee",
    numOfEmployees: 10,
    imageSrc: "assets/icons/employees.png",
    color: Colors.red,
  ),
  AdminCloudStorageInfo(
    title: "Present Employee",
    numOfEmployees: 1328,
    imageSrc: "assets/icons/present.png",

    color: const Color(0xFFFFA113),

  ),
  AdminCloudStorageInfo(
    title: "Absent Employee",
    numOfEmployees: 1328,
    imageSrc: "assets/icons/absent.png",

    color: const Color(0xFFA4CDFF),
  ),
  AdminCloudStorageInfo(
    title: "Late Employee",
    numOfEmployees: 20,
    imageSrc: "assets/icons/late.png",

    color: const Color(0xFF007EE5),

  ),
];
