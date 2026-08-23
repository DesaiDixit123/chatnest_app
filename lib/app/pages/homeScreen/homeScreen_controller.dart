import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/device/repositories/device_repositories.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeScreenController(this.homeScreenPresenter);

  final HomeScreenPresenter homeScreenPresenter;

  late TabController tabController;
  bool? isProfile;

  @override
  void onInit() async {
    tabController = TabController(
        vsync: this,
        length: 4);
    tabController.addListener(update);
    selectedChateData = null;
    selectedGroupChatData = null;
    fetchDataFromNative();
    super.onInit();
  }

  void fetchDataFromNative() async {
    try {
      const MethodChannel('HelloWorld').setMethodCallHandler(
        (call) async {
          if (call.method == 'CALL_ACCEPTED_INTENT') {
            final data = await call.arguments;
            if (data != null) {
              if (data['callType'] == "meeting") {
                await RouteManagement.goToMeetingCallScreen(
                  data['agorachannelName'],
                  data['agoratoken'],
                  data['callId'],
                  true,
                  false,
                );
              } else if (data['callType'] == "yes") {
                await Get.put<VideoCallController>(
                  VideoCallController(
                    Get.put(
                      VideoCallPresenter(
                        Get.put(
                          VideoCallUsecases(
                            Get.find(),
                          ),
                          permanent: true,
                        ),
                      ),
                      permanent: true,
                    ),
                    api: ApiWrapper(),
                  ),
                ).postChatJoinCall(data['callId']);
                await RouteManagement.goToVideoCallScreen(
                  data['agorachannelName'],
                  data['agoratoken'],
                  data['callId'],
                  false,
                  data['banner'],
                  data['fromusername'],
                  false,
                );
              } else {
                await Get.put<AudioCallController>(
                  AudioCallController(
                    Get.put(
                      AudioCallPresenter(
                        Get.put(
                          AudioCallUsecases(
                            Get.find(),
                          ),
                          permanent: true,
                        ),
                      ),
                      permanent: true,
                    ),
                    api: ApiWrapper(),
                  ),
                ).postChatJoinCall(data['callId']);
                await RouteManagement.goToAudioCallScreen(
                  data['agorachannelName'],
                  data['agoratoken'],
                  data['callId'],
                  false,
                  data['banner'],
                  data['fromusername'],
                  false,
                );
              }
            } else {
              print("error");
            }
          }
        },
      );
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  bool isSelcted = true;
  MyFriendDatum? selectedChateData = MyFriendDatum();
  GroupChatDatum? selectedGroupChatData = GroupChatDatum();
  bool isPinned = false;

  showDialog(bool isMap) async {
    await Get.dialog(
      Material(
        color: ColorsValue.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: Dimens.edgeInsets20_0_20_0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor),
                width: Get.width,
                child: Padding(
                  padding: Dimens.edgeInsets20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              if (isMap) {
                                tabController.animateTo(0);
                              }
                              Get.back();
                            },
                            child: SizedBox(
                              height: Get.height / 50,
                              child: Image.asset(
                                AssetConstants.cancleimage,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: Get.height / 5,
                        child: Image.asset(
                          AssetConstants.popupimage,
                        ),
                      ),
                      Dimens.boxHeight25,
                      Text(
                        "create_your_profile".tr,
                        style: Styles.black70020,
                      ),
                      Dimens.boxHeight5,
                      Text(
                        "Start Personalizing Your Experience – Skip or Create Your Profile with Ease"
                            .tr,
                        style: Styles.hinttext40014,
                        textAlign: TextAlign.center,
                      ),
                      Dimens.boxHeight30,
                      CustomBottomButton(
                        firstbtnText: "skip_now".tr.toUpperCase(),
                        secondbtnTxt: "continue".tr.toUpperCase(),
                        firstStyle: Styles.main50014,
                        secondStyle: Styles.white50014,
                        firstOnPressed: () {
                          if (isMap) {
                            tabController.animateTo(0);
                          }
                          Get.back();
                        },
                        secondOnPressed: () {
                          Get.back();
                          RouteManagement.goTocreateProfileView();
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String? fullName;
  String? profilePic;

  ProfileData profileData = ProfileData();

  Future<void> getProfile({
    bool isLoading = true,
  }) async {
    var response = await homeScreenPresenter.getProfile(
      isLoading: false,
    );
    if (response != null) {
      Utility.profileData = response.data!;
      Get.find<Repository>().saveValue(
          LocalKeys.authorizationlockpin, response.data?.chatlockpin ?? "");
      Get.find<Repository>().saveValue(
          LocalKeys.authorizationhidepin, response.data?.chathidepin ?? "");

      profileData = response.data!;
      fullName = response.data!.fullname ?? '';
      profilePic = response.data?.profileimage ?? "";
      isProfile = response.data!.isprofilecompleted;

      // isProfile ?? false
      //     ? null
      //     : Future.delayed(const Duration(seconds: 0)).then(
      //         (value) {
      //           showDialog(false);
      //         },
      //       );

      Get.find<Repository>()
          .saveValue(LocalKeys.userIds, response.data?.id ?? "");
      Get.find<Repository>()
          .saveValue(LocalKeys.profileImg, response.data?.profileimage ?? "");
      Get.find<Repository>()
          .saveValue(LocalKeys.chanelId, response.data?.channelId ?? "");

      // Initialize socket right after we get the required channelId and profile info
      SocketConnection.initSocket();
      Get.find<ProfileController>().getBusinessList();

      update();
    }
  }

  Future<void> postChatPinUnPin({
    bool isLoading = true,
  }) async {
    var response = await homeScreenPresenter.postChatPinUnPin(
      isLoading: isLoading,
      userid: "",
      isPinned: false,
    );
    if (response != null) {}
  }

  Future<void> postOnlineOffline(isonline) async {
    var response = await homeScreenPresenter.postOnlineOffline(
      isLoading: true,
      isonline: isonline,
    );
    if (response != null) {}
  }

  Future<void> postLogout() async {
    var response = await homeScreenPresenter.postLogout(
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      SocketConnection.socketDisconnect();
      Get.find<DeviceRepository>().deleteBox();
      RouteManagement.goToLoginView();
    }
  }
}
