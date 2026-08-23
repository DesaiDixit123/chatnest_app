import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RequestHistoryScreen extends StatelessWidget {
  const RequestHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<FindFriendController>(
      initState: (state) {
        var controller = Get.find<FindFriendController>();
        controller.findfriendhistoryController.clear();
        controller.pagingController = PagingController(firstPageKey: 1);
        controller.pagingController.addPageRequestListener((pageKey) async {
          await controller.postFindFriendsList(pageKey, "");
        });
      },
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "friendslist".tr,
                style: Styles.black70018,
              ),
            ],
          ),
          leading: Padding(
            padding: Dimens.edgeInsets15,
            child: InkWell(
              onTap: () {
                RouteManagement.goToHomeScreenView();
              },
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
              ),
            ),
          ),
          actions: [
            Visibility(
              // visible: Utility.profileData?.chatlockpin?.isEmpty ??
              //         false || Utility.profileData?.chatlockpin == null
              //     ? false
              //     : true,
              child: Padding(
                padding: Dimens.edgeInsetsRight20,
                child: InkWell(
                    onTap: () {
                      if (Utility.profileData?.recoveryEmail?.isEmpty ??
                          false) {
                        RouteManagement.goToRecoveryEmailScreen("Hide");
                      } else {
                        if (Utility.profileData?.chathidepin?.isEmpty ??
                            false || Utility.profileData?.chathidepin == null) {
                          RouteManagement.goToCreateHideChatPinScreen();
                        } else {
                          RouteManagement.goToHideChatVerifyPinScreen();
                        }
                      }
                    },
                    child: SvgPicture.asset(AssetConstants.keyIcon)),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets20_20_20_0,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.findfriendhistoryController,
                        onChanged: (value) {
                          _debouncer.run(() {
                            Future.sync(() {
                              return controller.pagingController.refresh();
                            });
                          });
                        },
                        decoration: InputDecoration(
                          fillColor: ColorsValue.textfildbackcolor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimens.five),
                              borderSide: BorderSide.none),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimens.five),
                              borderSide: BorderSide.none),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimens.five),
                              borderSide: BorderSide.none),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(Dimens.five),
                              borderSide: BorderSide.none),
                          filled: true,
                          isDense: true,
                          contentPadding: Dimens.edgeInsets12,
                          hintText: 'search'.tr,
                          suffixIcon: Icon(
                            Icons.search,
                            size: Dimens.thirty,
                            color: ColorsValue.hookupHeaderGreyColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Dimens.boxHeight20,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => controller.pagingController.refresh(),
                    ),
                     color: ColorsValue.appColor,
                    child: PagedListView<int, FindFirendsListDoc>(
                      pagingController: controller.pagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<FindFirendsListDoc>(
                        noItemsFoundIndicatorBuilder: (_) => Center(
                          child: Text(
                            "Friends list data not found".tr,
                            style: Styles.black40014,
                          ),
                        ),
                        itemBuilder: (BuildContext context, item, int index) {
                          return ListTile(
                            leading: Container(
                              height: Dimens.fifty,
                              width: Dimens.fifty,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                color: ColorsValue.maincolor1,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.hundred),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      ApiWrapper.imageUrl + item.profileimage,
                                  fit: BoxFit.cover,
                                  maxHeightDiskCache: 90,
                                  maxWidthDiskCache: 90,
                                  width: Dimens.fifty,
                                  height: Dimens.fifty,
                                  placeholder: (context, url) => Image.asset(
                                    AssetConstants.usera,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    AssetConstants.usera,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              item.nickname,
                              style: Styles.black50016,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            subtitle: Text(
                              item.aboutme,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: Styles.greyColor888840012,
                            ),
                            trailing: item.isfriend == "no"
                                ? InkWell(
                                    onTap: () {
                                      Get.dialog(SentRequestDialog(
                                        formKey: controller.sendRequestKey,
                                        title: item.nickname,
                                        textEditingController:
                                            controller.messageController,
                                        onTap: () {
                                          if (controller
                                              .sendRequestKey.currentState!
                                              .validate()) {
                                            Get.back();
                                            controller.sendNewFriendRequest(
                                                item.id,
                                                controller
                                                    .messageController.text);
                                          }
                                        },
                                      ));
                                      controller.update();
                                    },
                                    child: Container(
                                      height: Dimens.thirty,
                                      width: Dimens.thirty,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.maincolor1,
                                        borderRadius: BorderRadius.circular(
                                          Dimens.three,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: Dimens.edgeInsets6,
                                        child: Image.asset(
                                          AssetConstants.ic_user_add,
                                        ),
                                      ),
                                    ),
                                  )
                                : item.isfriend == 'sent'
                                    ? InkWell(
                                        onTap: () {
                                          controller.cancelSentRequest(
                                              item.friendrequestid ?? "");
                                          controller.update();
                                        },
                                        child: Container(
                                          height: Dimens.thirty,
                                          width: Dimens.thirty,
                                          decoration: BoxDecoration(
                                              color: ColorsValue.greyColor8888,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.three)),
                                          child: Padding(
                                            padding: Dimens.edgeInsets6,
                                            child: Image.asset(
                                              AssetConstants.ic_user_remove,
                                            ),
                                          ),
                                        ),
                                      )
                                    : item.isfriend == 'received'
                                        ? Container(
                                            height: Dimens.thirty,
                                            width: Dimens.thirty,
                                            decoration: BoxDecoration(
                                              color: ColorsValue.maincolor1,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                Dimens.three,
                                              ),
                                            ),
                                            child: PopupMenuButton(
                                              padding: Dimens.edgeInsets0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.ten)),
                                              icon: const Icon(
                                                Icons.more_vert,
                                                color: ColorsValue.white,
                                              ),
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return [
                                                  PopupMenuItem(
                                                    child: Text(
                                                      'accept_request'.tr,
                                                      style: Styles.black50014,
                                                    ),
                                                    onTap: () {
                                                      Get.dialog(
                                                        StatefulBuilder(
                                                          builder: (context,
                                                              setState) {
                                                            return Material(
                                                              color: ColorsValue
                                                                  .transparent,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          Dimens
                                                                              .edgeInsets20_0_20_0,
                                                                      child:
                                                                          Container(
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              ColorsValue.white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(Dimens.fifteen),
                                                                        ),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              Dimens.edgeInsets20,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: InkWell(
                                                                                    onTap: () {
                                                                                      Get.back();
                                                                                    },
                                                                                    child: SvgPicture.asset(
                                                                                      AssetConstants.cancleicon,
                                                                                    )),
                                                                              ),
                                                                              Center(
                                                                                child: SvgPicture.asset(
                                                                                  AssetConstants.unhidepopupicon,
                                                                                ),
                                                                              ),
                                                                              Dimens.boxHeight18,
                                                                              Center(
                                                                                child: Text(
                                                                                  "accept_request".tr,
                                                                                  style: Styles.black70020,
                                                                                ),
                                                                              ),
                                                                              Dimens.boxHeight18,
                                                                              CustomBottomButton(
                                                                                  firstbtnText: "cancle".tr.toUpperCase(),
                                                                                  secondbtnTxt: "accept".tr.toUpperCase(),
                                                                                  firstStyle: Styles.greyColor888850014,
                                                                                  secondStyle: Styles.white50014,
                                                                                  bordercolor: ColorsValue.greyColor8888,
                                                                                  firstOnPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  secondOnPressed: () {
                                                                                    Get.back();
                                                                                    controller.respondFriendsRequest(item.friendrequestid ?? "", "accepted");
                                                                                  }),
                                                                              Dimens.boxHeight18,
                                                                              Text(
                                                                                "Our profile settings for this person",
                                                                                style: Styles.black50018,
                                                                              ),
                                                                              Expanded(
                                                                                child: SingleChildScrollView(
                                                                                  child: Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'fullname'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          item.fullname,
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(AssetConstants.fullnameicon),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.fullname ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.fullname = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'phone_number'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          item.mobile,
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(AssetConstants.callicon),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.mobile ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.mobile = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'email'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          item.email,
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(AssetConstants.smsicon),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.email ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.email = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'date_of_birth'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          item.dob,
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(AssetConstants.dobicon),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.dob ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.dob = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'gender'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          item.gender,
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(AssetConstants.gendericon),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.gender ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.gender = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'social_media'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          'Privacy Policy',
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(AssetConstants.socialmediaicon),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.socialmedia ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.socialmedia = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'video_call'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          'Privacy Policy',
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(
                                                                                          AssetConstants.videoIcon,
                                                                                          colorFilter: ColorFilter.mode(
                                                                                            ColorsValue.appColor,
                                                                                            BlendMode.srcIn,
                                                                                          ),
                                                                                        ),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.videocall ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.videocall = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'audio_call'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          'Privacy Policy',
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(AssetConstants.callicon),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.audiocall ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.audiocall = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                      ListTile(
                                                                                        contentPadding: Dimens.edgeInsets0,
                                                                                        title: Text(
                                                                                          'mute_notification'.tr,
                                                                                          style: Styles.black50014,
                                                                                        ),
                                                                                        subtitle: Text(
                                                                                          'Privacy Policy',
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        leading: SvgPicture.asset(AssetConstants.ic_mute_noti),
                                                                                        trailing: CupertinoSwitch(
                                                                                          value: controller.authorizedPermissions.ismute ?? false,
                                                                                          activeColor: ColorsValue.maincolor1,
                                                                                          onChanged: (value) {
                                                                                            controller.authorizedPermissions.ismute = value;
                                                                                            setState(() {});
                                                                                          },
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text(
                                                      'rejectrequest'.tr,
                                                      style: Styles.black50014,
                                                    ),
                                                    onTap: () async {
                                                      await Get.dialog(
                                                        Padding(
                                                          padding: Dimens
                                                              .edgeInsetsTop20,
                                                          child: Material(
                                                            color: ColorsValue
                                                                .transparent,
                                                            child: Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: Dimens
                                                                        .edgeInsets20_0_20_0,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: ColorsValue
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(Dimens.fifteen),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            Dimens.edgeInsets25_30_25_30,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topRight,
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  child: SvgPicture.asset(
                                                                                    AssetConstants.cancleicon,
                                                                                  )),
                                                                            ),
                                                                            SvgPicture.asset(
                                                                              AssetConstants.canclepopupicon,
                                                                            ),
                                                                            Dimens.boxHeight18,
                                                                            Text(
                                                                              "rejectrequest".tr,
                                                                              style: Styles.black70020,
                                                                            ),
                                                                            Dimens.boxHeight10,
                                                                            Text(
                                                                              "are_you_sure_reject".tr,
                                                                              style: Styles.greyColor888840014,
                                                                            ),
                                                                            Dimens.boxHeight18,
                                                                            CustomBottomButton(
                                                                                firstbtnText: "block".tr.toUpperCase(),
                                                                                secondbtnTxt: "reject".tr.toUpperCase(),
                                                                                firstStyle: Styles.redcolor50014,
                                                                                secondStyle: Styles.white50014,
                                                                                bordercolor: ColorsValue.redColor,
                                                                                buttoncolor: ColorsValue.redColor,
                                                                                firstOnPressed: () {
                                                                                  Get.back();
                                                                                },
                                                                                secondOnPressed: () {
                                                                                  Get.back();
                                                                                  controller.respondFriendsRequest(item.friendrequestid ?? "", "rejected");
                                                                                })
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  PopupMenuItem(
                                                    child: Text(
                                                      'block_request'.tr,
                                                      style:
                                                          Styles.redColor50014,
                                                    ),
                                                    onTap: () async {
                                                      await Get.dialog(
                                                        Padding(
                                                          padding: Dimens
                                                              .edgeInsetsTop20,
                                                          child: Material(
                                                            color: ColorsValue
                                                                .transparent,
                                                            child: Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .stretch,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding: Dimens
                                                                        .edgeInsets20_0_20_0,
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: ColorsValue
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(Dimens.fifteen),
                                                                      ),
                                                                      child:
                                                                          Padding(
                                                                        padding:
                                                                            Dimens.edgeInsets25_30_25_30,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Align(
                                                                              alignment: Alignment.topRight,
                                                                              child: InkWell(
                                                                                  onTap: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  child: SvgPicture.asset(
                                                                                    AssetConstants.cancleicon,
                                                                                  )),
                                                                            ),
                                                                            SvgPicture.asset(
                                                                              AssetConstants.canclepopupicon,
                                                                            ),
                                                                            Dimens.boxHeight18,
                                                                            Text(
                                                                              "block_request".tr,
                                                                              style: Styles.black70020,
                                                                            ),
                                                                            Dimens.boxHeight10,
                                                                            Text(
                                                                              "are_you_sure_block".tr,
                                                                              style: Styles.greyColor888840014,
                                                                            ),
                                                                            Dimens.boxHeight18,
                                                                            CustomBottomButton(
                                                                              firstbtnText: "cancle".tr.toUpperCase(),
                                                                              secondbtnTxt: "block".tr.toUpperCase(),
                                                                              firstStyle: Styles.greyColor888850014,
                                                                              secondStyle: Styles.white50014,
                                                                              bordercolor: ColorsValue.greyColor8888,
                                                                              buttoncolor: ColorsValue.redColor,
                                                                              firstOnPressed: () {
                                                                                Get.back();
                                                                              },
                                                                              secondOnPressed: () {
                                                                                Get.back();
                                                                                controller.respondFriendsRequest(item.friendrequestid ?? "", "blocked");
                                                                              },
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ];
                                              },
                                            ),
                                          )
                                        : item.isfriend == 'block'
                                            ? InkWell(
                                                onTap: () async {
                                                  await Get.dialog(
                                                    Padding(
                                                      padding: Dimens
                                                          .edgeInsetsTop20,
                                                      child: Material(
                                                        color: ColorsValue
                                                            .transparent,
                                                        child: Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .stretch,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding: Dimens
                                                                    .edgeInsets20_0_20_0,
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: ColorsValue
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            Dimens.fifteen),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: Dimens
                                                                        .edgeInsets25_30_25_30,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.topRight,
                                                                          child: InkWell(
                                                                              onTap: () {
                                                                                Get.back();
                                                                              },
                                                                              child: SvgPicture.asset(
                                                                                AssetConstants.cancleicon,
                                                                              )),
                                                                        ),
                                                                        SvgPicture
                                                                            .asset(
                                                                          AssetConstants
                                                                              .canclepopupicon,
                                                                        ),
                                                                        Dimens
                                                                            .boxHeight18,
                                                                        Text(
                                                                          "unblock_request"
                                                                              .tr,
                                                                          style:
                                                                              Styles.black70020,
                                                                        ),
                                                                        Dimens
                                                                            .boxHeight10,
                                                                        Text(
                                                                          "are_you_sure_unblock"
                                                                              .tr,
                                                                          style:
                                                                              Styles.greyColor888840014,
                                                                        ),
                                                                        Dimens
                                                                            .boxHeight18,
                                                                        CustomBottomButton(
                                                                          firstbtnText: "cancle"
                                                                              .tr
                                                                              .toUpperCase(),
                                                                          secondbtnTxt: "unblock"
                                                                              .tr
                                                                              .toUpperCase(),
                                                                          firstStyle:
                                                                              Styles.greyColor888850014,
                                                                          secondStyle:
                                                                              Styles.white50014,
                                                                          bordercolor:
                                                                              ColorsValue.greyColor8888,
                                                                          buttoncolor:
                                                                              ColorsValue.redColor,
                                                                          firstOnPressed:
                                                                              () {
                                                                            Get.back();
                                                                          },
                                                                          secondOnPressed:
                                                                              () {
                                                                            Get.back();
                                                                            controller.updateFriendsRequest(item.friendrequestid ?? "",
                                                                                "unblocked");
                                                                          },
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  height: Dimens.twentyFive,
                                                  width: Dimens.seventy,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      Dimens.three,
                                                    ),
                                                    border: Border.all(
                                                      color:
                                                          ColorsValue.redColor,
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'unblocked'.tr,
                                                      style:
                                                          Styles.redColor40010,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : InkWell(
                                                onTap: () {
                                                  RouteManagement
                                                      .gooffAndToNamedChatScreen(
                                                          item.id ?? "", false);
                                                },
                                                child: Container(
                                                  height: Dimens.thirty,
                                                  width: Dimens.thirty,
                                                  decoration: BoxDecoration(
                                                    color:
                                                        ColorsValue.maincolor1,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      Dimens.three,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: Dimens.edgeInsets6,
                                                    child: Image.asset(
                                                      AssetConstants
                                                          .ic_chat_png,
                                                    ),
                                                  ),
                                                ),
                                              ),
                            contentPadding: Dimens.edgeInsets0,
                          );
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
