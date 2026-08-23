import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignGroupChatScreen extends StatelessWidget {
  const AssignGroupChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<SettingController>(
      initState: (state) {
        var controller = Get.find<SettingController>();
        // controller.groupListPagingController =
        // PagingController(firstPageKey: 1);
        // controller.groupListPagingController
        // .addPageRequestListener((pagekey) async {
        controller.postGroupListWithoutPaging();
        // });
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          body: Padding(
            padding: Dimens.edgeInsets20_0_20_0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: controller.serchGroupController,
                  hintText: 'search'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  suffixIcon: Icon(
                    Icons.search,
                    size: Dimens.twentyFour,
                    color: ColorsValue.hookupHeaderGreyColor,
                  ),
                  onChanged: (value) {
                    _debouncer.run(() {
                      Future.sync(
                        () {
                          return controller.postGroupListWithoutPaging();
                        },
                      );
                    });
                  },
                ),
                Dimens.boxHeight15,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => controller.postGroupListWithoutPaging(),
                    ),
                     color: ColorsValue.appColor,
                    child: ListView.builder(
                      itemCount: controller.groupLists.length,
                      itemBuilder: (context, index) {
                        var item = controller.groupLists[index];
                        return Padding(
                          padding: Dimens.edgeInsetsBottom12,
                          child: ListTile(
                            contentPadding: Dimens.edgeInsets0,
                            leading: Container(
                              height: Dimens.fifty,
                              width: Dimens.fifty,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                color: ColorsValue.maincolor1,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.hundred),
                                child: CachedNetworkImage(
                                  imageUrl: ApiWrapper.imageUrl +
                                      (item.profileimage ?? ""),
                                  fit: BoxFit.cover,
                                  maxHeightDiskCache: 90,
                                  maxWidthDiskCache: 90,
                                  width: Dimens.fifty,
                                  height: Dimens.fifty,
                                  placeholder: (context, url) => Image.asset(
                                    AssetConstants.usera,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    AssetConstants.usera,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              item.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.black50016,
                            ),
                            trailing: Transform.scale(
                              scale: 1.2,
                              child: Checkbox(
                                value: item.isUserSelect,
                                activeColor: ColorsValue.appColor,
                                checkColor: ColorsValue.white,
                                onChanged: (value) {
                                  item.isUserSelect = value!;
                                  if (value) {
                                    controller.groupChatUserList
                                        .add(item.id ?? "");
                                  } else {
                                    controller.groupChatUserList
                                        .remove(item.id ?? "");
                                  }
                                  controller.update();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
