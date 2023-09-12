
import 'package:flutter/material.dart';

class CloudStorageInfo {
  final String? imageSrc, title;
  final int? numOfEmployees;
  final Color? color;

  CloudStorageInfo({
    this.imageSrc,
    this.title,
    this.numOfEmployees,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Total Employee",
    numOfEmployees: 10,
    imageSrc: "assets/icons/employees.png",
    color: Colors.red,
  ),
  CloudStorageInfo(
    title: "Present Employee",
    numOfEmployees: 1328,
    imageSrc: "assets/icons/present.png",

    color: const Color(0xFFFFA113),

  ),
  CloudStorageInfo(
    title: "Absent Employee",
    numOfEmployees: 1328,
    imageSrc: "assets/icons/absent.png",

    color: const Color(0xFFA4CDFF),
  ),
  CloudStorageInfo(
    title: "Late Employee",
    numOfEmployees: 20,
    imageSrc: "assets/icons/late.png",

    color: const Color(0xFF007EE5),

  ),
];
