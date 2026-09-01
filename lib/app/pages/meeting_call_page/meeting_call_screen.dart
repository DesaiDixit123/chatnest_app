import 'dart:math';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MeetingCallScreen extends StatefulWidget {
  const MeetingCallScreen({
    super.key,
  });

  @override
  State<MeetingCallScreen> createState() => _MeetingCallScreenState();
}

class _MeetingCallScreenState extends State<MeetingCallScreen> {
  @override
  void dispose() {
    final controller = Get.isRegistered<MeetingCallController>() ? Get.find<MeetingCallController>() : null;
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
          final controller = Get.isRegistered<MeetingCallController>() ? Get.find<MeetingCallController>() : null;
          if (controller == null || !controller.isCallEnded) {
            if (Get.isRegistered<CallManagerService>()) {
              Get.find<CallManagerService>().minimizeCall();
            }
          }
        }
      },
      child: GetBuilder<MeetingCallController>(initState: (state) async {
      var controller = Get.find<MeetingCallController>();
      Future.delayed(Duration.zero, () async {
        if (await Utility.cameraPermissionCheack(context) &&
            // ignore: use_build_context_synchronously
            await Utility.microphonePermissionCheack(context)) {
          controller.token = Get.arguments[1];
          controller.channelName = Get.arguments[0];
          controller.meetingId = Get.arguments[2];
          controller.isHost = Get.arguments[4];
          controller.isMicEnabled = true;
          controller.isVideoEnabled = true;
          controller.initialize();
        }
      });
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: Stack(
          children: [
            // Main meeting view
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: OrientationBuilder(
                        builder: (context, orientation) {
                          final isPortrait =
                              orientation == Orientation.portrait;
                          if (controller.users.isEmpty) {
                            return const SizedBox();
                          }
                          WidgetsBinding.instance.addPostFrameCallback(
                            (_) {
                              controller.viewAspectRatio =
                                  isPortrait ? 3 / 3 : 3 / 2;
                              controller.update();
                            },
                          );
                          final layoutViews =
                              controller.createLayout(controller.users.length);
                          return AgoraMeetingLayout(
                            users: controller.users,
                            views: layoutViews,
                            viewAspectRatio: controller.viewAspectRatio,
                            controller: controller,
                          );
                        },
                      ),
                    ),
                  ),
                  // Control buttons - hide when in full screen
                  if (!controller.isFullScreen)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // End call button
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
                          // Microphone toggle
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
                          // Camera toggle
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
                          // Switch camera
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
                          // Screen share toggle
                          InkWell(
                            onTap: () {
                              controller.onToggleScreenShare();
                            },
                            child: Container(
                              height: Dimens.fifty,
                              width: Dimens.fifty,
                              decoration: BoxDecoration(
                                color: controller.isScreenSharing
                                    ? ColorsValue.appColor
                                    : ColorsValue.textfildbackcolor,
                                borderRadius: BorderRadius.circular(
                                  Dimens.five,
                                ),
                              ),
                              child: Icon(
                                controller.isScreenSharing
                                    ? Icons.stop_screen_share
                                    : Icons.screen_share,
                                color: controller.isScreenSharing
                                    ? Colors.white
                                    : Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                          // Participants list button
                          InkWell(
                            onTap: () {
                              _showParticipantsSheet(context, controller);
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
                              child: const Icon(
                                Icons.people_outline,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // Full screen overlay
            if (controller.isFullScreen && controller.fullScreenUser != null)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    controller.exitFullScreen();
                  },
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: [
                        // Full screen video
                        Center(
                          child:
                              controller.fullScreenUser!.isVideoEnabled ?? false
                                  ? controller.fullScreenUser!.view
                                  : CircleAvatar(
                                      backgroundColor: Colors.grey.shade800,
                                      maxRadius: 80,
                                      child: Image.asset(
                                        AssetConstants.usera,
                                      ),
                                    ),
                        ),
                        // Exit full screen hint
                        Positioned(
                          top: 40,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.fullscreen_exit,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Tap to exit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }),
  );
}

  void _showParticipantsSheet(
      BuildContext context, MeetingCallController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Participants (${controller.callMembersMap.length})",
                style: Styles.black70018,
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.callMembersMap.length,
                  itemBuilder: (context, index) {
                    final userId = controller.callMembersMap.keys.elementAt(index);
                    final userInfo = controller.callMembersMap[userId]!;
                    final bool isMe = userId == (Utility.profileData?.id ?? "");
                    final bool canKick = controller.isHost && !isMe;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                          "${ApiWrapper.imageUrl}${userInfo['image'] ?? ""}",
                        ),
                      ),
                      title: Text(
                        "${userInfo['name']}${isMe ? ' (You)' : ''}",
                        style: Styles.black50014,
                      ),
                      trailing: canKick
                          ? IconButton(
                              icon: const Icon(Icons.person_remove, color: Colors.red),
                              onPressed: () {
                                Get.back();
                                controller.postKickMember(userId);
                              },
                            )
                          : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class AgoraMeetingLayout extends StatelessWidget {
  const AgoraMeetingLayout({
    super.key,
    required Set<AgoraUser> users,
    required List<int> views,
    required double viewAspectRatio,
    required MeetingCallController controller,
  })  : _users = users,
        _views = views,
        _viewAspectRatio = viewAspectRatio,
        _controller = controller;

  final Set<AgoraUser> _users;
  final List<int> _views;
  final double _viewAspectRatio;
  final MeetingCallController _controller;

  @override
  Widget build(BuildContext context) {
    int totalCount = _views.reduce((value, element) => value + element);
    int rows = _views.length;
    int columns = _views.reduce(max);

    List<Widget> rowsList = [];
    for (int i = 0; i < rows; i++) {
      List<Widget> rowChildren = [];
      for (int j = 0; j < columns; j++) {
        int index = i * columns + j;
        if (index < totalCount) {
          rowChildren.add(
            AgoraMeetingView(
              user: _users.elementAt(index),
              viewAspectRatio: _viewAspectRatio,
              controller: _controller,
            ),
          );
        } else {
          rowChildren.add(
            const SizedBox.shrink(),
          );
        }
      }
      rowsList.add(
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rowsList,
    );
  }
}

class AgoraMeetingView extends StatelessWidget {
  const AgoraMeetingView({
    super.key,
    required double viewAspectRatio,
    required AgoraUser user,
    required MeetingCallController controller,
  })  : _viewAspectRatio = viewAspectRatio,
        _user = user,
        _controller = controller;

  final double _viewAspectRatio;
  final AgoraUser _user;
  final MeetingCallController _controller;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          _controller.toggleFullScreen(_user);
        },
        child: Padding(
          padding: Dimens.edgeInsets2,
          child: AspectRatio(
            aspectRatio: _viewAspectRatio,
            child: Container(
              decoration: BoxDecoration(
                color: ColorsValue.textfildbackcolor,
                borderRadius: BorderRadius.circular(
                  Dimens.ten,
                ),
                border: Border.all(
                  color: _user.isAudioEnabled ?? false
                      ? ColorsValue.appColor
                      : ColorsValue.redColor,
                  width: 2.0,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade800,
                      maxRadius: Dimens.fifty,
                      child: Image.asset(
                        AssetConstants.usera,
                      ),
                    ),
                  ),
                  if (_user.isVideoEnabled ?? false)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8 - 2),
                      child: _user.view,
                    ),
                  // Screen sharing indicator
                  if (_controller.isScreenSharing &&
                      _user.uid == _controller.currentUid)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsValue.appColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.screen_share,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Sharing',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
