import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ClearChatSelectScreen extends StatelessWidget {
  const ClearChatSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(initState: (state) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.find<SettingController>().fetchClearChatProfiles();
      });
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
            "Select Profiles".tr,
            style: Styles.black70018,
          ),
          actions: [
            if (!controller.isClearChatLoading)
              Row(
                children: [
                  Text("Select All".tr, style: Styles.black50014),
                  Checkbox(
                    value: controller.isSelectAll,
                    activeColor: ColorsValue.maincolor1,
                    onChanged: (value) {
                      if (value != null) {
                        controller.toggleSelectAllClearChat(value);
                      }
                    },
                  ),
                ],
              )
          ],
        ),
        floatingActionButton: controller.clearChatFriendList
                    .any((e) => e.isUserSelect == true) ||
                controller.clearChatGroupList.any((e) => e.isUserSelect == true)
            ? FloatingActionButton(
                onPressed: () {
                  controller.postClearSelectedChats();
                },
                backgroundColor: ColorsValue.maincolor1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Dimens.hundred,
                  ),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              )
            : null,
        body: controller.isClearChatLoading
            ? const Center(
                child: CircularProgressIndicator(color: ColorsValue.maincolor1))
            : ListView(
                padding: Dimens.edgeInsets20,
                children: [
                  if (controller.clearChatFriendList.isNotEmpty) ...[
                    Text("Contacts".tr, style: Styles.black70016),
                    Dimens.boxHeight10,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.clearChatFriendList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var friend = controller.clearChatFriendList[index];
                        return InkWell(
                          onTap: () {
                            controller.toggleClearChatUser(index, false);
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
                                          (friend.profileimage ?? ""),
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
                                  visible: friend.isUserSelect ?? false,
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
                              friend.nickname ?? friend.fullname ?? "",
                              style: Styles.black50016,
                            ),
                            subtitle: Text(
                              friend.mobile ?? "",
                              style: Styles.greyColor888840012,
                            ),
                          ),
                        );
                      },
                    ),
                    Dimens.boxHeight20,
                  ],
                  if (controller.clearChatGroupList.isNotEmpty) ...[
                    Text("Groups".tr, style: Styles.black70016),
                    Dimens.boxHeight10,
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.clearChatGroupList.length,
                      itemBuilder: (BuildContext context, int index) {
                        var group = controller.clearChatGroupList[index];
                        return InkWell(
                          onTap: () {
                            controller.toggleClearChatUser(index, true);
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
                                          (group.profileimage ?? ""),
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
                                  visible: group.isUserSelect ?? false,
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
                              group.name ?? "",
                              style: Styles.black50016,
                            ),
                            subtitle: Text(
                              group.description ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.greyColor888840012,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
      );
    });
  }
}
