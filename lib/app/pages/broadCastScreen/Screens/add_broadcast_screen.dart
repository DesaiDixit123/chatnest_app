import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AddBroadCastScreen extends StatelessWidget {
  const AddBroadCastScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<BroadCastController>(
      initState: (state) {
        var controller = Get.find<BroadCastController>();
        controller.friendsWithoutPaginationList();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: AppBar(
            shadowColor: ColorsValue.greyAAAAAA,
            backgroundColor: ColorsValue.white,
            elevation: Dimens.two,
            centerTitle: false,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: Dimens.edgeInsets20_15_10_15,
                child: SvgPicture.asset(
                  AssetConstants.appbarbackarrowicon,
                  colorFilter: const ColorFilter.mode(
                    ColorsValue.maincolor1,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Broadcast',
                  style: Styles.black70016,
                ),
                Dimens.boxHeight5,
                Text(
                  "add_members".tr,
                  style: Styles.greyColor888840012,
                ),
              ],
            ),
            actions: [
              InkWell(
                onTap: () {
                  if (controller.brodcastSelectedMemberList.length < 2) {
                    Utility.errorMessage(
                        "At least 2 Contacts must be selected");
                  } else if (controller.brodcastSelectedMemberList.isNotEmpty) {
                    RouteManagement.goToaddBroadcastTitleScreen(
                        Get.arguments ?? false);
                  } else {
                    Utility.errorMessage("please_select_member".tr);
                  }
                },
                child: Padding(
                  padding: Dimens.edgeInsetsRight20,
                  child: SvgPicture.asset(AssetConstants.rightIcon),
                ),
              ),
            ],
          ),
          body: Padding(
            padding: Dimens.edgeInsets20,
            child: ListView(
              shrinkWrap: true,
              children: [
                CustomTextFormField(
                  controller: controller.createGroupSearchController,
                  hintText: 'search'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  suffixIcon: Icon(
                    Icons.search,
                    size: Dimens.twentyFour,
                    color: ColorsValue.hookupHeaderGreyColor,
                  ),
                  onChanged: (value) {
                    _debouncer.run(() {
                      Future.sync(
                        () {
                          return controller.friendsWithoutPaginationList();
                        },
                      );
                    });
                  },
                ),
                Dimens.boxHeight20,
                SizedBox(
                  height: controller.brodcastSelectedMemberList.isNotEmpty
                      ? Dimens.eighty
                      : Dimens.zero,
                  child: controller.brodcastSelectedMemberList.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              controller.brodcastSelectedMemberList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: Dimens.edgeInsets7_0_7_0,
                              child: InkWell(
                                onTap: () {
                                  controller.brodcastSelectedMemberList
                                      .removeAt(index);
                                  controller.update();
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: Dimens.fifty,
                                      width: Dimens.fifty,
                                      child: Stack(
                                        children: [
                                          Container(
                                            height: Dimens.fifty,
                                            width: Dimens.fifty,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimens.hundred,
                                              ),
                                              color: ColorsValue.blackColor,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimens.hundred,
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: ApiWrapper.imageUrl +
                                                    (controller
                                                            .brodcastSelectedMemberList[
                                                                index]
                                                            .profileimage ??
                                                        ""),
                                                fit: BoxFit.cover,
                                                maxHeightDiskCache: 300,
                                                maxWidthDiskCache: 300,
                                                width: Dimens.fifty,
                                                height: Dimens.fifty,
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Image.asset(
                                                    AssetConstants.usera,
                                                    height: Dimens.fifty,
                                                  ),
                                                ),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image.asset(
                                                        AssetConstants.usera),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                              height: Dimens.eighteen,
                                              width: Dimens.eighteen,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Dimens.hundred,
                                                ),
                                                color: ColorsValue.maincolor1,
                                                border: Border.all(
                                                  color: ColorsValue.white,
                                                  width: Dimens.one,
                                                ),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.close,
                                                  size: Dimens.twelve,
                                                  color: ColorsValue.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Dimens.boxHeight5,
                                    Text(
                                      controller
                                              .brodcastSelectedMemberList[index]
                                              .nickname ??
                                          "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: Styles.greyColor888840010,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(),
                ),
                Dimens.boxHeight10,
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.myFriendsLists.length,
                  itemBuilder: (context, index) {
                    var item = controller.myFriendsLists[index];
                    return InkWell(
                      onTap: () {
                        var i = controller.brodcastSelectedMemberList
                            .indexWhere((element) =>
                                element.userid ==
                                controller.myFriendsLists[index].userid);
                        if (i.isNegative) {
                          controller.brodcastSelectedMemberList
                              .add(controller.myFriendsLists[index]);
                        } else {
                          controller.brodcastSelectedMemberList.removeAt(i);
                        }
                        controller.update();
                      },
                      child: ListTile(
                        contentPadding: Dimens.edgeInsets0,
                        leading: Stack(
                          children: [
                            Container(
                              height: Dimens.fifty,
                              width: Dimens.fifty,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                color: ColorsValue.blackColor,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: ApiWrapper.imageUrl +
                                      (item.profileimage ?? ""),
                                  fit: BoxFit.cover,
                                  maxHeightDiskCache: 300,
                                  maxWidthDiskCache: 300,
                                  width: Dimens.fifty,
                                  height: Dimens.fifty,
                                  placeholder: (context, url) => Center(
                                    child: Image.asset(
                                      AssetConstants.usera,
                                      height: Dimens.fifty,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(AssetConstants.usera),
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                                  controller.brodcastSelectedMemberList.any(
                                (element) =>
                                    element.userid ==
                                    controller.myFriendsLists[index].userid,
                              )
                                      ? true
                                      : false,
                              child: Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: Dimens.eighteen,
                                  width: Dimens.eighteen,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    color: ColorsValue.maincolor1,
                                    border: Border.all(
                                      color: ColorsValue.white,
                                      width: Dimens.one,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.done,
                                      size: Dimens.twelve,
                                      color: ColorsValue.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        title: Text(
                          controller.myFriendsLists[index].nickname ?? "",
                          style: Styles.black50016,
                        ),
                        subtitle: Text(
                          controller.myFriendsLists[index].aboutme ?? "",
                          style: Styles.greyColor888840012,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
