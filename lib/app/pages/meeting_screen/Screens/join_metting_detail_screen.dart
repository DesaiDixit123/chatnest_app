import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class JoinMeetingDetailScreen extends StatelessWidget {
  const JoinMeetingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeetingController>(
      initState: (state) {
        var controller = Get.find<MeetingController>();
        controller.meetingId = Get.arguments ?? "";
        controller.postMeetingGetOne();
      },
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                controller.hostMeetingDoc?.title ?? "",
                style: Styles.black70018,
              ),
            ],
          ),
          leading: Padding(
            padding: Dimens.edgeInsets15,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(AssetConstants.appbarbackarrowicon),
            ),
          ),
        ),
        body: controller.hostMeetingDoc?.id?.isNotEmpty ?? false
            ? SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: Dimens.edgeInsets20,
                      child: ListTile(
                        contentPadding: Dimens.edgeInsets0,
                        title: Text(
                          controller.hostMeetingDoc?.hostby?.fullname
                                      ?.isNotEmpty ??
                                  false
                              ? controller.hostMeetingDoc?.hostby?.fullname ??
                                  ""
                              : controller.hostMeetingDoc?.hostby?.nickname ??
                                  "",
                          style: Styles.black50016,
                        ),
                        subtitle: Text(
                          "Host Session",
                          style: Styles.greyColor888840012,
                        ),
                        leading: Container(
                          height: Dimens.fifty,
                          width: Dimens.fifty,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimens.hundred,
                            ),
                            color: ColorsValue.maincolor1,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimens.hundred,
                            ),
                            child: CachedNetworkImage(
                              imageUrl: ApiWrapper.imageUrl +
                                  (controller.hostMeetingDoc?.hostby
                                          ?.profileimage ??
                                      ""),
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
                            ),
                          ),
                        ),
                        trailing: controller.hostMeetingDoc?.status == "cancel"
                            ? Container(
                                padding: Dimens.edgeInsets5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                  border: Border.all(
                                    width: Dimens.one,
                                    color: ColorsValue.redColor,
                                  ),
                                ),
                                child: Text(
                                  'Cancel Session',
                                  style: Styles.redColor50014,
                                ),
                              )
                            : SizedBox(
                                height: Dimens.zero,
                                width: Dimens.zero,
                              ),
                      ),
                    ),
                    Dimens.boxHeight5,
                    Padding(
                      padding: Dimens.edgeInsets20_0_20_0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Session Date :- ",
                                style: Styles.black40014,
                              ),
                              Text(
                                "${controller.hostMeetingDoc?.meetingstartdate} - ${controller.hostMeetingDoc?.meetingenddate}",
                                style: Styles.greyColor888840014,
                              ),
                            ],
                          ),
                          Dimens.boxHeight5,
                          Row(
                            children: [
                              Text(
                                "Session Time :- ",
                                style: Styles.black40014,
                              ),
                              Text(
                                "${controller.hostMeetingDoc?.meetingstarttime} - ${controller.hostMeetingDoc?.meetingendtime}",
                                style: Styles.greyColor888840014,
                              ),
                            ],
                          ),
                          Dimens.boxHeight5,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Description :- ",
                                style: Styles.black40014,
                              ),
                              Flexible(
                                child: Text(
                                  controller.hostMeetingDoc?.description ?? "",
                                  style: Styles.greyColor888840014,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Dimens.boxHeight15,
                    Divider(
                      height: 1,
                      color: ColorsValue.whiteF1F1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: Dimens.edgeInsets20_20_20_0,
                        child: ListView.builder(
                          itemCount: controller.hostMeetingDoc?.members?.length,
                          itemBuilder: (context, index) {
                            var item =
                                controller.hostMeetingDoc?.members?[index];
                            return ListTile(
                              contentPadding: Dimens.edgeInsets0,
                              title: Text(
                                item?.userid?.fullname?.isNotEmpty ?? false
                                    ? item?.userid?.fullname ?? ""
                                    : item?.userid?.nickname ?? "",
                                style: Styles.black50016,
                              ),
                              subtitle: Text(
                                item?.userid?.aboutme ?? "",
                                style: Styles.greyColor888840012,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: Container(
                                height: Dimens.fifty,
                                width: Dimens.fifty,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.hundred,
                                  ),
                                  color: ColorsValue.maincolor1,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.hundred,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiWrapper.imageUrl +
                                        (item?.userid?.profileimage ?? ""),
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
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    if (controller.hostMeetingDoc?.status != "cancel") ...[
                      Padding(
                        padding: Dimens.edgeInsets20,
                        child: CustomButton(
                          text: 'join_meeting'.tr.toUpperCase(),
                          onTap: controller.hostMeetingDoc?.agorameta?.token
                                      ?.isNotEmpty ??
                                  false
                              ? () async {
                                  if (await Utility.cameraPermissionCheack(
                                          context) &&
                                      await Utility.microphonePermissionCheack(
                                          context)) {
                                    controller.postMeetingJoin(
                                        controller.hostMeetingDoc?.id);
                                  }
                                }
                              : null,
                          // : null,
                          height: Dimens.fifty,
                          backgroundColor: controller.hostMeetingDoc?.agorameta
                                      ?.token?.isNotEmpty ??
                                  false
                              ? ColorsValue.maincolor1
                              : ColorsValue.maincolor1.withOpacity(0.6),
                        ),
                      )
                    ],
                  ],
                ),
              )
            : const Center(
                child: const CircularProgressIndicator(),
              ),
      ),
    );
  }
}
