import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

/// A dropdown textfield widget that where you can type to search
/// from the list of items
class DropdownMultipleTree extends StatefulWidget {
  DropdownMultipleTree({
    Key? key,
    this.textEditingController,
    this.hintText,
    this.errorStyle,
    this.errorText,
    this.suffixIcon,
    this.prefixIcon,
    this.isReadOnly = false,
    required this.itemList,
    this.onChange,
    this.onSelected,
    this.onSelectedMainItemName,
    this.isMultipleSelctionEnable = false,
    this.multipleSelectedList,
    this.onMultiSelected,
    this.isClearButton = false,
    this.onClearField,
  }) : super(key: key);

  final TextEditingController? textEditingController;
  final String? hintText;
  final TextStyle? errorStyle;
  final String? errorText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool isMultipleSelctionEnable;
  final List<DropdownItemModel>? multipleSelectedList;

  final bool isReadOnly;
  final List<DropdownMultipleTreeModel> itemList;
  final Function(String value)? onChange;
  final Function(DropdownItemModel value)? onSelected;
  final Function(String value)? onSelectedMainItemName;
  final Function(List<DropdownItemModel> value)? onMultiSelected;
  final bool isClearButton;
  final Function()? onClearField;

  @override
  State<DropdownMultipleTree> createState() => _DropdownMultipleTreeState();
}

class _DropdownMultipleTreeState extends State<DropdownMultipleTree> {
  /// temp searched list
  var _tempSearchedList = <DropdownMultipleTreeModel>[];
  final GlobalKey<PopupMenuButtonState> _menuKey =
      GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) =>
                  Theme(
                data: ThemeData(
                  hoverColor: ColorsValue.white,
                  focusColor: ColorsValue.white,
                  highlightColor: ColorsValue.white,
                ),
                child: PopupMenuButton<DropdownItemModel>(
                  key: _menuKey,
                  enableFeedback: false,
                  onSelected: widget.onSelected,
                  splashRadius: 0,
                  tooltip: '',
                  offset: Offset(Dimens.zero, Dimens.sixty),
                  color: ColorsValue.white,
                  shadowColor: ColorsValue.white,
                  surfaceTintColor: ColorsValue.white,
                  constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      maxWidth: constraints.maxWidth,
                      maxHeight: Dimens.threeHundred),
                  child: CustomTextFormField(
                    readOnly: widget.isMultipleSelctionEnable,
                    fillColor: ColorsValue.textfildbackcolor,
                    hintText: widget.isMultipleSelctionEnable
                        ? widget.multipleSelectedList?.isEmpty ?? true
                            ? widget.hintText
                            : null
                        : widget.hintText,
                    controller: widget.textEditingController,
                    onTapped: () {
                      _menuKey.currentState!.showButtonMenu();
                    },
                    prefixIcon: widget.isMultipleSelctionEnable
                        ? widget.multipleSelectedList?.isNotEmpty ?? false
                            ? widget.prefixIcon
                            : null
                        : widget.prefixIcon,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((widget.isClearButton) &&
                            (widget.textEditingController?.text.isNotEmpty ??
                                false))
                          IconButton(
                            icon: SvgPicture.asset(AssetConstants.cancleicon),
                            splashRadius: 5,
                            onPressed: () {
                              widget.textEditingController?.clear();
                              if (widget.isClearButton) {
                                if (widget.onClearField != null) {
                                  widget.onClearField!();
                                }
                              }
                              setState(() {});
                            },
                          ),
                        const IconButton(
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                          ),
                          splashRadius: 5,
                          onPressed: null,
                        ),
                      ],
                    ),
                  ),
                  itemBuilder: (context) {
                    _tempSearchedList = List.from(widget.itemList);
                    return widget.isReadOnly
                        ? []
                        : [
                            PopupMenuItem(
                              padding: Dimens.edgeInsets0,
                              onTap: null,
                              enabled: false,
                              child: StatefulBuilder(
                                builder: (context, setState) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (widget.itemList.length > 4) ...[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Dimens.twenty,
                                            vertical: Dimens.ten),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomTextFormField(
                                                hintText: 'search'.tr,
                                                fillColor: ColorsValue
                                                    .textfildbackcolor,
                                                // suffixIcon: InkWell(
                                                //   onTap: () {},
                                                //   child: Icon(
                                                //     Icons.close,
                                                //     size: Dimens.twenty,
                                                //     color: Colors.grey.shade600,
                                                //   ),
                                                // ),
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      _tempSearchedList = List.from(widget
                                                          .itemList
                                                          .where((DropdownMultipleTreeModel
                                                                  string) =>
                                                              string.name
                                                                  .toLowerCase()
                                                                  .contains(value
                                                                      .toLowerCase()) ||
                                                              string.subItems!.any(
                                                                  (element) => element
                                                                      .name
                                                                      .toLowerCase()
                                                                      .contains(value.toLowerCase())))
                                                          .toList());
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    ListView.separated(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: _tempSearchedList.length,
                                      padding: Dimens.edgeInsets0,
                                      separatorBuilder: (context, index) =>
                                          Padding(
                                        padding: Dimens.edgeInsets20_0_20_0,
                                        child: Divider(
                                          height: Dimens.one,
                                          color: ColorsValue.textfildbackcolor,
                                        ),
                                      ),
                                      itemBuilder: (context, i) =>
                                          PopupMenuItem<
                                              DropdownMultipleTreeModel>(
                                        value: _tempSearchedList[i],
                                        enabled: false,
                                        child: Column(
                                          children: [
                                            ListTile(
                                              onTap: widget
                                                      .isMultipleSelctionEnable
                                                  ? () {
                                                      if (widget
                                                              .multipleSelectedList !=
                                                          null) {
                                                        for (var data
                                                            in _tempSearchedList[
                                                                        i]
                                                                    .subItems ??
                                                                <DropdownItemModel>[]) {
                                                          if (!widget
                                                              .multipleSelectedList!
                                                              .any((element) =>
                                                                  element
                                                                      .name ==
                                                                  data.name)) {
                                                            widget
                                                                .multipleSelectedList!
                                                                .add(data);
                                                          }
                                                        }

                                                        widget.onMultiSelected!(
                                                            widget
                                                                .multipleSelectedList!);
                                                        setState(() {});
                                                      }
                                                    }
                                                  : null,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      horizontal: Dimens.ten),
                                              minVerticalPadding: 0,
                                              title: DropdownMenuItem(
                                                value:
                                                    _tempSearchedList[i].name,
                                                child: Text(
                                                  '${_tempSearchedList[i].name}',
                                                  style: Styles.black50014,
                                                ),
                                              ),
                                              leading: widget
                                                      .isMultipleSelctionEnable
                                                  ? AbsorbPointer(
                                                      child: Checkbox(
                                                        activeColor: ColorsValue
                                                            .maincolor1,
                                                        value: _tempSearchedList[
                                                                i]
                                                            .subItems
                                                            ?.any((element) => widget
                                                                .multipleSelectedList!
                                                                .any((e) =>
                                                                    element.name
                                                                        .toLowerCase() ==
                                                                    e.name
                                                                        .toLowerCase())),
                                                        onChanged: (val) {},
                                                      ),
                                                    )
                                                  : null,
                                            ),
                                            Padding(
                                              padding:
                                                  Dimens.edgeInsets10_0_0_0,
                                              child: ListView.builder(
                                                padding: Dimens.edgeInsets0,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: _tempSearchedList[i]
                                                    .subItems
                                                    ?.length,
                                                itemBuilder: (context, i2) =>
                                                    ListTile(
                                                  onTap: widget
                                                          .isMultipleSelctionEnable
                                                      ? () {
                                                          if (widget
                                                                  .multipleSelectedList !=
                                                              null) {
                                                            if (!widget
                                                                .multipleSelectedList!
                                                                .any(
                                                              (element) =>
                                                                  element.name
                                                                      .toLowerCase() ==
                                                                  _tempSearchedList[
                                                                          i]
                                                                      .subItems?[
                                                                          i2]
                                                                      .name
                                                                      .toLowerCase(),
                                                            )) {
                                                              widget
                                                                  .multipleSelectedList!
                                                                  .add(_tempSearchedList[
                                                                              i]
                                                                          .subItems![
                                                                      i2]);
                                                              setState(() {});
                                                            } else {
                                                              var index = widget
                                                                  .multipleSelectedList!
                                                                  .indexWhere((element) =>
                                                                      _tempSearchedList[
                                                                              i]
                                                                          .subItems?[
                                                                              i2]
                                                                          .name ==
                                                                      element
                                                                          .name);
                                                              widget
                                                                  .multipleSelectedList!
                                                                  .removeAt(
                                                                      index);
                                                              setState(() {});
                                                            }
                                                            widget.onMultiSelected!(
                                                                widget
                                                                    .multipleSelectedList!);
                                                            setState(() {});
                                                          }
                                                        }
                                                      : () {
                                                          widget.textEditingController
                                                                  ?.text =
                                                              _tempSearchedList[
                                                                      i]
                                                                  .subItems![i2]
                                                                  .name;
                                                          setState(() {});
                                                          if (widget.onChange !=
                                                              null) {
                                                            widget.onChange!(
                                                                _tempSearchedList[
                                                                        i]
                                                                    .subItems![
                                                                        i2]
                                                                    .name);
                                                          }
                                                          if (widget
                                                                  .onSelected !=
                                                              null) {
                                                            widget.onSelected!(
                                                                _tempSearchedList[
                                                                            i]
                                                                        .subItems![
                                                                    i2]);
                                                          }
                                                          if (widget
                                                                  .onSelectedMainItemName !=
                                                              null) {
                                                            widget.onSelectedMainItemName!(
                                                                _tempSearchedList[
                                                                        i]
                                                                    .name);
                                                          }
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal:
                                                              Dimens.sixteen),
                                                  minVerticalPadding: 0,
                                                  title: DropdownMenuItem(
                                                    value: _tempSearchedList[i]
                                                        .subItems?[i2]
                                                        .name,
                                                    child: Container(
                                                      child: Text(
                                                        _tempSearchedList[i]
                                                            .subItems![i2]
                                                            .name,
                                                        style:
                                                            Styles.black40014,
                                                      ),
                                                    ),
                                                  ),
                                                  leading: widget
                                                          .isMultipleSelctionEnable
                                                      ? AbsorbPointer(
                                                          child: Checkbox(
                                                            activeColor:
                                                                ColorsValue
                                                                    .maincolor1,
                                                            value: widget
                                                                .multipleSelectedList!
                                                                .any(
                                                              (element) =>
                                                                  element.name
                                                                      .toLowerCase() ==
                                                                  _tempSearchedList[
                                                                          i]
                                                                      .subItems![
                                                                          i2]
                                                                      .name
                                                                      .toLowerCase(),
                                                            ),
                                                            onChanged: (val) {},
                                                          ),
                                                        )
                                                      : null,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ];
                  },
                ),
              ),
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
        ],
      );
}
