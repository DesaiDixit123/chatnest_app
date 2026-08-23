import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ShareUserContactScreen extends StatelessWidget {
  const ShareUserContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<ChatController>(
      initState: (state) {
        var controller = Get.find<ChatController>();
        controller.fetchContacts();
      },
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
              "share_contact".tr,
              style: Styles.black70018,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (Get.arguments[0]) {
                controller.sendGroupMessage("", false, true);
              } else {
                controller.sendMessage("", false, true);
              }
              Get.back();
            },
            backgroundColor: ColorsValue.maincolor1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Dimens.hundred,
              ),
            ),
            child: SvgPicture.asset(
              AssetConstants.ic_right_side_arrow,
            ),
          ),
          body: Padding(
            padding: Dimens.edgeInsets20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: controller.searchUserController,
                  hintText: 'search'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  suffixIcon: Icon(
                    Icons.search,
                    size: Dimens.twentyFour,
                    color: ColorsValue.hookupHeaderGreyColor,
                  ),
                  onChanged: (value) {
                    debouncer.run(() {
                      Future.sync(
                        () {
                          return controller.filterConatctUser(value);
                        },
                      );
                    });
                  },
                ),
                Dimens.boxHeight20,
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.contactsSearchList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var item = controller.contactsSearchList[index];
                      return InkWell(
                        onTap: () {
                          controller.update();
                        },
                        child: ListTile(
                          contentPadding: Dimens.edgeInsets0,
                          leading: Container(
                            height: Dimens.fifty,
                            width: Dimens.fifty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.blackColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              child: Image.asset(
                                AssetConstants.usera,
                                width: Dimens.fifty,
                                height: Dimens.fifty,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Text(
                            item.displayName.isNotEmpty
                                ? item.displayName
                                : " -- ",
                            style: Styles.black50016,
                          ),
                          subtitle: Text(
                            item.phones.isNotEmpty
                                ? item.phones.first.number
                                : " -- ",
                            style: Styles.greyColor888840012,
                          ),
                          trailing: Transform.scale(
                            scale: 1.2,
                            child: Radio(
                              value: index,
                              groupValue: controller.selectUser,
                              activeColor: ColorsValue.appColor,
                              onChanged: (value) {
                                controller.selectUser = value!;
                                controller.update();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
