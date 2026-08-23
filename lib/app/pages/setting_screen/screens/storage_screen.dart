import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';

class StorageScreen extends StatelessWidget {
  const StorageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(initState: (state) {
      var controller = Get.find<SettingController>();
      controller.postStorageInfo();
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "storage".tr,
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
        body: controller.dataMap.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PieChart(
                    dataMap: controller.dataMap,
                    chartType: ChartType.ring,
                    chartRadius: Get.width / 2,
                    colorList: [
                      ColorsValue.greyColor8888,
                      ColorsValue.appColor,
                    ],
                    ringStrokeWidth: 50,
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValues: false,
                    ),
                    legendOptions: LegendOptions(
                      showLegendsInRow: true,
                      legendPosition: LegendPosition.bottom,
                      showLegends: true,
                      legendTextStyle: Styles.greyColor888850012,
                      legendShape: BoxShape.circle,
                    ),
                  ),
                ],
              )
            : Utility.loaderWidget(),
      );
    });
  }
}
