import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A dropdown textfield widget that where you can type to search
/// from the list of items
class CustomDropdownSearch extends StatefulWidget {
  CustomDropdownSearch(
      {Key? key,
      this.focusNode,
      this.autoFocus = false,

      /// for single select
      ///  required this.textEditingController,
      this.isObscureText = false,
      this.obscureCharacter = ' ',
      this.textCapitalization = TextCapitalization.none,
      this.isFilled,
      this.contentPadding,
      this.fillColor,
      this.hintText,
      this.hintStyle,
      this.errorStyle,
      this.formBorder,
      this.formEnableBorder,
      this.errorBorder,
      this.errorText,
      this.suffixIcon,
      this.prefixIcon,
      this.textInputAction = TextInputAction.done,
      this.textInputType = TextInputType.text,
      this.formStyle,
      this.isReadOnly = false,
      this.onTap,
      this.maxLines = 1,
      this.maxLength,
      this.fieldHeight,
      this.fieldWidth,
      this.height,
      this.initialValue,
      required this.itemList,

      /// for single select
      /// this.onChange,
      /// for single select
      /// this.onSelected,
      this.multipleSelectedList,
      this.onMultiSelected,
      this.isClearButton = false,
      this.onClearField,
      this.isSubTitle = false,
      this.isCustomSearchEnable = false,
      this.customWidget,
      this.borderRadius = false,
      this.titleIcon,
      this.isNotShowSearchBar = false,
      this.isHandTool = false,
      this.currentDataLimit = 10,
      this.totalData = 0,
      this.onLoadMore,
      this.popUpMenuBorderRadius,
      this.isPopUpMenuOpen = false})
      : super(key: key);

  final FocusNode? focusNode;
  final bool autoFocus;

  /// for single select
  /// final TextEditingController textEditingController;
  final bool isObscureText;
  final String obscureCharacter;
  final TextCapitalization textCapitalization;
  final bool? isFilled;
  final int? maxLength;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final OutlineInputBorder? formBorder;
  final OutlineInputBorder? formEnableBorder;
  final OutlineInputBorder? errorBorder;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final TextStyle? formStyle;
  final List<DropdownItemModel>? multipleSelectedList;
  final bool isPopUpMenuOpen;

  final bool isReadOnly;
  final Function()? onTap;
  final int? maxLines;
  final double? fieldHeight;
  final double? fieldWidth;
  final double? height;
  final String? initialValue;
  final List<DropdownMultipleTreeModel> itemList;

  /// for single select
  /// final Function(String value)? onChange;
  /// for single select
  /// final Function(DropdownItemModel value)? onSelected;
  final Function(List<DropdownItemModel> value)? onMultiSelected;
  final bool isClearButton;
  final Function()? onClearField;
  final bool isSubTitle;
  final bool isCustomSearchEnable;
  final Widget? customWidget;
  final bool? borderRadius;
  final double? popUpMenuBorderRadius;
  final Widget? titleIcon;
  final bool isNotShowSearchBar;
  final bool isHandTool;
  final int currentDataLimit;
  final int totalData;
  final Future<void> Function(int currentSkipLimit, int currentLimit)?
      onLoadMore;

  @override
  State<CustomDropdownSearch> createState() => _CustomDropdownSearchState();
}

class _CustomDropdownSearchState extends State<CustomDropdownSearch> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: widget.fieldWidth ?? double.infinity,
            child: LayoutBuilder(
              key: UniqueKey(),
              builder: (BuildContext context, BoxConstraints constraints) =>
                  Theme(
                data: ThemeData(
                    hoverColor: ColorsValue.transparent,
                    focusColor: ColorsValue.transparent,
                    highlightColor: ColorsValue.transparent,
                    dividerColor: ColorsValue.grey),
                child: SizedBox(
                    height: widget.fieldHeight ?? Dimens.fifty,
                    child: DropdownSearch.multiSelection(
                      popupProps: PopupPropsMultiSelection.menu(
                          scrollbarProps: const ScrollbarProps(thickness: 0),
                          menuProps: const MenuProps(
                              backgroundColor: ColorsValue.whiteColor),
                          constraints: BoxConstraints(
                              minWidth:
                                  widget.fieldWidth ?? constraints.maxWidth,
                              maxWidth:
                                  widget.fieldWidth ?? constraints.maxWidth,
                              maxHeight: Dimens.threeHundred),
                          selectionWidget: (context, item, isSelected) =>
                              Checkbox(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.four)),
                                value: isSelected,
                                onChanged: (val) {},
                              ),
                          showSearchBox: true,
                          showSelectedItems: false,
                          searchDelay: const Duration(milliseconds: 0),
                          searchFieldProps: TextFieldProps(
                            padding: Dimens.edgeInsets10,

                            // autocorrect: true,

                            mouseCursor: SystemMouseCursors.basic,

                            // key: const Key('text-form-field'),
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.left,
                            cursorColor:
                                Get.theme.textSelectionTheme.cursorColor,
                            decoration: InputDecoration(
                              contentPadding: Dimens.edgeInsets10_0_10_0,
                              filled: true,
                              counterText: '',
                              fillColor: ColorsValue.textfildbackcolor,
                              border: Styles.outlineBorderEnableRadius8,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: Dimens.zero,
                                      style: BorderStyle.none),
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five)),
                              hintStyle: Styles.black40014,
                              labelStyle:
                                  const TextStyle(color: ColorsValue.greyColor),
                              hintText: 'search'.tr,
                            ),
                            style: Styles.black40014,
                          ),
                          itemBuilder: (context, item, isSelected) {
                            var data = widget.itemList
                                .where((element) => element.name == item)
                                .toList();
                            return Padding(
                              padding: Dimens.edgeInsets10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data[0].name,
                                    style: Styles.black40014,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          data[0].name,
                                          style: Styles.black40014,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                      items: widget.itemList.map((e) => e.name).toList(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        baseStyle: Styles.black40014,
                        dropdownSearchDecoration: InputDecoration(
                          contentPadding:
                              widget.contentPadding ?? Dimens.edgeInsets10,
                          // isHandTool: widget.isHandTool,
                          hintText: widget.hintText,
                          hintStyle: widget.hintStyle ?? Styles.black40014,
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: Dimens.zero, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(Dimens.five)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: Dimens.zero, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(Dimens.five)),
                          errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: Dimens.zero, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(Dimens.five)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: Dimens.zero, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(Dimens.five)),
                          filled: true,
                          fillColor: ColorsValue.textfildbackcolor,

                          enabled: !widget.isCustomSearchEnable,

                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: Dimens.zero, style: BorderStyle.none),
                              borderRadius: BorderRadius.circular(Dimens.five)),
                          labelStyle: widget.formStyle,
                        ),
                      ),
                      onChanged: (value) {
                        var _list = <DropdownItemModel>[];
                        for (var data in value) {
                          var index = widget.itemList
                              .indexWhere((element) => element.name == data);
                          if (!index.isNegative) {
                            // _list.add(widget.itemList[index]);
                          }
                        }

                        widget.onMultiSelected!(_list);
                      },
                      selectedItems: widget.multipleSelectedList
                              ?.map((e) => e.name)
                              .toList() ??
                          [],
                    )),
              ),
              //   child: PopupMenuButton<DropdownItemModel>(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.all(
              //         Radius.circular((widget.borderRadius ?? false)
              //             ? widget.popUpMenuBorderRadius ?? Dimens.fifteen
              //             : Dimens.zero),
              //       ),
              //     ),
              //     key: _menuKey,
              //     enableFeedback: false,
              //     onSelected: widget.onSelected,
              //     splashRadius: 0,
              //     color: ColorsValue.whiteColor,
              //     tooltip: '',
              //     offset:
              //         widget.offset ?? Offset(Dimens.zero, Dimens.seventyTwo),
              //     constraints: BoxConstraints(
              //         minWidth: widget.fieldWidth ?? constraints.maxWidth,
              //         maxWidth: widget.fieldWidth ?? constraints.maxWidth,
              //         maxHeight: Dimens.threeHundred),
              //     child: widget.customWidget != null
              //         ? widget.customWidget!
              //         : FormFieldWidget(
              //             isHandTool: widget.isHandTool,
              //             hintText: widget.hintText,
              //             hintStyle: widget.hintStyle,
              //             titleText: widget.titleText,
              //             titleIcon: widget.titleIcon,
              //             textEditingController: widget.textEditingController,
              //             onTap: () {
              //               if (!widget.isCustomSearchEnable) {
              //                 _menuKey.currentState!.showButtonMenu();
              //               }
              //             },
              //             titleTextStyle: widget.titleTextStyle ??
              //                 Styles.normalBlack12Color1F2021,
              //             fieldHeight: widget.fieldHeight,
              //             fillColor: widget.fillColor,

              //             fieldWidth:
              //                 widget.fieldWidth ?? Dimens.fourHunderFifty,
              //             errorText: widget.errorText,
              //             isAdditionalErrorText: widget.isAdditionalErrorText,
              //             isMandatoryfield: widget.isMandatoryfield,
              //             isReadOnly: !widget.isCustomSearchEnable,
              //             formEnableBorder: widget.formEnableBorder,
              //             // ??
              //             //     Styles.outlineBorderRadius10,
              //             formBorder: widget.formBorder,
              //             // ??
              //             // Styles.outlineBorderEnableRadius10,
              //             formStyle: widget.formStyle,
              //             onChange: (val) {
              //               if (widget.isCustomSearchEnable) {
              //                 _debouncer.run(
              //                   () {
              //                     if (val.trim().isNotEmpty) {
              //                       setState(
              //                         () {
              //                           var _list = <DropdownItemModel>[];
              //                           for (var data in widget.itemList) {
              //                             if (data.name
              //                                 .toLowerCase()
              //                                 .contains(val.toLowerCase())) {
              //                               if (_list.length < 20) {
              //                                 _list.add(data);
              //                               }
              //                             }
              //                           }
              //                           _tempSearchedList = List.from(_list);
              //                         },
              //                       );
              //                       if (_tempSearchedList.isNotEmpty) {
              //                         _menuKey.currentState!.showButtonMenu();
              //                       }
              //                     }
              //                   },
              //                 );
              //               }
              //             },
              //             suffixIcon: Row(
              //               mainAxisSize: MainAxisSize.min,
              //               children: [
              //                 if ((widget.isClearButton ||
              //                         widget.isCustomSearchEnable) &&
              //                     widget.textEditingController.text.isNotEmpty)
              //                   IconButton(
              //                     icon: SvgPicture.asset(
              //                         AssetConstants.crossGrey),
              //                     splashRadius: 5,
              //                     onPressed: () {
              //                       widget.textEditingController.clear();
              //                       if (widget.isClearButton) {
              //                         if (widget.onClearField != null) {
              //                           widget.onClearField!();
              //                         }
              //                       } else if (widget.isCustomSearchEnable) {
              //                         if (widget.onSelected != null) {
              //                           widget.onSelected!(
              //                               const DropdownItemModel(
              //                                   name: '',
              //                                   id: '',
              //                                   email: '',
              //                                   role: ''));
              //                         }
              //                       }

              //                       setState(() {});
              //                     },
              //                   ),
              //                 widget.suffixIcon ??
              //                     const InkWell(
              //                         child: Icon(
              //                             color: ColorsValue.blackColor,
              //                             Icons.keyboard_arrow_down_outlined))
              //               ],
              //             ),
              //           ),
              //     itemBuilder: (context) {
              //       if (!widget.isCustomSearchEnable) {
              //         _tempSearchedList = List.from(widget.itemList);
              //       }
              //       return widget.isReadOnly
              //           ? []
              //           : widget.isNotShowSearchBar
              //               ? [
              //                   PopupMenuItem(
              //                     padding: Dimens.edgeInsets0,
              //                     height: 0,
              //                     onTap: null,
              //                     enabled: false,
              //                     child: StatefulBuilder(
              //                       builder: (context, setState) => Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.end,
              //                         mainAxisSize: MainAxisSize.min,
              //                         children: [
              //                           //  isFinish: widget.itemList.length ==
              //                           //       widget.totalData,
              //                           //   textBuilder: (status) =>
              //                           //       widget.itemList.length ==
              //                           //               widget.totalData
              //                           //           ? ''
              //                           //           : 'Load More',
              //                           //   onLoadMore: () async {
              //                           //     if (widget.onLoadMore != null) {
              //                           //       await widget.onLoadMore!(
              //                           //           widget.itemList.length,
              //                           //           widget.currentDataLimit);
              //                           //       Navigator.of(context).pop();
              //                           //       _menuKey.currentState!
              //                           //           .showButtonMenu();
              //                           //     }
              //                           //     return true;
              //                           ListView.builder(
              //                             physics:
              //                                 const BouncingScrollPhysics(),
              //                             shrinkWrap: true,
              //                             itemCount: _tempSearchedList.length,
              //                             itemBuilder: (context, i) =>
              //                                 PopupMenuItem<DropdownItemModel>(
              //                                     padding: Dimens.edgeInsets0,
              //                                     value: _tempSearchedList[i],
              //                                     enabled: false,
              //                                     child: InkWell(
              //                                       onTap: widget
              //                                               .isMultipleSelctionEnable
              //                                           ? () {
              //                                               if (widget
              //                                                       .multipleSelectedList !=
              //                                                   null) {
              //                                                 if (!widget
              //                                                     .multipleSelectedList!
              //                                                     .any(
              //                                                   (element) =>
              //                                                       element.name
              //                                                           .toLowerCase() ==
              //                                                       _tempSearchedList[
              //                                                               i]
              //                                                           .name
              //                                                           .toLowerCase(),
              //                                                 )) {
              //                                                   widget
              //                                                       .multipleSelectedList!
              //                                                       .add(
              //                                                           _tempSearchedList[
              //                                                               i]);
              //                                                   setState(() {});
              //                                                 } else {
              //                                                   var index = widget
              //                                                       .multipleSelectedList!
              //                                                       .indexWhere((element) =>
              //                                                           _tempSearchedList[i]
              //                                                               .name ==
              //                                                           element
              //                                                               .name);
              //                                                   widget
              //                                                       .multipleSelectedList!
              //                                                       .removeAt(
              //                                                           index);
              //                                                   setState(() {});
              //                                                 }
              //                                                 widget.onMultiSelected!(
              //                                                     widget
              //                                                         .multipleSelectedList!);
              //                                                 setState(() {});
              //                                               }
              //                                             }
              //                                           : () {
              //                                               widget.textEditingController
              //                                                       .text =
              //                                                   _tempSearchedList[
              //                                                           i]
              //                                                       .name;
              //                                               setState(() {});
              //                                               if (widget
              //                                                       .onChange !=
              //                                                   null) {
              //                                                 widget.onChange!(
              //                                                     _tempSearchedList[
              //                                                             i]
              //                                                         .name);
              //                                               }
              //                                               if (widget
              //                                                       .onSelected !=
              //                                                   null) {
              //                                                 widget.onSelected!(
              //                                                     _tempSearchedList[
              //                                                         i]);
              //                                               }
              //                                               Navigator.pop(
              //                                                   context);
              //                                             },
              //                                       child: Row(
              //                                         children: [
              //                                           widget.isMultipleSelctionEnable
              //                                               ? AbsorbPointer(
              //                                                   child: Checkbox(
              //                                                     side:
              //                                                         BorderSide(
              //                                                       color: ColorsValue
              //                                                           .colorD7D7D7,
              //                                                       width: Dimens
              //                                                           .one,
              //                                                     ),
              //                                                     shape: RoundedRectangleBorder(
              //                                                         borderRadius:
              //                                                             BorderRadius.circular(
              //                                                                 Dimens.four)),
              //                                                     activeColor:
              //                                                         ColorsValue
              //                                                             .primaryColor,
              //                                                     value: widget
              //                                                         .multipleSelectedList!
              //                                                         .any(
              //                                                       (element) =>
              //                                                           element
              //                                                               .name
              //                                                               .toLowerCase() ==
              //                                                           _tempSearchedList[i]
              //                                                               .name
              //                                                               .toLowerCase(),
              //                                                     ),
              //                                                     onChanged:
              //                                                         (val) {},
              //                                                   ),
              //                                                 )
              //                                               : Dimens.box0,
              //                                           DropdownMenuItem(
              //                                             value:
              //                                                 _tempSearchedList[
              //                                                         i]
              //                                                     .name,
              //                                             child: Container(
              //                                               child: widget
              //                                                       .isSubTitle
              //                                                   ? ListTile(
              //                                                       title: _tempSearchedList[i].role?.isNotEmpty ??
              //                                                               false
              //                                                           ? Text(
              //                                                               '${_tempSearchedList[i].name} (${_tempSearchedList[i].role})',
              //                                                               style:
              //                                                                   Styles.black40014,
              //                                                             )
              //                                                           : Text(
              //                                                               '${_tempSearchedList[i].name}',
              //                                                               style:
              //                                                                   Styles.black40014,
              //                                                             ),
              //                                                       subtitle:
              //                                                           Column(
              //                                                         crossAxisAlignment:
              //                                                             CrossAxisAlignment
              //                                                                 .start,
              //                                                         children: [
              //                                                           if (_tempSearchedList[i].email?.isNotEmpty ??
              //                                                               false) ...[
              //                                                             Text(
              //                                                               '${_tempSearchedList[i].email} ',
              //                                                               style:
              //                                                                   Styles.grey9BA70014,
              //                                                             ),
              //                                                           ],
              //                                                           if (_tempSearchedList[i].phone?.isNotEmpty ??
              //                                                               false) ...[
              //                                                             _tempSearchedList[i].phone == null
              //                                                                 ? Dimens.box0
              //                                                                 : Dimens.boxHeight2,
              //                                                             _tempSearchedList[i].phone == null
              //                                                                 ? Container()
              //                                                                 : Text(
              //                                                                     '${_tempSearchedList[i].phone}',
              //                                                                     style: Styles.grey9BA70014,
              //                                                                   ),
              //                                                           ],
              //                                                           Divider(
              //                                                             thickness:
              //                                                                 Dimens.one,
              //                                                           )
              //                                                         ],
              //                                                       ),
              //                                                     )
              //                                                   : Column(
              //                                                       crossAxisAlignment:
              //                                                           CrossAxisAlignment
              //                                                               .start,
              //                                                       children: [
              //                                                         Padding(
              //                                                           padding: EdgeInsets.symmetric(
              //                                                               vertical:
              //                                                                   Dimens.nine,
              //                                                               horizontal: Dimens.sixteen),
              //                                                           child:
              //                                                               Text(
              //                                                             _tempSearchedList[i]
              //                                                                 .name,
              //                                                             style:
              //                                                                 Styles.black40014,
              //                                                           ),
              //                                                         ),
              //                                                         // Check if it's not the last item
              //                                                         if (i <
              //                                                             _tempSearchedList.length -
              //                                                                 1) ...[
              //                                                           Dimens
              //                                                               .boxHeight5,
              //                                                           Container(
              //                                                             width:
              //                                                                 Dimens.fourHunderFifty,
              //                                                             height:
              //                                                                 Dimens.one,
              //                                                             color:
              //                                                                 ColorsValue.colorD7D7D7,
              //                                                           )
              //                                                         ]
              //                                                       ],
              //                                                     ),
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     )),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                   )
              //                 ]
              //               : [
              //                   PopupMenuItem(
              //                     padding: Dimens.edgeInsets0,
              //                     onTap: null,
              //                     enabled: false,
              //                     child: StatefulBuilder(
              //                       builder: (context, setState) => Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.end,
              //                         children: [
              //                           if (widget.itemList.length > 4 &&
              //                               !widget.isCustomSearchEnable) ...[
              //                             Padding(
              //                               padding: EdgeInsets.symmetric(
              //                                   horizontal: Dimens.twenty,
              //                                   vertical: Dimens.ten),
              //                               child: Row(
              //                                 children: [
              //                                   Expanded(
              //                                     child: FormFieldWidget(
              //                                       hintText: 'search'.tr,
              //                                       fieldWidth: widget
              //                                               .fieldWidth ??
              //                                           Dimens.fourHunderFifty,
              //                                       // suffixIcon: InkWell(
              //                                       //   onTap: () {},
              //                                       //   child: Icon(
              //                                       //     Icons.close,
              //                                       //     size: Dimens.twenty,
              //                                       //     color: Colors.grey.shade600,
              //                                       //   ),
              //                                       // ),
              //                                       onChange: (value) {
              //                                         setState(
              //                                           () {
              //                                             _tempSearchedList = List.from(widget
              //                                                 .itemList
              //                                                 .where((DropdownItemModel
              //                                                         string) =>
              //                                                     string.name
              //                                                         .toLowerCase()
              //                                                         .contains(
              //                                                             value
              //                                                                 .toLowerCase()))
              //                                                 .toList());
              //                                           },
              //                                         );
              //                                       },
              //                                     ),
              //                                   ),
              //                                   if (widget
              //                                       .isMultipleSelctionEnable) ...[
              //                                     Dimens.boxWidth10,
              //                                     PopupMenuItem(
              //                                       value: null,
              //                                       onTap: () {
              //                                         if (widget
              //                                                 .onMultiSelected !=
              //                                             null) {
              //                                           widget.onMultiSelected!(
              //                                               []);
              //                                         }
              //                                       },
              //                                       child: Padding(
              //                                         padding: Dimens
              //                                             .edgeInsets0_0_20_0,
              //                                         child: Text(
              //                                           'clearAll'.tr,
              //                                           style: Styles
              //                                               .mediumPrimary16,
              //                                         ),
              //                                       ),
              //                                     )
              //                                   ],
              //                                 ],
              //                               ),
              //                             ),
              //                           ],
              //                           ListView.builder(
              //                             shrinkWrap: true,
              //                             itemCount: _tempSearchedList.length,
              //                             itemBuilder: (context, i) => PopupMenuItem<
              //                                     DropdownItemModel>(
              //                                 value: _tempSearchedList[i],
              //                                 enabled: false,
              //                                 child: InkWell(
              //                                   onTap: widget
              //                                           .isMultipleSelctionEnable
              //                                       ? () {
              //                                           if (widget
              //                                                   .multipleSelectedList !=
              //                                               null) {
              //                                             if (!widget
              //                                                 .multipleSelectedList!
              //                                                 .any(
              //                                               (element) =>
              //                                                   element.name
              //                                                       .toLowerCase() ==
              //                                                   _tempSearchedList[
              //                                                           i]
              //                                                       .name
              //                                                       .toLowerCase(),
              //                                             )) {
              //                                               widget
              //                                                   .multipleSelectedList!
              //                                                   .add(
              //                                                       _tempSearchedList[
              //                                                           i]);
              //                                               setState(() {});
              //                                             } else {
              //                                               var index = widget
              //                                                   .multipleSelectedList!
              //                                                   .indexWhere((element) =>
              //                                                       _tempSearchedList[
              //                                                               i]
              //                                                           .name ==
              //                                                       element
              //                                                           .name);
              //                                               widget
              //                                                   .multipleSelectedList!
              //                                                   .removeAt(
              //                                                       index);
              //                                               setState(() {});
              //                                             }
              //                                             widget.onMultiSelected!(
              //                                                 widget
              //                                                     .multipleSelectedList!);
              //                                             setState(() {});
              //                                           }
              //                                         }
              //                                       : () {
              //                                           widget.textEditingController
              //                                                   .text =
              //                                               _tempSearchedList[i]
              //                                                   .name;
              //                                           setState(() {});
              //                                           if (widget.onChange !=
              //                                               null) {
              //                                             widget.onChange!(
              //                                                 _tempSearchedList[
              //                                                         i]
              //                                                     .name);
              //                                           }
              //                                           if (widget.onSelected !=
              //                                               null) {
              //                                             widget.onSelected!(
              //                                                 _tempSearchedList[
              //                                                     i]);
              //                                           }
              //                                           Navigator.pop(context);
              //                                         },
              //                                   child: Row(
              //                                     children: [
              //                                       widget.isMultipleSelctionEnable
              //                                           ? AbsorbPointer(
              //                                               child: Checkbox(
              //                                                 side: BorderSide(
              //                                                   color: ColorsValue
              //                                                       .colorD7D7D7,
              //                                                   width:
              //                                                       Dimens.one,
              //                                                 ),
              //                                                 shape: RoundedRectangleBorder(
              //                                                     borderRadius:
              //                                                         BorderRadius.circular(
              //                                                             Dimens
              //                                                                 .four)),
              //                                                 activeColor:
              //                                                     ColorsValue
              //                                                         .primaryColor,
              //                                                 value: widget
              //                                                     .multipleSelectedList!
              //                                                     .any(
              //                                                   (element) =>
              //                                                       element.name
              //                                                           .toLowerCase() ==
              //                                                       _tempSearchedList[
              //                                                               i]
              //                                                           .name
              //                                                           .toLowerCase(),
              //                                                 ),
              //                                                 onChanged:
              //                                                     (val) {},
              //                                               ),
              //                                             )
              //                                           : Dimens.box0,
              //                                       DropdownMenuItem(
              //                                         value:
              //                                             _tempSearchedList[i]
              //                                                 .name,
              //                                         child: Container(
              //                                           child: widget.isSubTitle
              //                                               ? ListTile(
              //                                                   title: _tempSearchedList[i]
              //                                                               .role
              //                                                               ?.isNotEmpty ??
              //                                                           false
              //                                                       ? Text(
              //                                                           '${_tempSearchedList[i].name} (${_tempSearchedList[i].role})',
              //                                                           style: Styles
              //                                                               .black40014,
              //                                                         )
              //                                                       : Text(
              //                                                           '${_tempSearchedList[i].name}',
              //                                                           style: Styles
              //                                                               .black40014,
              //                                                         ),
              //                                                   subtitle:
              //                                                       Column(
              //                                                     crossAxisAlignment:
              //                                                         CrossAxisAlignment
              //                                                             .start,
              //                                                     children: [
              //                                                       if (_tempSearchedList[i]
              //                                                               .email
              //                                                               ?.isNotEmpty ??
              //                                                           false) ...[
              //                                                         Text(
              //                                                           '${_tempSearchedList[i].email} ',
              //                                                           style: Styles
              //                                                               .grey9BA70014,
              //                                                         ),
              //                                                       ],
              //                                                       if (_tempSearchedList[i]
              //                                                               .phone
              //                                                               ?.isNotEmpty ??
              //                                                           false) ...[
              //                                                         _tempSearchedList[i].phone ==
              //                                                                 null
              //                                                             ? Dimens
              //                                                                 .box0
              //                                                             : Dimens
              //                                                                 .boxHeight2,
              //                                                         _tempSearchedList[i].phone ==
              //                                                                 null
              //                                                             ? Container()
              //                                                             : Text(
              //                                                                 '${_tempSearchedList[i].phone}',
              //                                                                 style: Styles.grey9BA70014,
              //                                                               ),
              //                                                       ],
              //                                                       Divider(
              //                                                         thickness:
              //                                                             Dimens
              //                                                                 .one,
              //                                                       )
              //                                                     ],
              //                                                   ),
              //                                                 )
              //                                               : Text(
              //                                                   _tempSearchedList[
              //                                                           i]
              //                                                       .name,
              //                                                   style: Styles
              //                                                       .black40014,
              //                                                 ),
              //                                         ),
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 )

              //                                 //  ListTile(
              //                                 //   onTap: widget
              //                                 //           .isMultipleSelctionEnable
              //                                 //       ? () {
              //                                 //           if (widget
              //                                 //                   .multipleSelectedList !=
              //                                 //               null) {
              //                                 //             if (!widget
              //                                 //                 .multipleSelectedList!
              //                                 //                 .any(
              //                                 //               (element) =>
              //                                 //                   element.name
              //                                 //                       .toLowerCase() ==
              //                                 //                   _tempSearchedList[
              //                                 //                           i]
              //                                 //                       .name
              //                                 //                       .toLowerCase(),
              //                                 //             )) {
              //                                 //               widget
              //                                 //                   .multipleSelectedList!
              //                                 //                   .add(
              //                                 //                       _tempSearchedList[
              //                                 //                           i]);
              //                                 //               setState(() {});
              //                                 //             } else {
              //                                 //               var index = widget
              //                                 //                   .multipleSelectedList!
              //                                 //                   .indexWhere((element) =>
              //                                 //                       _tempSearchedList[
              //                                 //                               i]
              //                                 //                           .name ==
              //                                 //                       element.name);
              //                                 //               widget
              //                                 //                   .multipleSelectedList!
              //                                 //                   .removeAt(index);
              //                                 //               setState(() {});
              //                                 //             }
              //                                 //             widget.onMultiSelected!(
              //                                 //                 widget
              //                                 //                     .multipleSelectedList!);
              //                                 //             setState(() {});
              //                                 //           }
              //                                 //         }
              //                                 //       : () {
              //                                 //           widget.textEditingController
              //                                 //                   .text =
              //                                 //               _tempSearchedList[i]
              //                                 //                   .name;
              //                                 //           setState(() {});
              //                                 //           if (widget.onChange !=
              //                                 //               null) {
              //                                 //             widget.onChange!(
              //                                 //                 _tempSearchedList[i]
              //                                 //                     .name);
              //                                 //           }
              //                                 //           if (widget.onSelected !=
              //                                 //               null) {
              //                                 //             widget.onSelected!(
              //                                 //                 _tempSearchedList[
              //                                 //                     i]);
              //                                 //           }
              //                                 //           Navigator.pop(context);
              //                                 //         },
              //                                 //   contentPadding:
              //                                 //       EdgeInsets.symmetric(
              //                                 //           horizontal:
              //                                 //               Dimens.sixTeen),
              //                                 //   minVerticalPadding: 0,
              //                                 //   title: DropdownMenuItem(
              //                                 //     value:
              //                                 //         _tempSearchedList[i].name,
              //                                 //     child: Container(
              //                                 //       child: widget.isSubTitle
              //                                 //           ? ListTile(
              //                                 //               isThreeLine: true,
              //                                 //               title: _tempSearchedList[
              //                                 //                               i]
              //                                 //                           .role
              //                                 //                           ?.isNotEmpty ??
              //                                 //                       false
              //                                 //                   ? Text(
              //                                 //                       '${_tempSearchedList[i].name} (${_tempSearchedList[i].role})',
              //                                 //                       style: Styles
              //                                 //                           .black40014,
              //                                 //                     )
              //                                 //                   : Text(
              //                                 //                       '${_tempSearchedList[i].name}',
              //                                 //                       style: Styles
              //                                 //                           .black40014,
              //                                 //                     ),
              //                                 //               subtitle: Column(
              //                                 //                 crossAxisAlignment:
              //                                 //                     CrossAxisAlignment
              //                                 //                         .start,
              //                                 //                 children: [
              //                                 //                   if (_tempSearchedList[
              //                                 //                               i]
              //                                 //                           .email
              //                                 //                           ?.isNotEmpty ??
              //                                 //                       false) ...[
              //                                 //                     Text(
              //                                 //                       '${_tempSearchedList[i].email} ',
              //                                 //                       style: Styles
              //                                 //                           .grey9BA70014,
              //                                 //                     ),
              //                                 //                   ],
              //                                 //                   if (_tempSearchedList[
              //                                 //                               i]
              //                                 //                           .phone
              //                                 //                           ?.isNotEmpty ??
              //                                 //                       false) ...[
              //                                 //                     _tempSearchedList[i]
              //                                 //                                 .phone ==
              //                                 //                             null
              //                                 //                         ? Dimens
              //                                 //                             .box0
              //                                 //                         : Dimens
              //                                 //                             .boxHeight2,
              //                                 //                     _tempSearchedList[i]
              //                                 //                                 .phone ==
              //                                 //                             null
              //                                 //                         ? Container()
              //                                 //                         : Text(
              //                                 //                             '${_tempSearchedList[i].phone}',
              //                                 //                             style: Styles
              //                                 //                                 .grey9BA70014,
              //                                 //                           ),
              //                                 //                   ],
              //                                 //                   Divider(
              //                                 //                     thickness:
              //                                 //                         Dimens.one,
              //                                 //                   )
              //                                 //                 ],
              //                                 //               ),
              //                                 //             )
              //                                 //           : Text(
              //                                 //               _tempSearchedList[i]
              //                                 //                   .name,
              //                                 //               style: Styles
              //                                 //                   .black40014,
              //                                 //             ),
              //                                 //     ),
              //                                 //   ),
              //                                 //   trailing: widget
              //                                 //           .isMultipleSelctionEnable
              //                                 //       ? AbsorbPointer(
              //                                 //           child: Checkbox(
              //                                 //             activeColor: ColorsValue
              //                                 //                 .primaryColor,
              //                                 //             value: widget
              //                                 //                 .multipleSelectedList!
              //                                 //                 .any(
              //                                 //               (element) =>
              //                                 //                   element.name
              //                                 //                       .toLowerCase() ==
              //                                 //                   _tempSearchedList[
              //                                 //                           i]
              //                                 //                       .name
              //                                 //                       .toLowerCase(),
              //                                 //             ),
              //                                 //             onChanged: (val) {},
              //                                 //           ),
              //                                 //         )
              //                                 //       : Dimens.box0,
              //                                 // ),

              //                                 ),
              //                           ),
              //                         ],
              //                       ),
              //                     ),
              //                   )
              //                 ];
              //     },
              //   ),
              // ),
            ),
          ),

          // SizedBox(
          //   width: widget.fieldWidth ?? double.infinity,
          //   child: CustomSearchableDropDown(
          //     textEditingController: widget.textEditingController,
          //     items: widget.itemList,
          //     isSubTitle: widget.isSubTitle,
          //     onChanged: (val) {
          //       if (widget.onSelected != null) {
          //         widget.onSelected!(val);
          //       }
          //     },
          //     hintText: widget.hintText,
          //     titleText: widget.titleText,
          //     isMandatoryfield: widget.isMandatoryfield,
          //     titleTextStyle: widget.titleTextStyle ?? Styles.mediumGrey16,
          //     fieldWidth: widget.fieldWidth ?? Dimens.fourHunderFifty,
          //     errorText: widget.errorText,
          //     formEnableBorder:
          //         widget.formEnableBorder ?? Styles.outlineBorderRadius10,
          //     formBorder:
          //         widget.formBorder ?? Styles.outlineBorderEnableRadius10,
          //     formStyle: widget.formStyle,
          //     errorBorder: widget.errorBorder,
          //     errorStyle: widget.errorStyle,
          //     fieldHeight: widget.fieldHeight,
          //     height: widget.height,
          //     hintStyle: widget.hintStyle,
          //     isMultipleSelctionEnable: widget.isMultipleSelctionEnable,
          //     maxLines: widget.maxLines,
          //     multipleSelectedList: widget.multipleSelectedList,
          //     onMultiSelected: widget.onMultiSelected,
          //     titleTextColor: widget.titleTextColor,
          //     isReadOnly: widget.isReadOnly,
          //     onTap: widget.onTap,
          //     isClearButton: widget.isClearButton,
          //     onClearField: widget.onClearField,
          //   ),
          // ),
          // if (widget.multipleSelectedList != null &&
          //     widget.multipleSelectedList!.isNotEmpty &&
          //     widget.isMultipleSelctionEnable &&
          //     widget.customWidget == null) ...[
          //   Dimens.boxHeight10,
          //   Wrap(
          //     spacing: Responsive.isMobile(context)
          //         ? Dimens.twenty
          //         : Responsive.isTablet(context)
          //             ? Dimens.five
          //             : Dimens.five,
          //     runSpacing: Dimens.ten,
          //     children: List.generate(
          //       widget.multipleSelectedList!.length,
          //       (index) => InkWell(
          //         onTap: () {
          //           if (!widget.isReadOnly) {
          //             widget.multipleSelectedList!.removeAt(index);
          //             if (widget.onMultiSelected != null) {
          //               widget.onMultiSelected!(widget.multipleSelectedList!);
          //             }
          //           }
          //         },
          //         child: Container(
          //           padding: Dimens.edgeInsets5,
          //           decoration: BoxDecoration(
          //               border: Border.all(color: ColorsValue.primaryColor),
          //               borderRadius: BorderRadius.circular(Dimens.eight)),
          //           child: Padding(
          //             padding: Dimens.edgeInsets8_2_8_2,
          //             child: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 Flexible(
          //                   child: Text(
          //                     widget.multipleSelectedList![index].name,
          //                     style: Responsive.isMobile(context)
          //                         ? Styles.normalPrimary14
          //                         : Styles.normalPrimary12,
          //                   ),
          //                 ),
          //                 Dimens.boxWidth10,
          //                 if (!widget.isReadOnly) ...[
          //                   Icon(
          //                     Icons.close,
          //                     color: ColorsValue.colorsAEAEAE,
          //                     size: Dimens.twelve,
          //                   )
          //                   // Icon(
          //                   //   Icons.cancel_outlined,
          //                   //   color: ColorsValue.redColor,
          //                   //   size: Dimens.ten,
          //                   // )
          //                 ],
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ],
          if (widget.errorText != null)
            Column(
              children: [
                Text(
                  '${widget.errorText}',
                  style: Styles.errorStyle,
                ),
                Dimens.boxHeight5,
              ],
            ),
        ],
      );
}






/// for single selection
// import 'package:dropdown_search/dropdown_search.dart';
// import 'package:chatnest/app/app.dart';
// import 'package:chatnest/domain/domain.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';

// /// A dropdown textfield widget that where you can type to search
// /// from the list of items
// class CustomDropdownSearch extends StatefulWidget {
//   CustomDropdownSearch(
//       {Key? key,
//       this.focusNode,
//       this.autoFocus = false,
//       required this.textEditingController,
//       this.isObscureText = false,
//       this.obscureCharacter = ' ',
//       this.textCapitalization = TextCapitalization.none,
//       this.isFilled,
//       this.contentPadding,
//       this.fillColor,
//       this.hintText,
//       this.hintStyle,
//       this.errorStyle,
//       this.formBorder,
//       this.formEnableBorder,
//       this.errorBorder,
//       this.errorText,
//       this.suffixIcon,
//       this.prefixIcon,
//       this.textInputAction = TextInputAction.done,
//       this.textInputType = TextInputType.text,
//       this.formStyle,
//       this.isReadOnly = false,
//       this.onTap,
//       this.maxLines = 1,
//       this.maxLength,
//       this.fieldHeight,
//       this.fieldWidth,
//       this.height,
//       this.initialValue,
//       required this.itemList,
//       this.onChange,
//       this.onSelected,
//       this.isMultipleSelctionEnable = false,
//       this.multipleSelectedList,
//       this.onMultiSelected,
//       this.isClearButton = false,
//       this.onClearField,
//       this.isSubTitle = false,
//       this.isCustomSearchEnable = false,
//       this.customWidget,
//       this.borderRadius = false,
//       this.titleIcon,
//       this.isNotShowSearchBar = false,
//       this.isHandTool = false,
//       this.isAdditionalErrorText = false,
//       this.currentDataLimit = 10,
//       this.totalData = 0,
//       this.onLoadMore,
//       this.popUpMenuBorderRadius,
//       this.isPopUpMenuOpen = false})
//       : super(key: key);

//   final FocusNode? focusNode;
//   final bool autoFocus;
//   final TextEditingController textEditingController;
//   final bool isObscureText;
//   final String obscureCharacter;
//   final TextCapitalization textCapitalization;
//   final bool? isFilled;
//   final int? maxLength;
//   final EdgeInsets? contentPadding;
//   final Color? fillColor;
//   final String? hintText;
//   final TextStyle? hintStyle;
//   final TextStyle? errorStyle;
//   final OutlineInputBorder? formBorder;
//   final OutlineInputBorder? formEnableBorder;
//   final OutlineInputBorder? errorBorder;
//   final String? errorText;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;
//   final TextInputAction textInputAction;
//   final TextInputType textInputType;
//   final TextStyle? formStyle;
//   final bool isMultipleSelctionEnable;
//   final List<DropdownItemModel>? multipleSelectedList;
//   final bool isPopUpMenuOpen;

//   final bool isReadOnly;
//   final Function()? onTap;
//   final int? maxLines;
//   final double? fieldHeight;
//   final double? fieldWidth;
//   final double? height;
//   final String? initialValue;
//   final List<DropdownItemModel> itemList;
//   final Function(String value)? onChange;
//   final Function(DropdownItemModel value)? onSelected;
//   final Function(List<DropdownItemModel> value)? onMultiSelected;
//   final bool isClearButton;
//   final Function()? onClearField;
//   final bool isSubTitle;
//   final bool isCustomSearchEnable;
//   final Widget? customWidget;
//   final bool? borderRadius;
//   final double? popUpMenuBorderRadius;
//   final Widget? titleIcon;
//   final bool isNotShowSearchBar;
//   final bool isAdditionalErrorText;
//   final bool isHandTool;
//   final int currentDataLimit;
//   final int totalData;
//   final Future<void> Function(int currentSkipLimit, int currentLimit)?
//       onLoadMore;

//   @override
//   State<CustomDropdownSearch> createState() => _CustomDropdownSearchState();
// }

// class _CustomDropdownSearchState extends State<CustomDropdownSearch> {
//   @override
//   Widget build(BuildContext context) => Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: widget.fieldWidth ?? double.infinity,
//             child: LayoutBuilder(
//               key: UniqueKey(),
//               builder: (BuildContext context, BoxConstraints constraints) =>
//                   Theme(
//                 data: ThemeData(
//                     hoverColor: ColorsValue.transparent,
//                     focusColor: ColorsValue.transparent,
//                     highlightColor: ColorsValue.transparent,
//                     dividerColor: ColorsValue.grey),
//                 child: SizedBox(
//                   height: widget.fieldHeight ?? Dimens.fifty,
//                   child: widget.isMultipleSelctionEnable
//                       ? DropdownSearch.multiSelection(
//                           popupProps: PopupPropsMultiSelection.menu(
//                               scrollbarProps:
//                                   const ScrollbarProps(thickness: 0),
//                               menuProps: const MenuProps(
//                                   backgroundColor: ColorsValue.whiteColor),
//                               constraints: BoxConstraints(
//                                   minWidth:
//                                       widget.fieldWidth ?? constraints.maxWidth,
//                                   maxWidth:
//                                       widget.fieldWidth ?? constraints.maxWidth,
//                                   maxHeight: Dimens.threeHundred),
//                               selectionWidget: (context, item, isSelected) =>
//                                   Checkbox(
//                                     shape: RoundedRectangleBorder(
//                                         borderRadius:
//                                             BorderRadius.circular(Dimens.four)),
//                                     value: isSelected,
//                                     onChanged: (val) {},
//                                   ),
//                               showSearchBox: true,
//                               searchDelay: const Duration(milliseconds: 0),
//                               searchFieldProps: TextFieldProps(
//                                 padding: Dimens.edgeInsets10,

//                                 // autocorrect: true,

//                                 mouseCursor: SystemMouseCursors.basic,

//                                 // key: const Key('text-form-field'),
//                                 textAlignVertical: TextAlignVertical.center,
//                                 textAlign: TextAlign.left,
//                                 cursorColor:
//                                     Get.theme.textSelectionTheme.cursorColor,
//                                 decoration: InputDecoration(
//                                   contentPadding: Dimens.edgeInsets10_0_10_0,
//                                   filled: true,
//                                   counterText: '',
//                                   fillColor: ColorsValue.textfildbackcolor,
//                                   border: Styles.outlineBorderEnableRadius8,
//                                   enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           width: Dimens.zero,
//                                           style: BorderStyle.none),
//                                       borderRadius:
//                                           BorderRadius.circular(Dimens.five)),
//                                   focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           width: Dimens.zero,
//                                           style: BorderStyle.none),
//                                       borderRadius:
//                                           BorderRadius.circular(Dimens.five)),
//                                   errorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           width: Dimens.zero,
//                                           style: BorderStyle.none),
//                                       borderRadius:
//                                           BorderRadius.circular(Dimens.five)),
//                                   focusedErrorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                           width: Dimens.zero,
//                                           style: BorderStyle.none),
//                                       borderRadius:
//                                           BorderRadius.circular(Dimens.five)),
//                                   hintStyle: Styles.black40014,
//                                   labelStyle: const TextStyle(
//                                       color: ColorsValue.greyColor),
//                                   hintText: 'search'.tr,
//                                 ),
//                                 style: Styles.black40014,
//                               ),
//                               itemBuilder: (context, item, isSelected) {
//                                 var data = widget.itemList
//                                     .where((element) => element.name == item)
//                                     .toList();
//                                 return Padding(
//                                   padding: Dimens.edgeInsets10,
//                                   child: Text(
//                                     data[0].name,
//                                     style: Styles.black40014,
//                                   ),
//                                 );
//                               }),
//                           items: widget.itemList.map((e) => e.name).toList(),
//                           dropdownDecoratorProps: DropDownDecoratorProps(
//                             baseStyle: Styles.black40014,
//                             dropdownSearchDecoration: InputDecoration(
//                               contentPadding:
//                                   widget.contentPadding ?? Dimens.edgeInsets10,
//                               // isHandTool: widget.isHandTool,
//                               hintText: widget.hintText,
//                               hintStyle: widget.hintStyle ?? Styles.black40014,
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       width: Dimens.zero,
//                                       style: BorderStyle.none),
//                                   borderRadius:
//                                       BorderRadius.circular(Dimens.five)),
//                               focusedBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       width: Dimens.zero,
//                                       style: BorderStyle.none),
//                                   borderRadius:
//                                       BorderRadius.circular(Dimens.five)),
//                               errorBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       width: Dimens.zero,
//                                       style: BorderStyle.none),
//                                   borderRadius:
//                                       BorderRadius.circular(Dimens.five)),
//                               focusedErrorBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       width: Dimens.zero,
//                                       style: BorderStyle.none),
//                                   borderRadius:
//                                       BorderRadius.circular(Dimens.five)),
//                               filled: true,
//                               fillColor: ColorsValue.textfildbackcolor,

//                               enabled: !widget.isCustomSearchEnable,

//                               border: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                       width: Dimens.zero,
//                                       style: BorderStyle.none),
//                                   borderRadius:
//                                       BorderRadius.circular(Dimens.five)),
//                               labelStyle: widget.formStyle,

//                               suffixIcon: Container(
//                                 color: Colors.pink,
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     if ((widget.isClearButton ||
//                                             widget.isCustomSearchEnable) &&
//                                         widget.textEditingController.text
//                                             .isNotEmpty)
//                                       IconButton(
//                                         icon: SvgPicture.asset(
//                                             AssetConstants.cancleicon),
//                                         splashRadius: 5,
//                                         onPressed: () {
//                                           widget.textEditingController.clear();
//                                           if (widget.isClearButton) {
//                                             if (widget.onClearField != null) {
//                                               widget.onClearField!();
//                                             }
//                                           } else if (widget
//                                               .isCustomSearchEnable) {
//                                             if (widget.onSelected != null) {
//                                               widget.onSelected!(
//                                                   const DropdownItemModel(
//                                                 name: '',
//                                                 id: '',
//                                               ));
//                                             }
//                                           }

//                                           setState(() {});
//                                         },
//                                       ),
//                                     widget.suffixIcon ??
//                                         const InkWell(
//                                             child: Icon(
//                                                 color: ColorsValue.blackColor,
//                                                 Icons
//                                                     .keyboard_arrow_down_outlined))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           onChanged: (value) {
//                             var _list = <DropdownItemModel>[];
//                             for (var data in value) {
//                               var index = widget.itemList.indexWhere(
//                                   (element) => element.name == data);
//                               if (!index.isNegative) {
//                                 _list.add(widget.itemList[index]);
//                               }
//                             }

//                             widget.onMultiSelected!(_list);
//                           },
//                           selectedItems: widget.multipleSelectedList
//                                   ?.map((e) => e.name)
//                                   .toList() ??
//                               [],
//                         )
//                       : SizedBox(
//                           height: widget.fieldHeight ?? Dimens.fourtyThree,
//                           child: DropdownSearch<String>(
//                             popupProps: PopupProps.menu(
//                                 scrollbarProps:
//                                     const ScrollbarProps(thickness: 0),
//                                 constraints: BoxConstraints(
//                                     minWidth: widget.fieldWidth ??
//                                         constraints.maxWidth,
//                                     maxWidth: widget.fieldWidth ??
//                                         constraints.maxWidth,
//                                     maxHeight: Dimens.threeHundred),
//                                 showSearchBox: true,
//                                 menuProps: const MenuProps(
//                                     backgroundColor: Colors.white),
//                                 searchDelay: const Duration(milliseconds: 0),
//                                 searchFieldProps: TextFieldProps(
//                                   padding: Dimens.edgeInsets10,

//                                   // autocorrect: true,

//                                   mouseCursor: SystemMouseCursors.basic,

//                                   // key: const Key('text-form-field'),
//                                   textAlignVertical: TextAlignVertical.center,
//                                   textAlign: TextAlign.left,
//                                   cursorColor:
//                                       Get.theme.textSelectionTheme.cursorColor,
//                                   decoration: InputDecoration(
//                                     contentPadding: Dimens.edgeInsets10_0_10_0,
//                                     filled: true,
//                                     counterText: '',
//                                     fillColor: ColorsValue.textfildbackcolor,
//                                     border: Styles.outlineBorderEnableRadius8,
//                                     enabledBorder: Styles.outlineBorderRadius8,
//                                     focusedBorder:
//                                         Styles.outlineBorderEnableRadius8,
//                                     errorBorder: Styles.errorBorderRadius8,
//                                     focusedErrorBorder:
//                                         Styles.outlineBorderEnableRadius8,
//                                     hintStyle: Styles.black40014,
//                                     labelStyle: const TextStyle(
//                                         color: ColorsValue.greyColor),
//                                     hintText: 'search'.tr,
//                                   ),
//                                   style: Styles.black40014,
//                                 ),
//                                 itemBuilder: (context, item, isSelected) {
//                                   var data = widget.itemList
//                                       .where((element) =>
//                                           '${element.name} ${element.id ?? ''}' ==
//                                           item)
//                                       .toList();

//                                   return Padding(
//                                     padding: Dimens.edgeInsets10,
//                                     child: Text(
//                                       data[0].name,
//                                       style: Styles.black40014,
//                                     ),
//                                   );
//                                 }),
//                             items: widget.itemList
//                                 .map((e) => '${e.name} ${e.id ?? ''}')
//                                 .toList(),
//                             dropdownDecoratorProps: DropDownDecoratorProps(
//                               baseStyle: Styles.black40014,
//                               dropdownSearchDecoration: InputDecoration(
//                                 hintMaxLines: 1,
//                                 contentPadding: widget.contentPadding ??
//                                     Dimens.edgeInsets10_0_10_0,
//                                 // isHandTool: widget.isHandTool,
//                                 hintText: widget.hintText,
//                                 hintStyle:
//                                     widget.hintStyle ?? Styles.black40014,
//                                 enabledBorder: widget.errorText != null
//                                     ? Styles.errorBorderRadius8
//                                     : Styles.outlineBorderRadius8,
//                                 focusedBorder: widget.errorText != null
//                                     ? Styles.errorBorderRadius8
//                                     : Styles.outlineBorderEnableRadius8,
//                                 errorBorder: Styles.errorBorderRadius8,
//                                 focusedErrorBorder: widget.errorText != null
//                                     ? Styles.errorBorderRadius8
//                                     : Styles.outlineBorderEnableRadius8,

//                                 errorText: widget.errorText != null
//                                     ? null
//                                     : widget.errorText,
//                                 enabled: !widget.isCustomSearchEnable,
//                                 border: widget.errorText != null
//                                     ? Styles.errorBorderRadius8
//                                     : widget.formBorder ??
//                                         Styles.outlineBorderEnableRadius10,
//                                 labelStyle: widget.formStyle,

//                                 suffixIcon: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     if ((widget.isClearButton ||
//                                             widget.isCustomSearchEnable) &&
//                                         widget.textEditingController.text
//                                             .isNotEmpty)
//                                       IconButton(
//                                         icon: SvgPicture.asset(
//                                             AssetConstants.cancleicon),
//                                         splashRadius: 5,
//                                         onPressed: () {
//                                           widget.textEditingController.clear();
//                                           if (widget.isClearButton) {
//                                             if (widget.onClearField != null) {
//                                               widget.onClearField!();
//                                             }
//                                           } else if (widget
//                                               .isCustomSearchEnable) {
//                                             if (widget.onSelected != null) {
//                                               widget.onSelected!(
//                                                   const DropdownItemModel(
//                                                 name: '',
//                                                 id: '',
//                                               ));
//                                             }
//                                           }

//                                           setState(() {});
//                                         },
//                                       ),
//                                     widget.suffixIcon ??
//                                         const InkWell(
//                                             child: Icon(
//                                                 color: ColorsValue.blackColor,
//                                                 Icons
//                                                     .keyboard_arrow_down_outlined))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                             onChanged: (value) {
//                               if (widget.onSelected != null) {
//                                 var data = widget.itemList
//                                     .where((element) =>
//                                         '${element.name} ${element.id ?? ''}' ==
//                                         value)
//                                     .toList();
//                                 widget.textEditingController.text =
//                                     data[0].name;
//                                 widget.onSelected!(data[0]);
//                               }
//                             },
//                             selectedItem:
//                                 widget.textEditingController.text.isNotEmpty
//                                     ? widget.textEditingController.text
//                                     : '',
//                           ),
//                         ),
//                 ),
//               ),
//               //   child: PopupMenuButton<DropdownItemModel>(
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.all(
//               //         Radius.circular((widget.borderRadius ?? false)
//               //             ? widget.popUpMenuBorderRadius ?? Dimens.fifteen
//               //             : Dimens.zero),
//               //       ),
//               //     ),
//               //     key: _menuKey,
//               //     enableFeedback: false,
//               //     onSelected: widget.onSelected,
//               //     splashRadius: 0,
//               //     color: ColorsValue.whiteColor,
//               //     tooltip: '',
//               //     offset:
//               //         widget.offset ?? Offset(Dimens.zero, Dimens.seventyTwo),
//               //     constraints: BoxConstraints(
//               //         minWidth: widget.fieldWidth ?? constraints.maxWidth,
//               //         maxWidth: widget.fieldWidth ?? constraints.maxWidth,
//               //         maxHeight: Dimens.threeHundred),
//               //     child: widget.customWidget != null
//               //         ? widget.customWidget!
//               //         : FormFieldWidget(
//               //             isHandTool: widget.isHandTool,
//               //             hintText: widget.hintText,
//               //             hintStyle: widget.hintStyle,
//               //             titleText: widget.titleText,
//               //             titleIcon: widget.titleIcon,
//               //             textEditingController: widget.textEditingController,
//               //             onTap: () {
//               //               if (!widget.isCustomSearchEnable) {
//               //                 _menuKey.currentState!.showButtonMenu();
//               //               }
//               //             },
//               //             titleTextStyle: widget.titleTextStyle ??
//               //                 Styles.normalBlack12Color1F2021,
//               //             fieldHeight: widget.fieldHeight,
//               //             fillColor: widget.fillColor,

//               //             fieldWidth:
//               //                 widget.fieldWidth ?? Dimens.fourHunderFifty,
//               //             errorText: widget.errorText,
//               //             isAdditionalErrorText: widget.isAdditionalErrorText,
//               //             isMandatoryfield: widget.isMandatoryfield,
//               //             isReadOnly: !widget.isCustomSearchEnable,
//               //             formEnableBorder: widget.formEnableBorder,
//               //             // ??
//               //             //     Styles.outlineBorderRadius10,
//               //             formBorder: widget.formBorder,
//               //             // ??
//               //             // Styles.outlineBorderEnableRadius10,
//               //             formStyle: widget.formStyle,
//               //             onChange: (val) {
//               //               if (widget.isCustomSearchEnable) {
//               //                 _debouncer.run(
//               //                   () {
//               //                     if (val.trim().isNotEmpty) {
//               //                       setState(
//               //                         () {
//               //                           var _list = <DropdownItemModel>[];
//               //                           for (var data in widget.itemList) {
//               //                             if (data.name
//               //                                 .toLowerCase()
//               //                                 .contains(val.toLowerCase())) {
//               //                               if (_list.length < 20) {
//               //                                 _list.add(data);
//               //                               }
//               //                             }
//               //                           }
//               //                           _tempSearchedList = List.from(_list);
//               //                         },
//               //                       );
//               //                       if (_tempSearchedList.isNotEmpty) {
//               //                         _menuKey.currentState!.showButtonMenu();
//               //                       }
//               //                     }
//               //                   },
//               //                 );
//               //               }
//               //             },
//               //             suffixIcon: Row(
//               //               mainAxisSize: MainAxisSize.min,
//               //               children: [
//               //                 if ((widget.isClearButton ||
//               //                         widget.isCustomSearchEnable) &&
//               //                     widget.textEditingController.text.isNotEmpty)
//               //                   IconButton(
//               //                     icon: SvgPicture.asset(
//               //                         AssetConstants.crossGrey),
//               //                     splashRadius: 5,
//               //                     onPressed: () {
//               //                       widget.textEditingController.clear();
//               //                       if (widget.isClearButton) {
//               //                         if (widget.onClearField != null) {
//               //                           widget.onClearField!();
//               //                         }
//               //                       } else if (widget.isCustomSearchEnable) {
//               //                         if (widget.onSelected != null) {
//               //                           widget.onSelected!(
//               //                               const DropdownItemModel(
//               //                                   name: '',
//               //                                   id: '',
//               //                                   email: '',
//               //                                   role: ''));
//               //                         }
//               //                       }

//               //                       setState(() {});
//               //                     },
//               //                   ),
//               //                 widget.suffixIcon ??
//               //                     const InkWell(
//               //                         child: Icon(
//               //                             color: ColorsValue.blackColor,
//               //                             Icons.keyboard_arrow_down_outlined))
//               //               ],
//               //             ),
//               //           ),
//               //     itemBuilder: (context) {
//               //       if (!widget.isCustomSearchEnable) {
//               //         _tempSearchedList = List.from(widget.itemList);
//               //       }
//               //       return widget.isReadOnly
//               //           ? []
//               //           : widget.isNotShowSearchBar
//               //               ? [
//               //                   PopupMenuItem(
//               //                     padding: Dimens.edgeInsets0,
//               //                     height: 0,
//               //                     onTap: null,
//               //                     enabled: false,
//               //                     child: StatefulBuilder(
//               //                       builder: (context, setState) => Column(
//               //                         crossAxisAlignment:
//               //                             CrossAxisAlignment.end,
//               //                         mainAxisSize: MainAxisSize.min,
//               //                         children: [
//               //                           //  isFinish: widget.itemList.length ==
//               //                           //       widget.totalData,
//               //                           //   textBuilder: (status) =>
//               //                           //       widget.itemList.length ==
//               //                           //               widget.totalData
//               //                           //           ? ''
//               //                           //           : 'Load More',
//               //                           //   onLoadMore: () async {
//               //                           //     if (widget.onLoadMore != null) {
//               //                           //       await widget.onLoadMore!(
//               //                           //           widget.itemList.length,
//               //                           //           widget.currentDataLimit);
//               //                           //       Navigator.of(context).pop();
//               //                           //       _menuKey.currentState!
//               //                           //           .showButtonMenu();
//               //                           //     }
//               //                           //     return true;
//               //                           ListView.builder(
//               //                             physics:
//               //                                 const BouncingScrollPhysics(),
//               //                             shrinkWrap: true,
//               //                             itemCount: _tempSearchedList.length,
//               //                             itemBuilder: (context, i) =>
//               //                                 PopupMenuItem<DropdownItemModel>(
//               //                                     padding: Dimens.edgeInsets0,
//               //                                     value: _tempSearchedList[i],
//               //                                     enabled: false,
//               //                                     child: InkWell(
//               //                                       onTap: widget
//               //                                               .isMultipleSelctionEnable
//               //                                           ? () {
//               //                                               if (widget
//               //                                                       .multipleSelectedList !=
//               //                                                   null) {
//               //                                                 if (!widget
//               //                                                     .multipleSelectedList!
//               //                                                     .any(
//               //                                                   (element) =>
//               //                                                       element.name
//               //                                                           .toLowerCase() ==
//               //                                                       _tempSearchedList[
//               //                                                               i]
//               //                                                           .name
//               //                                                           .toLowerCase(),
//               //                                                 )) {
//               //                                                   widget
//               //                                                       .multipleSelectedList!
//               //                                                       .add(
//               //                                                           _tempSearchedList[
//               //                                                               i]);
//               //                                                   setState(() {});
//               //                                                 } else {
//               //                                                   var index = widget
//               //                                                       .multipleSelectedList!
//               //                                                       .indexWhere((element) =>
//               //                                                           _tempSearchedList[i]
//               //                                                               .name ==
//               //                                                           element
//               //                                                               .name);
//               //                                                   widget
//               //                                                       .multipleSelectedList!
//               //                                                       .removeAt(
//               //                                                           index);
//               //                                                   setState(() {});
//               //                                                 }
//               //                                                 widget.onMultiSelected!(
//               //                                                     widget
//               //                                                         .multipleSelectedList!);
//               //                                                 setState(() {});
//               //                                               }
//               //                                             }
//               //                                           : () {
//               //                                               widget.textEditingController
//               //                                                       .text =
//               //                                                   _tempSearchedList[
//               //                                                           i]
//               //                                                       .name;
//               //                                               setState(() {});
//               //                                               if (widget
//               //                                                       .onChange !=
//               //                                                   null) {
//               //                                                 widget.onChange!(
//               //                                                     _tempSearchedList[
//               //                                                             i]
//               //                                                         .name);
//               //                                               }
//               //                                               if (widget
//               //                                                       .onSelected !=
//               //                                                   null) {
//               //                                                 widget.onSelected!(
//               //                                                     _tempSearchedList[
//               //                                                         i]);
//               //                                               }
//               //                                               Navigator.pop(
//               //                                                   context);
//               //                                             },
//               //                                       child: Row(
//               //                                         children: [
//               //                                           widget.isMultipleSelctionEnable
//               //                                               ? AbsorbPointer(
//               //                                                   child: Checkbox(
//               //                                                     side:
//               //                                                         BorderSide(
//               //                                                       color: ColorsValue
//               //                                                           .colorD7D7D7,
//               //                                                       width: Dimens
//               //                                                           .one,
//               //                                                     ),
//               //                                                     shape: RoundedRectangleBorder(
//               //                                                         borderRadius:
//               //                                                             BorderRadius.circular(
//               //                                                                 Dimens.four)),
//               //                                                     activeColor:
//               //                                                         ColorsValue
//               //                                                             .primaryColor,
//               //                                                     value: widget
//               //                                                         .multipleSelectedList!
//               //                                                         .any(
//               //                                                       (element) =>
//               //                                                           element
//               //                                                               .name
//               //                                                               .toLowerCase() ==
//               //                                                           _tempSearchedList[i]
//               //                                                               .name
//               //                                                               .toLowerCase(),
//               //                                                     ),
//               //                                                     onChanged:
//               //                                                         (val) {},
//               //                                                   ),
//               //                                                 )
//               //                                               : Dimens.box0,
//               //                                           DropdownMenuItem(
//               //                                             value:
//               //                                                 _tempSearchedList[
//               //                                                         i]
//               //                                                     .name,
//               //                                             child: Container(
//               //                                               child: widget
//               //                                                       .isSubTitle
//               //                                                   ? ListTile(
//               //                                                       title: _tempSearchedList[i].role?.isNotEmpty ??
//               //                                                               false
//               //                                                           ? Text(
//               //                                                               '${_tempSearchedList[i].name} (${_tempSearchedList[i].role})',
//               //                                                               style:
//               //                                                                   Styles.black40014,
//               //                                                             )
//               //                                                           : Text(
//               //                                                               '${_tempSearchedList[i].name}',
//               //                                                               style:
//               //                                                                   Styles.black40014,
//               //                                                             ),
//               //                                                       subtitle:
//               //                                                           Column(
//               //                                                         crossAxisAlignment:
//               //                                                             CrossAxisAlignment
//               //                                                                 .start,
//               //                                                         children: [
//               //                                                           if (_tempSearchedList[i].email?.isNotEmpty ??
//               //                                                               false) ...[
//               //                                                             Text(
//               //                                                               '${_tempSearchedList[i].email} ',
//               //                                                               style:
//               //                                                                   Styles.grey9BA70014,
//               //                                                             ),
//               //                                                           ],
//               //                                                           if (_tempSearchedList[i].phone?.isNotEmpty ??
//               //                                                               false) ...[
//               //                                                             _tempSearchedList[i].phone == null
//               //                                                                 ? Dimens.box0
//               //                                                                 : Dimens.boxHeight2,
//               //                                                             _tempSearchedList[i].phone == null
//               //                                                                 ? Container()
//               //                                                                 : Text(
//               //                                                                     '${_tempSearchedList[i].phone}',
//               //                                                                     style: Styles.grey9BA70014,
//               //                                                                   ),
//               //                                                           ],
//               //                                                           Divider(
//               //                                                             thickness:
//               //                                                                 Dimens.one,
//               //                                                           )
//               //                                                         ],
//               //                                                       ),
//               //                                                     )
//               //                                                   : Column(
//               //                                                       crossAxisAlignment:
//               //                                                           CrossAxisAlignment
//               //                                                               .start,
//               //                                                       children: [
//               //                                                         Padding(
//               //                                                           padding: EdgeInsets.symmetric(
//               //                                                               vertical:
//               //                                                                   Dimens.nine,
//               //                                                               horizontal: Dimens.sixteen),
//               //                                                           child:
//               //                                                               Text(
//               //                                                             _tempSearchedList[i]
//               //                                                                 .name,
//               //                                                             style:
//               //                                                                 Styles.black40014,
//               //                                                           ),
//               //                                                         ),
//               //                                                         // Check if it's not the last item
//               //                                                         if (i <
//               //                                                             _tempSearchedList.length -
//               //                                                                 1) ...[
//               //                                                           Dimens
//               //                                                               .boxHeight5,
//               //                                                           Container(
//               //                                                             width:
//               //                                                                 Dimens.fourHunderFifty,
//               //                                                             height:
//               //                                                                 Dimens.one,
//               //                                                             color:
//               //                                                                 ColorsValue.colorD7D7D7,
//               //                                                           )
//               //                                                         ]
//               //                                                       ],
//               //                                                     ),
//               //                                             ),
//               //                                           ),
//               //                                         ],
//               //                                       ),
//               //                                     )),
//               //                           )
//               //                         ],
//               //                       ),
//               //                     ),
//               //                   )
//               //                 ]
//               //               : [
//               //                   PopupMenuItem(
//               //                     padding: Dimens.edgeInsets0,
//               //                     onTap: null,
//               //                     enabled: false,
//               //                     child: StatefulBuilder(
//               //                       builder: (context, setState) => Column(
//               //                         crossAxisAlignment:
//               //                             CrossAxisAlignment.end,
//               //                         children: [
//               //                           if (widget.itemList.length > 4 &&
//               //                               !widget.isCustomSearchEnable) ...[
//               //                             Padding(
//               //                               padding: EdgeInsets.symmetric(
//               //                                   horizontal: Dimens.twenty,
//               //                                   vertical: Dimens.ten),
//               //                               child: Row(
//               //                                 children: [
//               //                                   Expanded(
//               //                                     child: FormFieldWidget(
//               //                                       hintText: 'search'.tr,
//               //                                       fieldWidth: widget
//               //                                               .fieldWidth ??
//               //                                           Dimens.fourHunderFifty,
//               //                                       // suffixIcon: InkWell(
//               //                                       //   onTap: () {},
//               //                                       //   child: Icon(
//               //                                       //     Icons.close,
//               //                                       //     size: Dimens.twenty,
//               //                                       //     color: Colors.grey.shade600,
//               //                                       //   ),
//               //                                       // ),
//               //                                       onChange: (value) {
//               //                                         setState(
//               //                                           () {
//               //                                             _tempSearchedList = List.from(widget
//               //                                                 .itemList
//               //                                                 .where((DropdownItemModel
//               //                                                         string) =>
//               //                                                     string.name
//               //                                                         .toLowerCase()
//               //                                                         .contains(
//               //                                                             value
//               //                                                                 .toLowerCase()))
//               //                                                 .toList());
//               //                                           },
//               //                                         );
//               //                                       },
//               //                                     ),
//               //                                   ),
//               //                                   if (widget
//               //                                       .isMultipleSelctionEnable) ...[
//               //                                     Dimens.boxWidth10,
//               //                                     PopupMenuItem(
//               //                                       value: null,
//               //                                       onTap: () {
//               //                                         if (widget
//               //                                                 .onMultiSelected !=
//               //                                             null) {
//               //                                           widget.onMultiSelected!(
//               //                                               []);
//               //                                         }
//               //                                       },
//               //                                       child: Padding(
//               //                                         padding: Dimens
//               //                                             .edgeInsets0_0_20_0,
//               //                                         child: Text(
//               //                                           'clearAll'.tr,
//               //                                           style: Styles
//               //                                               .mediumPrimary16,
//               //                                         ),
//               //                                       ),
//               //                                     )
//               //                                   ],
//               //                                 ],
//               //                               ),
//               //                             ),
//               //                           ],
//               //                           ListView.builder(
//               //                             shrinkWrap: true,
//               //                             itemCount: _tempSearchedList.length,
//               //                             itemBuilder: (context, i) => PopupMenuItem<
//               //                                     DropdownItemModel>(
//               //                                 value: _tempSearchedList[i],
//               //                                 enabled: false,
//               //                                 child: InkWell(
//               //                                   onTap: widget
//               //                                           .isMultipleSelctionEnable
//               //                                       ? () {
//               //                                           if (widget
//               //                                                   .multipleSelectedList !=
//               //                                               null) {
//               //                                             if (!widget
//               //                                                 .multipleSelectedList!
//               //                                                 .any(
//               //                                               (element) =>
//               //                                                   element.name
//               //                                                       .toLowerCase() ==
//               //                                                   _tempSearchedList[
//               //                                                           i]
//               //                                                       .name
//               //                                                       .toLowerCase(),
//               //                                             )) {
//               //                                               widget
//               //                                                   .multipleSelectedList!
//               //                                                   .add(
//               //                                                       _tempSearchedList[
//               //                                                           i]);
//               //                                               setState(() {});
//               //                                             } else {
//               //                                               var index = widget
//               //                                                   .multipleSelectedList!
//               //                                                   .indexWhere((element) =>
//               //                                                       _tempSearchedList[
//               //                                                               i]
//               //                                                           .name ==
//               //                                                       element
//               //                                                           .name);
//               //                                               widget
//               //                                                   .multipleSelectedList!
//               //                                                   .removeAt(
//               //                                                       index);
//               //                                               setState(() {});
//               //                                             }
//               //                                             widget.onMultiSelected!(
//               //                                                 widget
//               //                                                     .multipleSelectedList!);
//               //                                             setState(() {});
//               //                                           }
//               //                                         }
//               //                                       : () {
//               //                                           widget.textEditingController
//               //                                                   .text =
//               //                                               _tempSearchedList[i]
//               //                                                   .name;
//               //                                           setState(() {});
//               //                                           if (widget.onChange !=
//               //                                               null) {
//               //                                             widget.onChange!(
//               //                                                 _tempSearchedList[
//               //                                                         i]
//               //                                                     .name);
//               //                                           }
//               //                                           if (widget.onSelected !=
//               //                                               null) {
//               //                                             widget.onSelected!(
//               //                                                 _tempSearchedList[
//               //                                                     i]);
//               //                                           }
//               //                                           Navigator.pop(context);
//               //                                         },
//               //                                   child: Row(
//               //                                     children: [
//               //                                       widget.isMultipleSelctionEnable
//               //                                           ? AbsorbPointer(
//               //                                               child: Checkbox(
//               //                                                 side: BorderSide(
//               //                                                   color: ColorsValue
//               //                                                       .colorD7D7D7,
//               //                                                   width:
//               //                                                       Dimens.one,
//               //                                                 ),
//               //                                                 shape: RoundedRectangleBorder(
//               //                                                     borderRadius:
//               //                                                         BorderRadius.circular(
//               //                                                             Dimens
//               //                                                                 .four)),
//               //                                                 activeColor:
//               //                                                     ColorsValue
//               //                                                         .primaryColor,
//               //                                                 value: widget
//               //                                                     .multipleSelectedList!
//               //                                                     .any(
//               //                                                   (element) =>
//               //                                                       element.name
//               //                                                           .toLowerCase() ==
//               //                                                       _tempSearchedList[
//               //                                                               i]
//               //                                                           .name
//               //                                                           .toLowerCase(),
//               //                                                 ),
//               //                                                 onChanged:
//               //                                                     (val) {},
//               //                                               ),
//               //                                             )
//               //                                           : Dimens.box0,
//               //                                       DropdownMenuItem(
//               //                                         value:
//               //                                             _tempSearchedList[i]
//               //                                                 .name,
//               //                                         child: Container(
//               //                                           child: widget.isSubTitle
//               //                                               ? ListTile(
//               //                                                   title: _tempSearchedList[i]
//               //                                                               .role
//               //                                                               ?.isNotEmpty ??
//               //                                                           false
//               //                                                       ? Text(
//               //                                                           '${_tempSearchedList[i].name} (${_tempSearchedList[i].role})',
//               //                                                           style: Styles
//               //                                                               .black40014,
//               //                                                         )
//               //                                                       : Text(
//               //                                                           '${_tempSearchedList[i].name}',
//               //                                                           style: Styles
//               //                                                               .black40014,
//               //                                                         ),
//               //                                                   subtitle:
//               //                                                       Column(
//               //                                                     crossAxisAlignment:
//               //                                                         CrossAxisAlignment
//               //                                                             .start,
//               //                                                     children: [
//               //                                                       if (_tempSearchedList[i]
//               //                                                               .email
//               //                                                               ?.isNotEmpty ??
//               //                                                           false) ...[
//               //                                                         Text(
//               //                                                           '${_tempSearchedList[i].email} ',
//               //                                                           style: Styles
//               //                                                               .grey9BA70014,
//               //                                                         ),
//               //                                                       ],
//               //                                                       if (_tempSearchedList[i]
//               //                                                               .phone
//               //                                                               ?.isNotEmpty ??
//               //                                                           false) ...[
//               //                                                         _tempSearchedList[i].phone ==
//               //                                                                 null
//               //                                                             ? Dimens
//               //                                                                 .box0
//               //                                                             : Dimens
//               //                                                                 .boxHeight2,
//               //                                                         _tempSearchedList[i].phone ==
//               //                                                                 null
//               //                                                             ? Container()
//               //                                                             : Text(
//               //                                                                 '${_tempSearchedList[i].phone}',
//               //                                                                 style: Styles.grey9BA70014,
//               //                                                               ),
//               //                                                       ],
//               //                                                       Divider(
//               //                                                         thickness:
//               //                                                             Dimens
//               //                                                                 .one,
//               //                                                       )
//               //                                                     ],
//               //                                                   ),
//               //                                                 )
//               //                                               : Text(
//               //                                                   _tempSearchedList[
//               //                                                           i]
//               //                                                       .name,
//               //                                                   style: Styles
//               //                                                       .black40014,
//               //                                                 ),
//               //                                         ),
//               //                                       ),
//               //                                     ],
//               //                                   ),
//               //                                 )

//               //                                 //  ListTile(
//               //                                 //   onTap: widget
//               //                                 //           .isMultipleSelctionEnable
//               //                                 //       ? () {
//               //                                 //           if (widget
//               //                                 //                   .multipleSelectedList !=
//               //                                 //               null) {
//               //                                 //             if (!widget
//               //                                 //                 .multipleSelectedList!
//               //                                 //                 .any(
//               //                                 //               (element) =>
//               //                                 //                   element.name
//               //                                 //                       .toLowerCase() ==
//               //                                 //                   _tempSearchedList[
//               //                                 //                           i]
//               //                                 //                       .name
//               //                                 //                       .toLowerCase(),
//               //                                 //             )) {
//               //                                 //               widget
//               //                                 //                   .multipleSelectedList!
//               //                                 //                   .add(
//               //                                 //                       _tempSearchedList[
//               //                                 //                           i]);
//               //                                 //               setState(() {});
//               //                                 //             } else {
//               //                                 //               var index = widget
//               //                                 //                   .multipleSelectedList!
//               //                                 //                   .indexWhere((element) =>
//               //                                 //                       _tempSearchedList[
//               //                                 //                               i]
//               //                                 //                           .name ==
//               //                                 //                       element.name);
//               //                                 //               widget
//               //                                 //                   .multipleSelectedList!
//               //                                 //                   .removeAt(index);
//               //                                 //               setState(() {});
//               //                                 //             }
//               //                                 //             widget.onMultiSelected!(
//               //                                 //                 widget
//               //                                 //                     .multipleSelectedList!);
//               //                                 //             setState(() {});
//               //                                 //           }
//               //                                 //         }
//               //                                 //       : () {
//               //                                 //           widget.textEditingController
//               //                                 //                   .text =
//               //                                 //               _tempSearchedList[i]
//               //                                 //                   .name;
//               //                                 //           setState(() {});
//               //                                 //           if (widget.onChange !=
//               //                                 //               null) {
//               //                                 //             widget.onChange!(
//               //                                 //                 _tempSearchedList[i]
//               //                                 //                     .name);
//               //                                 //           }
//               //                                 //           if (widget.onSelected !=
//               //                                 //               null) {
//               //                                 //             widget.onSelected!(
//               //                                 //                 _tempSearchedList[
//               //                                 //                     i]);
//               //                                 //           }
//               //                                 //           Navigator.pop(context);
//               //                                 //         },
//               //                                 //   contentPadding:
//               //                                 //       EdgeInsets.symmetric(
//               //                                 //           horizontal:
//               //                                 //               Dimens.sixTeen),
//               //                                 //   minVerticalPadding: 0,
//               //                                 //   title: DropdownMenuItem(
//               //                                 //     value:
//               //                                 //         _tempSearchedList[i].name,
//               //                                 //     child: Container(
//               //                                 //       child: widget.isSubTitle
//               //                                 //           ? ListTile(
//               //                                 //               isThreeLine: true,
//               //                                 //               title: _tempSearchedList[
//               //                                 //                               i]
//               //                                 //                           .role
//               //                                 //                           ?.isNotEmpty ??
//               //                                 //                       false
//               //                                 //                   ? Text(
//               //                                 //                       '${_tempSearchedList[i].name} (${_tempSearchedList[i].role})',
//               //                                 //                       style: Styles
//               //                                 //                           .black40014,
//               //                                 //                     )
//               //                                 //                   : Text(
//               //                                 //                       '${_tempSearchedList[i].name}',
//               //                                 //                       style: Styles
//               //                                 //                           .black40014,
//               //                                 //                     ),
//               //                                 //               subtitle: Column(
//               //                                 //                 crossAxisAlignment:
//               //                                 //                     CrossAxisAlignment
//               //                                 //                         .start,
//               //                                 //                 children: [
//               //                                 //                   if (_tempSearchedList[
//               //                                 //                               i]
//               //                                 //                           .email
//               //                                 //                           ?.isNotEmpty ??
//               //                                 //                       false) ...[
//               //                                 //                     Text(
//               //                                 //                       '${_tempSearchedList[i].email} ',
//               //                                 //                       style: Styles
//               //                                 //                           .grey9BA70014,
//               //                                 //                     ),
//               //                                 //                   ],
//               //                                 //                   if (_tempSearchedList[
//               //                                 //                               i]
//               //                                 //                           .phone
//               //                                 //                           ?.isNotEmpty ??
//               //                                 //                       false) ...[
//               //                                 //                     _tempSearchedList[i]
//               //                                 //                                 .phone ==
//               //                                 //                             null
//               //                                 //                         ? Dimens
//               //                                 //                             .box0
//               //                                 //                         : Dimens
//               //                                 //                             .boxHeight2,
//               //                                 //                     _tempSearchedList[i]
//               //                                 //                                 .phone ==
//               //                                 //                             null
//               //                                 //                         ? Container()
//               //                                 //                         : Text(
//               //                                 //                             '${_tempSearchedList[i].phone}',
//               //                                 //                             style: Styles
//               //                                 //                                 .grey9BA70014,
//               //                                 //                           ),
//               //                                 //                   ],
//               //                                 //                   Divider(
//               //                                 //                     thickness:
//               //                                 //                         Dimens.one,
//               //                                 //                   )
//               //                                 //                 ],
//               //                                 //               ),
//               //                                 //             )
//               //                                 //           : Text(
//               //                                 //               _tempSearchedList[i]
//               //                                 //                   .name,
//               //                                 //               style: Styles
//               //                                 //                   .black40014,
//               //                                 //             ),
//               //                                 //     ),
//               //                                 //   ),
//               //                                 //   trailing: widget
//               //                                 //           .isMultipleSelctionEnable
//               //                                 //       ? AbsorbPointer(
//               //                                 //           child: Checkbox(
//               //                                 //             activeColor: ColorsValue
//               //                                 //                 .primaryColor,
//               //                                 //             value: widget
//               //                                 //                 .multipleSelectedList!
//               //                                 //                 .any(
//               //                                 //               (element) =>
//               //                                 //                   element.name
//               //                                 //                       .toLowerCase() ==
//               //                                 //                   _tempSearchedList[
//               //                                 //                           i]
//               //                                 //                       .name
//               //                                 //                       .toLowerCase(),
//               //                                 //             ),
//               //                                 //             onChanged: (val) {},
//               //                                 //           ),
//               //                                 //         )
//               //                                 //       : Dimens.box0,
//               //                                 // ),

//               //                                 ),
//               //                           ),
//               //                         ],
//               //                       ),
//               //                     ),
//               //                   )
//               //                 ];
//               //     },
//               //   ),
//               // ),
//             ),
//           ),

//           // SizedBox(
//           //   width: widget.fieldWidth ?? double.infinity,
//           //   child: CustomSearchableDropDown(
//           //     textEditingController: widget.textEditingController,
//           //     items: widget.itemList,
//           //     isSubTitle: widget.isSubTitle,
//           //     onChanged: (val) {
//           //       if (widget.onSelected != null) {
//           //         widget.onSelected!(val);
//           //       }
//           //     },
//           //     hintText: widget.hintText,
//           //     titleText: widget.titleText,
//           //     isMandatoryfield: widget.isMandatoryfield,
//           //     titleTextStyle: widget.titleTextStyle ?? Styles.mediumGrey16,
//           //     fieldWidth: widget.fieldWidth ?? Dimens.fourHunderFifty,
//           //     errorText: widget.errorText,
//           //     formEnableBorder:
//           //         widget.formEnableBorder ?? Styles.outlineBorderRadius10,
//           //     formBorder:
//           //         widget.formBorder ?? Styles.outlineBorderEnableRadius10,
//           //     formStyle: widget.formStyle,
//           //     errorBorder: widget.errorBorder,
//           //     errorStyle: widget.errorStyle,
//           //     fieldHeight: widget.fieldHeight,
//           //     height: widget.height,
//           //     hintStyle: widget.hintStyle,
//           //     isMultipleSelctionEnable: widget.isMultipleSelctionEnable,
//           //     maxLines: widget.maxLines,
//           //     multipleSelectedList: widget.multipleSelectedList,
//           //     onMultiSelected: widget.onMultiSelected,
//           //     titleTextColor: widget.titleTextColor,
//           //     isReadOnly: widget.isReadOnly,
//           //     onTap: widget.onTap,
//           //     isClearButton: widget.isClearButton,
//           //     onClearField: widget.onClearField,
//           //   ),
//           // ),
//           // if (widget.multipleSelectedList != null &&
//           //     widget.multipleSelectedList!.isNotEmpty &&
//           //     widget.isMultipleSelctionEnable &&
//           //     widget.customWidget == null) ...[
//           //   Dimens.boxHeight10,
//           //   Wrap(
//           //     spacing: Responsive.isMobile(context)
//           //         ? Dimens.twenty
//           //         : Responsive.isTablet(context)
//           //             ? Dimens.five
//           //             : Dimens.five,
//           //     runSpacing: Dimens.ten,
//           //     children: List.generate(
//           //       widget.multipleSelectedList!.length,
//           //       (index) => InkWell(
//           //         onTap: () {
//           //           if (!widget.isReadOnly) {
//           //             widget.multipleSelectedList!.removeAt(index);
//           //             if (widget.onMultiSelected != null) {
//           //               widget.onMultiSelected!(widget.multipleSelectedList!);
//           //             }
//           //           }
//           //         },
//           //         child: Container(
//           //           padding: Dimens.edgeInsets5,
//           //           decoration: BoxDecoration(
//           //               border: Border.all(color: ColorsValue.primaryColor),
//           //               borderRadius: BorderRadius.circular(Dimens.eight)),
//           //           child: Padding(
//           //             padding: Dimens.edgeInsets8_2_8_2,
//           //             child: Row(
//           //               mainAxisSize: MainAxisSize.min,
//           //               children: [
//           //                 Flexible(
//           //                   child: Text(
//           //                     widget.multipleSelectedList![index].name,
//           //                     style: Responsive.isMobile(context)
//           //                         ? Styles.normalPrimary14
//           //                         : Styles.normalPrimary12,
//           //                   ),
//           //                 ),
//           //                 Dimens.boxWidth10,
//           //                 if (!widget.isReadOnly) ...[
//           //                   Icon(
//           //                     Icons.close,
//           //                     color: ColorsValue.colorsAEAEAE,
//           //                     size: Dimens.twelve,
//           //                   )
//           //                   // Icon(
//           //                   //   Icons.cancel_outlined,
//           //                   //   color: ColorsValue.redColor,
//           //                   //   size: Dimens.ten,
//           //                   // )
//           //                 ],
//           //               ],
//           //             ),
//           //           ),
//           //         ),
//           //       ),
//           //     ),
//           //   ),
//           // ],
//           if (widget.isAdditionalErrorText == true && widget.errorText != null)
//             Column(
//               children: [
//                 Text(
//                   '${widget.errorText}',
//                   style: Styles.errorStyle,
//                 ),
//                 Dimens.boxHeight5,
//               ],
//             ),
//         ],
//       );
// }
