import 'package:flutter/material.dart';
import 'package:wayaak_delivery/app/data/constants/constants.dart';
import 'package:wayaak_delivery/app/data/extensions/extensions.dart';

class UserSheetDataPart extends StatelessWidget {
  final String avatar;
  final String phone;
  final String name;
  const UserSheetDataPart({
    super.key,
    required this.avatar,
    required this.phone,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.grey),
        borderRadius: BorderRadius.circular(80),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              width: 55,
              height: 55,
              child: "${Constants.baseUrl}storage/$avatar".image(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                name.bodyMedium(
                  weight: FontWeight.bold,
                  color: Colors.black,
                ),
                const SizedBox(height: 5),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: phone.caption(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
