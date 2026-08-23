import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class MultiUserScreen extends StatelessWidget {
  const MultiUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(initState: (state) {
      var controller = Get.find<SettingController>();
      controller.multiUserPagingController = PagingController(firstPageKey: 1);
      controller.multiUserPagingController
          .addPageRequestListener((pageKey) async {
        await controller.postSubUserList(pageKey);
      });
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
                "multi_user".tr,
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
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(
                  double.maxFinite,
                  Dimens.fifty,
                ),
                backgroundColor: ColorsValue.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Dimens.five,
                  ),
                ),
              ),
              onPressed: () {
                controller.nameController.clear();
                controller.userNameController.clear();
                controller.emailController.clear();
                controller.mobileController.clear();
                controller.dailCode = "+91";
                controller.update();
                RouteManagement.goToCreateMultiUserScreen("");
              },
              child: Text(
                'create'.tr.toUpperCase(),
                style: Styles.white50016,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => controller.multiUserPagingController.refresh(),
            ),
             color: ColorsValue.appColor,
            child: PagedListView<int, MultiUserDoc>(
              pagingController: controller.multiUserPagingController,
              builderDelegate: PagedChildBuilderDelegate<MultiUserDoc>(
                noItemsFoundIndicatorBuilder: (_) => Center(
                  child: SvgPicture.asset(
                    AssetConstants.chat_empty,
                  ),
                ),
                itemBuilder: (context, item, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        onTap: () {},
                        contentPadding: Dimens.edgeInsets20_0_20_0,
                        title: Text(
                          item.username ?? "",
                          style: Styles.black50016,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.nameController.text =
                                    item.fullname ?? "";
                                controller.userNameController.text =
                                    item.username ?? "";
                                controller.emailController.text =
                                    item.email ?? "";
                                controller.mobileController.text =
                                    item.mobile ?? "";
                                controller.dailCode = item.countryCode ?? "";
                                controller.isValid = true;
                                controller.update();
                                RouteManagement.goToCreateMultiUserScreen(
                                    item.id ?? "");
                              },
                              child: SvgPicture.asset(
                                AssetConstants.ic_edit_detalis,
                              ),
                            ),
                            Dimens.boxWidth12,
                            InkWell(
                              onTap: () {
                                RouteManagement.goToSubUserChangePasswordScreen(
                                    item.id ?? "");
                              },
                              child: SvgPicture.asset(
                                AssetConstants.ic_lock,
                              ),
                            ),
                            Dimens.boxWidth5,
                            Transform.scale(
                              scale: 0.9,
                              child: CupertinoSwitch(
                                value: item.status ?? false,
                                activeColor: ColorsValue.maincolor1,
                                onChanged: (value) {
                                  item.status = value;
                                  controller.postUpdateSubUser(item.id);
                                  controller.update();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Dimens.boxHeight5,
                      Divider(
                        height: Dimens.one,
                        color: ColorsValue.greyE4E4E4,
                      ),
                      Dimens.boxHeight5,
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
