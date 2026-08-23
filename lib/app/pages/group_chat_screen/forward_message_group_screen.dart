import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ForwardMessageGroupScreen extends StatelessWidget {
  const ForwardMessageGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatController>(initState: (state) {
      var controller = Get.find<GroupChatController>();
      controller.forwardSelectedMemberList.clear();
      controller.myForwardFriendsList();
    }, builder: (controller) {
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
          title: Text(
            'forward'.tr,
            style: Styles.black70016,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.sixty,
            ),
          ),
          backgroundColor: ColorsValue.maincolor1,
          onPressed: () {
            controller.postChatForward(Get.arguments ?? "");
            controller.update();
          },
          child: SvgPicture.asset(
            AssetConstants.ic_right_side_arrow,
          ),
        ),
        body: Padding(
          padding: Dimens.edgeInsets20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: controller.forwardSelectedMemberList.isNotEmpty
                    ? Dimens.eighty
                    : Dimens.zero,
                child: controller.forwardSelectedMemberList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.forwardSelectedMemberList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: Dimens.edgeInsets7_0_7_0,
                            child: InkWell(
                              onTap: () {
                                controller.forwardSelectedMemberList
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
                                                  (controller
                                                          .forwardSelectedMemberList[
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
                                              errorWidget:
                                                  (context, url, error) =>
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
                                    controller.forwardSelectedMemberList[index]
                                                .fullname?.isEmpty ??
                                            false
                                        ? (controller
                                                .forwardSelectedMemberList[
                                                    index]
                                                .nickname ??
                                            "")
                                        : controller
                                                .forwardSelectedMemberList[
                                                    index]
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
              Expanded(
                child: ListView.builder(
                  itemCount: controller.myForwardFriendsLists.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        var i = controller.forwardSelectedMemberList.indexWhere(
                            (element) =>
                                element.userid ==
                                controller.myForwardFriendsLists[index].userid);
                        if (i.isNegative) {
                          controller.forwardSelectedMemberList
                              .add(controller.myForwardFriendsLists[index]);
                        } else {
                          controller.forwardSelectedMemberList.removeAt(i);
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
                                      (controller.myForwardFriendsLists[index]
                                              .profileimage ??
                                          ""),
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
                              visible: controller.forwardSelectedMemberList.any(
                                (element) =>
                                    element.userid ==
                                    controller
                                        .myForwardFriendsLists[index].userid,
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
                          controller.myForwardFriendsLists[index].fullname
                                      ?.isNotEmpty ??
                                  false
                              ? controller
                                      .myForwardFriendsLists[index].fullname ??
                                  ""
                              : controller
                                      .myForwardFriendsLists[index].nickname ??
                                  "",
                          style: Styles.black50016,
                        ),
                        subtitle: Text(
                            controller.myForwardFriendsLists[index].aboutme ??
                                "",
                            style: Styles.greyColor888840012,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
