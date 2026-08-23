import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:chatnest/sqflite_model/database_helper.dart';
import 'package:chatnest/sqflite_model/location_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:permission_handler/permission_handler.dart' as permission;
import 'package:chatnest/app/pages/status_screen/status_screen.dart';

class ChatController extends GetxController with GetTickerProviderStateMixin {
  ChatController(this.chatPresenter);

  final ChatPresenter chatPresenter;

  TabController? tabController;
  late TabController chatLockTabController;
  String? wallpaper;
  Position? currentPosition;
  MyFriendDatum? pendingLockItem;
  GroupChatDatum? pendingGroupLockItem;

  @override
  void onInit() async {
    debugPrint('ChatController onInit');
    tabController = TabController(vsync: this, length: 2);
    chatLockTabController = TabController(vsync: this, length: 2);
    tabController?.addListener(update);
    chatLockTabController.addListener(update);
    imagePath = Get.find<Repository>().getStringValue(LocalKeys.chatWallpaper);

    chatPagingController = PagingController(firstPageKey: 1);
    chatPagingController.addPageRequestListener((pagekey) async {
      debugPrint('ChatController page request for $pagekey');
      await myFriendsList(pagekey);
    });
    recorderController = RecorderController();

    postArchiveChatList();

    // await getCurrentPosition();

    super.onInit();
  }

  late TextEditingController serchController = TextEditingController();
  TextEditingController chatPinController = TextEditingController();
  GlobalKey<FormState> createpinFormKey = GlobalKey<FormState>();
  bool ischatpin = false;

  String? validpin(String value) {
    if (value.isEmpty) {
      return "pleaseentertpin".tr;
    } else if (value.length != 4) {
      return "pleaseenterrightpin".tr;
    } else {
      return null;
    }
  }

  PagingController<int, MyFriendDatum> chatPagingController =
      PagingController(firstPageKey: 1);

  List<MyFriendDatum> myFriendsLists = [];

  int totalMarkeReadUser = 0;

  int blockUserlimit = 10;
  List<MyFriendDatum> allFriends = [];
  List<MyFriendDatum> filteredFriends = [];

  void applyLocalFilter() {
    String query = serchController.text.toLowerCase();
    String currentUserId =
        Get.find<Repository>().getStringValue(LocalKeys.userIds);

    // Inject self-entry if not present
    bool selfExists = allFriends.any((user) => user.userid == currentUserId);
    MyFriendDatum? selfEntryInAll;
    if (selfExists) {
      selfEntryInAll =
          allFriends.firstWhere((user) => user.userid == currentUserId);
    }

    if (query.isEmpty && !isUnread) {
      filteredFriends = List.from(allFriends);
      if (!selfExists) {
        final profile = Utility.profileData;
        final self = MyFriendDatum(
          userid: currentUserId,
          fullname: "${profile?.fullname ?? ""} (You)",
          nickname: profile?.nickname,
          profileimage: profile?.profileimage,
          channelID: profile?.channelId,
        );
        filteredFriends.insert(0, self);
      }
    } else {
      filteredFriends = allFriends.where((user) {
        final name = (user.fullname ?? user.nickname ?? "").toLowerCase();
        final matchesName = name.contains(query);
        final matchesUnread = !isUnread || (user.unreadmessageCount ?? 0) > 0;
        return matchesName && matchesUnread;
      }).toList();

      // Ensure self is in filtered list if it matches query or "you"
      if (!filteredFriends.any((user) => user.userid == currentUserId)) {
        final profile = Utility.profileData;
        final name = (profile?.fullname ?? "").toLowerCase();
        if (name.contains(query) || "you".contains(query)) {
          final self = selfEntryInAll ??
              MyFriendDatum(
                userid: currentUserId,
                fullname: "${profile?.fullname ?? ""} (You)",
                nickname: profile?.nickname,
                profileimage: profile?.profileimage,
                channelID: profile?.channelId,
              );
          // Only add if not unread filter is on, or if we want self to bypass it (usually self doesn't have unread)
          if (!isUnread) {
            filteredFriends.add(self);
          }
        }
      }
    }

    // Always move self-message to top if it exists in the filtered list
    int selfIndex =
        filteredFriends.indexWhere((user) => user.userid == currentUserId);
    if (selfIndex != -1) {
      final self = filteredFriends.removeAt(selfIndex);
      // Ensure (You) suffix is there if it was found in allFriends without it
      if (!(self.fullname ?? "").contains("(You)")) {
        self.fullname = "${self.fullname ?? ""} (You)";
      }
      filteredFriends.insert(0, self);
    }

    chatPagingController.itemList = filteredFriends;
    chatPagingController.notifyListeners();
  }

  Future<void> myFriendsList(pageKey) async {
    debugPrint('myFriendsList called with pageKey: $pageKey');
    var response = await chatPresenter.myFriendsList(
      page: pageKey,
      limit: 10,
      search: serchController.text,
      unreadMessages: isUnread,
      contactFriend: true,
      fefieldFriend: true,
      receiverFriend: true,
      senderFriend: true,
      isLoading: false,
    );
    debugPrint('myFriendsList - response data: ${response?.data}');
    debugPrint(' searchhhhh${serchController.text}');
    if (response?.data != null) {
      if (pageKey == 1) {
        allFriends.clear();
      }

      var fetchedList = response?.data?.list ?? [];

      for (var data in fetchedList) {
        data.isOnline = Utility.onlineOfflineUserList.any((element) =>
            element.toLowerCase() == (data.channelID ?? "").toLowerCase());
      }

      allFriends.addAll(fetchedList);

// Apply local filter
      applyLocalFilter();

      final isLastPage = fetchedList.length < 10;
      if (isLastPage) {
        chatPagingController.appendLastPage([]);
      } else {
        var nextPageKey = pageKey + 1;
        chatPagingController.appendPage([], nextPageKey);
      }
      totalMarkeReadUser = response?.data?.totalmarkedasunreaduser ?? 0;
      Get.forceAppUpdate();
      update();
    }
    if (response == null) {
      debugPrint('myFriendsList - presenter returned null, retrying once');
      await Future.delayed(const Duration(milliseconds: 300));
      response = await chatPresenter.myFriendsList(
        page: pageKey,
        limit: 10,
        search: serchController.text,
        unreadMessages: isUnread,
        contactFriend: true,
        fefieldFriend: true,
        receiverFriend: true,
        senderFriend: true,
        isLoading: false,
      );
    }
    if (response == null) {
      debugPrint(
          'myFriendsList - still null after retry, appending empty page');
      // stop paging to avoid infinite loading
      chatPagingController.appendLastPage(<MyFriendDatum>[]);
      return;
    }
  }

  bool isUnread = false;
  bool isContectList = true;
  bool isFefildFriend = true;
  bool isReceveFriend = true;
  bool isSendFriend = true;

  PagingController<int, NotificationDoc> notificationPagingController =
      PagingController(firstPageKey: 1);

  List<NotificationDoc> notificationLists = [];

  Future<void> postNotificationList(pageKey) async {
    var response = await chatPresenter.postNotificationList(
      page: pageKey,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        notificationLists.clear();
      }
      notificationLists = response.data?.docs ?? [];

      final isLastPage = notificationLists.length < 10;
      if (isLastPage) {
        notificationPagingController.appendLastPage(notificationLists);
      } else {
        var nextPageKey = pageKey + 1;
        notificationPagingController.appendPage(notificationLists, nextPageKey);
      }
      update();
    }
  }

  Future<bool> postDeleteNotification({
    String? notificationId,
    int? index,
  }) async {
    final response = await chatPresenter.postDeleteNotification(
      notificationId: notificationId,
      isLoading: false,
    );

    if (response?.statusCode == 200) {
      if (notificationId == null || notificationId.isEmpty) {
        notificationLists.clear();
        notificationPagingController.itemList = [];
      } else if (index != null) {
        notificationPagingController.itemList?.removeAt(index);
        notificationLists.removeWhere((item) => item.id == notificationId);
      }
      update();
      return true;
    }

    return false;
  }

  ///===================================================== Chat User Profile Screen ========================================================///

  bool isShowHour = false;
  bool isEmoji = false;

  ///===================================================== Create Poll Screen ========================================================///

  TextEditingController askQuestionController = TextEditingController();

  List<QuestionModel> questionList = [
    QuestionModel(textController: TextEditingController()),
    QuestionModel(textController: TextEditingController()),
  ];

  bool isMultipalAns = false;
  int selectIndex = 0;

  GetOnePollsData getOnePollsModel = GetOnePollsData();

  Future<void> createPolls(bool isGroup, bool isBrodcast) async {
    var response = await chatPresenter.createPolls(
      pollid: "",
      polltitle: askQuestionController.text,
      optionsList: questionList.map((e) => e.textController!.text).toList(),
      allowmultipleans: isMultipalAns,
    );
    if (response != null) {
      getOnePollsModel = response.data;
      if (isGroup) {
        sendGroupMessage(getOnePollsModel.id, false, false);
      } else if (isBrodcast) {
        postSendMessageBroadcast(getOnePollsModel.id, false);
      } else {
        sendMessage(getOnePollsModel.id, false, false);
      }
      askQuestionController.clear();
      update();
      Get.back();
    }
  }

  int votedMember = 0;

  Future<void> getOnePoll(pollId) async {
    var response = await chatPresenter.getOnePoll(
      pollid: pollId,
    );
    votedMember = 0;
    if (response != null) {
      getOnePollsModel = response.data;
      for (var option in getOnePollsModel.options ?? <ChatListsOption>[]) {
        votedMember += option.usersvotes.length;
      }
      update();
    }
  }

  Future<void> postPollVote(ChatListsPoll? poll, String optionid) async {
    if (poll?.pollid?.allowmultipleans == true) {
      var index =
          poll?.pollid?.options.indexWhere((element) => element.id == optionid);
      var index2 = poll?.pollid?.options.indexWhere((element) =>
          (element.usersvotes.any((element2) =>
              element.id == optionid &&
              element2.userid?.id ==
                  Get.find<Repository>().getStringValue(LocalKeys.userIds))));
      if (index2?.isNegative == true) {
        poll?.pollid?.options[index!].usersvotes.add(Usersvote(
            userid: BroadcastCreatedBy(
                id: Get.find<Repository>().getStringValue(LocalKeys.userIds),
                profileimage: Get.find<Repository>()
                    .getStringValue(LocalKeys.profileImg)),
            timestamp: DateTime.now().millisecondsSinceEpoch));
      } else {
        poll?.pollid?.options[index2!].usersvotes.removeWhere((element) =>
            element.userid?.id ==
            Get.find<Repository>().getStringValue(LocalKeys.userIds));
      }
      poll?.pollid?.key = UniqueKey();
      update();
      chatPresenter.postPollVote(
        pollid: poll?.pollid?.id ?? '',
        optionid: optionid,
        isLoading: false,
      );
    } else {
      var index = poll?.pollid?.options.indexWhere((element) =>
          element.usersvotes.any((element2) =>
              element2.userid?.id ==
              Get.find<Repository>().getStringValue(LocalKeys.userIds)));
      if (index?.isNegative == false) {
        poll?.pollid?.options[index!].usersvotes.removeWhere((element) =>
            element.userid?.id ==
            Get.find<Repository>().getStringValue(LocalKeys.userIds));
      }

      var index2 =
          poll?.pollid?.options.indexWhere((element) => element.id == optionid);
      if (index2?.isNegative == false) {
        poll?.pollid?.options[index2!].usersvotes.add(Usersvote(
            userid: BroadcastCreatedBy(
                id: Get.find<Repository>().getStringValue(LocalKeys.userIds),
                profileimage: Get.find<Repository>()
                    .getStringValue(LocalKeys.profileImg)),
            timestamp: DateTime.now().millisecondsSinceEpoch));
      }
      poll?.pollid?.key = UniqueKey();
      update();
      chatPresenter.postPollVote(
        pollid: poll?.pollid?.id ?? '',
        optionid: optionid,
        isLoading: false,
      );
      chatPresenter.postPollVote(
        pollid: poll?.pollid?.id ?? '',
        optionid: poll?.pollid?.options[index!].id ?? '',
        isLoading: false,
      );
    }
  }

  ///===================================================== Audio Screen ========================================================///

  List<AudioModel> audioList = [];

  List<AudioModel> selectAudioList = [];

  ///===================================================== Share Contacts Screen ========================================================///

  TextEditingController searchContactController = TextEditingController();

  List<MyFriendDatum> contactsList = [];
  List<MyFriendDatum> contactSelectList = [];

  Future<void> myFriendsWithoutPaginationList() async {
    var response = await chatPresenter.myFriendsWithoutPaginationList(
      search: searchContactController.text,
      unreadMessages: false,
      contactFriend: true,
      fefieldFriend: true,
      receiverFriend: true,
      senderFriend: true,
    );
    contactsList.clear();
    if (response != null) {
      contactsList.addAll(response.data?.list ?? []);
    }
    update();
  }

  ///===================================================== View All Contacts ========================================================///

  List<ContactContent> getContactList = [];

  ///===================================================== Share Location Screen ========================================================///

  LatLng? selectedLocationLatLag;
  bool isSearchLoation = false;
  List<LocationModel> searchList = [];
  final Set<Marker> markers = {};
  final Completer<GoogleMapController> mapController = Completer();

  getLocationScreen(LatLng latlag) async {
    var response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${latlag.latitude},${latlag.longitude}&key=${ApiWrapper.placeApiCall}"));
    AddressModel responseModel = AddressModel();
    if (response.statusCode == 200) {
      responseModel = addressModelFromJson(response.body);
    }

    LocationModel location =
        LocationModel(responseModel.results?[0].formattedAddress, latlag);
    await DatabaseHelper.instance.createLocation(location);
    // print(myList);
    // return responseModel.results?[0].formattedAddress ?? "";
  }

  TextEditingController searchLocationController = TextEditingController();
  FocusNode locationFocusNode = FocusNode();

  getSearchListData() async {
    searchList.clear();
    List<LocationModel> locations =
        await DatabaseHelper.instance.getLocations();
    searchList.addAll(locations);
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
    moveToLocation(
        selectedLocationLatLag ?? const LatLng(21.170240, 72.831062));
  }

  void moveToLocation(LatLng latLng) {
    mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15.0,
          ),
        ),
      );
    });
    setMarker(latLng);

    // getLocationData(
    //     lat: latLng.latitude, lng: latLng.longitude, isForNavigator: false);
  }

  void setMarker(LatLng latLng) {
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId("mark"),
        position: latLng,
      ),
    );
    update();
  }

  Future<void> getCurrentPosition() async {
    if (await Utility.locationPermissionCheack()) {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position) {
        currentPosition = position;
        selectedLocationLatLag =
            LatLng(currentPosition!.latitude, currentPosition!.longitude);
        moveToLocation(selectedLocationLatLag!);
        update();
      }).catchError((e) {
        debugPrint(e);
      });
    }
  }

  ///================================================== Chat Screen =====================================///

  String? userId = "";
  int userBusinessIndex = 0;

  TextEditingController sendMessageController = TextEditingController();
  FocusNode messageFocusNode = FocusNode();
  FocusNode searchocusNode = FocusNode();
  OverlayEntry? autocompleteOverlay;
  bool isOverlayOpen = false;
  Widget? showchat;
  String imageFile = "";
  bool isReplyChat = false;

  Future<void> sendMessage(
      String? pollId, isLocation, bool isPersonalContact) async {
    List<String> userSelectList = [];

    for (var data in contactSelectList) {
      if (data.isSelect ?? false) {
        userSelectList.add(data.userid ?? "");
      }
    }

    var response = await chatPresenter.sendMessage(
      isLoading: false,
      receiverid: userId ?? "",
      message: sendMessageController.text,
      product: friendProductDoc?.id ?? "",
      latitude: isLocation ? selectedLocationLatLag?.latitude.toString() : "",
      longitude: isLocation ? selectedLocationLatLag?.longitude.toString() : "",
      pollid: pollId,
      context: isReplyChat ? chatListsDoc?.id : "",
      usersList: userSelectList,
      phonecontactData: isPersonalContact
          ? PhoneContact(
              name: contactsSearchList[selectUser].displayName,
              mobile: contactsSearchList[selectUser]
                  .phones
                  .map((e) => e.number)
                  .toList(),
            )
          : null,
      mediaFileList: sentImageMsgLists
          .map(
            (e) => ImageFormData(
              fieldName: "file",
              filePath: e.url ?? "",
              mediaType: MediaType.parse(lookupMimeType(e.url ?? "")!),
            ),
          )
          .toList(),
    );
    if (response != null) {
      isReplyChat = false;
      chatListsDoc = null;
      sentImageMsgLists.clear();
      getChatLists(1, userId);

      // Update allFriends to keep the source of truth in sync
      var friendIndex =
          allFriends.indexWhere((element) => element.userid == userId);
      if (friendIndex != -1) {
        var friendData = allFriends.removeAt(friendIndex);
        friendData.lastchatmessage = response;
        allFriends.insert(0, friendData);
      }

      var index = Get.find<ChatController>()
          .chatPagingController
          .itemList
          ?.indexWhere((element) => element.userid == userId);
      if (index?.isNegative == false) {
        Get.find<ChatController>()
            .chatPagingController
            .itemList?[index!]
            .lastchatmessage = null;
        Get.find<ChatController>()
            .chatPagingController
            .itemList?[index!]
            .lastchatmessage = response;

        var data =
            Get.find<ChatController>().chatPagingController.itemList![index!];
        Get.find<ChatController>()
            .chatPagingController
            .itemList
            ?.removeAt(index);
        Get.find<ChatController>()
            .chatPagingController
            .itemList
            ?.insert(0, data);
      }
      questionList.map((e) => e.textController?.clear()).toList();
      update();
    }
  }

  Future<void> postChatSendBulkMessage(String? pollId, isLocation) async {
    var response = await chatPresenter.postChatSendBulkMessage(
      isLoading: false,
      receiverid: userId ?? "",
      message: sendMessageController.text,
      context: isReplyChat ? chatListsDoc?.id : "",
      mediaFileList: sentImageMsgLists
          .map(
            (e) => ImageFormData(
              fieldName: "file[${sentImageMsgLists.indexOf(e)}]",
              filePath: e.url ?? "",
              mediaType: MediaType.parse(lookupMimeType(e.url ?? "")!),
            ),
          )
          .toList(),
    );
    if (response != null) {
      isReplyChat = false;
      chatListsDoc = null;
      sentImageMsgLists.clear();
      getChatLists(1, userId);

      // Update allFriends to keep the source of truth in sync
      var friendIndex =
          allFriends.indexWhere((element) => element.userid == userId);
      if (friendIndex != -1) {
        var friendData = allFriends.removeAt(friendIndex);
        friendData.lastchatmessage = response;
        allFriends.insert(0, friendData);
      }

      var index = Get.find<ChatController>()
          .chatPagingController
          .itemList
          ?.indexWhere((element) => element.userid == userId);
      if (index?.isNegative == false) {
        Get.find<ChatController>()
            .chatPagingController
            .itemList?[index!]
            .lastchatmessage = null;
        Get.find<ChatController>()
            .chatPagingController
            .itemList?[index!]
            .lastchatmessage = response;

        var data =
            Get.find<ChatController>().chatPagingController.itemList![index!];
        Get.find<ChatController>()
            .chatPagingController
            .itemList
            ?.removeAt(index);
        Get.find<ChatController>()
            .chatPagingController
            .itemList
            ?.insert(0, data);
      }
    }
  }

  List<MediaModel> sentImageMsgLists = [];
  final imageFileList = <XFile>[];

  final picker = ImagePicker();
  int sentImageMsgIndex = 0;

  Future setCameraPhoto(
      ImageSource camera, bool isGroup, bool isBrodcast) async {
    final pickedFile = await picker.pickImage(source: camera);

    if (pickedFile != null) {
      var croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]),
          IOSUiSettings(title: 'Cropper', aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio5x3,
            CropAspectRatioPreset.ratio5x4,
            CropAspectRatioPreset.ratio7x5,
            CropAspectRatioPreset.ratio16x9
          ]),
        ],
      );

      if (croppedFile != null) {
        sentImageMsgLists.add(
          MediaModel(url: croppedFile.path, isVideo: false),
        );

        if (sentImageMsgLists.isNotEmpty) {
          if (isGroup) {
            sendGroupMessage("", false, false);
          } else if (isBrodcast) {
            postSendMessageBroadcast("", false);
          } else {
            sendMessage("", false, false);
          }
        }
      }
    }
    update();
  }

  List<String> imagePaths = [];

  Future sendImage(ImageSource imageSource, bool isEdit, bool isGroup,
      bool isBrodcast) async {
    if (Platform.isAndroid) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: Utility.imageTypeList + Utility.videoTypeList,
      );

      if (result != null) {
        if (Utility.getImageSizeMB(result.files.first.path ?? "") <= 56) {
          for (var file in result.files) {
            var last = file.path?.split('.').last;
            for (var data in Utility.imageTypeList) {
              if (data == last) {
                sentImageMsgLists.add(
                  MediaModel(url: file.path, isVideo: false),
                );
              }
            }

            for (var data in Utility.videoTypeList) {
              if (data == last) {
                sentImageMsgLists.add(
                  MediaModel(url: file.path, isVideo: true),
                );
              }
            }
          }
          if (!isEdit) {
            RouteManagement.goToMultipalSendImageScreen(isGroup, isBrodcast);
          }
        } else {
          Utility.errorMessage("max_16_mb_img".tr);
        }
      }
    } else {
      var picker = ImagePicker();
      var result = await picker.pickMultipleMedia();

      if (result.isNotEmpty) {
        if (sentImageMsgLists.length < 20) {
          for (var file in result) {
            if (Utility.getImageSizeMB(file.path ?? "") <= 16) {
              var last = file.path.split('.').last;
              for (var data in Utility.imageTypeList) {
                if (data == last) {
                  sentImageMsgLists.add(
                    MediaModel(url: file.path, isVideo: false),
                  );
                }
              }

              for (var data in Utility.videoTypeList) {
                if (data == last) {
                  sentImageMsgLists.add(
                    MediaModel(url: file.path, isVideo: true),
                  );
                }
              }
              print(sentImageMsgLists);

              if (!isEdit) {
                RouteManagement.goToMultipalSendImageScreen(
                    isGroup, isBrodcast);
              }
            } else {
              Utility.errorMessage('max_16_mb_img'.tr);
            }
          }
        } else {
          Utility.errorMessage("Maximum 20 Photos Upload".tr);
        }
      }
    }
    update();
  }

  Future<void> selectDocumnets(isGroup, isBrodcast) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: Utility.docsTypeList,
    );
    sentImageMsgLists.clear();
    if (result != null) {
      if (Utility.getImageSizeMB(result.files.first.path ?? "") <= 100) {
        sentImageMsgLists.add(
          MediaModel(url: result.files.first.path ?? "", isVideo: false),
        );
        if (sentImageMsgLists.isNotEmpty) {
          if (isGroup) {
            sendGroupMessage("", false, false);
          } else if (isBrodcast) {
            postSendMessageBroadcast("", false);
          } else {
            sendMessage("", false, false);
          }
        }
      } else {
        Utility.errorMessage("max_100_mb_doc".tr);
      }

      update();
    }
  }

  Future<void> selectAudios(isGroup, isBrodcast) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: false,
    );
    sentImageMsgLists.clear();
    if (result != null) {
      if (Utility.getImageSizeMB(result.files.first.path ?? "") <= 56) {
        sentImageMsgLists.add(
          MediaModel(url: result.files.first.path ?? "", isVideo: false),
        );
        if (sentImageMsgLists.isNotEmpty) {
          if (isGroup) {
            sendGroupMessage("", false, false);
          } else if (isBrodcast) {
            postSendMessageBroadcast("", false);
          } else {
            sendMessage("", false, false);
          }
        }
      } else {
        Utility.errorMessage("max_56_mb_aud".tr);
      }

      update();
    }
  }

  bool isCategory = false;
  String locationText = "";
  String locationBusinessText = "";
  LatLng? businessLatlag;
  List<UserMediaModel> shredMediaList = [];

  GetOneFriendsData? getOneFriendsData = GetOneFriendsData();
  Future<void> getOneFriends(userId) async {
    debugPrint("[ANTIGRAVITY_DEBUG] getOneFriends called for userId: $userId");
    var response = await chatPresenter.getOneFriends(
      userid: userId ?? "",
      isLoading: false,
    );
    debugPrint(
        "[ANTIGRAVITY_DEBUG] getOneFriends response received: ${response != null}");
    if (getOneFriendsData?.userid != userId) {
      getOneFriendsData = null;
      shredMediaList.clear();
    }
    if (response != null) {
      try {
        debugPrint(
            "[ANTIGRAVITY_DEBUG] getOneFriends response data: ${response.data.userid}");
        getOneFriendsData = response.data;

        for (var data
            in getOneFriendsData?.latestmedias ?? <ChatListsMediaData>[]) {
          if (data.content?.media.path.isNotEmpty ?? false) {
            shredMediaList.add(
              UserMediaModel(
                url: data.content?.media.path,
                isVideo: data.content?.media.type == "IMG" ? false : true,
                timestemp: data.senttimestamp,
              ),
            );
          } else {
            data.content?.multimedias
                ?.map(
                  (e) => shredMediaList.add(
                    UserMediaModel(
                      url: e.path,
                      isVideo: e.type == "IMG" ? false : true,
                      timestemp: data.senttimestamp,
                    ),
                  ),
                )
                .toList();
          }
        }

        for (var datas in Utility.onlineOfflineUserList) {
          var index = chatPagingController.itemList
              ?.indexWhere((element) => element.channelID == datas);

          if (index != null && index != -1) {
            chatPagingController.itemList?[index].isOnline = true;
          }

          if (getOneFriendsData?.channelID == datas) {
            getOneFriendsData?.isOnline = true;
          }
        }

        authorizedPermissions = AuthorizedPermissions(
          fullname: response.data.yourPermissions?.fullname,
          mobile: response.data.yourPermissions?.mobile,
          email: response.data.yourPermissions?.email,
          dob: response.data.yourPermissions?.dob,
          gender: response.data.yourPermissions?.gender,
          socialmedia: response.data.yourPermissions?.socialmedia,
          videocall: response.data.yourPermissions?.videocall,
          audiocall: response.data.yourPermissions?.audiocall,
          ismute: response.data.yourPermissions?.ismute,
        );

        if (response.data.location != null &&
            (response.data.location!.coordinates?.length ?? 0) >= 2) {
          try {
            locationText = await getLocation(
                response.data.location!.coordinates[1],
                response.data.location!.coordinates[0]);
          } catch (e) {
            debugPrint("Error getting location: $e");
            locationText = "";
          }
        } else {
          locationText = "";
        }

        if (response.data.businessprofiles?.isNotEmpty ?? false) {
          try {
            final bpLocation =
                response.data.businessprofiles![userBusinessIndex].location;
            if (bpLocation != null &&
                (bpLocation.coordinates?.length ?? 0) >= 2) {
              locationBusinessText = await getLocation(
                  bpLocation.coordinates[1], bpLocation.coordinates[0]);

              businessLatlag =
                  LatLng(bpLocation.coordinates[1], bpLocation.coordinates[0]);
              print(businessLatlag);
            } else {
              locationBusinessText = "";
            }
          } catch (e) {
            debugPrint("Error getting business location: $e");
            locationBusinessText = "";
          }
          print(businessLatlag);
        }
      } catch (e, stack) {
        debugPrint("Error in getOneFriends data processing: $e");
        print("Stack trace: $stack");
      }

      update();
    }
  }

  Future<String> getLocation(double lat, double log) async {
    var response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$log&key=${ApiWrapper.placeApiCall}"));
    AddressModel? responseModel;
    if (response.statusCode == 200) {
      responseModel = addressModelFromJson(response.body);
    }
    if (responseModel == null) return "";
    if (responseModel.results == null || responseModel.results!.isEmpty) {
      return "";
    }
    return responseModel.results!.first.formattedAddress ?? "";
  }

  List<ChatListsDoc> chatMessageList = [];
  List<ChatListDeletedfor> allDeleteList = [];

  bool isMicOnOff = false;

  ChatListsDoc? chatListsDoc = ChatListsDoc();

  int pageCount = 1;

  bool isLastPage = false;
  bool isLoading = false;

  final ScrollController scrollController = ScrollController();
  TextEditingController chatSearchController = TextEditingController();
  bool isSearch = false;

  Future<void> getChatLists(int pageKey, userId) async {
    if (pageKey == 1) {
      pageCount = 1;
    }
    var response = await chatPresenter.getChatLists(
      userid: userId ?? "",
      page: pageCount,
      limit: 10,
      search: chatSearchController.text,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isLastPage = false;
        chatMessageList.clear();
        allDeleteList.clear();
      }

      for (var data in response.data.docs ?? <ChatListsDoc>[]) {
        allDeleteList.addAll(data.deletedfor ?? []);
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isLastPage = true;
        chatMessageList.addAll(response.data.docs ?? []);
      } else {
        pageCount++;
        chatMessageList.addAll(response.data.docs ?? []);
        print(Get.find<Repository>().getStringValue(LocalKeys.userIds));
      }
      if (pageKey == 1) {
        if (scrollController.positions.isNotEmpty) {
          scrollController.jumpTo(0);
        }
      }
    }

    update();
  }

  Future<void> fetchUserStatusAndNavigate(
      String? userId, String? statusId) async {
    if (userId == null || userId.isEmpty) return;

    try {
      var response = await chatPresenter.getOneUserStatus(
        userid: userId,
        isLoading: true,
      );

      if (response?.data != null) {
        Get.to(() => StatusViewer(
              statuses: response!.data.statuses,
              name: response.data.name,
              profileImage: response.data.profileimage,
              initialStatusId: statusId,
            ));
      }
    } catch (e) {
      debugPrint("Error fetching user status: $e");
    }
  }

  Future<void> postDeliveredMessage(String? messageid) async {
    var response = await chatPresenter.postDeliveredMessage(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {}
  }

  Future<void> postSeenMessage(String? messageid) async {
    var response = await chatPresenter.postSeenMessage(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {}
  }

  Future<void> postChatDeleteMessage(chatMessageData, deletefor) async {
    var response = await chatPresenter.postChatDeleteMessage(
      isLoading: false,
      messageid: chatMessageData.id ?? "",
      deletefor: deletefor,
    );
    if (response != null) {
      chatMessageList.remove(chatMessageList);
      getChatLists(1, userId);
      update();
    }
  }

  bool isChatMessageEdit = false;
  String? chatMessageIds;

  Future<void> postChatMessageEdit(message) async {
    var response = await chatPresenter.postChatMessageEdit(
      isLoading: false,
      messageid: chatMessageIds ?? "",
      message: message,
    );
    if (response != null) {
      isChatMessageEdit = false;
      isReplyChat = false;
      chatListsDoc = null;
      sentImageMsgLists.clear();
      var index =
          chatMessageList.indexWhere((element) => element.id == chatMessageIds);
      if (index.isNegative == false) {
        chatMessageList[index].content?.text.message = message;
        chatMessageList[index].isedited = true;
      }

      update();
    }
  }

  Future<void> postChatBookmarkAndRemove(
      messageid, isBookmark, isUserBookmark) async {
    var response = await chatPresenter.postChatBookmarkAndRemove(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {
      if (isBookmark) {
        if (isUserBookmark) {
          var index = bookmarkUserList
              .indexWhere((element) => element.id == response.data?.id);
          if (index.isNegative == false) {
            bookmarkUserList.removeAt(index);
          }
          var indexChat = chatMessageList
              .indexWhere((element) => element.id == response.data?.id);
          if (indexChat.isNegative == false) {
            chatMessageList[indexChat].bookmarks = null;
            chatMessageList[indexChat].bookmarks = response.data?.bookmarks;
          }
        } else {
          var index = bookmarkList
              .indexWhere((element) => element.id == response.data?.id);
          if (index.isNegative == false) {
            bookmarkList.removeAt(index);
          }
        }
      } else {
        var index = chatMessageList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          chatMessageList[index].bookmarks = null;
          chatMessageList[index].bookmarks = response.data?.bookmarks;
        }
      }
      update();
    }
  }

  Future<void> postChatFavoriteAndRemove(messageid, isFavorite) async {
    var response = await chatPresenter.postChatFavoriteAndRemove(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {
      if (isFavorite) {
        var index = chatFavoriteList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          chatFavoriteList.removeAt(index);
        }
      } else {
        var index = chatMessageList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          chatMessageList[index].favorites = null;
          chatMessageList[index].favorites = response.data?.favorites;
        }
      }
      update();
    }
  }

  Future<void> postChatMessageReaction(messageid, reaction) async {
    var response = await chatPresenter.postChatMessageReaction(
      isLoading: false,
      messageid: messageid ?? "",
      reaction: reaction,
    );
    if (response != null) {
      var index = chatMessageList
          .indexWhere((element) => element.id == response.data?.id);
      if (index.isNegative == false) {
        chatMessageList[index].reactions = null;
        chatMessageList[index].reactions = response.data?.reactions;
      }
      update();
    }
  }

  Future<void> postChatMessageUnReaction(messageid) async {
    var response = await chatPresenter.postChatMessageUnReaction(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {
      var index = chatMessageList
          .indexWhere((element) => element.id == response.data?.id);
      if (index.isNegative == false) {
        chatMessageList[index].reactions = null;
        chatMessageList[index].reactions = response.data?.reactions;
      }
      update();
    }
  }

  String? productIds;

  List<FriendProductData>? friendProductList = [];

  FriendProductData? friendProductDoc = FriendProductData();
  bool isProductSend = false;

  Future<void> postfriendsproducts() async {
    var response = await chatPresenter.postfriendsproducts(
      search: "",
      userid: userId ?? "",
      business: "",
      parentcategory: [],
      childcategory: [],
    );
    if (response != null) {
      friendProductList = response.data ?? [];
    }
    update();
  }

  List<String> imagesList = [];
  List<String> videosList = [];
  List<String> allVideoList = [];

  GetOneFriendProductData? getOneFriendData = GetOneFriendProductData();

  Future<void> postFriendProductGetOne(productid) async {
    var response = await chatPresenter.postFriendProductGetOne(
      productid: productid,
      isLoading: true,
    );
    getOneFriendData = null;
    imagesList.clear();
    videosList.clear();
    allVideoList.clear();
    if (response?.data != null) {
      getOneFriendData = response?.data;

      final productData = response?.data?.productdata;

      for (var item in productData?.images ?? []) {
        imagesList.add(item);
      }
      for (var item in productData?.videos ?? []) {
        videosList.add(item);
      }
      if ((productData?.image ?? "").isNotEmpty) {
        allVideoList.add(productData!.image!);
      }
      allVideoList.addAll(
        [...imagesList, ...videosList].where((item) => item.isNotEmpty),
      );
    }
    update();
  }

  void showOverlayDialog(
      ChatController controller, bool isGroup, bool isBrodcast) {
    Overlay(
      initialEntries: [
        controller.autocompleteOverlay = OverlayEntry(
          builder: (context) {
            controller.isOverlayOpen = true;
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: Dimens.edgeInsets20_0_20_85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Material(
                      elevation: 1,
                      borderRadius: BorderRadius.all(
                        Radius.circular(Dimens.ten),
                      ),
                      child: Container(
                        width: Get.width,
                        padding: Dimens.edgeInsets8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimens.ten),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: Dimens.edgeInsets0_10_0_20,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        controller.isOverlayOpen = false;
                                        controller.autocompleteOverlay
                                            ?.remove();
                                        var data = await Utility
                                            .filePickPermissionCheack();
                                        if (data) {
                                          controller.selectDocumnets(
                                              isGroup, isBrodcast);
                                        }
                                        update();
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                ColorsValue.maincoloropacity1,
                                            child: Padding(
                                              padding: Dimens.edgeInsets8,
                                              child: SvgPicture.asset(
                                                AssetConstants
                                                    .attechDocumentIcon,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "document".tr,
                                            style: Styles.main50012,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        controller.isOverlayOpen = false;

                                        controller.autocompleteOverlay
                                            ?.remove();
                                        var data =
                                            await Utility.audioPermissionCheack(
                                                context);
                                        if (data) {
                                          controller.selectAudios(
                                              isGroup, isBrodcast);
                                        }
                                        update();
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                ColorsValue.maincoloropacity1,
                                            child: Padding(
                                              padding: Dimens.edgeInsets8,
                                              child: SvgPicture.asset(
                                                AssetConstants.attechMusicIcon,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "audio".tr,
                                            style: Styles.main50012,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        controller.isOverlayOpen = false;

                                        controller.autocompleteOverlay
                                            ?.remove();
                                        controller.sentImageMsgLists.clear();
                                        var data =
                                            await Utility.imagePermissionCheack(
                                                context);
                                        if (data) {
                                          controller.sendImage(
                                              ImageSource.gallery,
                                              false,
                                              isGroup,
                                              isBrodcast);
                                        }
                                        update();
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                ColorsValue.maincoloropacity1,
                                            child: Padding(
                                              padding: Dimens.edgeInsets8,
                                              child: SvgPicture.asset(
                                                AssetConstants
                                                    .attechGalleryIcon,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "gallery".tr,
                                            style: Styles.main50012,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets0_10_0_20,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        controller.isOverlayOpen = false;

                                        controller.autocompleteOverlay
                                            ?.remove();
                                        var data = await Utility
                                            .locationPermissionCheack();
                                        if (data) {
                                          RouteManagement
                                              .goToShareLocationScreen(
                                                  isGroup, isBrodcast);
                                        }
                                        update();
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                ColorsValue.maincoloropacity1,
                                            child: Padding(
                                              padding: Dimens.edgeInsets8,
                                              child: SvgPicture.asset(
                                                AssetConstants
                                                    .attechLocationIcon,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "location".tr,
                                            style: Styles.main50012,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        controller.isOverlayOpen = false;
                                        controller.autocompleteOverlay
                                            ?.remove();
                                        RouteManagement.goToShareContactScreen(
                                            isGroup, isBrodcast);
                                        update();
                                      },
                                      child: Column(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                ColorsValue.maincoloropacity1,
                                            child: Padding(
                                              padding: Dimens.edgeInsets8,
                                              child: Padding(
                                                padding: Dimens.edgeInsets3,
                                                child: SvgPicture.asset(
                                                  AssetConstants.usericon,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "profile".tr,
                                            style: Styles.main50012,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (!isBrodcast) ...[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          controller.isOverlayOpen = false;
                                          controller.autocompleteOverlay
                                              ?.remove();
                                          RouteManagement
                                              .goToShareUserContactScreen(
                                                  isGroup, isBrodcast);
                                          update();
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  ColorsValue.maincoloropacity1,
                                              child: Padding(
                                                padding: Dimens.edgeInsets8,
                                                child: SvgPicture.asset(
                                                  AssetConstants
                                                      .attechContactIcon,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "contact".tr,
                                              style: Styles.main50012,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ] else ...[
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          controller.isOverlayOpen = false;

                                          controller.autocompleteOverlay
                                              ?.remove();
                                          var data = await Utility
                                              .locationPermissionCheack();
                                          if (data) {
                                            RouteManagement
                                                .goToCreatePollScreen(
                                                    isGroup, isBrodcast);
                                          }
                                          update();
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  ColorsValue.maincoloropacity1,
                                              child: Padding(
                                                padding: Dimens.edgeInsets8,
                                                child: SvgPicture.asset(
                                                  AssetConstants.attechPollIcon,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "poll".tr,
                                              style: Styles.main50012,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            if (isGroup) ...[
                              Padding(
                                padding: Dimens.edgeInsetsBottom10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () async {
                                          controller.isOverlayOpen = false;

                                          controller.autocompleteOverlay
                                              ?.remove();
                                          var data = await Utility
                                              .locationPermissionCheack();
                                          if (data) {
                                            RouteManagement
                                                .goToCreatePollScreen(
                                                    isGroup, isBrodcast);
                                          }
                                          update();
                                        },
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                                  ColorsValue.maincoloropacity1,
                                              child: Padding(
                                                padding: Dimens.edgeInsets8,
                                                child: SvgPicture.asset(
                                                  AssetConstants.attechPollIcon,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "poll".tr,
                                              style: Styles.main50012,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    ),
                                    Expanded(
                                      child: Container(),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                controller.autocompleteOverlay?.remove();
                controller.isOverlayOpen = false;
                controller.update();
              },
            );
          },
        )
      ],
    );
  }

  bool isPinned = false;

  Future<void> postChatPinUnPin(userId) async {
    int io = chatPagingController.itemList!
        .indexWhere((element) => element.userid == userId);
    var response = await chatPresenter.postChatPinUnPin(
      userid: userId,
      isPinned:
          chatPagingController.itemList![io].isPinned == true ? false : true,
    );
    if (response?.statusCode == 200) {
      chatPagingController.refresh();
      update();
    } else {
      Utility.errorMessage(
          jsonDecode(response?.data.toString() ?? "")['Message']);
    }
  }

  List<MyFriendDatum> myForwardFriendsLists = [];
  List<MyFriendDatum> forwardSelectedMemberList = [];

  Future<void> myForwardFriendsList() async {
    var response = await chatPresenter.myFriendsWithoutPaginationList(
      search: "",
      unreadMessages: isUnread,
      contactFriend: isContectList,
      fefieldFriend: isFefildFriend,
      receiverFriend: isReceveFriend,
      senderFriend: isSendFriend,
      isLoading: false,
    );
    myForwardFriendsLists.clear();
    if (response != null) {
      myForwardFriendsLists.addAll(response.data?.list ?? []);
      update();
    }
  }

  Future<void> postChatForward(messageid) async {
    var response = await chatPresenter.postChatForward(
      messageid: messageid,
      forwardto: forwardSelectedMemberList.map((e) => e.userid ?? "").toList(),
    );
    if (response != null) {
      chatPagingController.refresh();
      Get.back();
      update();
    }
  }

  Future<void> postShareTextToUsers(String text) async {
    if (forwardSelectedMemberList.isEmpty) {
      Utility.errorMessage("Please select at least one friend");
      return;
    }

    Utility.showLoader();
    try {
      for (var member in forwardSelectedMemberList) {
        await chatPresenter.sendMessage(
          receiverid: member.userid ?? "",
          message: text,
          isLoading: false,
        );
      }
      Utility.closeLoader();
      Utility.showMessage("Message shared successfully", MessageType.success,
          () => Get.back(), "OK");
      Get.back(); // Close ForwardMessageScreen
    } catch (e) {
      Utility.closeLoader();
      Utility.errorMessage("Failed to share message: $e");
    }
    update();
  }

  List<ChatListMultiMedia>? multiMediaList = [];

  // post call initiate api
  Future<void> postCallInitaite({
    bool isLoading = false,
    required String receiverId,
    required bool isVideoCall,
    required bool isAudioCall,
    required bool isGroupCall,
  }) async {
    var response = await chatPresenter.postCallInitaite(
      isLoading: isLoading,
      isAudioCall: isAudioCall,
      isGroupCall: isGroupCall,
      isVideoCall: isVideoCall,
      receiverId: receiverId,
    );
    if (response != null) {
      if (response.data.calldata.id == null ||
          response.data.calldata.id!.isEmpty) {
        Utility.showMessage("Failed to initiate call: Invalid meeting ID",
            MessageType.error, () => Get.back(), 'Okay');
        return;
      }
      if (isAudioCall) {
        RouteManagement.goToAudioCallScreen(
          response.data.calldata.agorameta?.channelName ?? "",
          response.data.calldata.agorameta?.token ?? "",
          response.data.calldata.id ?? "",
          true,
          response.data.calldata.touser?.profileimage ?? "",
          response.data.calldata.touser?.fullname?.isEmpty ?? false
              ? response.data.calldata.touser?.nickname ?? ""
              : response.data.calldata.touser?.fullname ?? "",
          true,
        );
      } else {
        RouteManagement.goToVideoCallScreen(
            response.data.calldata.agorameta?.channelName ?? "",
            response.data.calldata.agorameta?.token ?? "",
            response.data.calldata.id ?? "",
            true,
            response.data.calldata.touser?.profileimage ?? "",
            response.data.calldata.touser?.fullname?.isEmpty ?? false
                ? response.data.calldata.touser?.nickname ?? ""
                : response.data.calldata.touser?.fullname ?? "",
            true);
      }
      FirebaseAccessToken firebaseAccessToken = FirebaseAccessToken();
      String token = "";
      Object? oauthError;
      for (var attempt = 1; attempt <= 3; attempt++) {
        try {
          token = await firebaseAccessToken.getToken();
          if (token.isNotEmpty) {
            break;
          }
        } catch (e) {
          oauthError = e;
        }
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      }

      if (token.isEmpty) {
        print(
            "❌ Unable to get Firebase OAuth token for call push after retries. error=$oauthError");
      } else {
        // Get.find<Repository>().saveValue(LocalKeys.notificationToken, token);
        print("OAuth $token");
        postSendFcmApi(response.data, "onincomingindividualcall", token);
      }
      chatPagingController.refresh();
    }
    update();
  }

  // post call initiate api
  Future<void> postSendFcmApi(CallInitiatedData callInitiatedData,
      String callType, String authToken) async {
    final tokens = callInitiatedData.fcmTokens ?? <String>[];
    if (tokens.isEmpty) {
      print(
          "❌ No FCM tokens returned by call/initiate. Closed/background incoming call cannot work. "
          "callId=${callInitiatedData.calldata.id ?? ""} "
          "from=${callInitiatedData.calldata.from?.id ?? ""} "
          "to=${callInitiatedData.calldata.touser?.id ?? ""} "
          "type=$callType");
      return;
    }

    for (var data in tokens) {
      ResponseModel? response;
      Object? lastError;
      for (var attempt = 1; attempt <= 3; attempt++) {
        try {
          response = await chatPresenter.postSendFcmApi(
            registrationToken: data,
            userName: callInitiatedData.fromusername,
            callid: callInitiatedData.calldata.id ?? "",
            agoratoken: callInitiatedData.calldata.agorameta?.token ?? "",
            type: callType,
            banner: callInitiatedData.calldata.from?.profileimage ?? "",
            fromid: callInitiatedData.calldata.from?.id ?? "",
            toid: callInitiatedData.calldata.touser?.id ?? "",
            agorachannelName:
                callInitiatedData.calldata.agorameta?.channelName ?? "",
            isaudiocall: callInitiatedData.isaudiocall ?? "",
            isgroupcall: callInitiatedData.isgroupcall ?? "",
            isvideocall: callInitiatedData.isvideocall ?? "",
            authToken: authToken,
            isLoading: isLoading,
          );
          if (response?.statusCode == 200) {
            break;
          }
          await Future.delayed(Duration(milliseconds: 300 * attempt));
        } catch (e) {
          lastError = e;
          await Future.delayed(Duration(milliseconds: 300 * attempt));
        }
      }

      if (response?.statusCode == 200) {
        print(
            "✅ FCM call push sent. type=$callType token=${data.length > 20 ? data.substring(0, 20) : data}...");
      } else {
        print(
            "❌ FCM call push failed after retries. type=$callType status=${response?.statusCode} body=${response?.data} error=$lastError");
      }
      update();
    }
  }

  AuthorizedPermissions authorizedPermissions = AuthorizedPermissions(
    fullname: true,
    mobile: true,
    email: true,
    dob: true,
    gender: true,
    socialmedia: true,
    videocall: true,
    audiocall: true,
    ismute: true,
  );

  Future<void> updateFriendsRequest(String friendrequestid, status) async {
    var response = await chatPresenter.updateFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: authorizedPermissions,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      if (status == "blocked") {
        Get.back();
        Get.back();
        chatPagingController.refresh();
      } else {
        getOneFriends(userId);
      }
    }
    update();
  }

  DateTime returnDateAndTimeFormat(String time) {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));
    return DateTime(dt.year, dt.month, dt.day);
  }

  String groupMessageDateAndTime(String time) {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final aDate = DateTime(dt.year, dt.month, dt.day);

    if (aDate == today) {
      difference = "Today";
    } else if (aDate == yesterday) {
      difference = "Yesterday";
    } else {
      difference = DateFormat.yMMMd().format(dt).toString();
    }

    return difference;
  }

  ///================================================================= MessageInfoScreen ==============================================================================///

  ChatListsDoc chatMessageInfo = ChatListsDoc();

  ///===================================================== Chat archiv ========================================================///

  Future<void> postArchiveChat(String? friendrequestids) async {
    var response = await chatPresenter.postArchiveChat(
      isLoading: false,
      friendrequestids: [friendrequestids ?? ""],
    );
    if (response?.statusCode == 200) {
      postArchiveChatList();
      chatPagingController.refresh();
      update();
    }
  }

  List<MyFriendDatum> myArchiveFriendsLists = [];

  Future<void> postArchiveChatList() async {
    var response = await chatPresenter.postArchiveChatList(
      search: serchController.text,
      unreadMessages: isUnread,
      contactFriend: isContectList,
      fefieldFriend: isFefildFriend,
      receiverFriend: isReceveFriend,
      senderFriend: isSendFriend,
      isLoading: false,
    );
    myArchiveFriendsLists.clear();
    if (response?.data != null) {
      myArchiveFriendsLists.addAll(response?.data ?? []);
      update();
    }
  }

  Future<void> postArchiveChatRemove(String? friendrequestids) async {
    var response = await chatPresenter.postArchiveChatRemove(
      isLoading: false,
      friendrequestids: [
        friendrequestids ?? "",
      ],
    );
    if (response?.statusCode == 200) {
      postArchiveChatList();
      chatPagingController.refresh();
      update();
    }
  }

  void markChatAsReadLocal(String friendRequestId, String userId) {
    // Update allFriends
    for (var f in allFriends) {
      if (f.friendrequestid == friendRequestId) {
        f.unreadmessageCount = 0;
        f.ismarkedasunread = false;
      }
    }

    // Update filteredFriends
    for (var f in filteredFriends) {
      if (f.friendrequestid == friendRequestId) {
        f.unreadmessageCount = 0;
        f.ismarkedasunread = false;
      }
    }

    // Update PagingController list
    final list = chatPagingController.itemList;
    if (list != null) {
      for (var f in list) {
        if (f.friendrequestid == friendRequestId) {
          f.unreadmessageCount = 0;
          f.ismarkedasunread = false;
        }
      }
    }

    chatPagingController.notifyListeners();
    update();
  }

  Future<void> postReadChat(String? friendrequestids) async {
    await chatPresenter.postReadChat(
      isLoading: false,
      friendrequestids: [friendrequestids ?? ""],
    );
  }

  Future<void> postUnReadChat(String? friendrequestids) async {
    var response = await chatPresenter.postUnReadChat(
      isLoading: false,
      friendrequestids: [
        friendrequestids ?? "",
      ],
    );
    if (response != null) {
      chatPagingController.refresh();
      update();
    }
  }

  ///================================================================= ShareUserContactScreen ==============================================///

  int selectUser = 0;

  List<Contact> contactsDataList = [];
  List<Contact> contactsSearchList = [];

  TextEditingController searchUserController = TextEditingController();

  Future fetchContacts() async {
    if (await FlutterContacts.requestPermission()) {
      final contacts = await FlutterContacts.getContacts(
        withProperties: true,
      );
      contactsDataList.clear();
      contactsSearchList.clear();
      if (contacts.isNotEmpty) {
        contactsDataList.addAll(contacts);
        contactsSearchList.addAll(contacts);
      }
    }
    update();
  }

  void filterConatctUser(String value) {
    contactsSearchList = contactsDataList
        .where((item) =>
            item.displayName.toLowerCase().contains(value.toLowerCase()))
        .toList();
    update();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///================================================================= GroupChatScreen
  ///
  ///
  ///

  String? groupId;
  Future<void> sendGroupMessage(
      String? pollId, bool isLocation, bool isPersonalContact) async {
    List<String> userSelectList = [];
    for (var data in contactSelectList) {
      if (data.isSelect ?? false) {
        userSelectList.add(data.userid ?? "");
      }
    }
    var response = await chatPresenter.sendGroupMessage(
      isLoading: false,
      receiverid: groupId ?? "",
      message: sendMessageController.text,
      product: "",
      latitude: isLocation ? selectedLocationLatLag?.latitude.toString() : "",
      longitude: isLocation ? selectedLocationLatLag?.longitude.toString() : "",
      pollid: pollId,
      context: isReplyChat ? chatGroupListsDoc?.id : "",
      phonecontactData: isPersonalContact
          ? PhoneContact(
              name: contactsSearchList[selectUser].displayName,
              mobile: contactsSearchList[selectUser]
                  .phones
                  .map((e) => e.number)
                  .toList(),
            )
          : null,
      usersList: userSelectList,
      mediaFileList: sentImageMsgLists
          .map(
            (e) => ImageFormData(
              fieldName: "file",
              filePath: e.url ?? "",
              mediaType: MediaType.parse(lookupMimeType(e.url ?? "")!),
            ),
          )
          .toList(),
    );
    if (response != null) {
      sentImageMsgLists.clear();
      getGroupChatLists(1);
      Get.find<GroupChatController>().groupListPagingController.refresh();
    }
  }

  Future<void> postGroupChatSendBulkMessage(String? pollId, isLocation) async {
    var response = await chatPresenter.postGroupChatSendBulkMessage(
      isLoading: false,
      receiverid: groupId ?? "",
      message: sendMessageController.text,
      context: isReplyChat ? chatGroupListsDoc?.id : "",
      mediaFileList: sentImageMsgLists
          .map(
            (e) => ImageFormData(
              fieldName: "file[${sentImageMsgLists.indexOf(e)}]",
              filePath: e.url ?? "",
              mediaType: MediaType.parse(lookupMimeType(e.url ?? "")!),
            ),
          )
          .toList(),
    );
    if (response != null) {
      sentImageMsgLists.clear();
      getGroupChatLists(1);
      Get.find<GroupChatController>().groupListPagingController.refresh();
    }
  }

  bool isGroupLastPage = false;
  int pageGroupCount = 1;

  final ScrollController scrollGroupController = ScrollController();
  List<ChatListsDoc> chatGroupMessageList = [];
  ChatListsDoc? chatGroupListsDoc = ChatListsDoc();
  TextEditingController groupChatSearchController = TextEditingController();
  bool isGroupSearch = false;

  Future<void> getGroupChatLists(int pageKey) async {
    if (pageKey == 1) {
      pageGroupCount = 1;
    }
    var response = await chatPresenter.getGroupChatLists(
      groupid: groupId ?? "",
      page: pageGroupCount,
      limit: 10,
      search: groupChatSearchController.text,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isGroupLastPage = false;
        chatGroupMessageList.clear();
      }
      if ((response.data.docs?.length ?? 0) < 10) {
        isGroupLastPage = true;
        chatGroupMessageList.addAll(response.data.docs ?? []);
      } else {
        pageGroupCount++;
        chatGroupMessageList.addAll(response.data.docs ?? []);
      }
      if (pageKey == 1) {
        if (scrollGroupController.positions.isNotEmpty) {
          scrollGroupController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postGroupDeliveredMessage(String? messageid) async {
    var response = await chatPresenter.postGroupDeliveredMessage(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {}
  }

  Future<void> postGroupSeenMessage(String? messageid) async {
    var response = await chatPresenter.postGroupSeenMessage(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {}
  }

  GetOneGroupData getOneGroupData = GetOneGroupData();

  Future<void> getOneGroup() async {
    var response = await chatPresenter.getOneGroup(
      groupid: groupId ?? "",
    );
    if (response != null) {
      getOneGroupData = response.data;
    }
    update();
  }

  Future<void> postChatGroupDeleteMessage(chatMessageData, deletefor) async {
    var response = await chatPresenter.postChatGroupDeleteMessage(
      isLoading: false,
      messageid: chatMessageData.id ?? "",
      deletefor: deletefor,
    );
    if (response != null) {
      chatMessageList.remove(chatMessageList);
      getGroupChatLists(1);
      update();
    }
  }

  bool isChatGroupMessageEdit = false;
  String? chatGroupMessageIds;

  bool isSubUser = false;

  Future<void> postChatGroupMessageEdit(message) async {
    var response = await chatPresenter.postChatGroupMessageEdit(
      isLoading: false,
      messageid: chatGroupMessageIds ?? "",
      message: message,
    );
    if (response != null) {
      isChatGroupMessageEdit = false;
      var index = chatGroupMessageList
          .indexWhere((element) => element.id == chatGroupMessageIds);
      if (index.isNegative == false) {
        chatGroupMessageList[index].content?.text.message = message;
        chatGroupMessageList[index].isedited = true;
      }
      update();
    }
  }

  Future<void> postChatGroupBookmarkAndRemove(messageid, isBookmark) async {
    var response = await chatPresenter.postChatGroupBookmarkAndRemove(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {
      if (isBookmark) {
        var index = bookmarkList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          bookmarkList.removeAt(index);
        }
      } else {
        var index = chatGroupMessageList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          chatGroupMessageList[index].bookmarks = null;
          chatGroupMessageList[index].bookmarks = response.data?.bookmarks;
        }
      }
      update();
    }
  }

  Future<void> postChatGroupFavoriteAndRemove(messageid, isFavorite) async {
    var response = await chatPresenter.postChatGroupFavoriteAndRemove(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {
      if (isFavorite) {
        var index = chatGroupFavoriteList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          chatGroupFavoriteList.removeAt(index);
        }
      } else {
        var index = chatGroupMessageList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          chatGroupMessageList[index].favorites = null;
          chatGroupMessageList[index].favorites = response.data?.favorites;
        }
      }
      update();
    }
  }

  Future<void> postChatGroupMessageReaction(messageid, reaction) async {
    var response = await chatPresenter.postChatGroupMessageReaction(
      isLoading: false,
      messageid: messageid ?? "",
      reaction: reaction,
    );
    if (response != null) {
      var index = chatGroupMessageList
          .indexWhere((element) => element.id == response.data?.id);
      if (index.isNegative == false) {
        chatGroupMessageList[index].reactions = null;
        chatGroupMessageList[index].reactions = response.data?.reactions;
      }
      update();
    }
  }

  Future<void> postChatGroupMessageUnReaction(messageid) async {
    var response = await chatPresenter.postChatGroupMessageUnReaction(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {
      var index = chatGroupMessageList
          .indexWhere((element) => element.id == response.data?.id);
      if (index.isNegative == false) {
        chatGroupMessageList[index].reactions = null;
        chatGroupMessageList[index].reactions = response.data?.reactions;
      }
      update();
    }
  }

  // post call initiate api
  Future<void> postGroupCallInitaite({
    bool isLoading = false,
    required String receiverId,
    required bool isVideoCall,
    required bool isAudioCall,
    required bool isGroupCall,
  }) async {
    var response = await chatPresenter.postCallInitaite(
      isLoading: isLoading,
      isAudioCall: isAudioCall,
      isGroupCall: isGroupCall,
      isVideoCall: isVideoCall,
      receiverId: receiverId,
    );
    if (response != null) {
      if (response.data.calldata.id == null ||
          response.data.calldata.id!.isEmpty) {
        Utility.showMessage("Failed to initiate call: Invalid meeting ID",
            MessageType.error, () => Get.back(), 'Okay');
        return;
      }
      if (isAudioCall) {
        RouteManagement.goToAudioCallScreen(
          response.data.calldata.agorameta?.channelName ?? "",
          response.data.calldata.agorameta?.token ?? "",
          response.data.calldata.id ?? "",
          true,
          response.data.calldata.touser?.profileimage ?? "",
          response.data.fromusername,
          true,
        );
      } else {
        RouteManagement.goToVideoCallScreen(
            response.data.calldata.agorameta?.channelName ?? "",
            response.data.calldata.agorameta?.token ?? "",
            response.data.calldata.id ?? "",
            true,
            response.data.calldata.touser?.profileimage ?? "",
            response.data.fromusername,
            true);
      }
      // postSendFcmApi(response.data, "onincominggroupcall");
      FirebaseAccessToken firebaseAccessToken = FirebaseAccessToken();
      String token = "";
      Object? oauthError;
      for (var attempt = 1; attempt <= 3; attempt++) {
        try {
          token = await firebaseAccessToken.getToken();
          if (token.isNotEmpty) {
            break;
          }
        } catch (e) {
          oauthError = e;
        }
        await Future.delayed(Duration(milliseconds: 300 * attempt));
      }
      if (token.isEmpty) {
        print(
            "❌ Unable to get Firebase OAuth token for group call push after retries. error=$oauthError");
      } else {
        print("OAuth $token");
        postSendFcmApi(response.data, "onincominggroupcall", token);
      }
      Get.find<GroupChatController>().groupListPagingController.refresh();
    }
    update();
  }

  bool isGroupPinned = false;

  int pageBookmarkCount = 1;
  bool isbookmarkLastPage = false;
  bool isBookmarksLoading = false;

  List<ChatListsDoc> bookmarkList = [];

  final ScrollController scrollBookmarkdController = ScrollController();

  Future<void> postBookmarksList(pageKey) async {
    if (pageKey == 1) {
      pageBookmarkCount = 1;
    }
    var response = await chatPresenter.postBookmarksList(
      page: pageBookmarkCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isbookmarkLastPage = false;
        bookmarkList.clear();
      }

      if ((response.data?.length ?? 0) < 10) {
        isbookmarkLastPage = true;
        bookmarkList.addAll(response.data ?? []);
      } else {
        pageBookmarkCount++;
        bookmarkList.addAll(response.data ?? []);
      }
      if (pageKey == 1) {
        if (scrollBookmarkdController.positions.isNotEmpty) {
          scrollBookmarkdController.jumpTo(0);
        }
      }
    }
    update();
  }

  ///================================================================= GroupMessageInfoScreen ==============================================================================///

  ChatListsDoc groupChatListDocs = ChatListsDoc();

  ///================================================================= Mic ==============================================================================///

  bool isRecording = false;

  String? filePath;
  late final RecorderController recorderController;
  late Directory appDirectory;
  String? _recordingPath;

  Future<void> startRecording() async {
    var status = await permission.Permission.microphone.request();
    if (status.isGranted) {
      appDirectory = await getApplicationDocumentsDirectory();
      final path =
          '${appDirectory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.aac';

      await recorderController.record(path: path);
      isRecording = true;
      update();
    }
  }

  @override
  void dispose() {
    recorderController.dispose();
    super.dispose();
  }

  Future<void> stopRecording() async {
    try {
      _recordingPath = await recorderController.stop(false);
      isRecording = false;
      update();
      if (_recordingPath != null) {
        sentImageMsgLists.add(
          MediaModel(url: _recordingPath ?? "", isVideo: false),
        );
        sendMessage("", false, false);
        print("Recording saved at: $_recordingPath");
      }
    } catch (e) {
      print('Error stopping recorder: $e');
    }
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///================================================================= BrodcastChatScreen ==============================================================================///

  PagingController<int, BroadcastDoc> broadcastPagingController =
      PagingController(firstPageKey: 1);

  BroadcastDoc? broadcastDoc = BroadcastDoc();

  TextEditingController searchController = TextEditingController();
  TextEditingController sendBrodcastMsgController = TextEditingController();

  List<BroadcastDoc> broadcastList = [];

  int brodcastLimit = 10;

  Future<void> postListBroadcast(pageKey) async {
    var response = await chatPresenter.postListBroadcast(
      page: pageKey,
      limit: brodcastLimit,
      search: searchController.text,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        broadcastList.clear();
      }
      broadcastList = response.data?.docs ?? [];

      final isLastPage = broadcastList.length < blockUserlimit;
      if (isLastPage) {
        broadcastPagingController.appendLastPage(broadcastList);
      } else {
        var nextPageKey = pageKey + 1;
        broadcastPagingController.appendPage(broadcastList, nextPageKey);
      }
      update();
    }
  }

  GetOneBroadcastData? getOneBroadcastData = GetOneBroadcastData();

  String? broadcastid = "";

  Future<void> getOneBroadcast(broadcastid) async {
    var response = await chatPresenter.getOneBroadcast(
      broadcastid: broadcastid ?? "",
      isLoading: true,
    );
    if (response != null) {
      getOneBroadcastData = response.data;
    }
    update();
  }

  List<ChatListsDoc> chatBrodcastMessageList = [];

  ChatListsDoc? chatBrodcastListsDoc = ChatListsDoc();

  int pageBrodcastCount = 1;

  bool isBrodcastLastPage = false;
  bool isBrodcastLoading = false;

  final ScrollController scrollBrodcastController = ScrollController();

  Future<void> postChatListBroadcast(int pageKey) async {
    if (pageKey == 1) {
      pageBrodcastCount = 1;
    }
    var response = await chatPresenter.postChatListBroadcast(
      broadcastid: broadcastid ?? "",
      page: pageBrodcastCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isBrodcastLastPage = false;
        chatBrodcastMessageList.clear();
      }
      if ((response.data.docs?.length ?? 0) < 10) {
        isBrodcastLastPage = true;
        chatBrodcastMessageList.addAll(response.data.docs ?? []);
      } else {
        pageBrodcastCount++;
        chatBrodcastMessageList.addAll(response.data.docs ?? []);
      }
      if (pageKey == 1) {
        if (scrollBrodcastController.positions.isNotEmpty) {
          scrollBrodcastController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postSendMessageBroadcast(String? pollId, isLocation) async {
    List<String> userSelectList = [];

    for (var data in contactSelectList) {
      if (data.isSelect ?? false) {
        userSelectList.add(data.userid ?? "");
      }
    }
    var response = await chatPresenter.postSendMessageBroadcast(
      isLoading: false,
      broadcastid: broadcastid ?? "",
      message: sendBrodcastMsgController.text,
      product: friendProductDoc?.id ?? "",
      latitude: isLocation ? selectedLocationLatLag?.latitude.toString() : "",
      longitude: isLocation ? selectedLocationLatLag?.longitude.toString() : "",
      pollid: pollId,
      usersList: userSelectList,
      context: isReplyChat ? chatBrodcastListsDoc?.id : "",
      mediaFileList: sentImageMsgLists
          .map(
            (e) => ImageFormData(
              fieldName: "file",
              filePath: e.url ?? "",
              mediaType: MediaType.parse(lookupMimeType(e.url ?? "")!),
            ),
          )
          .toList(),
    );
    if (response != null) {
      isReplyChat = false;
      chatBrodcastListsDoc = null;
      sentImageMsgLists.clear();
      postChatListBroadcast(1);
      var index = Get.find<ChatController>()
          .broadcastPagingController
          .itemList
          ?.indexWhere((element) => element.id == broadcastid);
      if (index?.isNegative == false) {
        Get.find<ChatController>()
            .broadcastPagingController
            .itemList?[index!]
            .lastchatmessage
            ?.timestamp = 0;
        Get.find<ChatController>()
            .broadcastPagingController
            .itemList?[index!]
            .lastchatmessage
            ?.timestamp = response.senttimestamp ?? 0;

        var data = Get.find<ChatController>()
            .broadcastPagingController
            .itemList![index!];
        Get.find<ChatController>()
            .broadcastPagingController
            .itemList
            ?.removeAt(index);
        Get.find<ChatController>()
            .broadcastPagingController
            .itemList
            ?.insert(0, data);
      }
      questionList.map((e) => e.textController?.clear()).toList();
      update();
    }
  }

  Future<void> postSendMultiMediaBroadcast(String? pollId, isLocation) async {
    var response = await chatPresenter.postSendMultiMediaBroadcast(
      isLoading: false,
      broadcastid: broadcastid ?? "",
      message: sendBrodcastMsgController.text,
      context: isReplyChat ? chatBrodcastListsDoc?.id : "",
      mediaFileList: sentImageMsgLists
          .map(
            (e) => ImageFormData(
              fieldName: "file[${sentImageMsgLists.indexOf(e)}]",
              filePath: e.url ?? "",
              mediaType: MediaType.parse(lookupMimeType(e.url ?? "")!),
            ),
          )
          .toList(),
    );
    if (response != null) {
      isReplyChat = false;
      chatBrodcastListsDoc = null;
      sentImageMsgLists.clear();
      postChatListBroadcast(1);
      var index = Get.find<ChatController>()
          .broadcastPagingController
          .itemList
          ?.indexWhere((element) => element.id == broadcastid);
      if (index?.isNegative == false) {
        Get.find<ChatController>()
            .broadcastPagingController
            .itemList?[index!]
            .lastchatmessage
            ?.timestamp = 0;
        Get.find<ChatController>()
            .broadcastPagingController
            .itemList?[index!]
            .lastchatmessage
            ?.timestamp = response.senttimestamp ?? 0;

        var data = Get.find<ChatController>()
            .broadcastPagingController
            .itemList![index!];
        Get.find<ChatController>()
            .broadcastPagingController
            .itemList
            ?.removeAt(index);
        Get.find<ChatController>()
            .broadcastPagingController
            .itemList
            ?.insert(0, data);
      }
    }
  }

  Future<void> postBrodcastDeleteMeg(ChatListsDoc chatMessageList) async {
    var response = await chatPresenter.postBrodcastDeleteMeg(
      messageid: chatMessageList.id ?? "",
      isLoading: true,
    );
    if (response != null) {
      postChatListBroadcast(1);
    }
    update();
  }

  Future<void> postBrodcastFavorite(messageid, isFavorite) async {
    var response = await chatPresenter.postBrodcastFavorite(
      isLoading: false,
      messageid: messageid ?? "",
    );
    if (response != null) {
      if (isFavorite) {
        var index = brodcastFavoriteList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          brodcastFavoriteList.removeAt(index);
        }
      } else {
        var index = chatBrodcastMessageList
            .indexWhere((element) => element.id == response.data?.id);
        if (index.isNegative == false) {
          chatBrodcastMessageList[index].favorites = null;
          chatBrodcastMessageList[index].favorites = response.data?.favorites;
        }
      }
      update();
    }
  }

  ////=============================================== ChatWallpaperScreen =================================================///
  final pickerProfile = ImagePicker();
  File? imgFile;
  String imagePath = "";
  Future selectWallpaper() async {
    final pickedFile =
        await pickerProfile.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (Utility.getImageSizeMB(pickedFile.path) <= 16) {
        imagePath = pickedFile.path;
        imgFile = File(pickedFile.path);
        RouteManagement.goToChatWallpaperPreviewScreen();
        // profileImage = await profilePresenter.setProfilePic(
        //     filePath: imageFile?.path ?? "");
      } else {
        Utility.errorMessage("max_16_mb_img".tr);
      }
    }
    update();
  }

  ////=============================================== ReportUserScreen =================================================///

  GlobalKey<FormState> reportKey = GlobalKey<FormState>();
  TextEditingController reasonController = TextEditingController();

  String selectedReportReason = 'Spam';
  final List<String> reportReasons = [
    'Spam',
    'Harassment',
    'Abusive Content',
    'Fake Profile',
    'Other'
  ];

  void selectReportReason(String reason) {
    selectedReportReason = reason;
    update();
  }

  String? reportUser;

  Future<void> postChatReport(String userid) async {
    String finalReason = selectedReportReason;
    if (selectedReportReason == 'Other') {
      finalReason = reasonController.text.trim();
      if (finalReason.isEmpty) {
        Utility.snacBar('Please enter a description for "Other"', ColorsValue.appColor);
        return;
      }
    }

    var response = await chatPresenter.postChatReport(
      reportid: "",
      userid: userid,
      reason: finalReason,
      isLoading: true,
    );
    if (response?.statusCode == 200) {
      Get.back();
      reasonController.clear();
      Utility.snacBar(jsonDecode(response?.data.toString() ?? "")['Message'],
          ColorsValue.appColor);
    }
    update();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///================================================================= SharedMediaScreen ==============================================================================///

  String? brodId = "";
  String? mediaTitle = "";

  List<ChatListsDoc> chatMediaList = [];
  List<UserMediaModel> chatMediaRecentList = [];
  List<UserMediaModel> chatMediaWeekList = [];
  List<UserMediaModel> chatMediaMonthList = [];
  List<UserMediaModel> chatMediaOldList = [];
  List<UserMediaModel> photoVideoList = [];
  int pagMediaCount = 1;
  bool isMediaLastPage = false;
  bool isMediaLoading = false;

  final ScrollController scrollMediaController = ScrollController();

  Future<void> postPhotoVideo(int pageKey) async {
    if (pageKey == 1) {
      pagMediaCount = 1;
    }
    var response = await chatPresenter.postPhotoVideo(
      userid: userId ?? "",
      page: pagMediaCount,
      limit: 30,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isMediaLastPage = false;
        chatMediaRecentList.clear();
        photoVideoList.clear();
        chatMediaWeekList.clear();
        chatMediaMonthList.clear();
        chatMediaOldList.clear();
        chatMediaList.clear();
      }
      if ((response.data.docs?.length ?? 0) < 30) {
        isMediaLastPage = true;
        chatMediaList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          if (data.content?.media.path.isNotEmpty ?? false) {
            photoVideoList.add(
              UserMediaModel(
                url: data.content?.media.path,
                isVideo: data.content?.media.type == "IMG" ? false : true,
                timestemp: data.senttimestamp,
              ),
            );
          } else {
            data.content?.multimedias
                ?.map(
                  (e) => photoVideoList.add(
                    UserMediaModel(
                      url: e.path,
                      isVideo: e.type == "IMG" ? false : true,
                      timestemp: data.senttimestamp,
                    ),
                  ),
                )
                .toList();
          }
        }

        for (var data in photoVideoList ?? <UserMediaModel>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.timestemp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatMediaMonthList.add(data);
          } else {
            chatMediaOldList.add(data);
          }
        }
      } else {
        pagMediaCount++;
        chatMediaList.addAll(response.data.docs ?? []);
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          if (data.content?.media.path.isNotEmpty ?? false) {
            photoVideoList.add(
              UserMediaModel(
                url: data.content?.media.path,
                isVideo: data.content?.media.type == "IMG" ? false : true,
                timestemp: data.senttimestamp,
              ),
            );
          } else {
            data.content?.multimedias
                ?.map(
                  (e) => photoVideoList.add(
                    UserMediaModel(
                      url: e.path,
                      isVideo: e.type == "IMG" ? false : true,
                      timestemp: data.senttimestamp,
                    ),
                  ),
                )
                .toList();
          }
        }

        for (var data in photoVideoList ?? <UserMediaModel>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.timestemp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatMediaMonthList.add(data);
          } else {
            chatMediaOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollMediaController.positions.isNotEmpty) {
          scrollMediaController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postBrodcastPhoto(int pageKey) async {
    if (pageKey == 1) {
      pagMediaCount = 1;
    }
    var response = await chatPresenter.postBrodcastPhoto(
      broadcastid: brodId ?? "",
      page: pagMediaCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isMediaLastPage = false;
        chatMediaRecentList.clear();
        photoVideoList.clear();
        chatMediaWeekList.clear();
        chatMediaMonthList.clear();
        chatMediaOldList.clear();
        chatMediaList.clear();
      }
      if ((response.data.docs?.length ?? 0) < 30) {
        isMediaLastPage = true;
        chatMediaList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          if (data.content?.media.path.isNotEmpty ?? false) {
            photoVideoList.add(
              UserMediaModel(
                url: data.content?.media.path,
                isVideo: data.content?.media.type == "IMG" ? false : true,
                timestemp: data.senttimestamp,
              ),
            );
          } else {
            data.content?.multimedias
                ?.map(
                  (e) => photoVideoList.add(
                    UserMediaModel(
                      url: e.path,
                      isVideo: e.type == "IMG" ? false : true,
                      timestemp: data.senttimestamp,
                    ),
                  ),
                )
                .toList();
          }
        }

        for (var data in photoVideoList ?? <UserMediaModel>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.timestemp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatMediaMonthList.add(data);
          } else {
            chatMediaOldList.add(data);
          }
        }
      } else {
        pagMediaCount++;
        chatMediaList.addAll(response.data.docs ?? []);
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          if (data.content?.media.path.isNotEmpty ?? false) {
            photoVideoList.add(
              UserMediaModel(
                url: data.content?.media.path,
                isVideo: data.content?.media.type == "IMG" ? false : true,
                timestemp: data.senttimestamp,
              ),
            );
          } else {
            data.content?.multimedias
                ?.map(
                  (e) => photoVideoList.add(
                    UserMediaModel(
                      url: e.path,
                      isVideo: e.type == "IMG" ? false : true,
                      timestemp: data.senttimestamp,
                    ),
                  ),
                )
                .toList();
          }
        }

        for (var data in photoVideoList ?? <UserMediaModel>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.timestemp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatMediaMonthList.add(data);
          } else {
            chatMediaOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollMediaController.positions.isNotEmpty) {
          scrollMediaController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postGroupPhoto(int pageKey) async {
    if (pageKey == 1) {
      pagMediaCount = 1;
    }
    var response = await chatPresenter.postGroupPhoto(
      groupid: brodId ?? "",
      page: pagMediaCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isMediaLastPage = false;
        chatMediaRecentList.clear();
        photoVideoList.clear();
        chatMediaWeekList.clear();
        chatMediaMonthList.clear();
        chatMediaOldList.clear();
        chatMediaList.clear();
      }
      if ((response.data.docs?.length ?? 0) < 30) {
        isMediaLastPage = true;
        chatMediaList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          if (data.content?.media.path.isNotEmpty ?? false) {
            photoVideoList.add(
              UserMediaModel(
                url: data.content?.media.path,
                isVideo: data.content?.media.type == "IMG" ? false : true,
                timestemp: data.senttimestamp,
              ),
            );
          } else {
            data.content?.multimedias
                ?.map(
                  (e) => photoVideoList.add(
                    UserMediaModel(
                      url: e.path,
                      isVideo: e.type == "IMG" ? false : true,
                      timestemp: data.senttimestamp,
                    ),
                  ),
                )
                .toList();
          }
        }

        for (var data in photoVideoList ?? <UserMediaModel>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.timestemp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatMediaMonthList.add(data);
          } else {
            chatMediaOldList.add(data);
          }
        }
      } else {
        pagMediaCount++;
        chatMediaList.addAll(response.data.docs ?? []);
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          if (data.content?.media.path.isNotEmpty ?? false) {
            photoVideoList.add(
              UserMediaModel(
                url: data.content?.media.path,
                isVideo: data.content?.media.type == "IMG" ? false : true,
                timestemp: data.senttimestamp,
              ),
            );
          } else {
            data.content?.multimedias
                ?.map(
                  (e) => photoVideoList.add(
                    UserMediaModel(
                      url: e.path,
                      isVideo: e.type == "IMG" ? false : true,
                      timestemp: data.senttimestamp,
                    ),
                  ),
                )
                .toList();
          }
        }

        for (var data in photoVideoList ?? <UserMediaModel>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.timestemp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatMediaMonthList.add(data);
          } else {
            chatMediaOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollMediaController.positions.isNotEmpty) {
          scrollMediaController.jumpTo(0);
        }
      }
    }
    update();
  }

  List<ChatListsDoc> chatLinksList = [];
  List<ChatListsDoc> chatLinksRecentList = [];
  List<ChatListsDoc> chatLinksWeekList = [];
  List<ChatListsDoc> chatLinksMonthList = [];
  List<ChatListsDoc> chatLinksOldList = [];
  int pagLinksCount = 1;
  bool isLinksLastPage = false;
  bool isLinksLoading = false;

  final ScrollController scrollLinksController = ScrollController();

  Future<void> postLinks(int pageKey) async {
    if (pageKey == 1) {
      pagLinksCount = 1;
    }
    var response = await chatPresenter.postLinks(
      userid: userId ?? "",
      page: pagLinksCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isLinksLastPage = false;
        chatLinksRecentList.clear();
        chatLinksWeekList.clear();
        chatLinksMonthList.clear();
        chatLinksOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isLinksLastPage = true;
        chatLinksList.addAll(response.data.docs ?? []);
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatLinksRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatLinksWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatLinksMonthList.add(data);
          } else {
            chatLinksOldList.add(data);
          }
        }
      } else {
        pagLinksCount++;
        chatLinksList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatLinksRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatLinksWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatLinksMonthList.add(data);
          } else {
            chatLinksOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollLinksController.positions.isNotEmpty) {
          scrollLinksController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postBrodcastLink(int pageKey) async {
    if (pageKey == 1) {
      pagLinksCount = 1;
    }
    var response = await chatPresenter.postBrodcastLink(
      broadcastid: brodId ?? "",
      page: pagLinksCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isLinksLastPage = false;
        chatLinksRecentList.clear();
        chatLinksWeekList.clear();
        chatLinksMonthList.clear();
        chatLinksOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isLinksLastPage = true;
        chatLinksList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatLinksRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatLinksWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatLinksMonthList.add(data);
          } else {
            chatLinksOldList.add(data);
          }
        }
      } else {
        pagLinksCount++;
        chatLinksList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatLinksRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatLinksWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatLinksMonthList.add(data);
          } else {
            chatLinksOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollLinksController.positions.isNotEmpty) {
          scrollLinksController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postGroupLink(int pageKey) async {
    if (pageKey == 1) {
      pagLinksCount = 1;
    }
    var response = await chatPresenter.postGroupLink(
      groupid: brodId ?? "",
      page: pagLinksCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isLinksLastPage = false;
        chatLinksRecentList.clear();
        chatLinksWeekList.clear();
        chatLinksMonthList.clear();
        chatLinksOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isLinksLastPage = true;
        chatLinksList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatLinksRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatLinksWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatLinksMonthList.add(data);
          } else {
            chatLinksOldList.add(data);
          }
        }
      } else {
        pagLinksCount++;
        chatLinksList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatLinksRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatLinksWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatLinksMonthList.add(data);
          } else {
            chatLinksOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollLinksController.positions.isNotEmpty) {
          scrollLinksController.jumpTo(0);
        }
      }
    }
    update();
  }

  List<ChatListsDoc> chatDocsList = [];
  List<ChatListsDoc> chatDocsRecentList = [];
  List<ChatListsDoc> chatDocsWeekList = [];
  List<ChatListsDoc> chatDocsMonthList = [];
  List<ChatListsDoc> chatDocsOldList = [];

  int pagDocsCount = 1;
  bool isDocsLastPage = false;
  bool isDocsLoading = false;

  final ScrollController scrollDocsController = ScrollController();

  Future<void> postDocs(int pageKey) async {
    if (pageKey == 1) {
      pagDocsCount = 1;
    }
    var response = await chatPresenter.postDocs(
      userid: userId ?? "",
      page: pagDocsCount,
      limit: 10,
      isLoading: false,
    );

    if (response != null) {
      if (pageKey == 1) {
        isDocsLastPage = false;
        chatDocsRecentList.clear();
        chatDocsWeekList.clear();
        chatDocsMonthList.clear();
        chatDocsOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isDocsLastPage = true;
        chatDocsList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatDocsRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatDocsWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatDocsMonthList.add(data);
          } else {
            chatDocsOldList.add(data);
          }
        }
      } else {
        pagDocsCount++;
        chatDocsList.addAll(response.data.docs ?? []);
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatDocsRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatDocsWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatDocsMonthList.add(data);
          } else {
            chatDocsOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollDocsController.positions.isNotEmpty) {
          scrollDocsController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postBrodcastDoc(int pageKey) async {
    if (pageKey == 1) {
      pagDocsCount = 1;
    }
    var response = await chatPresenter.postBrodcastDoc(
      broadcastid: brodId ?? "",
      page: pagDocsCount,
      limit: 10,
      isLoading: false,
    );

    if (response != null) {
      if (pageKey == 1) {
        isDocsLastPage = false;
        chatDocsRecentList.clear();
        chatDocsWeekList.clear();
        chatDocsMonthList.clear();
        chatDocsOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isDocsLastPage = true;
        chatDocsList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatDocsRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatDocsWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatDocsMonthList.add(data);
          } else {
            chatDocsOldList.add(data);
          }
        }
      } else {
        pagDocsCount++;
        chatDocsList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatDocsRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatDocsWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatDocsMonthList.add(data);
          } else {
            chatDocsOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollDocsController.positions.isNotEmpty) {
          scrollDocsController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postGroupDoc(int pageKey) async {
    if (pageKey == 1) {
      pagDocsCount = 1;
    }
    var response = await chatPresenter.postGroupDoc(
      groupid: brodId ?? "",
      page: pagDocsCount,
      limit: 10,
      isLoading: false,
    );

    if (response != null) {
      if (pageKey == 1) {
        isDocsLastPage = false;
        chatDocsRecentList.clear();
        chatDocsWeekList.clear();
        chatDocsMonthList.clear();
        chatDocsOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isDocsLastPage = true;
        chatDocsList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatDocsRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatDocsWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatDocsMonthList.add(data);
          } else {
            chatDocsOldList.add(data);
          }
        }
      } else {
        pagDocsCount++;
        chatDocsList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatDocsRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatDocsWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatDocsMonthList.add(data);
          } else {
            chatDocsOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollDocsController.positions.isNotEmpty) {
          scrollDocsController.jumpTo(0);
        }
      }
    }
    update();
  }

  DateTime getStartOfLastMonth() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month - 1, 1);
  }

  DateTime getStartOfToday() {
    return DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  DateTime getStartOfLastWeek() {
    return getStartOfToday()
        .subtract(Duration(days: DateTime.now().weekday - 1));
  }

  List<ChatListsDoc> chatAudioMediaList = [];
  List<ChatListsDoc> chatAudioMediaRecentList = [];
  List<ChatListsDoc> chatAudioMediaWeekList = [];
  List<ChatListsDoc> chatAudioMediaMonthList = [];
  List<ChatListsDoc> chatAudioMediaOldList = [];
  int pagAudioMediaCount = 1;
  bool isAudioMediaLastPage = false;
  bool isAudioMediaLoading = false;

  final ScrollController scrollAudioMediaController = ScrollController();

  Future<void> postAudios(int pageKey) async {
    if (pageKey == 1) {
      pagAudioMediaCount = 1;
    }
    var response = await chatPresenter.postAudios(
      userid: userId ?? "",
      page: pagAudioMediaCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isAudioMediaLastPage = false;
        chatAudioMediaRecentList.clear();
        chatAudioMediaWeekList.clear();
        chatAudioMediaMonthList.clear();
        chatAudioMediaOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isAudioMediaLastPage = true;
        chatAudioMediaList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatAudioMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatAudioMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatAudioMediaMonthList.add(data);
          } else {
            chatAudioMediaOldList.add(data);
          }
        }
      } else {
        pagAudioMediaCount++;
        chatAudioMediaList.addAll(response.data.docs ?? []);

        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatAudioMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatAudioMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatAudioMediaMonthList.add(data);
          } else {
            chatAudioMediaOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollAudioMediaController.positions.isNotEmpty) {
          scrollAudioMediaController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postBrodcastAudio(int pageKey) async {
    if (pageKey == 1) {
      pagAudioMediaCount = 1;
    }
    var response = await chatPresenter.postBrodcastAudio(
      broadcastid: brodId ?? "",
      page: pagAudioMediaCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isAudioMediaLastPage = false;
        chatAudioMediaRecentList.clear();
        chatAudioMediaWeekList.clear();
        chatAudioMediaMonthList.clear();
        chatAudioMediaOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isAudioMediaLastPage = true;
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatAudioMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatAudioMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatAudioMediaMonthList.add(data);
          } else {
            chatAudioMediaOldList.add(data);
          }
        }
      } else {
        pagAudioMediaCount++;
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatAudioMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatAudioMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatAudioMediaMonthList.add(data);
          } else {
            chatAudioMediaOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollAudioMediaController.positions.isNotEmpty) {
          scrollAudioMediaController.jumpTo(0);
        }
      }
    }
    update();
  }

  Future<void> postGroupAudio(int pageKey) async {
    if (pageKey == 1) {
      pagAudioMediaCount = 1;
    }
    var response = await chatPresenter.postGroupAudio(
      groupid: brodId ?? "",
      page: pagAudioMediaCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isAudioMediaLastPage = false;
        chatAudioMediaRecentList.clear();
        chatAudioMediaWeekList.clear();
        chatAudioMediaMonthList.clear();
        chatAudioMediaOldList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isAudioMediaLastPage = true;
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatAudioMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatAudioMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatAudioMediaMonthList.add(data);
          } else {
            chatAudioMediaOldList.add(data);
          }
        }
      } else {
        pagAudioMediaCount++;
        for (var data in response.data.docs ?? <ChatListsDoc>[]) {
          var selectDate =
              DateTime.fromMillisecondsSinceEpoch(data.senttimestamp ?? 0);
          DateTime startOfToday = getStartOfToday();
          DateTime startOfLastWeek = getStartOfLastWeek();
          DateTime startOfLastMonth = getStartOfLastMonth();
          DateTime startOfThisMonth =
              DateTime(DateTime.now().year, DateTime.now().month, 1);
          if (selectDate.isAfter(startOfToday)) {
            chatAudioMediaRecentList.add(data);
          } else if (selectDate.isAfter(startOfLastWeek) &&
              selectDate.isBefore(startOfToday)) {
            chatAudioMediaWeekList.add(data);
          } else if (selectDate.isAfter(startOfLastMonth) &&
              selectDate.isBefore(startOfThisMonth)) {
            chatAudioMediaMonthList.add(data);
          } else {
            chatAudioMediaOldList.add(data);
          }
        }
      }
      if (pageKey == 1) {
        if (scrollAudioMediaController.positions.isNotEmpty) {
          scrollAudioMediaController.jumpTo(0);
        }
      }
    }
    update();
  }

  ///===================================================== Hide and lock ========================================================///

  bool isEnterPin = false;

  GlobalKey<FormState> createLockKey = GlobalKey<FormState>();
  TextEditingController createLockPinController = TextEditingController();

  Future<void> postChatLock(MyFriendDatum itemData) async {
    var response = await chatPresenter.postChatLock(
      friendrequestids: [
        itemData.friendrequestid ?? "",
      ],
      isLoading: false,
    );
    Get.closeAllSnackbars();
    if (response != null) {
      chatPagingController.itemList!.remove(itemData);
      Utility.snacBar(
          jsonDecode(response.data)['Message'], ColorsValue.appColor);
    }
    update();
  }

  Future<void> postGroupChatLock(GroupChatDatum itemData) async {
    var response = await chatPresenter.postGroupChatLock(
      groupids: [itemData.id ?? ""],
      isLoading: false,
    );
    Get.closeAllSnackbars();
    if (response != null) {
      Get.find<GroupChatController>()
          .groupListPagingController
          .itemList!
          .remove(itemData);
      Utility.snacBar(
          jsonDecode(response.data)['Message'], ColorsValue.appColor);
    }
    update();
  }

  String createPin = "";

  Future<void> postCreatePin() async {
    var response = await chatPresenter.postCreatePinLock(
      pin: createLockPinController.text,
      isLoading: true,
    );
    Get.closeAllSnackbars();
    if (response?.status == 200) {
      isEnterPin = false;
      Get.find<HomeScreenController>().getProfile();
      Get.back();
      Get.back();
      if (pendingLockItem != null) {
        postChatLock(pendingLockItem!);
        pendingLockItem = null;
      } else if (pendingGroupLockItem != null) {
        postGroupChatLock(pendingGroupLockItem!);
        pendingGroupLockItem = null;
      }
    } else {
      Utility.errorMessage(response?.message ?? "");
    }
    update();
  }

  GlobalKey<FormState> verfiyLockKey = GlobalKey<FormState>();
  TextEditingController verfiyLockPinController = TextEditingController();

  Future<void> postVerifyPin() async {
    var response = await chatPresenter.postVerifyPinLock(
      pin: verfiyLockPinController.text,
      isLoading: false,
    );
    if (response?.status == 200) {
      RouteManagement.goToChatLockScreen();
    } else {
      Utility.errorMessage(response?.message ?? "");
    }
    update();
  }

  Future<void> postForgotPinLock() async {
    var response = await chatPresenter.postForgotPinLock(
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      RouteManagement.goToChangeLockForgotPinScreen();
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  TextEditingController serchChatLockController = TextEditingController();

  PagingController<int, FriendsListDatum> chatLockPagingController =
      PagingController(firstPageKey: 1);

  List<FriendsListDatum> chatLockFriendList = [];

  int chatLockLimit = 10;

  Future<void> postChatLockFriends(pageKey) async {
    var response = await chatPresenter.postChatLockFriends(
      page: pageKey,
      limit: chatLockLimit,
      search: serchChatLockController.text,
      unreadMessages: isUnread,
      contactFriend: isContectList,
      fefieldFriend: isFefildFriend,
      receiverFriend: isReceveFriend,
      senderFriend: isSendFriend,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        chatLockFriendList.clear();
      }
      chatLockFriendList = response.data;
      for (var data in chatLockFriendList) {
        data.isOnline = Utility.onlineOfflineUserList
            .any((element) => element == data.channelID);
      }
      final isLastPage = chatLockFriendList.length < chatLockLimit;
      if (isLastPage) {
        chatLockPagingController.appendLastPage(chatLockFriendList);
      } else {
        var nextPageKey = pageKey + 1;
        chatLockPagingController.appendPage(chatLockFriendList, nextPageKey);
      }
      update();
    }
  }

  GlobalKey<FormState> changeLockKey = GlobalKey<FormState>();
  TextEditingController changeOldPinController = TextEditingController();
  TextEditingController changeNewPinController = TextEditingController();
  TextEditingController changeConfirmPinController = TextEditingController();

  Future<void> postChangePinLock() async {
    var response = await chatPresenter.postChangePinLock(
      oldpin: changeOldPinController.text,
      newpin: changeNewPinController.text,
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      Get.back();
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  TextEditingController groupLockSearchController = TextEditingController();

  PagingController<int, GroupFriendData> groupLockPagingController =
      PagingController(firstPageKey: 1);

  List<GroupFriendData> groupLockLists = [];

  bool isUnreadMessage = false;

  Future<void> groupsUserChatList(pageKey) async {
    var response = await chatPresenter.groupsUserChatList(
      page: pageKey,
      limit: 10,
      search: groupLockSearchController.text,
      isunreadmessagefilteronoff: isUnreadMessage,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        groupLockLists.clear();
      }
      groupLockLists = response.data ?? [];

      final isLastPage = groupLockLists.length < 10;
      if (isLastPage) {
        groupLockPagingController.appendLastPage(groupLockLists);
      } else {
        var nextPageKey = pageKey + 1;
        groupLockPagingController.appendPage(groupLockLists, nextPageKey);
      }
      update();
    }
  }

  Future<void> postUnLockChat(FriendsListDatum itemData) async {
    var response = await chatPresenter.postUnLockChat(
      friendrequestids: [itemData.friendrequestid ?? ""],
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      chatLockPagingController.itemList!.remove(itemData);
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  Future<void> postUnLockGroup(GroupFriendData itemData) async {
    var response = await chatPresenter.postUnLockGroup(
      groupids: [itemData.id ?? ""],
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      groupLockPagingController.itemList!.remove(itemData);
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  Future<void> postChatHide(FriendsListDatum itemData) async {
    var response = await chatPresenter.postChatHide(
      friendrequestids: [itemData.friendrequestid ?? ""],
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      chatLockPagingController.itemList!.remove(itemData);
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  Future<void> postGroupChatHide(GroupFriendData itemData) async {
    var response = await chatPresenter.postGroupChatHide(
      groupids: [itemData.id ?? ""],
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      groupLockPagingController.itemList!.remove(itemData);
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  GlobalKey<FormState> forgotLockKey = GlobalKey<FormState>();
  TextEditingController forgotOtpPinController = TextEditingController();
  TextEditingController forgotNewPinController = TextEditingController();
  TextEditingController forgotConfirmPinController = TextEditingController();

  Future<void> postChatLockVerifyOtp() async {
    var response = await chatPresenter.postChatLockVerifyOtp(
      otp: int.parse(forgotOtpPinController.text),
      pin: int.parse(forgotNewPinController.text),
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      Get.back();
      Get.back();
    } else {
      Utility.errorMessage(
          jsonDecode(response?.data.toString() ?? "")['Message']);
    }
    update();
  }

  Future<void> postClearIndividualChats(String userId) async {
    var response = await chatPresenter.postClearIndividualChats(
      userid: userId,
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      await getChatLists(1, userId);

      // Utility.snacBar(jsonDecode(response?.data.toString() ?? "")['Message'],
      //     ColorsValue.appColor);
      Get.back();
    } else {
      Utility.errorMessage(
          jsonDecode(response?.data.toString() ?? "")['Message']);
    }
    update();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///================================================= Favorite Message Screen ===============================================///

  List<ChatListsDoc> chatFavoriteList = [];
  int pagFavoriteCount = 1;
  bool isFavoriteLastPage = false;
  bool isFavoriteLoading = false;

  final ScrollController scrollFavoriteController = ScrollController();

  Future<void> listFavoriteMessage(int pageKey) async {
    if (pageKey == 1) {
      pagFavoriteCount = 1;
    }
    var response = await chatPresenter.listFavoriteMessage(
      userid: userId ?? "",
      page: pagFavoriteCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isFavoriteLastPage = false;
        chatFavoriteList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isFavoriteLastPage = true;
        chatFavoriteList.addAll(response.data.docs ?? []);
      } else {
        pagFavoriteCount++;
        chatFavoriteList.addAll(response.data.docs ?? []);
      }
      if (pageKey == 1) {
        if (scrollFavoriteController.positions.isNotEmpty) {
          scrollFavoriteController.jumpTo(0);
        }
      }
    }
    update();
  }

  ///================================================= Chat Bookmark Message Message Screen ===============================================///

  List<ChatListsDoc> chatBookmarkList = [];
  int pagBookmarkCount = 1;
  bool isBookmarkLastPage = false;
  bool isBookmarkLoading = false;

  final ScrollController scrollBookmarkController = ScrollController();

  Future<void> listChatBookmarkMessage(int pageKey) async {
    if (pageKey == 1) {
      pagBookmarkCount = 1;
    }
    var response = await chatPresenter.listChatBookmarkMessage(
      page: pagBookmarkCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isBookmarkLastPage = false;
        chatBookmarkList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isBookmarkLastPage = true;
        chatBookmarkList.addAll(response.data.docs ?? []);
      } else {
        pagBookmarkCount++;
        chatBookmarkList.addAll(response.data.docs ?? []);
      }
      if (pageKey == 1) {
        if (scrollBookmarkController.positions.isNotEmpty) {
          scrollBookmarkController.jumpTo(0);
        }
      }
    }
    update();
  }

  ///================================================= Group Favorite Message Screen ===============================================///

  List<ChatListsDoc> chatGroupFavoriteList = [];
  int pageGroupFavoriteCount = 1;
  bool isGroupFavoriteLastPage = false;
  bool isGroupFavoriteLoading = false;

  final ScrollController scrollGroupFavoriteController = ScrollController();

  Future<void> listGroupFavoriteMessage(int pageKey) async {
    if (pageKey == 1) {
      pageGroupFavoriteCount = 1;
    }
    var response = await chatPresenter.listGroupFavoriteMessage(
      groupid: groupId ?? "",
      page: pageGroupFavoriteCount,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        isGroupFavoriteLastPage = false;
        chatGroupFavoriteList.clear();
      }

      if ((response.data.docs?.length ?? 0) < 10) {
        isGroupFavoriteLastPage = true;
        chatGroupFavoriteList.addAll(response.data.docs ?? []);
      } else {
        pageGroupFavoriteCount++;
        chatGroupFavoriteList.addAll(response.data.docs ?? []);
      }
      if (pageKey == 1) {
        if (scrollGroupFavoriteController.positions.isNotEmpty) {
          scrollGroupFavoriteController.jumpTo(0);
        }
      }
    }
    update();
  }

  ///================================================= Brodcast Favorite Message Screen ===============================================///

  final ScrollController scrollBrodcastFavoriteController = ScrollController();

  List<ChatListsDoc> brodcastFavoriteList = [];

  ChatListsDoc? chatBrodcastFavoriteListsDoc = ChatListsDoc();

  int pageBrodcastFavoriteCount = 1;

  bool isBrodcastFavoriteLastPage = false;
  bool isBrodcastFavoriteLoading = false;

  String? broadcastFavoriteid = "";

  Future<void> postListFavoriteMessages(pageKey) async {
    var response = await chatPresenter.postListFavoriteMessages(
      broadcastid: broadcastid ?? "",
      page: 1,
      limit: 10,
      isLoading: true,
    );
    if (response != null) {
      if (pageKey == 1) {
        isBrodcastLastPage = false;
        brodcastFavoriteList.clear();
      }
      if ((response.data.docs?.length ?? 0) < 10) {
        isBrodcastLastPage = true;
        brodcastFavoriteList.addAll(response.data.docs ?? []);
      } else {
        pageBrodcastCount++;
        brodcastFavoriteList.addAll(response.data.docs ?? []);
      }
      if (pageKey == 1) {
        if (scrollBrodcastController.positions.isNotEmpty) {
          scrollBrodcastController.jumpTo(0);
        }
      }
    }
    update();
  }

  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////

  GlobalKey<FormState> sendRequestKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();

  Future<void> sendNewFriendRequest(String receiverid, String message,
      int index, bool isView, bool isGroup) async {
    var response = await chatPresenter.sendNewFriendRequest(
      receiverid: receiverid,
      message: message,
      product: "",
      authorizedPermissions: authorizedPermissions,
    );
    if (response?.data != null) {
      if (isGroup) {
        messageController.clear();
        chatGroupMessageList[index].content?.contact[0].isfriend = "sent";
        chatGroupMessageList[index].content?.contact[0].friendrequestid =
            response?.data?.id;
      } else if (isView) {
        messageController.clear();
        getContactList[index].isfriend = "sent";
        getContactList[index].friendrequestid = response?.data?.id;
      } else {
        messageController.clear();
        chatMessageList[index].content?.contact[0].isfriend = "sent";
        chatMessageList[index].content?.contact[0].friendrequestid =
            response?.data?.id;
      }

      update();
    }
    update();
  }

  Future<void> cancelSentRequest(
      String friendrequestid, index, isView, bool isGroup) async {
    var response = await chatPresenter.cancelSentRequest(
      friendrequestid: friendrequestid,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      if (isGroup) {
        messageController.clear();
        chatGroupMessageList[index].content?.contact[0].isfriend = "no";
      } else if (isView) {
        getContactList[index].isfriend = "no";
      } else {
        chatMessageList[index].content?.contact[0].isfriend = "no";
      }
      Utility.snacBar(
          "Friend request cancle successfully...", ColorsValue.maincolor1);
    }
    update();
  }

  Future<void> sendNewFriendFavoriteRequest(String receiverid, String message,
      int index, bool isGroup, bool isBookmark) async {
    var response = await chatPresenter.sendNewFriendRequest(
      receiverid: receiverid,
      message: message,
      product: "",
      authorizedPermissions: authorizedPermissions,
    );
    if (response?.data != null) {
      if (isBookmark) {
        messageController.clear();
        bookmarkList[index].content?.contact[0].isfriend = "sent";
        bookmarkList[index].content?.contact[0].friendrequestid =
            response?.data?.id;
      } else if (isGroup) {
        messageController.clear();
        chatGroupFavoriteList[index].content?.contact[0].isfriend = "sent";
        chatGroupFavoriteList[index].content?.contact[0].friendrequestid =
            response?.data?.id;
      } else {
        messageController.clear();
        chatFavoriteList[index].content?.contact[0].isfriend = "sent";
        chatFavoriteList[index].content?.contact[0].friendrequestid =
            response?.data?.id;
      }
    }
    update();
  }

  Future<void> cancelSentFavoriteRequest(
      String friendrequestid, index, bool isGroup, bool isBookmark) async {
    var response = await chatPresenter.cancelSentRequest(
      friendrequestid: friendrequestid,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      if (isBookmark) {
        messageController.clear();
        bookmarkList[index].content?.contact[0].isfriend = "no";
      } else if (isGroup) {
        chatGroupFavoriteList[index].content?.contact[0].isfriend = "no";
      } else {
        chatFavoriteList[index].content?.contact[0].isfriend = "no";
      }
      Utility.snacBar(
          "Friend request cancle successfully...", ColorsValue.maincolor1);
    }
    update();
  }

  Future<void> postUnFriend(String friendrequestid) async {
    var response = await chatPresenter.postUnFriend(
      friendrequestid: friendrequestid,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      RouteManagement.goToHomeScreenView();
    } else {
      Utility.errorMessage(jsonDecode(response.data.toString())['Message']);
    }
    update();
  }

  List<ChatListsDoc> bookmarkUserList = [];

  int pageUserBookmarkCount = 1;
  bool isUserbookmarkLastPage = false;
  bool isUserBookmarksLoading = false;

  final ScrollController bookmarkUserController = ScrollController();

  Future<void> postIndiviualBookmark(pageKey, userId) async {
    if (pageKey == 1) {
      pageUserBookmarkCount = 1;
    }
    var response = await chatPresenter.postIndiviualBookmark(
      userid: userId,
      page: pageUserBookmarkCount,
      limit: 10,
      isLoading: false,
    );
    if (response?.data != null) {
      if (pageKey == 1) {
        isUserbookmarkLastPage = false;
        bookmarkUserList.clear();
      }

      if ((response?.data?.docs?.length ?? 0) < 10) {
        isUserbookmarkLastPage = true;
        bookmarkUserList.addAll(response?.data?.docs ?? []);
      } else {
        pageUserBookmarkCount++;
        bookmarkUserList.addAll(response?.data?.docs ?? []);
      }
      if (pageKey == 1) {
        if (bookmarkUserController.positions.isNotEmpty) {
          bookmarkUserController.jumpTo(0);
        }
      }
    }
    update();
  }
}

class QuestionModel {
  TextEditingController? textController;

  QuestionModel({required this.textController});
}

class AudioModel {
  bool? isSelect = false;

  AudioModel({
    this.isSelect,
  });
}

class MediaModel {
  String? url;
  bool? isVideo;

  MediaModel({
    required this.url,
    required this.isVideo,
  });
}

class UserMediaModel {
  String? url;
  int? timestemp;
  bool? isVideo;

  UserMediaModel({
    required this.url,
    required this.timestemp,
    required this.isVideo,
  });
}
