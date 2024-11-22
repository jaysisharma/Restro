import 'package:flutter/material.dart';

import '../../../../utils/theme.dart';

class AddressWidget extends StatelessWidget {
  const AddressWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text(
                "Delivered to",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Row(
              children: const [
                Icon(Icons.location_on, color: AppColors.primary),
                Text(
                  "123 Main Street, City",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ],
        ),
      ],
    );
  }
}