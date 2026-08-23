import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CallInfoScreen extends StatelessWidget {
  const CallInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments is List ? Get.arguments as List : <dynamic>[];
    final String targetId =
        args.isNotEmpty ? (args[0] ?? "").toString() : "";
    final bool isGroupHistory = args.length > 1 && args[1] == true;

    return GetBuilder<CallController>(
      initState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          var controller = Get.find<CallController>();
          if (isGroupHistory) {
            controller.postHistoryByGroup(targetId);
          } else {
            controller.postHistoryByUser(targetId);
          }
        });
      },
      builder: (controller) {
        final String currentUserId =
            Get.find<Repository>().getStringValue(LocalKeys.userIds);

        if (controller.isCallHistoryLoading) {
          return Scaffold(
            backgroundColor: ColorsValue.white,
            appBar: AppBar(
              shadowColor: ColorsValue.greyAAAAAA,
              backgroundColor: ColorsValue.white,
              elevation: Dimens.two,
              centerTitle: false,
              leading: InkWell(
                onTap: Get.back,
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
                'call_info'.tr,
                style: Styles.black70018,
              ),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (controller.callHistoryByUserList.isEmpty) {
          final String message = controller.callHistoryErrorMessage.isNotEmpty
              ? controller.callHistoryErrorMessage
              : "no_data_found".tr;

          return Scaffold(
            backgroundColor: ColorsValue.white,
            appBar: AppBar(
              shadowColor: ColorsValue.greyAAAAAA,
              backgroundColor: ColorsValue.white,
              elevation: Dimens.two,
              centerTitle: false,
              leading: InkWell(
                onTap: Get.back,
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
                'call_info'.tr,
                style: Styles.black70018,
              ),
            ),
            body: Center(
              child: Padding(
                padding: Dimens.edgeInsets20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 32,
                      color: ColorsValue.greyColor8888,
                    ),
                    Dimens.boxHeight10,
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: Styles.greyColor888840012,
                    ),
                    if (controller.callHistoryErrorMessage.isNotEmpty) ...[
                      Dimens.boxHeight10,
                      TextButton(
                        onPressed: () {
                          if (isGroupHistory) {
                            controller.postHistoryByGroup(targetId);
                          } else {
                            controller.postHistoryByUser(targetId);
                          }
                        },
                        child: Text("retry".tr),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }

        final CallHistoryByUserData headerItem =
            controller.callHistoryByUserList.first;
        final List<ChatListsFrom> otherMembers =
            _otherMembers(headerItem, currentUserId);
        final String headerSubtitle =
            _headerSubtitle(headerItem, currentUserId);
        final String receiverId = targetId.isNotEmpty
            ? targetId
            : _resolveTopReceiverId(
                headerItem,
                currentUserId,
                isGroupHistory,
              );

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
              'call_info'.tr,
              style: Styles.black70018,
            ),
          ),
          body: Padding(
            padding: Dimens.edgeInsets20,
            child: Column(
              children: [
                ListTile(
                  contentPadding: Dimens.edgeInsets0,
                  leading: _buildHeaderAvatar(headerItem, currentUserId),
                  title: Text(
                    _participantTitle(headerItem, currentUserId),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.black50016,
                  ),
                  subtitle: headerSubtitle.isNotEmpty
                      ? Padding(
                          padding: Dimens.edgeInsetsTopt05,
                          child: Text(
                            headerSubtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Styles.greyColor888840012,
                          ),
                        )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (receiverId.isEmpty) return;
                          if (await Utility.cameraPermissionCheack(context) &&
                              await Utility.microphonePermissionCheack(context)) {
                            Get.find<ChatController>().postCallInitaite(
                              isLoading: true,
                              receiverId: receiverId,
                              isAudioCall: false,
                              isGroupCall: isGroupHistory,
                              isVideoCall: true,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          AssetConstants.videoIcon,
                          colorFilter: const ColorFilter.mode(
                            ColorsValue.maincolor1,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Dimens.boxWidth20,
                      InkWell(
                        onTap: () async {
                          if (receiverId.isEmpty) return;
                          if (await Utility.microphonePermissionCheack(context)) {
                            Get.find<ChatController>().postCallInitaite(
                              isLoading: true,
                              receiverId: receiverId,
                              isAudioCall: true,
                              isGroupCall: isGroupHistory,
                              isVideoCall: false,
                            );
                          }
                        },
                        child: SvgPicture.asset(
                          AssetConstants.ic_call,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: Dimens.one,
                  color: ColorsValue.textfildbackcolor,
                ),
                Dimens.boxHeight10,
                Expanded(
                  child: ListView(
                    children: [
                      ..._buildHistoryWidgets(
                        controller.callHistoryByUserList,
                        currentUserId,
                      ),
                      if (otherMembers.length > 1) ...[
                        Dimens.boxHeight10,
                        Text(
                          "${otherMembers.length} ${'people'.tr}",
                          style: Styles.black50016,
                        ),
                        Dimens.boxHeight8,
                        ...otherMembers.map(
                          (member) => ListTile(
                            contentPadding: Dimens.edgeInsets0,
                            leading: Container(
                              height: Dimens.fourty,
                              width: Dimens.fourty,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimens.hundred),
                                color: ColorsValue.textfildbackcolor,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.hundred),
                                child: (member.profileimage ?? "").isNotEmpty
                                    ? CachedNetworkImage(
                                        imageUrl:
                                            ApiWrapper.imageUrl + (member.profileimage ?? ""),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          AssetConstants.usera,
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          AssetConstants.usera,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Image.asset(
                                        AssetConstants.usera,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            title: Text(
                              _displayName(member),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.black50016,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if ((member.id ?? "").isEmpty) return;
                                    RouteManagement.goToChatScreen(
                                      member.id ?? "",
                                      false,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.message_outlined,
                                    color: ColorsValue.maincolor1,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _startIndividualCall(
                                      context,
                                      member.id ?? "",
                                      false,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.call_outlined,
                                    color: ColorsValue.maincolor1,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _startIndividualCall(
                                      context,
                                      member.id ?? "",
                                      true,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.videocam_outlined,
                                    color: ColorsValue.maincolor1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _startIndividualCall(
    BuildContext context,
    String receiverId,
    bool isVideoCall,
  ) async {
    if (receiverId.isEmpty) return;

    if (isVideoCall) {
      if (await Utility.cameraPermissionCheack(context) &&
          await Utility.microphonePermissionCheack(context)) {
        Get.find<ChatController>().postCallInitaite(
          isLoading: true,
          receiverId: receiverId,
          isAudioCall: false,
          isGroupCall: false,
          isVideoCall: true,
        );
      }
      return;
    }

    if (await Utility.microphonePermissionCheack(context)) {
      Get.find<ChatController>().postCallInitaite(
        isLoading: true,
        receiverId: receiverId,
        isAudioCall: true,
        isGroupCall: false,
        isVideoCall: false,
      );
    }
  }

  List<Widget> _buildHistoryWidgets(
    List<CallHistoryByUserData> history,
    String currentUserId,
  ) {
    final List<Widget> widgets = [];

    for (int i = 0; i < history.length; i++) {
      final CallHistoryByUserData item = history[i];
      final String dayLabel = _getDayString(item);
      final String prevDayLabel = i == 0 ? "" : _getDayString(history[i - 1]);
      final bool showDayHeader = i == 0 || dayLabel != prevDayLabel;

      if (showDayHeader && dayLabel.isNotEmpty) {
        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: Dimens.five),
            child: Text(
              dayLabel,
              style: Styles.greyColor888840012,
            ),
          ),
        );
      }

      final bool isOutgoing = _isOutgoing(item, currentUserId);
      final String callStatus = _checkCallStatus(item, currentUserId);
      final bool isMissed =
          callStatus == "Missed call" || callStatus == "No answer";
      final Color statusColor = isMissed ? Colors.red : Colors.green;
      final int callTimestamp = _callTimestamp(item);

      widgets.add(
        ListTile(
          contentPadding: Dimens.edgeInsets0,
          leading: SizedBox(
            width: 44,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 16,
                  top: 9,
                  child: Icon(
                    (item.isaudiocall ?? false)
                        ? Icons.call
                        : Icons.videocam_rounded,
                    size: 22,
                    color: statusColor,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 15,
                  child: Icon(
                    isOutgoing ? Icons.call_made : Icons.call_received,
                    size: 14,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  isOutgoing ? "outgoing".tr : "incoming".tr,
                  style: Styles.black50016,
                ),
              ),
              Dimens.boxWidth6,
              Flexible(
                child: Text(
                  callStatus.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.greyColor888840012.copyWith(
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: Dimens.edgeInsetsTopt05,
            child: Text(
              Utility.getTimeStempToTime(callTimestamp),
              style: Styles.greyColor888840012,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  String _resolveTopReceiverId(
    CallHistoryByUserData item,
    String currentUserId,
    bool isGroupHistory,
  ) {
    if (isGroupHistory) return item.togroup?.id ?? "";
    final ChatListsFrom? user = _otherParty(item, currentUserId);
    return user?.id ?? "";
  }

  Widget _buildHeaderAvatar(
    CallHistoryByUserData item,
    String currentUserId,
  ) {
    final bool isGroup = item.togroup != null;
    final int membersLength = item.members?.length ?? 0;

    if (!isGroup && membersLength <= 2) {
      final ChatListsFrom? otherParty = _otherParty(item, currentUserId);
      return _singleAvatar(otherParty?.profileimage ?? "");
    }

    final String groupImage = item.togroup?.profileimage ?? "";
    if (isGroup && groupImage.isNotEmpty) {
      return _singleAvatar(groupImage);
    }

    final List<ChatListsFrom> others = _otherMembers(item, currentUserId);
    if (others.isEmpty) return _singleAvatar("");

    return _compositeAvatar(others);
  }

  Widget _singleAvatar(String profileImage) {
    return Container(
      height: Dimens.fifty,
      width: Dimens.fifty,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.hundred),
        color: ColorsValue.maincolor1,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.hundred),
        child: profileImage.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: ApiWrapper.imageUrl + profileImage,
                fit: BoxFit.cover,
                maxHeightDiskCache: 90,
                maxWidthDiskCache: 90,
                width: Dimens.fifty,
                height: Dimens.fifty,
                placeholder: (context, url) => Image.asset(
                  AssetConstants.usera,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  AssetConstants.usera,
                  fit: BoxFit.cover,
                ),
              )
            : Image.asset(
                AssetConstants.usera,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  Widget _compositeAvatar(List<ChatListsFrom> members) {
    final List<ChatListsFrom> avatars = members.take(4).toList();

    return Container(
      height: Dimens.fifty,
      width: Dimens.fifty,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimens.hundred),
        color: ColorsValue.maincolor1,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimens.hundred),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(1),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 1,
          ),
          itemBuilder: (context, index) {
            if (index >= avatars.length) {
              return Container(
                color: ColorsValue.textfildbackcolor,
                child: Icon(
                  Icons.person,
                  size: 12,
                  color: ColorsValue.greyColor8888,
                ),
              );
            }

            final String image = avatars[index].profileimage ?? "";
            if (image.isEmpty) {
              return Container(
                color: ColorsValue.textfildbackcolor,
                child: Icon(
                  Icons.person,
                  size: 12,
                  color: ColorsValue.greyColor8888,
                ),
              );
            }

            return CachedNetworkImage(
              imageUrl: ApiWrapper.imageUrl + image,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: ColorsValue.textfildbackcolor,
              ),
              errorWidget: (context, url, error) => Container(
                color: ColorsValue.textfildbackcolor,
                child: Icon(
                  Icons.person,
                  size: 12,
                  color: ColorsValue.greyColor8888,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _headerSubtitle(CallHistoryByUserData item, String currentUserId) {
    final List<ChatListsFrom> others = _otherMembers(item, currentUserId);
    if (others.length > 1) {
      return "${others.length} ${'people'.tr}";
    }

    final ChatListsFrom? otherParty = _otherParty(item, currentUserId);
    final String phone =
        "${otherParty?.countryCode ?? ""} ${otherParty?.mobile ?? ""}".trim();
    return phone;
  }

  String _participantTitle(CallHistoryByUserData item, String currentUserId) {
    final List<ChatListsFrom> others = _otherMembers(item, currentUserId);
    if (others.isNotEmpty) {
      final List<String> names = others.map(_displayName).toList();
      if (names.length > 2) {
        return "${names[0]}, ${names[1]} & ${names.length - 2} others";
      }
      if (names.length == 2) {
        return "${names[0]} & ${names[1]}";
      }
      return names[0];
    }

    final String groupName = (item.togroup?.name ?? "").trim();
    if (groupName.isNotEmpty) return groupName;
    if (_isConference(item)) return "conference_call".tr;

    return _displayName(_otherParty(item, currentUserId));
  }

  List<ChatListsFrom> _otherMembers(
    CallHistoryByUserData item,
    String currentUserId,
  ) {
    final List<ChatListsFrom> result = [];
    final Set<String> seenIds = <String>{};

    for (final member in item.members ?? <CallHistoryMember>[]) {
      final ChatListsFrom? user = member.memberid;
      final String id = user?.id ?? "";
      if (id.isEmpty || id == currentUserId || seenIds.contains(id)) continue;
      seenIds.add(id);
      result.add(user!);
    }

    return result;
  }

  ChatListsFrom? _otherParty(CallHistoryByUserData item, String currentUserId) {
    final String fromId = item.from?.id ?? "";
    if (fromId == currentUserId) return item.touser;
    return item.from ?? item.touser;
  }

  bool _isConference(CallHistoryByUserData item) {
    return (item.members?.length ?? 0) > 2;
  }

  bool _isOutgoing(CallHistoryByUserData item, String currentUserId) {
    return (item.from?.id ?? "") == currentUserId ||
        (item.initiatedby?.id ?? "") == currentUserId;
  }

  int _callTimestamp(CallHistoryByUserData item) {
    if (item.createdAt != null) return item.createdAt!.millisecondsSinceEpoch;
    return item.timestamp ?? 0;
  }

  String _getDayString(CallHistoryByUserData item) {
    final int timestamp = _callTimestamp(item);
    if (timestamp == 0) return "";

    final DateTime now = DateTime.now();
    final DateTime callTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime callDay =
        DateTime(callTime.year, callTime.month, callTime.day);

    if (callDay == today) return "today".tr;
    if (callDay == today.subtract(const Duration(days: 1))) {
      return "yesterday".tr;
    }
    return Utility.parseTimeStamptoDDMMMMYY(timestamp);
  }

  String _checkCallStatus(CallHistoryByUserData item, String currentUserId) {
    final List<CallHistoryMember> members =
        item.members ?? <CallHistoryMember>[];

    CallHistoryMember? myMember;
    for (final member in members) {
      if ((member.memberid?.id ?? "") == currentUserId) {
        myMember = member;
        break;
      }
    }

    if (myMember != null) {
      if ((myMember.startedAt ?? 0) > 0) {
        final int startedAt = myMember.startedAt ?? 0;
        final int endedAt = (myMember.endedAt ?? 0) > 0
            ? (myMember.endedAt ?? 0)
            : DateTime.now().millisecondsSinceEpoch;
        return _formatDuration(startedAt, endedAt);
      }

      if (myMember.status == "ringing" || myMember.status == "disconnected") {
        return "Missed call";
      }

      return "No answer";
    }

    CallHistoryMember? connectedMember;
    for (final member in members) {
      if ((member.startedAt ?? 0) > 0) {
        connectedMember = member;
        break;
      }
    }

    if (connectedMember != null) {
      final int startedAt = connectedMember.startedAt ?? 0;
      final int endedAt = (connectedMember.endedAt ?? 0) > 0
          ? (connectedMember.endedAt ?? 0)
          : DateTime.now().millisecondsSinceEpoch;
      return _formatDuration(startedAt, endedAt);
    }

    final bool isMissed = members.any(
      (member) =>
          ((member.status == "ringing" || member.status == "disconnected") &&
              (member.startedAt ?? 0) == 0),
    );

    return isMissed ? "missed_call" : "no_answer";
  }

  String _formatDuration(int startedAt, int endedAt) {
    final int durationSeconds = ((endedAt - startedAt) / 1000).floor();
    if (durationSeconds <= 0) return "0s";

    final int hours = durationSeconds ~/ 3600;
    final int minutes = (durationSeconds % 3600) ~/ 60;
    final int seconds = durationSeconds % 60;

    final StringBuffer buffer = StringBuffer();
    if (hours > 0) buffer.write("${hours}h ");
    if (minutes > 0) buffer.write("${minutes}m ");
    if (seconds > 0 || buffer.isEmpty) buffer.write("${seconds}s");
    return buffer.toString().trim();
  }

  String _displayName(ChatListsFrom? user) {
    if (user == null) return "Unknown User";

    final String fullName = (user.fullname ?? "").trim();
    if (fullName.isNotEmpty) return fullName;

    final String nickName = (user.nickname ?? "").trim();
    if (nickName.isNotEmpty) return nickName;

    final String mobile = (user.mobile ?? "").trim();
    if (mobile.isNotEmpty) return mobile;

    return "Unknown User";
  }
}
