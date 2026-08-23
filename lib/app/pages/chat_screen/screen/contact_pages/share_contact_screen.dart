import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ShareContactScreen extends StatelessWidget {
  const ShareContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<ChatController>(initState: (state) {
      Get.find<ChatController>().myFriendsWithoutPaginationList();
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
            "Profile Share".tr,
            style: Styles.black70018,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            RouteManagement.goToViewAllSelectContactScreen(
                Get.arguments[0] ?? false, Get.arguments[1] ?? false);
          },
          backgroundColor: ColorsValue.maincolor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.hundred,
            ),
          ),
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
                controller: controller.searchContactController,
                hintText: 'search'.tr,
                fillColor: ColorsValue.textfildbackcolor,
                suffixIcon: Icon(
                  Icons.search,
                  size: Dimens.twentyFour,
                  color: ColorsValue.hookupHeaderGreyColor,
                ),
                onChanged: (value) {
                  debouncer.run(() {
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
                height: controller.contactSelectList.isNotEmpty
                    ? Dimens.eighty
                    : Dimens.zero,
                child: controller.contactSelectList.isNotEmpty
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.contactSelectList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: Dimens.edgeInsets7_0_7_0,
                            child: InkWell(
                              onTap: () {
                                controller.contactSelectList.removeAt(index);
                                controller.update();
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Stack(
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
                                                (controller.contactsList[index]
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
                                              Icons.close,
                                              size: Dimens.twelve,
                                              color: ColorsValue.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Text(
                                    controller.contactSelectList[index]
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
                  itemCount: controller.contactsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        var i = controller.contactSelectList.indexWhere(
                            (element) =>
                                element == controller.contactsList[index]);
                        if (i.isNegative) {
                          controller.contactSelectList
                              .add(controller.contactsList[index]);
                        } else {
                          controller.contactSelectList.removeAt(i);
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
                                      (controller.contactsList[index]
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
                              visible: controller.contactSelectList.any(
                                (element) =>
                                    element == controller.contactsList[index],
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
                          controller.contactsList[index].nickname ?? "",
                          style: Styles.black50016,
                        ),
                        subtitle: Text(
                          controller.contactsList[index].mobile ?? "",
                          style: Styles.greyColor888840012,
                        ),
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
