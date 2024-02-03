import 'package:flutter/material.dart';
import '../../../constants/AppColor_constants.dart';
import 'adminconstants.dart';

class AdminStorageInfoCard extends StatelessWidget {
  const AdminStorageInfoCard({
    Key? key,
    required this.title,
    required this.imageOrIcon, // Modified property
  }) : super(key: key);

  final String title;
  final Widget imageOrIcon; // Modified property

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFFAF9F6), // Cream color
      elevation: 5,
      shape: MediaQuery.of(context).size.height > 720
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
          : RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Container(
        padding: MediaQuery.of(context).size.height > 720
            ? EdgeInsets.all(20)
            : EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(defaultPadding),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: imageOrIcon, // Use the provided image or icon
            ),
            Expanded(
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
