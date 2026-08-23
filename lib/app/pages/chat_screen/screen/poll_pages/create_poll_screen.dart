import 'package:chatnest/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CreatePollScreen extends StatelessWidget {
  const CreatePollScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        initState: (state) {},
        builder: (controller) {
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
                'create_poll'.tr,
                style: Styles.black70018,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (controller.askQuestionController.text.isEmpty) {
                  Utility.errorMessage("Add a question.");
                } else if (controller.questionList[controller.selectIndex]
                        .textController?.text.isEmpty ??
                    false) {
                  Utility.errorMessage(
                      "Add a question and at least two options.");
                } else {
                  controller.createPolls(
                      Get.arguments[0] ?? false, Get.arguments[1] ?? false);
                }
              },
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
            body: ListView(
              padding: Dimens.edgeInsets20,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'question'.tr,
                      style: Styles.black50014,
                    ),
                    CustomTextFormField(
                      controller: controller.askQuestionController,
                      hintText: 'ask_question'.tr,
                      fillColor: ColorsValue.textfildbackcolor,
                    ),
                    Dimens.boxHeight20,
                    Divider(
                      height: Dimens.one,
                      color: ColorsValue.textfildbackcolor,
                    ),
                    Dimens.boxHeight20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'option'.tr,
                          style: Styles.black50014,
                        ),
                        Visibility(
                          visible:
                              controller.questionList.length > 3 ? false : true,
                          child: InkWell(
                            onTap: () {
                              if (controller
                                  .questionList[controller.selectIndex]
                                  .textController!
                                  .text
                                  .isNotEmpty)
                                controller.questionList.add(
                                  QuestionModel(
                                    textController: TextEditingController(),
                                  ),
                                );
                              controller.update();
                            },
                            child: Text(
                              '+ Add'.tr,
                              style: Styles.main50014,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      children:
                          controller.questionList.asMap().entries.map((e) {
                        controller.selectIndex = e.key;
                        return Padding(
                          padding: Dimens.edgeInsets0_5_0_5,
                          child: TextFormField(
                            controller: e.value.textController,
                            cursorColor: ColorsValue.maincolor1,
                            decoration: InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.all(Dimens.fifteen),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five),
                                ),
                                filled: true,
                                fillColor: ColorsValue.textfildbackcolor,
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five),
                                ),
                                hintStyle: Styles.greyAAA40014,
                                hintText: '+ Add',
                                suffixIcon: Padding(
                                  padding: Dimens.edgeInsets10,
                                  child: Visibility(
                                    visible: controller.selectIndex < 2
                                        ? false
                                        : true,
                                    child: InkWell(
                                      onTap: () {
                                        controller.questionList
                                            .removeAt(controller.selectIndex);
                                        controller.update();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.five,
                                          ),
                                          color: ColorsValue.maincolor1,
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: ColorsValue.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          ),
                        );
                      }).toList(),
                    ),
                    Dimens.boxHeight20,
                    Divider(
                      height: Dimens.one,
                      color: ColorsValue.textfildbackcolor,
                    ),
                    Dimens.boxHeight20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'allow_multiple_answers'.tr,
                          style: Styles.black50016,
                        ),
                        CupertinoSwitch(
                          value: controller.isMultipalAns,
                          activeColor: ColorsValue.maincolor1,
                          onChanged: (value) {
                            controller.isMultipalAns = value;
                            controller.update();
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        });
  }
}
