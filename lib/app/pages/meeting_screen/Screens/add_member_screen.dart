import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AddMembersScreen extends StatelessWidget {
  const AddMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<MeetingController>(
      initState: (state) {
        var controller = Get.find<MeetingController>();
        controller.myFriendsWithoutPaginationList();
      },
      builder: (controller) => Scaffold(
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
                'new_meeting'.tr,
                style: Styles.black70016,
              ),
              Dimens.boxHeight5,
              Text(
                "add_members".tr,
                style: Styles.greyColor888840012,
              ),
            ],
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
            if (controller.selectedMemberList.isEmpty) {
              Utility.errorMessage("please_select_member".tr);
            } else if (controller.selectedMemberList.length < 2) {
              Utility.errorMessage("At least 2 Members must be selected");
            } else {
              controller.postSaveMetting();
            }
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
              CustomTextFormField(
                controller: controller.searchMemberController,
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
                        return controller.myFriendsWithoutPaginationList();
                      },
                    );
                  });
                },
              ),
              Dimens.boxHeight20,
              SizedBox(
                height: controller.selectedMemberList.isNotEmpty
                    ? Dimens.eighty
                    : Dimens.zero,
                child: controller.selectedMemberList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.selectedMemberList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: Dimens.edgeInsets7_0_7_0,
                            child: InkWell(
                              onTap: () {
                                controller.selectedMemberList.removeAt(index);
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
                                                          .selectedMemberList[
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
                                    controller.selectedMemberList[index]
                                            .fullname ??
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
                itemCount: controller.memberLists.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      var i = controller.selectedMemberList.indexWhere(
                          (element) =>
                              element.userid ==
                              controller.memberLists[index].userid);
                      if (i.isNegative) {
                        controller.selectedMemberList
                            .add(controller.memberLists[index]);
                      } else {
                        controller.selectedMemberList.removeAt(i);
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
                                    (controller
                                            .memberLists[index].profileimage ??
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
                            visible: controller.selectedMemberList.any(
                              (element) =>
                                  element.userid ==
                                  controller.memberLists[index].userid,
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
                        controller.memberLists[index].fullname?.isEmpty ?? false
                            ? (controller.memberLists[index].nickname ?? "")
                            : controller.memberLists[index].nickname ?? "",
                        style: Styles.black50016,
                      ),
                      subtitle: Text(
                          controller.memberLists[index].aboutme ?? "",
                          style: Styles.greyColor888840012,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ),
                  );
                },
              ))
            ],
          ),
        ),
      ),
    );
  }
}
