import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FloatingCallWidget extends StatelessWidget {
  const FloatingCallWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Only proceed if CallManagerService is registered
    if (!Get.isRegistered<CallManagerService>()) {
      return const SizedBox.shrink();
    }
    
    final callManager = Get.find<CallManagerService>();

    return Obx(() {
      if (!callManager.isCallActive || !callManager.isMinimized.value) {
        return const SizedBox.shrink();
      }

      return Material(
        type: MaterialType.transparency,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () => callManager.returnToCall(),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      ColorsValue.appColor,
                      ColorsValue.appColor.withOpacity(0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: ColorsValue.appColor.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _buildAvatar(callManager),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getCallTitle(callManager),
                            style: Styles.white70018.copyWith(fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            "Tap to return to call",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone_in_talk_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAvatar(CallManagerService callManager) {
    final image = callManager.activeUserImage.value;
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(21),
        child: image.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: ApiWrapper.imageUrl + image,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Image.asset(AssetConstants.usera, fit: BoxFit.cover),
                placeholder: (_, __) => Container(color: Colors.white10),
              )
            : Image.asset(AssetConstants.usera, fit: BoxFit.cover),
      ),
    );
  }

  String _getCallTitle(CallManagerService callManager) {
    final name = callManager.activeUserName.value;
    final type = callManager.activeCallType.value;
    
    String typeStr = "Call";
    if (type == CallType.meeting) typeStr = "Meeting";
    if (type == CallType.video) typeStr = "Video Call";

    if (name.isNotEmpty && name != "User") {
      return "$typeStr with $name";
    }
    return "$typeStr in progress";
  }
}
