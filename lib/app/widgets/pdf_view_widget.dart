import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PdfViewWidget extends StatelessWidget {
  const PdfViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              Get.arguments[1],
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
      body: PDFView(
        filePath: ApiWrapper.imageUrl + Get.arguments[0],
      ),
    );
  }


}
