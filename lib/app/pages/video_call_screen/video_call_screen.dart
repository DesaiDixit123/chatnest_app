import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({
    super.key,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  bool _showLocalAsMain = false;

  AgoraUser? _localUser(VideoCallController controller) {
    for (final user in controller.users) {
      if (user.uid == controller.currentUid) {
        return user;
      }
    }
    return null;
  }

  AgoraUser? _primaryRemoteUser(VideoCallController controller) {
    for (final user in controller.users) {
      if (user.uid != controller.currentUid) {
        return user;
      }
    }
    return null;
  }

  Widget _buildVideoSurface({
    required AgoraUser? user,
    required BorderRadius borderRadius,
    required bool showName,
  }) {
    final hasVideo = user?.isVideoEnabled ?? false;
    final imagePath = (user?.bannerImg ?? "").trim();

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasVideo && user?.view != null)
              user!.view!
            else
              Center(
                child: SizedBox(
                  height: 110,
                  width: 110,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: imagePath.isNotEmpty
                        ? CachedNetworkImage(
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
              ),
            if (showName) const SizedBox.shrink(),
          ],
        ),
      ),
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
      child: GetBuilder<VideoCallController>(initState: (state) async {
      var controller = Get.find<VideoCallController>();
      Future.delayed(Duration.zero, () async {
        if (await Utility.cameraPermissionCheack(context) &&
            // ignore: use_build_context_synchronously
            await Utility.microphonePermissionCheack(context)) {
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
      });
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final localUser = _localUser(controller);
                      final remoteUser = _primaryRemoteUser(controller);
                      final hasRemote = remoteUser != null;
                      final mainUser = hasRemote && !_showLocalAsMain
                          ? remoteUser
                          : localUser;
                      final pipUser = hasRemote && !_showLocalAsMain
                          ? localUser
                          : remoteUser;
                      String fallbackRemoteName = "User";
                      if (Get.arguments is List) {
                        final args = Get.arguments as List;
                        if (args.length > 5) {
                          fallbackRemoteName = (args[5] ?? "User").toString();
                        }
                      }
                      String mainName = ((mainUser?.name ?? "").trim().isNotEmpty
                              ? (mainUser?.name ?? "").trim()
                              : (hasRemote ? fallbackRemoteName : "You"))
                          .trim();
                      if (hasRemote && (mainName.isEmpty || mainName == "User")) {
                        if (controller.queuedRemoteMembersById.isNotEmpty) {
                          final queued = controller.queuedRemoteMembersById.values.first;
                          if (queued.name != null && queued.name!.isNotEmpty && queued.name != "User") {
                            mainName = queued.name!;
                          }
                        }
                        if (mainName.isEmpty || mainName == "User") {
                          final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
                          controller.callMembersMap.forEach((k, v) {
                            if (k != currentUserId && (mainName.isEmpty || mainName == "User")) {
                              final mName = (v['name'] ?? "").toString().trim();
                              final mMobile = (v['mobile'] ?? "").toString().trim();
                              if (mName.isNotEmpty && mName != "User") {
                                mainName = mName;
                              } else if (mMobile.isNotEmpty) {
                                mainName = mMobile;
                              }
                            }
                          });
                        }
                        if (mainName.isEmpty || mainName == "User") {
                          final res = Utility.resolveUserDisplay(
                            fullname: fallbackRemoteName == "User" ? null : fallbackRemoteName,
                            profileimage: mainUser?.bannerImg,
                          );
                          if (res['name'] != null && res['name']!.isNotEmpty && res['name'] != "User") {
                            mainName = res['name']!;
                          }
                        }
                      }
                      final resolvedMainName =
                          (mainUser?.uid == controller.currentUid &&
                                  (mainName.isEmpty || mainName == "User"))
                              ? "You"
                              : mainName;

                      return Stack(
                        children: [
                          if (controller.users.length > 2)
                            Positioned.fill(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount:
                                      controller.users.length > 4 ? 3 : 2,
                                  childAspectRatio: controller.viewAspectRatio,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: controller.users.length,
                                itemBuilder: (context, index) {
                                  final gridUser =
                                      controller.users.elementAt(index);
                                  final bool isMe = gridUser.uid == controller.currentUid;
                                  String resolvedName =
                                      isMe ? "You" : (gridUser.name ?? "User");
                                  if (!isMe && (resolvedName == "User" || resolvedName.trim().isEmpty)) {
                                    String? memberUserId;
                                    controller.callMembersMap.forEach((k, v) {
                                      if (v['uid'] == gridUser.uid.toString()) {
                                        memberUserId = k;
                                        final cand = (v['name'] ?? v['mobile'] ?? "").toString().trim();
                                        if (cand.isNotEmpty && cand != "User") {
                                          resolvedName = cand;
                                        }
                                      }
                                    });

                                    final res = Utility.resolveUserDisplay(
                                      userId: memberUserId,
                                      profileimage: gridUser.bannerImg,
                                    );
                                    if (res['name'] != null && res['name']!.isNotEmpty && res['name'] != "User") {
                                      resolvedName = res['name']!;
                                    }
                                  }
                                  final bool isHost = controller.isSelfCall ?? false;
                                  
                                  return Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      _buildVideoSurface(
                                        user: gridUser,
                                        borderRadius: BorderRadius.circular(14),
                                        showName: false,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.black45,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            resolvedName,
                                            style: Styles.white50012,
                                          ),
                                        ),
                                      ),
                                      if (isHost && !isMe)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: InkWell(
                                            onTap: () {
                                              String memberIdToKick = "";
                                              controller.callMembersMap.forEach((key, value) {
                                                if (value['uid'] == gridUser.uid.toString()) {
                                                  memberIdToKick = key;
                                                }
                                              });
                                              if (memberIdToKick.isNotEmpty) {
                                                controller.postKickMember(memberIdToKick);
                                              } else {
                                                Utility.showMessage("Cannot find user to kick", MessageType.error, () => null, '');
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: const BoxDecoration(
                                                color: Colors.black45,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                            )
                          else ...[
                            Positioned.fill(
                              child: _buildVideoSurface(
                                user: mainUser,
                                borderRadius: BorderRadius.circular(14),
                                showName: remoteUser != null,
                              ),
                            ),
                            if (hasRemote && pipUser != null)
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showLocalAsMain = !_showLocalAsMain;
                                    });
                                  },
                                  child: Container(
                                    width: constraints.maxWidth * 0.28,
                                    height: constraints.maxHeight * 0.24,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.white70,
                                        width: 1.4,
                                      ),
                                    ),
                                    child: _buildVideoSurface(
                                      user: pipUser,
                                      borderRadius: BorderRadius.circular(10),
                                      showName: false,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                          Positioned(
                            top: 14,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black45,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.users.length > 2
                                        ? "${controller.users.length} Participants"
                                        : resolvedMainName,
                                    style: Styles.white50012,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    controller.callStatusText,
                                    style: Styles.white50012,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
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
                    InkWell(
                      onTap: () {
                        controller.onToggleCamera();
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
                            controller.isVideoEnabled
                                ? AssetConstants.ic_video_on
                                : AssetConstants.ic_video_off,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.onSwitchCamera();
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
                          child: Image.asset(
                            AssetConstants.ic_camera_switch,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        controller.showAddParticipantSheet(context);
                      },
                      child: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          color: ColorsValue.textfildbackcolor,
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        child: const Icon(Icons.person_add),
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
