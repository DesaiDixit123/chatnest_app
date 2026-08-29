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

    if (displayName.isEmpty || displayName == "User") {
      if (controller.pendingInvitees.isNotEmpty) {
        final pending = controller.pendingInvitees.first;
        if (pending.name.isNotEmpty && pending.name != "User") {
          displayName = pending.name;
        }
      }
    }

    if (displayName.isEmpty || displayName == "User") {
      final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
      controller.callMembersMap.forEach((key, val) {
        if (key != currentUserId && (displayName.isEmpty || displayName == "User")) {
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
        } else if (displayName.isEmpty || displayName == "User" || displayImg.isEmpty) {
          String? memberUserId;
          // 1. Try exact UID match
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

          // 2. Try unmatched remote members in callMembersMap
          if (displayName.isEmpty || displayName == "User") {
            final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
            for (var entry in controller.callMembersMap.entries) {
              if (entry.key != currentUserId) {
                final candName = (entry.value['name'] ?? entry.value['mobile'] ?? "").toString().trim();
                if (candName.isNotEmpty && candName != "User") {
                  displayName = candName;
                  if (displayImg.isEmpty) {
                    displayImg = (entry.value['image'] ?? "").toString().trim();
                  }
                  memberUserId = entry.key;
                  break;
                }
              }
            }
          }

          // 3. Try pendingInvitees
          if (displayName.isEmpty || displayName == "User") {
            if (controller.pendingInvitees.isNotEmpty) {
              displayName = controller.pendingInvitees.first.name;
              memberUserId = controller.pendingInvitees.first.userId;
            }
          }

          // 4. Resolve via Utility.resolveUserDisplay
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
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          displayImg.isNotEmpty
                              ? NetworkImage("${ApiWrapper.imageUrl}$displayImg")
                              : const AssetImage(AssetConstants.usera) as ImageProvider,
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
    // We no longer disposeAgora here to keep it active in background
    Get.find<CallManagerService>().minimizeCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          Get.find<CallManagerService>().minimizeCall();
        }
      },
      child: GetBuilder<AudioCallController>(initState: (state) async {
      var controller = Get.find<AudioCallController>();
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
        controller.initialize();
      }
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: Colors.black,
        //   surfaceTintColor: Colors.black,
        //   centerTitle: false,
        //   title: Row(
        //     children: [
        //       const Icon(
        //         Icons.meeting_room_rounded,
        //         color: Colors.white54,
        //       ),
        //       const SizedBox(width: 6.0),
        //       const Text(
        //         'Channel name: ',
        //         style: TextStyle(
        //           color: Colors.white54,
        //           fontSize: 16.0,
        //         ),
        //       ),
        //     ],
        //   ),
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.only(right: 8.0),
        //       child: Row(
        //         mainAxisSize: MainAxisSize.min,
        //         children: [
        //           const Icon(
        //             Icons.people_alt_rounded,
        //             color: Colors.white54,
        //           ),
        //           const SizedBox(width: 6.0),
        //           Text(
        //             controller.users.length.toString(),
        //             style: const TextStyle(
        //               color: Colors.white54,
        //               fontSize: 16.0,
        //             ),
        //           ),
        //         ],
        //       ),
        //     )
        //   ],
        // ),
        body: SafeArea(
          child: Column(
            children: [
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
