import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ProductFilterScreen extends StatelessWidget {
  const ProductFilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        bottomNavigationBar: Padding(
          padding: Dimens.edgeInsets20_18_20_18,
          child: CustomBottomButton(
            firstbtnText: 'clear'.tr.toUpperCase(),
            secondbtnTxt: 'apply'.tr.toUpperCase(),
            firstStyle: Styles.greyColor888850014,
            secondStyle: Styles.white50014,
            bordercolor: ColorsValue.greyColor8888,
            firstOnPressed: () {},
            secondOnPressed: () {},
          ),
        ),
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
                colorFilter:
                    ColorFilter.mode(ColorsValue.maincolor1, BlendMode.srcIn),
              ),
            ),
          ),
          title: Text(
            'filter'.tr,
            style: Styles.black70018,
          ),
        ),
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  color: ColorsValue.textfildbackcolor,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                            itemBuilder: (context, index) => ListTile(
                                  onTap: () {},
                                  title: Center(
                                    child: Text(
                                      "Low To High",
                                      style: Styles.greyColor888850014,
                                    ),
                                  ),
                                )),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => Row(
                          children: [
                            Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                checkColor: ColorsValue.white,
                                activeColor: ColorsValue.maincolor1,
                                value: controller.isFilter,
                                onChanged: (value) {
                                  controller.isFilter = value!;
                                  controller.update();
                                },
                              ),
                            ),
                            Text(
                              "high_to_low".tr,
                              style: Styles.greyColor888850014,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
