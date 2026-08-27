import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SendRequestScreen extends StatelessWidget {
  const SendRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        body: SafeArea(
          child: Column(
            children: [
              Dimens.boxHeight20,
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => controller.pagingController.refresh(),
                  ),
                   color: ColorsValue.appColor,
                  child: PagedListView<int, SentFirendsDoc>(
                    pagingController: controller.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<SentFirendsDoc>(
                      noItemsFoundIndicatorBuilder: (_) => Center(
                        child: SvgPicture.asset(
                          AssetConstants.ic_send_request_empty,
                        ),
                      ),
                      itemBuilder: (BuildContext context, item, int index) {
                        return Padding(
                          padding: Dimens.edgeInsets20_05_20_05,
                          child: Column(
                            children: [
                              ListTile(
                                contentPadding: Dimens.edgeInsets0,
                                isThreeLine: true,
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
                                    borderRadius:
                                        BorderRadius.circular(Dimens.hundred),
                                     child: ApiWrapper.isValidImageUrl(
                                             item.receiverid?.profileimage)
                                         ? CachedNetworkImage(
                                             imageUrl: ApiWrapper.imageUrl +
                                                 item.receiverid!.profileimage!,
                                             fit: BoxFit.cover,
                                             maxHeightDiskCache: 90,
                                             maxWidthDiskCache: 90,
                                             width: Dimens.fifty,
                                             height: Dimens.fifty,
                                             placeholder: (context, url) =>
                                                 Image.asset(
                                               AssetConstants.usera,
                                               fit: BoxFit.cover,
                                             ),
                                             errorWidget:
                                                 (context, url, error) =>
                                                     Image.asset(
                                               AssetConstants.usera,
                                               fit: BoxFit.cover,
                                             ),
                                           )
                                         : Image.asset(
                                             AssetConstants.usera,
                                             fit: BoxFit.cover,
                                             width: Dimens.fifty,
                                             height: Dimens.fifty,
                                           ),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.receiverid?.fullname ?? "",
                                      style: Styles.black50016,
                                    ),
                                    Text(
                                      Utility.getTimeStempToDate(item.timestamp)
                                          .toString(),
                                      style: Styles.greyColor888840012,
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.lastchatmessage?.message?.content
                                              .text.message ??
                                          "",
                                      style: Styles.greyColor888840014,
                                    ),
                                    Dimens.boxHeight10,
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.status == "sent"
                                              ? "pending".toUpperCase()
                                              : item.status == "rejected"
                                                  ? 'rejected'.tr.toUpperCase()
                                                  : "blocked".tr.toUpperCase(),
                                          style: item.status == "rejected" ||
                                                  item.status == "blocked"
                                              ? Styles.redcolor50012
                                              : Styles.main50012,
                                        ),
                                        item.status == "sent"
                                            ? InkWell(
                                                onTap: () {
                                                  controller.cancelSentRequest(
                                                      item.id);
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimens.five),
                                                      border: Border.all(
                                                        color: ColorsValue
                                                            .redColor,
                                                        width: Dimens.one,
                                                      )),
                                                  child: Padding(
                                                    padding: Dimens
                                                        .edgeInsets50_5_50_5,
                                                    child: Text(
                                                      "cancle".tr.toUpperCase(),
                                                      style:
                                                          Styles.redcolor50012,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight10,
                              Divider(
                                height: Dimens.ten,
                                color: ColorsValue.textfildbackcolor,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
