import 'dart:convert';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class MeetingController extends GetxController
    with GetSingleTickerProviderStateMixin {
  MeetingController(this.meetingPresenter);

  final MeetingPresenter meetingPresenter;

  late TabController meetingTabController;
  TextEditingController searchMeetingController = TextEditingController();
  TextEditingController searchMemberController = TextEditingController();
  TextEditingController searchHostMeetingController = TextEditingController();
  TextEditingController searchJoinMeetingController = TextEditingController();
  TextEditingController searchPastMeetingController = TextEditingController();

  @override
  void onInit() {
    // TODO: implement onInit
    meetingTabController = TabController(vsync: this, length: 3);
    meetingTabController.addListener(update);
    super.onInit();
  }

  DateTime? pickedStart;
  DateTime? pickedEnd;

  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String? selectValidStartDate = "";
  String? selectValidEndDate = "";
  String? selectValidStartTime = "";
  String? selectValidEndTime = "";

  TimeOfDay? startTimeOfDay;
  TimeOfDay? endTimeOfDay;

  GlobalKey<FormState> addMeetingKey = GlobalKey<FormState>();

  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  List<MyFriendDatum> allMemberList = [];
  List<MyFriendDatum> memberLists = [];
  List<MyFriendDatum> selectedMemberList = [];
  bool isLoadingMembers = false;

  Future<void> myFriendsWithoutPaginationList() async {
    isLoadingMembers = true;
    update();

    try {
      // 1. Ensure phone contacts are loaded into deviceContactsMap
      await Utility.loadDeviceContacts();

      // 2. Fetch friend list from backend
      var response = await meetingPresenter.myFriendsWithoutPaginationList(
        search: "",
        unreadMessages: false,
        contactFriend: true,
        fefieldFriend: true,
        receiverFriend: true,
        senderFriend: true,
        isLoading: false,
      );

      final currentUserId =
          Get.find<Repository>().getStringValue(LocalKeys.userIds);
      final List<MyFriendDatum> combined = [];
      final Set<String> seenUserIds = {};
      final Set<String> seenPhones = {};

      if (currentUserId.isNotEmpty) {
        seenUserIds.add(currentUserId);
      }

      if (response?.data?.list != null) {
        for (var f in response!.data!.list!) {
          final uid = f.userid ?? "";
          if (uid.isNotEmpty && !seenUserIds.contains(uid)) {
            seenUserIds.add(uid);
            final phoneNorm = Utility.normalizePhoneNumber(f.mobile);
            if (phoneNorm.isNotEmpty) {
              seenPhones.add(phoneNorm);
            }
            combined.add(f);
          }
        }
      }

      // 3. Load registered contacts from CallController
      if (Get.isRegistered<CallController>()) {
        final callCtrl = Get.find<CallController>();
        if (callCtrl.contactsList.isEmpty) {
          await callCtrl.fetchContacts();
          await callCtrl.postSyncContacts();
        }

        // Cache contact names into deviceContactsMap
        for (var contact in callCtrl.contactsList) {
          final phone = contact.contactNumber ??
              contact.mobile ??
              contact.chatNestUser?.mobile;
          final norm = Utility.normalizePhoneNumber(phone);
          final digits = (phone ?? "").replaceAll(RegExp(r'[^0-9]'), '');
          final name = contact.contactName ?? contact.name;
          if (name != null &&
              name.trim().isNotEmpty &&
              name != phone &&
              !RegExp(r'^[+0-9\s()-]+$').hasMatch(name)) {
            if (norm.isNotEmpty) Utility.deviceContactsMap[norm] = name.trim();
            if (digits.isNotEmpty) {
              Utility.deviceContactsMap[digits] = name.trim();
            }
          }

          if (contact.isChatNestUser == true) {
            final uid = contact.userid ?? contact.chatNestUser?.id ?? "";
            final isSeenUser = uid.isNotEmpty && seenUserIds.contains(uid);
            final isSeenPhone = norm.isNotEmpty && seenPhones.contains(norm);

            if (!isSeenUser && !isSeenPhone && uid.isNotEmpty) {
              seenUserIds.add(uid);
              if (norm.isNotEmpty) seenPhones.add(norm);

              combined.add(
                MyFriendDatum(
                  userid: uid,
                  fullname: name ?? contact.chatNestUser?.fullName ?? "",
                  nickname: name ?? contact.chatNestUser?.fullName ?? "",
                  mobile: phone ?? "",
                  profileimage: contact.chatNestUser?.profileImage ?? "",
                  countryCode: "",
                ),
              );
            }
          }
        }
      }

      // 4. Sort alphabetically by resolved contact display name
      combined.sort((a, b) {
        return a.displayName
            .toLowerCase()
            .compareTo(b.displayName.toLowerCase());
      });

      allMemberList = List.from(combined);

      // 5. Restore edit selection if in edit mode
      if (isEdit) {
        selectedMemberList.clear();
        for (var data in hostMeetingDoc?.members ?? <Member>[]) {
          var index =
              allMemberList.indexWhere((e) => e.userid == data.userid?.id);
          if (index.isNegative == false) {
            selectedMemberList.add(allMemberList[index]);
          }
        }
      }

      // 6. Apply filter
      filterMembers(searchMemberController.text);
    } catch (e) {
      debugPrint("❌ MeetingController.myFriendsWithoutPaginationList error: $e");
    } finally {
      isLoadingMembers = false;
      update();
    }
  }

  void filterMembers([String? query]) {
    final q = (query ?? searchMemberController.text).trim().toLowerCase();
    if (q.isEmpty) {
      memberLists = List.from(allMemberList);
    } else {
      final qDigits = q.replaceAll(RegExp(r'[^0-9]'), '');
      memberLists = allMemberList.where((m) {
        final name = m.displayName.toLowerCase();
        final rawFullname = (m.fullname ?? "").toLowerCase();
        final phone = (m.mobile ?? "").toLowerCase();
        final phoneDigits = phone.replaceAll(RegExp(r'[^0-9]'), '');

        final nameMatches = name.contains(q) || rawFullname.contains(q);
        final phoneMatches = phone.contains(q) ||
            (qDigits.isNotEmpty && phoneDigits.contains(qDigits));
        return nameMatches || phoneMatches;
      }).toList();
    }
    update();
  }

  Future<void> postSaveMetting() async {
    var response = await meetingPresenter.postSaveMetting(
      meetingId: meetingId.isEmpty ? "" : meetingId,
      title: titleController.text,
      description: desController.text,
      meetingstartdate: startDateController.text,
      meetingstarttime: selectValidStartTime ?? "",
      meetingenddate: endDateController.text,
      meetingendtime: selectValidEndTime ?? "",
      memberList: selectedMemberList.map((e) => e.userid ?? "").toList(),
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      final meetingData = jsonDecode(response!.data);
      final createdMeetingId = meetingData['Data']['_id'] ?? "";
      final meetingLink = "https://cochat.click/meeting/join/$createdMeetingId";

      if (isEdit) {
        postMeetingGetOne();
        Get.back();
        Get.back();
      } else {
        Get.back();
        Get.back();

        // Show success dialog for new creations
        Get.defaultDialog(
          title: "Session Scheduled",
          titleStyle: Styles.black70018,
          content: Column(
            children: [
              Text(
                "Share this link with others to join:",
                style: Styles.greyColor888840014,
                textAlign: TextAlign.center,
              ),
              Dimens.boxHeight10,
              Container(
                padding: Dimens.edgeInsets10,
                decoration: BoxDecoration(
                  color: ColorsValue.textfildbackcolor,
                  borderRadius: BorderRadius.circular(Dimens.five),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        meetingLink,
                        style: Styles.black50014,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Clipboard.setData(
                            ClipboardData(text: meetingLink));
                        Utility.errorMessage("Link copied to clipboard");
                      },
                      child: Icon(
                        Icons.copy,
                        color: ColorsValue.maincolor1,
                        size: Dimens.twenty,
                      ),
                    ),
                  ],
                ),
              ),
              Dimens.boxHeight20,
              CustomButton(
                text: "Share with Friends",
                height: Dimens.fifty,
                onTap: () {
                  Get.back(); // Close dialog
                  Get.toNamed(Routes.forwardMessageScreen,
                      arguments: meetingLink);
                },
              ),
              Dimens.boxHeight10,
              CustomButton(
                text: "Done",
                height: Dimens.fifty,
                onTap: () => Get.back(),
              ),
            ],
          ),
        );
      }
      hostPagingController.refresh();
      update();
    } else {
      Utility.errorMessage(jsonDecode(response.toString()));
    }
  }

  PagingController<int, HostMeetingDoc> hostPagingController =
      PagingController(firstPageKey: 1);

  List<HostMeetingDoc> hostMeetingList = [];

  Future<void> postMeetingHostingList(pageKey) async {
    var response = await meetingPresenter.postMeetingHostingList(
      page: pageKey,
      limit: 10,
      search: searchHostMeetingController.text,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        hostMeetingList.clear();
      }

      hostMeetingList = response.data?.docs ?? [];

      var lastPage = hostMeetingList.length < 10;
      if (lastPage) {
        hostPagingController.appendLastPage(hostMeetingList);
      } else {
        var nextKeys = pageKey + 1;
        hostPagingController.appendPage(hostMeetingList, nextKeys);
      }
      update();
    }
  }

  String meetingId = "";
  bool isEdit = false;
  String subTitle = "";
  HostMeetingDoc? hostMeetingDoc = HostMeetingDoc();
  bool? isBtnVisible = false;
  bool? isJoinBtnVisible = false;

  Future<void> postMeetingGetOne() async {
    var response = await meetingPresenter.postMeetingGetOne(
      meetingid: meetingId,
      isLoading: true,
    );
    hostMeetingDoc = null;
    if (response?.status == 200) {
      hostMeetingDoc = response?.data;

      var format = DateFormat("HH:mm");
      String formattedTime = DateFormat('HH:mm').format(DateTime.now());
      var one = format.parse(formattedTime);
      var two = format.parse(hostMeetingDoc?.meetingstarttime ?? "");
      if (two.difference(one).inMinutes < 10) {
        isBtnVisible = true;
      }
      update();
    }
  }

  PagingController<int, HostMeetingDoc> joinPagingController =
      PagingController(firstPageKey: 1);

  List<HostMeetingDoc> joinMeetingList = [];

  Future<void> postMeetingJoinList(pageKey) async {
    var response = await meetingPresenter.postMeetingJoinList(
      page: pageKey,
      limit: 10,
      search: searchJoinMeetingController.text,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        joinMeetingList.clear();
      }

      joinMeetingList = response.data?.docs ?? [];

      var lastPage = joinMeetingList.length < 10;
      if (lastPage) {
        joinPagingController.appendLastPage(joinMeetingList);
      } else {
        var nextKeys = pageKey + 1;
        joinPagingController.appendPage(joinMeetingList, nextKeys);
      }
      update();
    }
  }

  PagingController<int, HostMeetingDoc> pastPagingController =
      PagingController(firstPageKey: 1);

  List<HostMeetingDoc> pastMeetingList = [];

  bool _hasValidAgoraMeta(Agorameta? meta) {
    final token = (meta?.token ?? "").trim();
    final channelName = (meta?.channelName ?? "").trim();
    return token.isNotEmpty && channelName.isNotEmpty;
  }

  bool get hasActiveMeetingSession {
    final id =
        Get.find<Repository>().getStringValue(LocalKeys.lastActiveMeetingId);
    return id.isNotEmpty;
  }

  String get activeMeetingTitle {
    final title =
        Get.find<Repository>().getStringValue(LocalKeys.lastActiveMeetingTitle);
    return title.isNotEmpty ? title : "Ongoing Session";
  }

  void dismissActiveMeetingBanner() {
    final repo = Get.find<Repository>();
    repo.clearData(LocalKeys.lastActiveMeetingId);
    repo.clearData(LocalKeys.lastActiveMeetingTitle);
    repo.clearData(LocalKeys.lastActiveMeetingChannel);
    repo.clearData(LocalKeys.lastActiveMeetingToken);
    repo.clearData(LocalKeys.lastActiveMeetingIsHost);
    update();
  }

  Future<void> rejoinActiveMeetingSession() async {
    final repo = Get.find<Repository>();
    final meetingId = repo.getStringValue(LocalKeys.lastActiveMeetingId);
    final isHost =
        repo.getStringValue(LocalKeys.lastActiveMeetingIsHost) == "true";
    if (meetingId.isEmpty) return;

    if (isHost) {
      await postHostMeetingStart(meetingId);
    } else {
      await postMeetingJoin(meetingId);
    }
  }

  void _showMeetingNotStartedDialog() {
    dismissActiveMeetingBanner();
    Utility.showDialog(
      "Session not started yet or has already ended.",
    );
  }

  Future<void> postMeetingPastList(pageKey) async {
    var response = await meetingPresenter.postMeetingPastList(
      page: pageKey,
      limit: 10,
      search: searchPastMeetingController.text,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        pastMeetingList.clear();
      }

      pastMeetingList = response.data?.docs ?? [];

      var lastPage = pastMeetingList.length < 10;
      if (lastPage) {
        pastPagingController.appendLastPage(pastMeetingList);
      } else {
        var nextKeys = pageKey + 1;
        pastPagingController.appendPage(pastMeetingList, nextKeys);
      }
      update();
    }
  }

  Future<void> postHostMeetingStart(meetingId) async {
    var response = await meetingPresenter.postHostMeetingStart(
      meetingid: meetingId,
      isLoading: true,
    );
    if (response != null) {
      if (_hasValidAgoraMeta(response.data?.agorameta)) {
        RouteManagement.goToMeetingCallScreen(
            response.data?.agorameta?.channelName ?? "",
            response.data?.agorameta?.token ?? "",
            meetingId,
            true,
            true);
      } else {
        _showMeetingNotStartedDialog();
      }
    } else {
      dismissActiveMeetingBanner();
    }
    update();
  }

  Future<void> postMeetingJoin(meetingId) async {
    var response = await meetingPresenter.postMeetingJoin(
      meetingid: meetingId,
      isLoading: true,
    );
    if (response != null) {
      if (_hasValidAgoraMeta(response.data?.agorameta)) {
        RouteManagement.goToMeetingCallScreen(
            response.data?.agorameta?.channelName ?? "",
            response.data?.agorameta?.token ?? "",
            meetingId,
            true,
            false);
      } else {
        _showMeetingNotStartedDialog();
      }
    } else {
      dismissActiveMeetingBanner();
    }
    update();
  }

  Future<void> postStartInstantMeeting() async {
    // Auto-generate meeting times
    final now = DateTime.now();
    final endTime = now.add(const Duration(hours: 1));

    final startDate = DateFormat("dd-MM-yyyy").format(now);
    final startTime = DateFormat("HH:mm").format(now);
    final endDate = DateFormat("dd-MM-yyyy").format(endTime);
    final endTimeFormatted = DateFormat("HH:mm").format(endTime);

    // Create the meeting
    var saveResponse = await meetingPresenter.postSaveMetting(
      meetingId: "",
      title: titleController.text.trim().isEmpty
          ? "Instant Session"
          : titleController.text.trim(),
      description: desController.text.trim().isEmpty
          ? "Instant Session"
          : desController.text.trim(),
      meetingstartdate: startDate,
      meetingstarttime: startTime,
      meetingenddate: endDate,
      meetingendtime: endTimeFormatted,
      memberList: selectedMemberList.map((e) => e.userid ?? "").toList(),
      isLoading: true,
    );

    if (saveResponse?.statusCode == 200) {
      // Refresh the host meeting list immediately
      hostPagingController.refresh();

      // Extract meeting ID from response
      final meetingData = jsonDecode(saveResponse!.data);
      final createdMeetingId = meetingData['Data']['_id'] ?? "";

      // Immediately start the meeting so members receive the incoming meeting call!
      var startResponse = await meetingPresenter.postHostMeetingStart(
        meetingid: createdMeetingId,
        isLoading: true,
      );

      if (startResponse != null) {
        if (_hasValidAgoraMeta(startResponse.data?.agorameta)) {
          // Navigate to meeting call screen
          RouteManagement.goToMeetingCallScreen(
              startResponse.data?.agorameta?.channelName ?? "",
              startResponse.data?.agorameta?.token ?? "",
              createdMeetingId,
              true,
              true);

          // Refresh the host meeting list
          hostPagingController.refresh();
        } else {
          _showMeetingNotStartedDialog();
        }
      }
    } else {
      Utility.errorMessage(saveResponse?.data != null
          ? jsonDecode(saveResponse!.data)['Message'] ?? "Failed to create session"
          : "Failed to create session");
    }
    update();
  }

  Future<void> postMeetingCancle(meetingId) async {
    var response = await meetingPresenter.postMeetingCancle(
      meetingid: meetingId,
      isLoading: true,
    );
    if (response?.data != null) {
      Utility.showMessage(
          "Session cancelled successfully", MessageType.success, () => null, "OK");
      hostPagingController.refresh();
      joinPagingController.refresh();
      pastPagingController.refresh();
      Get.back();
    } else {
      Utility.errorMessage(
          jsonDecode(response?.data.toString() ?? "")['Message'] ?? "Failed to cancel session");
    }
    update();
  }
}
