import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
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
    final controller = Get.isRegistered<MeetingCallController>()
        ? Get.find<MeetingCallController>()
        : null;
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
          final controller = Get.isRegistered<MeetingCallController>()
              ? Get.find<MeetingCallController>()
              : null;
          if (controller == null || !controller.isCallEnded) {
            if (Get.isRegistered<CallManagerService>()) {
              Get.find<CallManagerService>().minimizeCall();
            }
          }
        }
      },
      child: GetBuilder<MeetingCallController>(
        initState: (state) async {
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
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Top Bar
                      _buildTopBar(context, controller),

                      // Video View Layout
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 8.0),
                          child: _buildVideoGrid(controller),
                        ),
                      ),

                      // Bottom Control Bar
                      if (!controller.isFullScreen)
                        _buildBottomControlBar(context, controller),
                    ],
                  ),

                  // Full screen view overlay
                  if (controller.isFullScreen &&
                      controller.fullScreenUser != null)
                    _buildFullScreenOverlay(controller),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, MeetingCallController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Minimize button
          GestureDetector(
            onTap: () {
              Get.find<CallManagerService>().minimizeCall();
              Get.back();
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),

          // Title & Duration
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.meetingTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      controller.formattedDuration,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "${controller.users.length} in session",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Mirror toggle & Quick camera switch
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => controller.toggleMirror(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: controller.isMirrored
                        ? Colors.blueAccent.withOpacity(0.3)
                        : Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.flip_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => controller.onSwitchCamera(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cameraswitch_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVideoGrid(MeetingCallController controller) {
    if (controller.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
            ),
            const SizedBox(height: 16),
            Text(
              "Joining ${controller.meetingTitle}...",
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      );
    }

    final userList = controller.users.toList();
    final count = userList.length;

    if (count == 1) {
      // Single participant fills the area
      return _buildVideoTile(userList[0], controller);
    } else if (count == 2) {
      // 2 participants: Split vertically
      return Column(
        children: [
          Expanded(child: _buildVideoTile(userList[0], controller)),
          const SizedBox(height: 8),
          Expanded(child: _buildVideoTile(userList[1], controller)),
        ],
      );
    } else if (count == 3 || count == 4) {
      // 2x2 grid
      return Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildVideoTile(userList[0], controller)),
                const SizedBox(width: 8),
                Expanded(child: _buildVideoTile(userList[1], controller)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: [
                Expanded(child: _buildVideoTile(userList[2], controller)),
                const SizedBox(width: 8),
                Expanded(
                  child: count > 3
                      ? _buildVideoTile(userList[3], controller)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      // 5+ participants: scrollable 2-column grid
      return GridView.builder(
        itemCount: count,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.85,
        ),
        itemBuilder: (context, index) {
          return _buildVideoTile(userList[index], controller);
        },
      );
    }
  }

  Widget _buildVideoTile(AgoraUser user, MeetingCallController controller) {
    final bool isMe =
        user.uid == controller.currentUid || user.uid == 0;
    final bool isVideoOn = user.isVideoEnabled ?? false;
    final bool isAudioOn = user.isAudioEnabled ?? false;

    String displayName = isMe ? "You" : (user.name ?? "Participant");
    if (!isMe && (displayName == "Participant" || displayName.isEmpty)) {
      controller.callMembersMap.forEach((k, v) {
        if (v['uid'] == user.uid.toString()) {
          final n = v['name'];
          if (n != null && n.isNotEmpty) displayName = n;
        }
      });
    }

    return GestureDetector(
      onTap: () => controller.toggleFullScreen(user),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isAudioOn ? Colors.greenAccent.withOpacity(0.5) : Colors.white12,
            width: isAudioOn ? 2.0 : 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video surface, Screen Sharing Card, or Avatar
            if (isMe && controller.isScreenSharing)
              _buildLocalScreenSharingView(controller)
            else if (isVideoOn && user.view != null)
              user.view!
            else
              _buildCameraOffAvatar(user, displayName),

            // Top-left Screen Sharing Badge
            if (controller.isScreenSharing && isMe)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.screen_share, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Sharing Screen',
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

            // Top-right Individual Mirror Flip Button
            if (isVideoOn && !(isMe && controller.isScreenSharing))
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () => controller.toggleUserMirror(user.uid),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.flip_rounded,
                      color: controller.isUserMirrored(user.uid)
                          ? Colors.blueAccent
                          : Colors.white70,
                      size: 16,
                    ),
                  ),
                ),
              ),

            // Bottom-left Participant Info Pill
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isAudioOn ? Icons.mic : Icons.mic_off,
                          color: isAudioOn ? Colors.white : Colors.redAccent,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraOffAvatar(AgoraUser user, String displayName) {
    final String image = (user.bannerImg ?? "").toString();
    final bool hasImage = image.isNotEmpty;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white12,
            backgroundImage: hasImage
                ? NetworkImage("${ApiWrapper.imageUrl}$image")
                : null,
            child: !hasImage
                ? const Icon(Icons.person, color: Colors.white70, size: 36)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            "Camera is off",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControlBar(
      BuildContext context, MeetingCallController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. End Call
          _buildControlButton(
            onTap: () => controller.onCallEnd(context, controller),
            backgroundColor: ColorsValue.redColor,
            icon: SvgPicture.asset(
              AssetConstants.ic_end_call,
              width: 22,
              height: 22,
            ),
          ),

          // 2. Microphone Toggle
          _buildControlButton(
            onTap: () => controller.onToggleAudio(),
            backgroundColor: controller.isMicEnabled
                ? Colors.white.withOpacity(0.12)
                : ColorsValue.redColor,
            icon: Icon(
              controller.isMicEnabled ? Icons.mic : Icons.mic_off,
              color: Colors.white,
              size: 22,
            ),
          ),

          // 3. Camera Toggle
          _buildControlButton(
            onTap: () => controller.onToggleCamera(),
            backgroundColor: controller.isVideoEnabled
                ? Colors.white.withOpacity(0.12)
                : ColorsValue.redColor,
            icon: Icon(
              controller.isVideoEnabled
                  ? Icons.videocam
                  : Icons.videocam_off,
              color: Colors.white,
              size: 22,
            ),
          ),

          // 4. Switch Camera
          _buildControlButton(
            onTap: () => controller.onSwitchCamera(),
            backgroundColor: Colors.white.withOpacity(0.12),
            icon: const Icon(
              Icons.cameraswitch,
              color: Colors.white,
              size: 22,
            ),
          ),

          // 5. Screen Share
          _buildControlButton(
            onTap: () => controller.onToggleScreenShare(),
            backgroundColor: controller.isScreenSharing
                ? Colors.blueAccent
                : Colors.white.withOpacity(0.12),
            icon: Icon(
              controller.isScreenSharing
                  ? Icons.stop_screen_share
                  : Icons.screen_share,
              color: Colors.white,
              size: 22,
            ),
          ),

          // 6. Participants Sheet
          _buildControlButton(
            onTap: () => controller.showParticipantsSheet(context),
            backgroundColor: Colors.white.withOpacity(0.12),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(
                  Icons.people_alt_outlined,
                  color: Colors.white,
                  size: 22,
                ),
                Positioned(
                  right: -4,
                  top: -4,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.greenAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "${controller.users.length}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required VoidCallback onTap,
    required Color backgroundColor,
    required Widget icon,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }

  Widget _buildLocalScreenSharingView(MeetingCallController controller) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E293B), Color(0xFF0F172A)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.screen_share_rounded,
                  color: Colors.blueAccent,
                  size: 36,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "You are sharing your screen",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              const Text(
                "Participants can see your screen live",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => controller.stopScreenSharing(),
                icon: const Icon(Icons.stop_screen_share, size: 14, color: Colors.white),
                label: const Text(
                  "Stop Sharing",
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFullScreenOverlay(MeetingCallController controller) {
    final user = controller.fullScreenUser!;
    final isMe = user.uid == controller.currentUid || user.uid == 0;
    final isVideoOn = user.isVideoEnabled ?? false;

    return Positioned.fill(
      child: GestureDetector(
        onTap: () => controller.exitFullScreen(),
        child: Container(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (isMe && controller.isScreenSharing)
                _buildLocalScreenSharingView(controller)
              else if (isVideoOn && user.view != null)
                user.view!
              else
                _buildCameraOffAvatar(user, user.name ?? "Participant"),

              Positioned(
                top: 40,
                right: 16,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.fullscreen_exit, color: Colors.white, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Tap to exit',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
