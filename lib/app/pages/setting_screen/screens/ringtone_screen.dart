import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RingtoneScreen extends StatelessWidget {
  const RingtoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(initState: (state) {
      var controller = Get.find<SettingController>();
      controller.getRingtone();
      // if (controller.ringName != "") {
      //   for (var i = 0; i < controller.ringtoneList.length; i++) {
      //     if (controller.ringtoneList[i].name == controller.ringName) {
      //       controller.ringtoneList.add(controller.ringtoneList[i]);
      //     }
      //   }
      // }
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "ringtone".tr,
                style: Styles.black70018,
              ),
            ],
          ),
          leading: Padding(
            padding: Dimens.edgeInsets15,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
              ),
            ),
          ),
        ),
        body: ListView(
          shrinkWrap: true,
          padding: Dimens.edgeInsets20,
          physics: const ClampingScrollPhysics(),
          children: [
            ListTile(
              onTap: () {
                Get.find<Repository>()
                    .saveValue("ringtone", 'system_ringtone_default');
              },
              contentPadding: Dimens.edgeInsets0,
              title: Text(
                'same_as_device_ringtone'.tr,
                style: Styles.black70016,
              ),
              trailing: SvgPicture.asset(AssetConstants.setting_right_arrow),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.two,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight15,
            Text(
              'custom'.tr.toUpperCase(),
              style: Styles.greyColor888870016,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.ringtoneList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Get.find<Repository>().saveValue(LocalKeys.ringtones,
                        controller.ringtoneList[index].name);

                    Get.find<Repository>().saveValue(LocalKeys.ringSelect,
                        controller.ringtoneList[index].isSelect);

                    controller.ringtoneValue =
                        controller.ringtoneList[index].isSelect!;
                    controller.update();
                    Get.forceAppUpdate();
                  },
                  contentPadding: Dimens.edgeInsets0,
                  title: Text(
                    controller.ringtoneList[index].name ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.black50016,
                  ),
                  trailing: Transform.scale(
                    scale: 1.2,
                    child: Radio(
                      value: controller.ringtoneList[index].isSelect ?? 0,
                      groupValue: controller.ringtoneValue,
                      activeColor: ColorsValue.appColor,
                      onChanged: (value) {
                        controller.ringtoneValue = value!;
                        Get.find<Repository>()
                            .saveValue(LocalKeys.ringSelect, value);
                        Get.find<Repository>().saveValue(LocalKeys.ringtones,
                            controller.ringtoneList[index].name);
                        controller.update();
                        Get.forceAppUpdate();
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
      );
    });
  }
}
