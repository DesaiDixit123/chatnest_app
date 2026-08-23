import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScreenDemo extends StatelessWidget {
  const ScreenDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(builder: (context) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              Get.find<Repository>().getStringValue(LocalKeys.fcmToken),
            ),
            SizedBox(
              height: 10,
            ),
            CustomButton(
              text: "Copy",
              onTap: () {
                Utility.copyText(
                    Get.find<Repository>().getStringValue(LocalKeys.fcmToken));
              },
            )
          ],
        ),
      );
    });
  }
}
