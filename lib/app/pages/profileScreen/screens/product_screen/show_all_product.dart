import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:page_indicator/page_indicator.dart';

class ShowAllProductScreen extends StatelessWidget {
  const ShowAllProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          shadowColor: Colors.black.withOpacity(0.4),
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
        // body: Center(
        //   child: SizedBox(
        //     height: Dimens.twoHundredFifty,
        //     child: PageIndicatorContainer(
        //       align: IndicatorAlign.bottom,
        //       length: controller.allVideoList.length,
        //       indicatorSpace: 5,
        //       padding: Dimens.edgeInsets10,
        //       indicatorColor: ColorsValue.grey,
        //       indicatorSelectorColor: ColorsValue.maincolor1,
        //       shape: IndicatorShape.circle(size: Dimens.nine),
        //       key: key,
        //       child: PageView.builder(
        //         controller: PageController(initialPage: Get.arguments ?? 0),
        //         itemCount: controller.allVideoList.length,
        //         itemBuilder: (context, index) {
        //           var type = controller.allVideoList[index].split('.').last;
        //           return Utility.videoTypeList
        //                   .every((element) => element != type)
        //               ? Padding(
        //                   padding: Dimens.edgeInsets0_10_0_30,
        //                   child: InkWell(
        //                     onTap: () {
        //                       RouteManagement.goToShowFullScareenImage(
        //                           controller.allVideoList[index], "Image");
        //                     },
        //                     child: ClipRRect(
        //                       borderRadius: BorderRadius.circular(6),
        //                       child: CachedNetworkImage(
        //                         imageUrl: ApiWrapper.imageUrl +
        //                             (controller.allVideoList[index]),
        //                         fit: BoxFit.cover,
        //                         placeholder: (context, url) => const Center(
        //                             child: CircularProgressIndicator()),
        //                         errorWidget: (context, url, error) =>
        //                             const Icon(Icons.error),
        //                       ),
        //                     ),
        //                   ),
        //                 )
        //               : Padding(
        //                   padding: Dimens.edgeInsets0_10_0_30,
        //                   child: InkWell(
        //                     onTap: () {
        //                       RouteManagement.goToShowFullScareenImage(
        //                           controller.allVideoList[index], "Video");
        //                     },
        //                     child: Stack(
        //                       children: [
        //                         SizedBox(
        //                           width: double.maxFinite,
        //                           height: Dimens.twoHundredFifty,
        //                           child: ThumbNailImageFullpage(
        //                             url: controller.allVideoList[index],
        //                           ),
        //                         ),
        //                         Center(
        //                           child: SvgPicture.asset(
        //                             AssetConstants.ic_video_play,
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 );
        //         },
        //       ),
        //     ),
        //   ),
        // ),
     
      );
    });
  }
}
