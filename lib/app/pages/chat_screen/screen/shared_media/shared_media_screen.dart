import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SharedMediascreen extends StatefulWidget {
  const SharedMediascreen({super.key});

  @override
  State<SharedMediascreen> createState() => _SharedMediascreenState();
}

class _SharedMediascreenState extends State<SharedMediascreen>
    with SingleTickerProviderStateMixin {
  TabController? tabMediaController;

  @override
  void initState() {
    super.initState();
    tabMediaController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabMediaController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) {
        var controller = Get.find<ChatController>();
        controller.brodId = Get.arguments[0] ?? "";
        controller.mediaTitle = Get.arguments[2] ?? "";
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: AppBar(
            shadowColor: ColorsValue.greyAAAAAA,
            backgroundColor: ColorsValue.white,
            elevation: Dimens.zero,
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
              controller.mediaTitle ?? "",
              style: Styles.black70018,
            ),
            bottom: TabBar(
              controller: tabMediaController,
              automaticIndicatorColorAdjustment: true,
              labelColor: ColorsValue.maincolor1,
              indicatorColor: ColorsValue.maincolor1,
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: Styles.main50016,
              tabs: [
                Tab(text: 'media'.tr),
                Tab(text: 'audio'.tr),
                Tab(text: 'docs'.tr),
                Tab(text: 'links'.tr),
              ],
            ),
          ),
          body: TabBarView(
            controller: tabMediaController,
            children: const [
              MediaScreen(),
              AudioMediaScreen(),
              DocsScreen(),
              LinksScreen(),
            ],
          ),
        );
      },
    );
  }
}
