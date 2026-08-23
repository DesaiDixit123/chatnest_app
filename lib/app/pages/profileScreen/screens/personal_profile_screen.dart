import 'package:chatnest/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PersonalProfileScreen extends StatelessWidget {
  const PersonalProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (state) async {
        var controller = Get.find<ProfileController>();
        await controller.getProfile();
        controller.personalProfileView = [
          ProfileDetail(
              icon: SvgPicture.asset(AssetConstants.callicon),
              title: "mobile_number".tr,
              subtitle: controller.profileData?.mobile?.isNotEmpty ?? false
                  ? '${controller.profileData?.countryCode} ${controller.profileData?.mobile}'
                  : " -- "),
          ProfileDetail(
              icon: SvgPicture.asset(AssetConstants.gendericon),
              title: "Gender",
              subtitle: controller.profileData?.gender ?? " -- "),
          ProfileDetail(
              icon: SvgPicture.asset(AssetConstants.smsicon),
              title: 'Email',
              subtitle: controller.profileData?.email ?? " -- "),
          ProfileDetail(
              icon: SvgPicture.asset(AssetConstants.dobicon),
              title: 'Date of Birth',
              subtitle: controller.profileData?.dob ?? " -- "),
          ProfileDetail(
              icon: SvgPicture.asset(AssetConstants.usericon),
              title: 'About us',
              subtitle: controller.profileData?.aboutme ?? " -- "),
          ProfileDetail(
            icon: SvgPicture.asset(AssetConstants.locationicon),
            title: 'Location',
            subtitle: controller.locationText.isNotEmpty
                ? controller.locationText
                : " -- ",
          ),
          ProfileDetail(
              icon: SvgPicture.asset(AssetConstants.intrestedinicon),
              title: 'Intrested in',
              subtitle: controller.profileData?.interestedin ?? " -- "),
          ProfileDetail(
              icon: SvgPicture.asset(AssetConstants.intrestedageicon),
              title: 'Intrested Age Range',
              subtitle:
                  '${controller.profileData?.interestedagerangemin} - ${controller.profileData?.interestedagerangemax}'),
        ];
      },
      builder: (controller) => ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        padding: Dimens.edgeInsets20_10_20_10,
        children: [
          Wrap(
            direction: Axis.horizontal,
            children: controller.personalProfileView.asMap().entries.map(
              (e) {
                var index = e.key;
                return ListTile(
                  isThreeLine: true,
                  dense: true,
                  contentPadding: Dimens.edgeInsets0,
                  title: Padding(
                    padding: EdgeInsets.zero,
                    child: Text(
                      '${controller.personalProfileView[index].title}',
                      style: Styles.black50014,
                    ),
                  ),
                  subtitle: Text(
                    '${controller.personalProfileView[index].subtitle}',
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: Styles.greyColor888840014,
                  ),
                  leading: controller.personalProfileView[index].icon,
                );
              },
            ).toList(),
          ),
          // Dimens.boxHeight10,
          // const Divider(
          //   color: ColorsValue.textfildbackcolor,
          // ),
          // Dimens.boxHeight10,
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Row(
          //       children: [
          //         SvgPicture.asset(AssetConstants.lockicon),
          //         Dimens.boxWidth10,
          //         Text(
          //           "applock_with_faceid".tr,
          //           style: Styles.black50016,
          //         ),
          //       ],
          //     ),
          //     CupertinoSwitch(
          //         activeColor: ColorsValue.maincolor1,
          //         value: controller.applock,
          //         onChanged: (value) {
          //           controller.applock = value;
          //           controller.update();
          //         })
          //   ],
          // ),
          // Dimens.boxHeight100,
        ],
      ),
    );
  }
}
