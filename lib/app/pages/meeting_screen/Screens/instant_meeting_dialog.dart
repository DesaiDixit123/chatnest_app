import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstantMeetingDialog extends StatelessWidget {
  const InstantMeetingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeetingController>(
      builder: (controller) {
        return Container(
          padding: Dimens.edgeInsets20,
          decoration: BoxDecoration(
            color: ColorsValue.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Dimens.twenty),
              topRight: Radius.circular(Dimens.twenty),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'instant_meeting'.tr,
                    style: Styles.black70018,
                  ),
                  InkWell(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      size: Dimens.twentyFour,
                      color: ColorsValue.greyColor8888,
                    ),
                  ),
                ],
              ),
              Dimens.boxHeight10,
              Text(
                'instant_meeting_description'.tr,
                style: Styles.greyColor888840012,
              ),
              Dimens.boxHeight20,

              // Title input
              CustomTextFormField(
                controller: controller.titleController,
                hintText: 'type_meeting_title'.tr,
                fillColor: ColorsValue.textfildbackcolor,
              ),
              Dimens.boxHeight15,

              // Description input (optional)
              CustomTextFormField(
                controller: controller.desController,
                hintText: 'description_optional'.tr,
                maxLines: 2,
                fillColor: ColorsValue.textfildbackcolor,
              ),
              Dimens.boxHeight20,

              // Add members button
              InkWell(
                onTap: () async {
                  // Load friends list for selection
                  await controller.myFriendsWithoutPaginationList();

                  // Show member selection dialog
                  Get.dialog(
                    GetBuilder<MeetingController>(
                      builder: (ctrl) => Dialog(
                        child: Container(
                          height: Get.height * 0.7,
                          padding: Dimens.edgeInsets20,
                          child: Column(
                            children: [
                              Text(
                                'add_members'.tr,
                                style: Styles.black70018,
                              ),
                              Dimens.boxHeight20,
                              Expanded(
                                child: ListView.builder(
                                  itemCount: ctrl.memberLists.length,
                                  itemBuilder: (context, index) {
                                    final member = ctrl.memberLists[index];
                                    final isSelected = ctrl.selectedMemberList
                                        .any((e) => e.userid == member.userid);

                                    return ListTile(
                                      onTap: () {
                                        if (isSelected) {
                                          ctrl.selectedMemberList.removeWhere(
                                              (e) => e.userid == member.userid);
                                        } else {
                                          ctrl.selectedMemberList.add(member);
                                        }
                                        ctrl.update();
                                      },
                                      leading: CircleAvatar(
                                        backgroundImage: member.profileimage !=
                                                null
                                            ? NetworkImage(
                                                '${ApiWrapper.imageUrl}${member.profileimage}')
                                            : null,
                                        child: member.profileimage == null
                                            ? Text(member.fullname?[0] ?? 'U')
                                            : null,
                                      ),
                                      title: Text(member.fullname ?? ''),
                                      trailing: isSelected
                                          ? Icon(Icons.check_circle,
                                              color: ColorsValue.maincolor1)
                                          : Icon(Icons.circle_outlined),
                                    );
                                  },
                                ),
                              ),
                              Dimens.boxHeight10,
                              CustomButton(
                                text: 'done'.tr.toUpperCase(),
                                height: Dimens.fifty,
                                onTap: () => Get.back(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: Dimens.edgeInsets15,
                  decoration: BoxDecoration(
                    color: ColorsValue.textfildbackcolor,
                    borderRadius: BorderRadius.circular(Dimens.five),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_add,
                        color: ColorsValue.maincolor1,
                        size: Dimens.twenty,
                      ),
                      Dimens.boxWidth10,
                      Expanded(
                        child: Text(
                          controller.selectedMemberList.isEmpty
                              ? 'add_members'.tr
                              : '${controller.selectedMemberList.length} ${'members_selected'.tr}',
                          style: controller.selectedMemberList.isEmpty
                              ? Styles.greyColor888840014
                              : Styles.black50014,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: Dimens.sixteen,
                        color: ColorsValue.greyColor8888,
                      ),
                    ],
                  ),
                ),
              ),
              Dimens.boxHeight25,

              // Start meeting button
              CustomButton(
                text: 'start_meeting'.tr.toUpperCase(),
                height: Dimens.fifty,
                onTap: () async {
                  if (controller.titleController.text.isEmpty) {
                    Utility.errorMessage('enter_meeting_title'.tr);
                    return;
                  }

                  // Check camera and microphone permissions
                  if (await Utility.cameraPermissionCheack(context) &&
                      await Utility.microphonePermissionCheack(context)) {
                    Get.back(); // Close the dialog
                    controller.postStartInstantMeeting();
                  }
                },
              ),
              Dimens.boxHeight10,
            ],
          ),
        );
      },
    );
  }
}
