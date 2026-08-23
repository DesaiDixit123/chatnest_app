import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ViewPollVoteScreen extends StatelessWidget {
  const ViewPollVoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) {
      var controller = Get.find<ChatController>();
      controller.getOnePoll(Get.arguments ?? "");
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          shadowColor: ColorsValue.greyAAAAAA,
          backgroundColor: ColorsValue.white,
          elevation: Dimens.two,
          centerTitle: false,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: Dimens.edgeInsets20_15_10_15,
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.maincolor1,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          title: Text(
            'view_votes'.tr,
            style: Styles.black70018,
          ),
        ),
        body: Padding(
          padding: Dimens.edgeInsets20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.getOnePollsModel.polltitle ?? "",
                style: Styles.black50016,
              ),
              Text(
                "${controller.votedMember} members voted",
                // controller.getOnePollsModel.options?.reduce((value, element) => value.usersvotes.length + element.usersvotes.length)??[];
                style: Styles.greyAAA40012,
              ),
              Dimens.boxHeight20,
              Divider(
                height: Dimens.one,
                color: ColorsValue.textfildbackcolor,
              ),
              Dimens.boxHeight20,
              Expanded(
                child: ListView.builder(
                  itemCount: controller.getOnePollsModel.options?.length ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: Dimens.edgeInsets0_10_0_10,
                      child: Container(
                        padding: Dimens.edgeInsets10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                          color: ColorsValue.textfildbackcolor,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  controller.getOnePollsModel.options?[index]
                                          .title ??
                                      "",
                                  style: Styles.black50016,
                                ),
                                Text(
                                  "${controller.getOnePollsModel.options?[index].usersvotes.length} ${'votes'.tr}",
                                  style: Styles.greyAAA40012,
                                ),
                              ],
                            ),
                            Dimens.boxHeight10,
                            Divider(
                              height: Dimens.one,
                              color: ColorsValue.white,
                            ),
                            if (controller.getOnePollsModel.options?[index]
                                    .usersvotes.isNotEmpty ??
                                false) ...[
                              Wrap(
                                children: controller
                                    .getOnePollsModel.options![index].usersvotes
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return ListTile(
                                    contentPadding: Dimens.edgeInsets0,
                                    leading: Container(
                                      height: Dimens.fourty,
                                      width: Dimens.fourty,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.hundred,
                                        ),
                                        color: ColorsValue.white,
                                      ),
                                      child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: ApiWrapper.imageUrl +
                                                (e.value.userid?.profileimage ??
                                                    ""),
                                            fit: BoxFit.cover,
                                            maxHeightDiskCache: 90,
                                            maxWidthDiskCache: 90,
                                            placeholder: (context, url) {
                                              return Image.asset(
                                                  AssetConstants.usera);
                                            },
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                  AssetConstants.usera);
                                            },
                                          )),
                                    ),
                                    title: Text(
                                      e.value.userid?.fullname?.isEmpty ?? false
                                          ? e.value.userid?.nickname ?? ""
                                          : e.value.userid?.fullname ?? "",
                                      style: Styles.black50014,
                                    ),
                                    subtitle: Text(
                                      Utility.dateTimeTodayWithDate(
                                          e.value.timestamp ?? 0),
                                      style: Styles.greyColor888840010,
                                    ),
                                  );
                                }).toList(),
                              )
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
