import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
      initState: (state) {},
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Padding(
              padding: Dimens.edgeInsets20_0_20_0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    controller: controller.searchCallController,
                    hintText: 'search'.tr,
                    fillColor: ColorsValue.textfildbackcolor,
                    suffixIcon: Icon(
                      Icons.search,
                      size: Dimens.twentyFour,
                      color: ColorsValue.hookupHeaderGreyColor,
                    ),
                  ),
                  Dimens.boxHeight20,
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () => Future.sync(
                        () => controller.chatHsitoryPagingController.refresh(),
                      ),
                      color: ColorsValue.appColor,
                      child: PagedListView<int, CallHistoryDoc>(
                        pagingController: controller.chatHsitoryPagingController,
                        builderDelegate: PagedChildBuilderDelegate(
                          noItemsFoundIndicatorBuilder: (_) {
                            return Center(
                              child: SvgPicture.asset(
                                AssetConstants.ic_call_history_empty,
                              ),
                            );
                          },
                          itemBuilder: (context, item, index) {
                            final String currentUserId =
                                Get.find<Repository>().getStringValue(
                              LocalKeys.userIds,
                            );
                            final _CallInfoTarget callInfoTarget =
                                _resolveCallInfoTarget(item, currentUserId);

                            return InkWell(
                              onTap: () {
                                if (callInfoTarget.id.isEmpty) return;
                                RouteManagement.goToCallInfoScreen(
                                  callInfoTarget.id,
                                  callInfoTarget.isGroup,
                                );
                              },
                              child: ListTile(
                                contentPadding: Dimens.edgeInsets0,
                                leading: _buildCallAvatar(item, currentUserId),
                                title: Text(
                                  _callDisplayName(item, currentUserId),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.black50016,
                                ),
                                subtitle: Padding(
                                  padding: Dimens.edgeInsetsTopt05,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        _isOutgoing(item, currentUserId)
                                            ? AssetConstants.ic_outcoming_call
                                            : AssetConstants.ic_incoming_call,
                                      ),
                                      Dimens.boxWidth10,
                                      Text(
                                        Utility.dateTimeTodayWithDate(
                                          item.timestamp,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ],
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await _redialCall(
                                          context,
                                          item,
                                          currentUserId,
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        item.isvideocall ?? false
                                            ? AssetConstants.videoIcon
                                            : AssetConstants.audioIcon,
                                        colorFilter: const ColorFilter.mode(
                                          ColorsValue.maincolor1,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ),
                                    Dimens.boxWidth20,
                                    InkWell(
                                      onTap: () {
                                        controller.postDeleteCall(
                                          item.id ?? "",
                                          index,
                                        );
                                      },
                                      child: SvgPicture.asset(
                                        AssetConstants.cancleicon,
                                        height: Dimens.sixteen,
                                        width: Dimens.sixteen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _redialCall(
    BuildContext context,
    CallHistoryDoc item,
    String currentUserId,
  ) async {
    final bool isVideoCall = item.isvideocall ?? false;
    final String groupId = item.togroup?.id ?? "";

    if (groupId.isNotEmpty) {
      if (isVideoCall) {
        if (await Utility.cameraPermissionCheack(context) &&
            await Utility.microphonePermissionCheack(context)) {
          Get.find<ChatController>().postGroupCallInitaite(
            isLoading: true,
            receiverId: groupId,
            isAudioCall: false,
            isVideoCall: true,
            isGroupCall: true,
          );
        }
      } else {
        if (await Utility.microphonePermissionCheack(context)) {
          Get.find<ChatController>().postGroupCallInitaite(
            isLoading: true,
            receiverId: groupId,
            isAudioCall: true,
            isGroupCall: true,
            isVideoCall: false,
          );
        }
      }
      return;
    }

    final String peerUserId = _resolvePeerUserId(item, currentUserId);
    if (peerUserId.isEmpty) return;

    if (isVideoCall) {
      if (await Utility.cameraPermissionCheack(context) &&
          await Utility.microphonePermissionCheack(context)) {
        Get.find<ChatController>().postCallInitaite(
          isLoading: true,
          receiverId: peerUserId,
          isAudioCall: false,
          isGroupCall: false,
          isVideoCall: true,
        );
      }
    } else {
      if (await Utility.microphonePermissionCheack(context)) {
        Get.find<ChatController>().postCallInitaite(
          isLoading: true,
          receiverId: peerUserId,
          isAudioCall: true,
          isGroupCall: false,
          isVideoCall: false,
        );
      }
    }
  }

  _CallInfoTarget _resolveCallInfoTarget(
    CallHistoryDoc item,
    String currentUserId,
  ) {
    final String groupId = item.togroup?.id ?? "";
    if (groupId.isNotEmpty) {
      return _CallInfoTarget(
        id: groupId,
        isGroup: true,
      );
    }

    return _CallInfoTarget(
      id: _resolvePeerUserId(item, currentUserId),
      isGroup: false,
    );
  }

  String _resolvePeerUserId(
    CallHistoryDoc item,
    String currentUserId,
  ) {
    final String fromId = item.from?.id ?? "";
    final String toUserId = item.touser?.id ?? "";

    if (fromId == currentUserId && toUserId.isNotEmpty) return toUserId;
    if (fromId.isNotEmpty && fromId != currentUserId) return fromId;
    if (toUserId.isNotEmpty && toUserId != currentUserId) return toUserId;

    final List<ChatListsFrom> others = _otherMemberUsers(item, currentUserId);
    if (others.isNotEmpty) return others.first.id ?? "";

    return "";
  }

  Widget _buildCallAvatar(
    CallHistoryDoc item,
    String currentUserId,
  ) {
    final bool isGroupCall = item.isgroupcall ?? false;
    final int membersLength = item.members?.length ?? 0;

    if (!isGroupCall && membersLength <= 2) {
      final ChatListsFrom? otherParty = _otherParty(item, currentUserId);
      return _singleAvatar(otherParty?.profileimage ?? "");
    }

    final String groupImage = item.togroup?.profileimage ?? "";
    if (isGroupCall && groupImage.isNotEmpty) {
      return _singleAvatar(groupImage);
    }

    final List<ChatListsFrom> others = _otherMemberUsers(item, currentUserId);
    if (others.isEmpty) {
      final ChatListsFrom? otherParty = _otherParty(item, currentUserId);
      return _singleAvatar(otherParty?.profileimage ?? "");
    }

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
                ),
                errorWidget: (context, url, error) => Image.asset(
                  AssetConstants.usera,
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

  String _callDisplayName(
    CallHistoryDoc item,
    String currentUserId,
  ) {
    if ((item.members?.length ?? 0) > 2) {
      return "conference_call".tr;
    }

    if (item.isgroupcall ?? false) {
      final String groupName = (item.togroup?.name ?? "").trim();
      if (groupName.isNotEmpty) return groupName;

      final List<ChatListsFrom> others = _otherMemberUsers(item, currentUserId);
      if (others.isNotEmpty) return _displayName(others.first);

      return "Unknown Group";
    }

    return _displayName(_otherParty(item, currentUserId));
  }

  bool _isOutgoing(CallHistoryDoc item, String currentUserId) {
    return (item.from?.id ?? item.initiatedby?.id ?? "") == currentUserId;
  }

  List<ChatListsFrom> _otherMemberUsers(
    CallHistoryDoc item,
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

  ChatListsFrom? _otherParty(CallHistoryDoc item, String currentUserId) {
    final String fromId = item.from?.id ?? "";
    final String toUserId = item.touser?.id ?? "";

    if (fromId == currentUserId) return item.touser;
    if (fromId.isNotEmpty && fromId != currentUserId) return item.from;
    if (toUserId.isNotEmpty && toUserId != currentUserId) return item.touser;

    return item.from ?? item.touser;
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

class _CallInfoTarget {
  final String id;
  final bool isGroup;

  const _CallInfoTarget({
    required this.id,
    required this.isGroup,
  });
}
