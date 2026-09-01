import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/models/agora_user_model.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AudioCallScreen extends StatefulWidget {
  const AudioCallScreen({
    super.key,
  });

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  bool _showGroupLayout(AudioCallController controller) {
    final remoteCount =
        controller.users.where((user) => user.uid != controller.currentUid).length;
    return remoteCount > 1;
  }

  AgoraUser? _remoteUser(AudioCallController controller) {
    for (final user in controller.users) {
      if (user.uid != controller.currentUid) {
        return user;
      }
    }
    return null;
  }

  Widget _buildOneToOneCallView(
    BuildContext context,
    AudioCallController controller,
  ) {
    final remoteUser = _remoteUser(controller);
    String imagePath = (remoteUser?.bannerImg?.isNotEmpty ?? false)
        ? remoteUser!.bannerImg!
        : (controller.userImage ?? "");
    final remoteName = remoteUser?.name?.trim() ?? "";
    String displayName = remoteName.isNotEmpty && remoteName != "User"
        ? remoteName
        : controller.userName;

    String? targetUserId;
    if (remoteUser != null) {
      controller.callMembersMap.forEach((k, v) {
        if (v['uid'] == remoteUser.uid.toString()) {
          targetUserId = k;
        }
      });
    }

    if (displayName.isEmpty || displayName == "User") {
      if (controller.pendingInvitees.isNotEmpty) {
        final pending = controller.pendingInvitees.first;
        targetUserId ??= pending.userId;
        if (pending.name.isNotEmpty && pending.name != "User") {
          displayName = pending.name;
        }
      }
    }

    final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
    if (displayName.isEmpty || displayName == "User") {
      controller.callMembersMap.forEach((key, val) {
        if (key != currentUserId && (displayName.isEmpty || displayName == "User")) {
          targetUserId ??= key;
          final mName = (val['name'] ?? "").toString().trim();
          final mMobile = (val['mobile'] ?? "").toString().trim();
          if (mName.isNotEmpty && mName != "User") {
            displayName = mName;
          } else if (mMobile.isNotEmpty) {
            displayName = mMobile;
          }
          if (imagePath.isEmpty) {
            imagePath = (val['image'] ?? "").toString().trim();
          }
        }
      });
    }

    if (displayName.isEmpty || displayName == "User" || imagePath.isEmpty) {
      final res = Utility.resolveUserDisplay(
        userId: targetUserId,
        fullname: displayName == "User" ? null : displayName,
        profileimage: imagePath,
      );
      if (displayName.isEmpty || displayName == "User") {
        displayName = res['name'] ?? "User";
      }
      if (imagePath.isEmpty && res['image'] != null && res['image']!.isNotEmpty) {
        imagePath = res['image']!;
      }
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Dimens.hundredTwenty,
            width: Dimens.hundredTwenty,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Dimens.twoHundred,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                Dimens.twoHundred,
              ),
              child: imagePath.isNotEmpty
                  ? CachedNetworkImage(
                      height: Dimens.hundredTwenty,
                      width: Dimens.hundredTwenty,
                      imageUrl: ApiWrapper.imageUrl + imagePath,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Image.asset(
                          AssetConstants.usera,
                          fit: BoxFit.cover,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return Image.asset(
                          AssetConstants.usera,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                  : Image.asset(
                      AssetConstants.usera,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Dimens.boxHeight20,
          Text(
            displayName,
            style: Styles.black70018,
          ),
          const SizedBox(height: 6),
          Text(
            controller.callStatusText,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCallView(AudioCallController controller) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      itemCount: controller.users.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final user = controller.users.toList()[index];
        final bool isHost = controller.isSelfCall ?? false;
        final bool isMe = user.uid == controller.currentUid;

        String displayName = (user.name ?? "").trim();
        String displayImg = (user.bannerImg ?? "").trim();

        if (isMe) {
          final res = Utility.resolveUserDisplay(
            fullname: Utility.profileData?.fullname,
            nickname: Utility.profileData?.nickname,
            profileimage: Utility.profileData?.profileimage,
          );
          displayName = res['name'] ?? "You";
          if (displayName == "User") displayName = "You";
          displayImg = res['image'] ?? "";
        } else {
          if (displayName.isEmpty || displayName == "User" || displayImg.isEmpty) {
            String? memberUserId;
            controller.callMembersMap.forEach((k, v) {
              if (v['uid'] == user.uid.toString()) {
                memberUserId = k;
                if (displayName.isEmpty || displayName == "User") {
                  displayName = (v['name'] ?? v['mobile'] ?? "").toString().trim();
                }
                if (displayImg.isEmpty) {
                  displayImg = (v['image'] ?? "").toString().trim();
                }
              }
            });

            final res = Utility.resolveUserDisplay(
              userId: memberUserId,
              fullname: displayName == "User" ? null : displayName,
              profileimage: displayImg,
            );
            if (displayName.isEmpty || displayName == "User") {
              displayName = res['name'] ?? "User";
            }
            if (displayImg.isEmpty && res['image'] != null && res['image']!.isNotEmpty) {
              displayImg = res['image']!;
            }
          }
        }
        
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 80,
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: displayImg.isNotEmpty
                            ? CachedNetworkImage(
                                height: 80,
                                width: 80,
                                imageUrl: ApiWrapper.imageUrl + displayImg,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Image.asset(
                                  AssetConstants.usera,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) => Image.asset(
                                  AssetConstants.usera,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Image.asset(
                                AssetConstants.usera,
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      displayName.isEmpty ? "User" : displayName,
                      style: Styles.black70014,
                    ),
                  ],
                ),
              ),
              if (isHost && !isMe)
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () {
                      // Call kick method
                      // Get mapping from uid if necessary, or pass backend userid if the Agora uid is matched.
                      // Since we need backend memberId, we should look it up from callMembersMap or similar.
                      // Currently `user.uid` is the numeric Agora UID. 
                      // Wait, we need the actual user ID from the backend to kick them. Let's trace it.
                      // Using backend userid if mapped, otherwise it might just remove them from UI
                      // For now, the user ID might be passed differently, let's just trigger controller.postKickMember
                       String memberIdToKick = "";
                       controller.callMembersMap.forEach((key, value) {
                         if (value['uid'] == user.uid.toString()) {
                           memberIdToKick = key;
                         }
                       });
                       if (memberIdToKick.isNotEmpty) {
                          controller.postKickMember(memberIdToKick);
                       } else {
                          // Fallback or show error
                          Utility.showMessage("Cannot find user to kick", MessageType.error, () => null, '');
                       }
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    final controller = Get.isRegistered<AudioCallController>() ? Get.find<AudioCallController>() : null;
    if (controller == null || !controller.isCallEnded) {
      if (Get.isRegistered<CallManagerService>()) {
        Get.find<CallManagerService>().minimizeCall();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          final controller = Get.isRegistered<AudioCallController>() ? Get.find<AudioCallController>() : null;
          if (controller == null || !controller.isCallEnded) {
            if (Get.isRegistered<CallManagerService>()) {
              Get.find<CallManagerService>().minimizeCall();
            }
          }
        }
      },
      child: GetBuilder<AudioCallController>(initState: (state) async {
      var controller = Get.find<AudioCallController>();
      if (!controller.isInitialized) {
        if (await Utility.microphonePermissionCheack(context)) {
          controller.timer?.cancel();
          if (Get.arguments[3] ?? false) {
            controller.counter = 30;
            controller.startTimer();
          }
          controller.token = Get.arguments[1];
          controller.channelName = Get.arguments[0];
          controller.isMicEnabled = true;
          controller.isVideoEnabled = true;
          await controller.initialize();
        }
      } else {
        await controller.initialize();
      }
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 4.0, right: 8.0, bottom: 2.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.black87,
                          size: 22,
                        ),
                        onPressed: () {
                          Get.find<CallManagerService>().minimizeCall();
                          Get.back();
                        },
                      ),
                    ),
                    Center(
                      child: Text(
                        controller.callStatusText,
                        style: Styles.black70018.copyWith(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              if (controller.pendingInvitees.isNotEmpty)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ColorsValue.textfildbackcolor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Calling participants",
                        style: Styles.black60014,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: controller.pendingInvitees
                            .map(
                              (e) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "${e.name} • ${e.status}",
                                  style: Styles.black50012,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: _showGroupLayout(controller)
                    ? _buildGroupCallView(controller)
                    : _buildOneToOneCallView(context, controller),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        controller.onCallEnd(context, controller);
                      },
                      child: Container(
                          height: Dimens.fifty,
                          width: Dimens.fifty,
                          decoration: BoxDecoration(
                            color: ColorsValue.redColor,
                            borderRadius: BorderRadius.circular(
                              Dimens.five,
                            ),
                          ),
                          child: Padding(
                            padding: Dimens.edgeInsets10,
                            child: SvgPicture.asset(
                              AssetConstants.ic_end_call,
                            ),
                          )),
                    ),
                    Dimens.boxWidth20,
                    InkWell(
                      onTap: () {
                        controller.onToggleAudio();
                      },
                      child: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          color: ColorsValue.textfildbackcolor,
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Padding(
                          padding: Dimens.edgeInsets12,
                          child: SvgPicture.asset(
                            controller.isMicEnabled
                                ? AssetConstants.ic_mic_on
                                : AssetConstants.ic_mic_off,
                          ),
                        ),
                      ),
                    ),
                    Dimens.boxWidth20,
                    InkWell(
                      onTap: () {
                        controller.switchSpeakerphone();
                      },
                      child: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          color: ColorsValue.textfildbackcolor,
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Padding(
                            padding: Dimens.edgeInsets12,
                            child: Icon(
                              controller.isSpeaker
                                  ? Icons.volume_off
                                  : Icons.volume_up_outlined,
                            )
                            // SvgPicture.asset(
                            //   controller.isSpeaker
                            //       ? AssetConstants.ic_mic_on
                            //       : AssetConstants.ic_mic_off,
                            // ),
                            ),
                      ),
                    ),
                    Dimens.boxWidth20,
                    InkWell(
                      onTap: () {
                        controller.showAddParticipantSheet(context);
                      },
                      child: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          color: ColorsValue.textfildbackcolor,
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Padding(
                          padding: Dimens.edgeInsets12,
                          child: Icon(Icons.person_add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }),
  );
}
}
