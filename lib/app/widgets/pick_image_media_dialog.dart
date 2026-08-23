import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickImageMediaDialog extends StatefulWidget {
  const PickImageMediaDialog({super.key, required this.imageLength});
  final int imageLength;

  @override
  State<PickImageMediaDialog> createState() => _PickImageMediaDialogState();
}

class _PickImageMediaDialogState extends State<PickImageMediaDialog> {
  final detailsTEC = TextEditingController();

  final imageFileList = <XFile>[];

  final picker = ImagePicker();

  @override
  void initState() {
    imageFileList.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => ListView(
        shrinkWrap: true,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: Dimens.twenty,
              vertical: Dimens.fifty,
            ),
            padding: Dimens.edgeInsets20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                Dimens.ten,
              ),
              color: Colors.white,
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'upload_photo'.tr,
                        style: Styles.black70020,
                      ),
                      IconButton(
                        onPressed: Get.back,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Dimens.boxHeight50,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'select_photo'.tr,
                        style: Styles.greyAAA40014,
                      ),
                    ],
                  ),
                  Dimens.boxHeight10,
                  InkWell(
                    onTap: imageFileList.length < widget.imageLength
                        ? () async {
                            final List<XFile> selectedImages =
                                await picker.pickMultiImage(imageQuality: 5);

                            if (selectedImages.length < widget.imageLength &&
                                imageFileList.length < widget.imageLength) {
                              imageFileList.addAll(selectedImages);
                              setState(() {});
                            } else {
                              Utility.snacBar(
                                  'Maximum ${widget.imageLength} Images Upload'
                                      .tr,
                                  ColorsValue.maincolor1);
                            }
                          }
                        : null,
                    child: DottedBorder(
                      strokeCap: StrokeCap.butt,
                      borderType: BorderType.RRect,
                      color: Colors.black,
                      child: imageFileList.isEmpty
                          ? Container(
                              height: Dimens.twoHundred,
                              width: double.infinity,
                              color: Colors.white,
                              alignment: Alignment.center,
                              child: Text('drop_img_here'.tr),
                            )
                          : SizedBox(
                              height: Dimens.hundredTwenty,
                              width: double.infinity,
                              child: ListView.builder(
                                itemCount: imageFileList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Padding(
                                  padding: Dimens.edgeInsets8,
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(Dimens.five),
                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {},
                                            child: Image.file(
                                              File(imageFileList[index].path),
                                              height: Dimens.hundredEight,
                                              width: Dimens.hundredEight,
                                              filterQuality: FilterQuality.low,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: InkWell(
                                              onTap: () {
                                                imageFileList.removeAt(index);
                                                setState(() {});
                                              },
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                width: Dimens.hundredEight,
                                                height: Dimens.twenty,
                                                color: ColorsValue.maincolor1,
                                                child: Center(
                                                  child: Text(
                                                    'remove'.tr,
                                                    style: Styles.white50014,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width, Dimens.fifty),
                      backgroundColor: ColorsValue.maincolor1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.ten),
                      ),
                    ),
                    onPressed: () {
                      if (imageFileList.isEmpty) return;
                      Get.back<MediaClass>(
                        result: MediaClass(
                          mediaList: imageFileList,
                        ),
                      );
                    },
                    child: Text(
                      'submit'.tr,
                      style: Styles.whiteBold18,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );
}
