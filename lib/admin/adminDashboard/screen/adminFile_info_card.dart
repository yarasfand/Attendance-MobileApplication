import 'package:flutter/material.dart';
import '../../../constants/AppColor_constants.dart';
import 'adminconstants.dart';


class AdminFileInfoCard extends StatelessWidget {
  final String imageSrc;
  final String title;
  final int numOfEmployees;
  final Color color;

  const AdminFileInfoCard({
    Key? key,
    required this.imageSrc,
    required this.title,
    required this.numOfEmployees,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding:  const EdgeInsets.all(defaultPadding),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),

        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1), // Use the provided color
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Image.asset(imageSrc), // Use the provided image source
                ),
                Text(
                  "$numOfEmployees ", // Use the provided number of employees
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: AppColors.darkGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
