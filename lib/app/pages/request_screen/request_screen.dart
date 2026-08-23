import 'package:chatnest/app/pages/request_screen/request_page.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:chatnest/app/theme/theme.dart';
import 'package:chatnest/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      initState: (state) {
        var controller = Get.find<RequestController>();

        controller.blockUserPagingController
            .addPageRequestListener((pagekey) async {
          await controller.blockedUserListApi(pagekey);
        });
      },
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: GradientAppBar(
          elevation: 5,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'blocked_users'.tr,
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
              child: SvgPicture.asset(AssetConstants.appbarbackarrowicon),
            ),
          ),
        ),
        body: const BlockUserScreen(),
      ),
    );
  }
}
