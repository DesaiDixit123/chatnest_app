import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MeetingLinkCard extends StatefulWidget {
  const MeetingLinkCard({
    super.key,
    required this.meetingUrl,
    required this.isSend,
  });

  final String meetingUrl;
  final bool isSend;

  @override
  State<MeetingLinkCard> createState() => _MeetingLinkCardState();
}

class _MeetingLinkCardState extends State<MeetingLinkCard> {
  GetOneMeetingModel? meetingData;
  bool isLoading = true;
  late MeetingPresenter presenter;

  @override
  void initState() {
    super.initState();
    print(
        "ANTIGRAVITY: MeetingLinkCard initialized with url: ${widget.meetingUrl}");
    _initPresenter();
    _fetchMeetingDetails();
  }

  void _initPresenter() {
    final repository = Get.find<Repository>();
    presenter = MeetingPresenter(
      MeetingUsecases(repository),
      CommonUsecases(repository),
    );
  }

  String _extractMeetingId() {
    // Regex to find /meeting/join/ID pattern in any text
    final regex = RegExp(r'/meeting/join/([a-zA-Z0-9]+)');
    final match = regex.firstMatch(widget.meetingUrl);

    if (match != null && match.groupCount >= 1) {
      return match.group(1) ?? "";
    }
    return "";
  }

  Future<void> _fetchMeetingDetails() async {
    final meetingId = _extractMeetingId();
    if (meetingId.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await presenter.postMeetingGetOne(
        meetingid: meetingId,
        isLoading: false,
      );
      if (mounted) {
        setState(() {
          meetingData = response;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _joinMeeting() async {
    final meetingId = _extractMeetingId();
    if (meetingId.isEmpty) return;

    if (await Utility.cameraPermissionCheack(context) &&
        await Utility.microphonePermissionCheack(context)) {
      final response = await presenter.postMeetingJoin(
        meetingid: meetingId,
        isLoading: true,
      );

      final token = (response?.data?.agorameta?.token ?? "").trim();
      final channelName = (response?.data?.agorameta?.channelName ?? "").trim();

      if (response != null && token.isNotEmpty && channelName.isNotEmpty) {
        RouteManagement.goToMeetingCallScreen(
          channelName,
          token,
          meetingId,
          false,
          false,
        );
      } else {
        Utility.showDialog(
          "Meeting not started yet. Please wait for host to start the meeting.",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: Dimens.edgeInsets10,
        width: Get.width * 0.7,
        decoration: BoxDecoration(
          color: widget.isSend
              ? ColorsValue.lightmainColor
              : ColorsValue.textfildbackcolor,
          borderRadius: BorderRadius.circular(Dimens.ten),
        ),
        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (meetingData == null || meetingData?.data == null) {
      // Fallback to text link if fetch failed
      print(
          "ANTIGRAVITY: meetingData is null, falling back to text. URL: ${widget.meetingUrl}");
      return Text(
        widget.meetingUrl,
        style: Styles.black40014.copyWith(
          color: Colors.blue,
          decoration: TextDecoration.underline,
        ),
      );
    }

    final data = meetingData!.data!;
    // Since HostMeetingDoc doesn't have isInstant, we use a generic label
    // or infer from date if needed. For now, specific labels are safer.
    final title = data.title ?? "Meeting";
    final date = data.meetingstartdate ?? "";
    final time = data.meetingstarttime ?? "";

    return Container(
      width: Get.width * 0.7,
      decoration: BoxDecoration(
          color: const Color(0xFFE8F1F8), // Light blueish grey
          borderRadius: BorderRadius.circular(Dimens.ten),
          border: const Border(
            left: BorderSide(
                color: Color(0xFF1B3E6D), width: 4), // Dark blue accent
          )),
      padding: Dimens.edgeInsets15,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons
                    .calendar_month_outlined, // Changed icon to match image better (calendar)
                color: const Color(0xFF1B3E6D),
                size: Dimens.twenty,
              ),
              Dimens.boxWidth10,
              Text(
                "MEETING", // Updated text
                style: Styles.blackBold12.copyWith(
                  // Changed from black70012 to blackBold12
                  color: const Color(0xFF1B3E6D),
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Dimens.boxHeight10,
          Text(
            title,
            style: Styles.black70016,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Dimens.boxHeight5,
          Text(
            "Date: $date",
            style: Styles.greyColor888840012,
          ),
          Text(
            "Time: $time",
            style: Styles.greyColor888840012,
          ),
          Dimens.boxHeight15,
          CustomButton(
            text: "Join Meeting",
            height: Dimens.fourty, // Changed from forty to fourty
            backgroundColor: const Color(
                0xFF1B3E6D), // Changed from color to backgroundColor
            onTap: _joinMeeting,
            style: Styles.white50014, // Changed from textStyle to style
            radius: BorderRadius.circular(
                Dimens.five), // Changed from borderRadius to radius
          ),
        ],
      ),
    );
  }
}
