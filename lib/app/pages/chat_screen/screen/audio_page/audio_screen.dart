import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Get.arguments ?? "Send Audio",
                style: Styles.black70018,
              ),
              Dimens.boxHeight3,
              Text(
                "${controller.selectAudioList.isEmpty ? 0 : controller.selectAudioList.length} selected",
                style: Styles.main40012,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: ColorsValue.maincolor1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.hundred,
            ),
          ),
          child: Icon(
            Icons.done,
            size: Dimens.thirty,
            color: ColorsValue.white,
          ),
        ),
        body: ListView.builder(
            itemCount: controller.audioList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  if (controller.audioList[index].isSelect ?? false) {
                    controller.audioList[index].isSelect = false;
                    controller.selectAudioList
                        .remove(controller.audioList[index]);
                  } else {
                    controller.audioList[index].isSelect = true;
                    controller.selectAudioList.add(controller.audioList[index]);
                  }
                  controller.update();
                },
                child: Padding(
                  padding: Dimens.edgeInsets20_0_20_0,
                  child: ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    leading: Stack(
                      children: [
                        Container(
                          height: Dimens.fifty,
                          width: Dimens.fifty,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimens.hundred,
                            ),
                            color: ColorsValue.lightmainColor,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              Dimens.hundred,
                            ),
                            child: Padding(
                              padding: Dimens.edgeInsets10,
                              child: SvgPicture.asset(
                                AssetConstants.attechMusicIcon,
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: controller.audioList[index].isSelect ?? false
                              ? true
                              : false,
                          child: Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: Dimens.eighteen,
                              width: Dimens.eighteen,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimens.fifty),
                                color: ColorsValue.maincolor1,
                                border: Border.all(
                                  width: Dimens.one,
                                  color: ColorsValue.white,
                                ),
                              ),
                              child: Icon(
                                Icons.done,
                                size: Dimens.ten,
                                color: ColorsValue.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    title: Text(
                      "data",
                      style: Styles.black50016,
                    ),
                    subtitle: Text(
                      "00:11",
                      style: Styles.greyColor888840012,
                    ),
                  ),
                ),
              );
            }),
      );
    });
  }
}
