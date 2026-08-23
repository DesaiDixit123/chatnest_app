import 'dart:io';

import 'package:chatnest/app/theme/colors_value.dart';
import 'package:chatnest/app/utils/utility.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/models/status_model.dart';
import 'package:image_picker/image_picker.dart';
import 'controllers/status_controller.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chatnest/app/theme/dimens.dart';
import 'package:chatnest/app/theme/styles.dart';
import 'package:chatnest/app/utils/asset_constants.dart';
import 'package:chatnest/domain/entities/enums.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorsValue.whiteColor,
        // appBar: AppBar(
        //   backgroundColor: ColorsValue.whiteColor,
        //   elevation: 0,
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back, color: ColorsValue.blackcolor),
        //     onPressed: () => Navigator.maybePop(context),
        //   ),
        //   title: const Text(
        //     "Status",
        //     style: TextStyle(
        //       color: ColorsValue.blackcolor,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        floatingActionButton: _StatusUploadFab(),
        body: SafeArea(
          child: GetBuilder<StatusController>(
            initState: (_) {
              Get.find<StatusController>().loadAll();
            },
            builder: (controller) {
              if (controller.isLoading) {
                return Center(
                  child: CircularProgressIndicator(
                    color: ColorsValue.appColor,
                  ),
                );
              }

              return ListView(
                children: [
                  /// ================= MY STATUS =================
                  ListTile(
                    leading: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: controller.myStatuses.isEmpty
                                  ? ColorsValue.greyColor8888
                                  : ColorsValue.greenColor,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: ColorsValue.greyColorEEEE,
                            backgroundImage:
                                Utility.profileData?.profileimage != null &&
                                        Utility.profileData!.profileimage!
                                            .isNotEmpty
                                    ? NetworkImage(
                                        ApiWrapper.imageUrl +
                                            Utility.profileData!.profileimage!,
                                      )
                                    : null,
                            child: Utility.profileData?.profileimage == null ||
                                    Utility.profileData!.profileimage!.isEmpty
                                ? Icon(
                                    Icons.person,
                                    color: ColorsValue.greyColor8888,
                                  )
                                : null,
                          ),
                        ),

                        /// ➕ ADD BUTTON
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: ColorsValue.appColor,
                              border: Border.all(
                                color: ColorsValue.whiteColor,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    title: const Text(
                      "My moments",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorsValue.blackcolor,
                      ),
                    ),
                    subtitle: Text(
                      controller.myStatuses.isEmpty
                          ? "Tap to add a moment"
                          : "${controller.myStatuses.length} updates",
                      style: TextStyle(
                        color: ColorsValue.greyColor8888,
                      ),
                    ),
                    onTap: () {
                      if (controller.myStatuses.isEmpty) {
                        _openUploadOptions(context);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StatusViewer(
                              name: "My Moments",
                              statuses: controller.myStatuses,
                              initialStatusId: controller.myStatuses.first.id,
                              isMyStatus: true,
                            ),
                          ),
                        );
                      }
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      "Recent updates",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorsValue.greyColor8888,
                      ),
                    ),
                  ),

                  /// ================= FRIEND STATUSES =================
                  ...controller.friendsStatuses.map((friend) {
                    final statuses = friend['statuses'] as List;

                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: ColorsValue.appColor,
                            width: 2,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: ColorsValue.greyColorEEEE,
                          backgroundImage: friend['profilepic'] != null &&
                                  friend['profilepic'].toString().isNotEmpty
                              ? NetworkImage(
                                  ApiWrapper.imageUrl + friend['profilepic'],
                                )
                              : null,
                        ),
                      ),
                      title: Text(
                        friend['name'] ?? "User",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: ColorsValue.blackcolor,
                        ),
                      ),
                      subtitle: Text(
                        "${statuses.length} updates",
                        style: TextStyle(
                          color: ColorsValue.greyColor8888,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StatusViewer(
                              name: friend['name'] ?? "User",
                              statuses: statuses
                                  .map((e) => StatusModel.fromJson(e))
                                  .toList(),
                              isMyStatus: false,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatusUploadFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: ColorsValue.appColor, // ✅ main app color
      elevation: 4,
      child: const Icon(
        Icons.camera_alt,
        color: Colors.white, // stays white (good contrast)
      ),
      onPressed: () => _openUploadOptions(context),
    );
  }
}

class TextStatusPage extends StatefulWidget {
  const TextStatusPage({super.key});

  @override
  State<TextStatusPage> createState() => _TextStatusPageState();
}

class _TextStatusPageState extends State<TextStatusPage> {
  final TextEditingController textCtrl = TextEditingController();
  String color = "#000000";
  int duration = 24;

  final colors = [
    "#000000",
    "#e91e63",
    "#2196f3",
    "#4caf50",
    "#ff9800",
    "#9c27b0",
    "#03a9f4",
    "#795548",
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<StatusController>(
      builder: (controller) => Scaffold(
        backgroundColor: Color(int.parse(color.replaceFirst("#", "0xff"))),
        body: SafeArea(
          child: Column(
            children: [
              if (controller.isUploadingStatus)
                LinearProgressIndicator(
                  minHeight: 2,
                  color: ColorsValue.whiteColor,
                  backgroundColor: Colors.white24,
                ),

              /// 🔝 TOP BAR
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: controller.isUploadingStatus
                          ? null
                          : () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    PopupMenuButton<int>(
                      initialValue: duration,
                      color: Colors.black87,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.timer,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 4),
                            Text("$duration " + "h".tr,
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      onSelected: (val) => setState(() => duration = val),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                            value: 6,
                            child: Text("6_hours".tr,
                                style: const TextStyle(color: Colors.white))),
                        PopupMenuItem(
                            value: 12,
                            child: Text("12_hours".tr,
                                style: const TextStyle(color: Colors.white))),
                        PopupMenuItem(
                            value: 24,
                            child: Text("24_hours".tr,
                                style: const TextStyle(color: Colors.white))),
                      ],
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.check, color: Colors.white),
                      onPressed: controller.isUploadingStatus
                          ? null
                          : () async {
                              if (textCtrl.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("please_write_something".tr),
                                    backgroundColor: Colors.black87,
                                  ),
                                );
                                return;
                              }

                              final success = await controller.uploadTextStatus(
                                text: textCtrl.text.trim(),
                                color: color,
                                duration: duration,
                              );

                              if (success && context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(Get.context!).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      "Moment uploaded",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Colors.green.shade700,
                                  ),
                                );
                              }
                            },
                    ),
                  ],
                ),
              ),

              /// ✍️ TEXT INPUT
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: TextField(
                      controller: textCtrl,
                      maxLines: null,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      enabled: !controller.isUploadingStatus,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        hintText: "Type a moment",
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 26,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ),

              /// 🎨 COLOR PICKER
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  height: 48,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: colors.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final c = colors[i];
                      final isSelected = c == color;

                      return GestureDetector(
                        onTap: controller.isUploadingStatus
                            ? null
                            : () => setState(() => color = c),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isSelected ? 46 : 40,
                          height: isSelected ? 46 : 40,
                          decoration: BoxDecoration(
                            color:
                                Color(int.parse(c.replaceFirst("#", "0xff"))),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.white, width: 3)
                                : null,
                          ),
                        ),
                      );
                    },
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

Future<String?> _pickImage() async {
  final picker = ImagePicker();
  final XFile? file = await picker.pickImage(
    source: ImageSource.gallery,
    imageQuality: 80,
  );
  return file?.path;
}

Future<String?> _pickVideo() async {
  final picker = ImagePicker();
  final XFile? file = await picker.pickVideo(
    source: ImageSource.gallery,
  );
  return file?.path;
}

void _openImagePreview(
  BuildContext context,
  String imagePath,
) {
  final captionCtrl = TextEditingController();
  int duration = 24;

  showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
            builder: (context, setState) => GetBuilder<StatusController>(
              builder: (statusController) => Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    Center(
                      child: Image.file(
                        File(imagePath),
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (statusController.isUploadingStatus)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          bottom: false,
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            color: ColorsValue.appColor,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                      ),
                    Positioned(
                      top: 40,
                      right: 16,
                      child: PopupMenuButton<int>(
                        initialValue: duration,
                        color: Colors.black87,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text("$duration " + "h".tr,
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        onSelected: (val) => setState(() => duration = val),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 6,
                              child: Text("6_hours".tr,
                                  style: const TextStyle(color: Colors.white))),
                          PopupMenuItem(
                              value: 12,
                              child: Text("12_hours".tr,
                                  style: const TextStyle(color: Colors.white))),
                          PopupMenuItem(
                              value: 24,
                              child: Text("24_hours".tr,
                                  style: const TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 12,
                      right: 12,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Container(
                              height: Dimens.fourtyFive,
                              decoration: BoxDecoration(
                                color: ColorsValue.whiteColor,
                                borderRadius: BorderRadius.circular(
                                  Dimens.fourtyone,
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                    spreadRadius: 0.3,
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                    color: Colors.black38,
                                  )
                                ],
                              ),
                              child: TextFormField(
                                controller: captionCtrl,
                                enabled: !statusController.isUploadingStatus,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: Dimens.edgeInsets10,
                                  hintText: 'add_caption'.tr,
                                  hintStyle: Styles.hookup40012,
                                  border: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Dimens.boxWidth10,
                          InkWell(
                            onTap: statusController.isUploadingStatus
                                ? null
                                : () async {
                                    FocusScope.of(context).unfocus();

                                    final success = await statusController
                                        .uploadImageStatus(
                                      imagePath: imagePath,
                                      caption: captionCtrl.text,
                                      duration: duration,
                                    );

                                    if (success && context.mounted) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    }
                                  },
                            child: Container(
                              height: Dimens.fourtyFive,
                              width: Dimens.fourtyFive,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius:
                                    BorderRadius.circular(Dimens.fifty),
                              ),
                              child: Center(
                                child: statusController.isUploadingStatus
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        AssetConstants.sendIcon,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
}

void _openUploadOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _UploadTile(
                icon: Icons.text_fields,
                color: Colors.blue,
                title: "text_moment".tr,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const TextStatusPage());
                },
              ),
              _UploadTile(
                icon: Icons.image,
                color: Colors.orange,
                title: "image_moment".tr,
                onTap: () async {
                  final imagePath = await _pickImage();
                  if (imagePath != null) {
                    _openImagePreview(context, imagePath);
                  }
                },
              ),
              _UploadTile(
                icon: Icons.videocam,
                color: Colors.red,
                title: "video_moment".tr,
                onTap: () async {
                  Navigator.pop(context);
                  final videoPath = await _pickVideo();
                  if (videoPath != null) {
                    _openVideoPreview(context, videoPath);
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      );
    },
  );
}

void _openVideoPreview(
  BuildContext context,
  String videoPath,
) {
  final captionCtrl = TextEditingController();
  int duration = 24;
  final controllerVideo = VideoPlayerController.file(File(videoPath));

  controllerVideo.initialize().then((_) {
    controllerVideo.play();
    controllerVideo.setLooping(true);
  });

  showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
            builder: (context, setState) => GetBuilder<StatusController>(
              builder: (statusController) => Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    Center(
                      child: AspectRatio(
                        aspectRatio: controllerVideo.value.aspectRatio,
                        child: VideoPlayer(controllerVideo),
                      ),
                    ),
                    if (statusController.isUploadingStatus)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          bottom: false,
                          child: LinearProgressIndicator(
                            minHeight: 2,
                            color: ColorsValue.appColor,
                            backgroundColor: Colors.white24,
                          ),
                        ),
                      ),
                    Positioned(
                      top: 40,
                      right: 16,
                      child: PopupMenuButton<int>(
                        initialValue: duration,
                        color: Colors.black87,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.timer,
                                  color: Colors.white, size: 16),
                              const SizedBox(width: 4),
                              Text("$duration " + "h".tr,
                                  style: const TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                        onSelected: (val) => setState(() => duration = val),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                              value: 6,
                              child: Text("6_hours".tr,
                                  style: const TextStyle(color: Colors.white))),
                          PopupMenuItem(
                              value: 12,
                              child: Text("12_hours".tr,
                                  style: const TextStyle(color: Colors.white))),
                          PopupMenuItem(
                              value: 24,
                              child: Text("24_hours".tr,
                                  style: const TextStyle(color: Colors.white))),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 12,
                      right: 12,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: captionCtrl,
                                  enabled: !statusController.isUploadingStatus,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    hintText: "add_caption".tr,
                                    hintStyle: TextStyle(color: Colors.white54),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon:
                                    Icon(Icons.send, color: Colors.green),
                                onPressed: statusController.isUploadingStatus
                                    ? null
                                    : () async {
                                        FocusScope.of(context).unfocus();

                                        final success = await statusController
                                            .uploadVideoStatus(
                                          videoPath: videoPath,
                                          caption: captionCtrl.text,
                                          duration: duration,
                                        );

                                        controllerVideo.dispose();

                                        if (success && context.mounted) {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                      },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
}

class StatusViewer extends StatefulWidget {
  final List<StatusModel> statuses;
  final String name;
  final String? profileImage;
  final String? initialStatusId;
  final bool isMyStatus;

  const StatusViewer({
    super.key,
    required this.statuses,
    required this.name,
    this.profileImage,
    this.initialStatusId,
    this.isMyStatus = false,
  });

  @override
  State<StatusViewer> createState() => StatusViewerState();
}

class StatusViewerState extends State<StatusViewer> {
  int index = 0;
  VideoPlayerController? _videoController;
  late StatusController _statusController;
  late List<StatusModel> _statuses;
  List<Map<String, dynamic>> _currentInteractions = [];
  bool _isInteractionLoading = false;

  bool get _hasStatuses => _statuses.isNotEmpty;

  StatusModel get _currentStatus => _statuses[index];

  bool get _isOwnStatus {
    final status = _currentStatus;
    return widget.isMyStatus ||
        (status.userId.isNotEmpty && status.userId == Utility.profileData?.id);
  }

  @override
  void initState() {
    super.initState();
    _statusController = Get.find<StatusController>();
    _statuses = List<StatusModel>.from(widget.statuses);

    if (widget.initialStatusId != null) {
      int initialIndex =
          _statuses.indexWhere((s) => s.id == widget.initialStatusId);
      if (initialIndex != -1) {
        index = initialIndex;
      }
    }
    _handleStatusChanged();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _loadVideo(String url) {
    _videoController?.dispose();

    _videoController = VideoPlayerController.network(
      ApiWrapper.imageUrl + url,
    )
      ..initialize().then((_) {
        if (!mounted || _videoController == null) return;
        _videoController!
          ..play()
          ..setLooping(false);
        setState(() {});
      })
      ..addListener(() {
        if (!mounted || _videoController == null) return;
        if (!_videoController!.value.isInitialized) return;
        if (_videoController!.value.duration == Duration.zero) return;
        if (_videoController!.value.position >=
            _videoController!.value.duration) {
          _next();
        }
      });
  }

  void _next() {
    if (!_hasStatuses) return;
    _videoController?.dispose();
    _videoController = null;

    if (index < _statuses.length - 1) {
      setState(() => index++);
      _handleStatusChanged();
    } else {
      Navigator.pop(context);
    }
  }

  void _previous() {
    if (!_hasStatuses) return;
    if (index > 0) {
      _videoController?.dispose();
      _videoController = null;
      setState(() => index--);
      _handleStatusChanged();
    }
  }

  void _handleStatusChanged() {
    if (!_hasStatuses) return;
    if (_isOwnStatus) {
      _loadInteractions();
    } else {
      _statusController.markStatusViewed(statusId: _currentStatus.id);
    }
  }

  Future<void> _loadInteractions() async {
    if (!_hasStatuses || !_isOwnStatus) return;
    setState(() => _isInteractionLoading = true);
    final interactions = await _statusController.getStatusInteractions(
      statusId: _currentStatus.id,
    );
    if (!mounted) return;
    setState(() {
      _currentInteractions = interactions;
      _isInteractionLoading = false;
    });
  }

  Future<void> _showDeleteConfirmation() async {
    if (!_hasStatuses) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('delete_moment'.tr),
        content: Text('are_you_sure_delete_moment'.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('delete'.tr, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete != true) return;

    final statusId = _currentStatus.id;
    final success = await _statusController.deleteStatus(statusId: statusId);
    if (!mounted) return;

    if (!success) {
      Utility.showMessage(
          "Failed to delete moment", MessageType.error, () => null, "");
      return;
    }

    setState(() {
      _statuses.removeWhere((s) => s.id == statusId);
      if (_statuses.isNotEmpty && index >= _statuses.length) {
        index = _statuses.length - 1;
      }
    });

    await _statusController.loadAll();
    if (!mounted) return;

    if (_statuses.isEmpty) {
      Navigator.pop(context);
      return;
    }

    _handleStatusChanged();
    Utility.showMessage("Moment deleted", MessageType.success, () => null, "");
  }

  Future<void> _showUpdateDialog() async {
    if (!_hasStatuses) return;

    final status = _currentStatus;
    final textController = TextEditingController(text: status.text);
    final palette = const [
      "#000000",
      "#e91e63",
      "#2196f3",
      "#4caf50",
      "#ff9800",
      "#9c27b0",
      "#03a9f4",
      "#795548",
    ];
    String selectedColor =
        status.color.isNotEmpty ? status.color : palette.first;

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text("update_moment".tr),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: textController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: status.contentType == "text"
                            ? "edit_moment_text".tr
                            : "edit_caption".tr,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    if (status.contentType == "text") ...[
                      SizedBox(height: 14),
                      Text(
                        "background".tr,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: palette.map((hex) {
                          final isSelected = selectedColor == hex;
                          return GestureDetector(
                            onTap: () => setDialogState(() {
                              selectedColor = hex;
                            }),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Color(
                                  int.parse(hex.replaceFirst("#", "0xff")),
                                ),
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      )
                                    : null,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text("cancel".tr),
                ),
                GetBuilder<StatusController>(
                  builder: (controller) => TextButton(
                    onPressed: controller.isStatusActionLoading
                        ? null
                        : () async {
                            final updated =
                                await _statusController.updateStatus(
                              statusId: status.id,
                              text: textController.text.trim(),
                              color: status.contentType == "text"
                                  ? selectedColor
                                  : null,
                            );

                            if (!mounted) return;

                            if (updated == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("failed_update_moment".tr),
                                ),
                              );
                              return;
                            }

                            setState(() {
                              _statuses[index] = updated;
                            });
                            await _statusController.loadAll();
                            await _loadInteractions();
                            if (!mounted) return;

                            Navigator.pop(dialogContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("moment_updated".tr),
                              ),
                            );
                          },
                    child: Text(
                      controller.isStatusActionLoading
                          ? "updating".tr
                          : "update".tr,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showViewersBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Text(
                    "viewed_by".tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Spacer(),
                  Text(
                    "${_currentInteractions.length}",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.white24),
            Expanded(
              child: _isInteractionLoading
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : _currentInteractions.isEmpty
                      ? Center(
                          child: Text(
                            "no_views_yet".tr,
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _currentInteractions.length,
                          itemBuilder: (context, i) {
                            final interaction = _currentInteractions[i];
                            final user =
                                interaction['user'] as Map<String, dynamic>?;
                            final name = (user?['fullname'] ??
                                    user?['nickname'] ??
                                    "User")
                                .toString();
                            final profile =
                                (user?['profileimage'] ?? "").toString();
                            final viewedTs = interaction['viewedtimestamp'];
                            DateTime? viewedAt;
                            if (viewedTs is int) {
                              viewedAt = DateTime.fromMillisecondsSinceEpoch(
                                viewedTs,
                              );
                            } else if (viewedTs is String) {
                              viewedAt = DateTime.tryParse(viewedTs);
                            }

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey[700],
                                backgroundImage: profile.isNotEmpty
                                    ? NetworkImage(
                                        ApiWrapper.imageUrl + profile,
                                      )
                                    : null,
                                child: profile.isEmpty
                                    ? Icon(Icons.person,
                                        color: Colors.white)
                                    : null,
                              ),
                              title: Text(
                                name,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                viewedAt == null
                                    ? "viewed".tr
                                    : "viewed".tr + " ${_formatTime(viewedAt)}",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'just_now'.tr;
    }
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}' + 'm_ago'.tr;
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}' + 'h_ago'.tr;
    }
    return '${difference.inDays}' + 'd_ago'.tr;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasStatuses) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "no_moments_available".tr,
            style: TextStyle(color: Colors.white70),
          ),
        ),
      );
    }

    final status = _currentStatus;
    final isOwnStatus = _isOwnStatus;

    Widget content;

    /// IMAGE (NO STRETCH)
    if (status.contentType == "image") {
      content = Stack(
        children: [
          Center(
            child: InteractiveViewer(
              child: Image.network(
                ApiWrapper.imageUrl + status.media,
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// CAPTION
          if (status.text.isNotEmpty)
            Positioned(
              bottom: 110,
              left: 16,
              right: 16,
              child: Text(
                status.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(blurRadius: 6, color: Colors.black),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    /// VIDEO (AUTO PLAY + NO STRETCH)
    else if (status.contentType == "video") {
      if (_videoController == null) {
        _loadVideo(status.media);
      }

      content = Stack(
        children: [
          Center(
            child: _videoController != null &&
                    _videoController!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _videoController!.value.aspectRatio,
                    child: VideoPlayer(_videoController!),
                  )
                : CircularProgressIndicator(
                    color: Colors.white,
                  ),
          ),

          /// CAPTION
          if (status.text.isNotEmpty)
            Positioned(
              bottom: 110,
              left: 16,
              right: 16,
              child: Text(
                status.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      blurRadius: 6,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
        ],
      );
    }

    /// TEXT STATUS
    else {
      content = Container(
        width: double.infinity,
        height: double.infinity,
        color: status.color.isNotEmpty
            ? Color(int.parse(
                status.color.replaceFirst("#", "0xff"),
              ))
            : Colors.black,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          status.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    final tapControlTop = MediaQuery.of(context).padding.top + 120;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(child: content),

          GetBuilder<StatusController>(
            builder: (controller) => controller.isStatusActionLoading
                ? Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SafeArea(
                      bottom: false,
                      child: LinearProgressIndicator(
                        minHeight: 2,
                        color: ColorsValue.appColor,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ),

          /// TAP CONTROLS
          Positioned.fill(
            top: tapControlTop,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _previous,
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _next,
                  ),
                ),
              ],
            ),
          ),

          /// TOP OVERLAY (kept after tap controls so menu remains clickable)
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PROGRESS BAR
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: List.generate(
                      _statuses.length,
                      (i) => Expanded(
                        child: Container(
                          height: 3,
                          margin: EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: i <= index ? Colors.white : Colors.white30,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// USER + BACK + OPTIONS
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Expanded(
                        child: Text(
                          widget.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (isOwnStatus)
                        PopupMenuButton<String>(
                          onSelected: (value) async {
                            // if (value == 'edit') {
                            //   await _showUpdateDialog();
                            // } else
                            if (value == 'delete') {
                              await _showDeleteConfirmation();
                            } else if (value == 'viewers') {
                              _showViewersBottomSheet();
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem(
                              value: 'viewers',
                              child: Row(
                                children: [
                                  Icon(Icons.visibility, size: 18),
                                  SizedBox(width: 8),
                                  Text('viewed_by'.tr),
                                ],
                              ),
                            ),
                            // const PopupMenuItem(
                            //   value: 'edit',
                            //   child: Row(
                            //     children: [
                            //       Icon(Icons.edit, size: 18),
                            //       SizedBox(width: 8),
                            //       Text('Edit'),
                            //     ],
                            //   ),
                            // ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      color: Colors.red, size: 18),
                                  SizedBox(width: 8),
                                  Text('delete'.tr,
                                      style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          icon:
                              Icon(Icons.more_vert, color: Colors.white),
                        )
                      else
                        const SizedBox(width: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),

          if (isOwnStatus)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                top: false,
                child: GestureDetector(
                  onTap: _showViewersBottomSheet,
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.visibility,
                            color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          "${_currentInteractions.length} views",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          else
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _ReplyInputField(
                statusId: status.id,
                controller: _statusController,
              ),
            ),
        ],
      ),
    );
  }
}

class _UploadTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _UploadTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      onTap: onTap,
    );
  }
}

/// 💬 REPLY INPUT FIELD
class _ReplyInputField extends StatefulWidget {
  final String statusId;
  final StatusController controller;

  const _ReplyInputField({
    required this.statusId,
    required this.controller,
  });

  @override
  State<_ReplyInputField> createState() => _ReplyInputFieldState();
}

class _ReplyInputFieldState extends State<_ReplyInputField> {
  final TextEditingController _replyCtrl = TextEditingController();
  bool isPosting = false;

  @override
  void dispose() {
    _replyCtrl.dispose();
    super.dispose();
  }

  void _postReply() async {
    if (_replyCtrl.text.trim().isEmpty) {
      return;
    }

    setState(() => isPosting = true);

    final success = await widget.controller.replyToStatus(
      statusId: widget.statusId,
      message: _replyCtrl.text.trim(),
    );

    setState(() => isPosting = false);

    if (success) {
      _replyCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("reply_posted".tr, style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("failed_post_reply".tr),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom + 8,
        ),
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border(
            top: BorderSide(color: Colors.white24),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _replyCtrl,
                decoration: InputDecoration(
                  hintText: "Reply to moment...",
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Colors.white24,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(
                      color: Colors.white54,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: Colors.white10,
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: null,
                enabled: !isPosting,
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: ColorsValue.appColor,
              radius: 20,
              child: isPosting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: _postReply,
                      padding: EdgeInsets.zero,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
