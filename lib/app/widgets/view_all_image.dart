import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ViewAllImages extends StatelessWidget {
  const ViewAllImages({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) {
      var controller = Get.find<ChatController>();
      controller.multiMediaList = Get.arguments ?? [];
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Images",
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
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: GridView.builder(
            padding: Dimens.edgeInsets20,
            itemCount: controller.multiMediaList?.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemBuilder: (context, indexs) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimens.ten),
                  border: Border.all(
                    color: ColorsValue.maincolor1,
                    width: Dimens.two,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.ten),
                  child: controller.multiMediaList?[indexs].type == "IMG"
                      ? InkWell(
                          onTap: () {
                            RouteManagement.goToShowFullScareenImage(
                                controller.multiMediaList?[indexs].path ?? "",
                                controller.multiMediaList?[indexs].type ??
                                    "");
                          },
                          child: CachedNetworkImage(
                            imageUrl: ApiWrapper.imageUrl +
                                (controller.multiMediaList?[indexs].path ??
                                    ""),
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: Lottie.asset(
                                AssetConstants.imageLoader,
                                fit: BoxFit.cover,
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              AssetConstants.placeholder,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            RouteManagement.goToShowFullScareenImage(
                                controller.multiMediaList?[indexs].path ?? "",
                                "Video");
                          },
                          child: Stack(
                            children: [
                              VideoThumbnailWidget(
                                video:
                                    controller.multiMediaList?[indexs].path ??
                                        "",
                              ),
                              Center(
                                child: Icon(
                                  Icons.play_circle,
                                  color: ColorsValue.white,
                                  size: Dimens.fourty,
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
