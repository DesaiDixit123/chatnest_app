import 'package:chatnest/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CustomInternationalPhoneFild extends StatelessWidget {
  CustomInternationalPhoneFild({
    Key? key,
    required this.text,
    this.validation,
    required this.hintText,
    this.initialvalue,
    this.keyboardAction,
    this.onInputChanged,
    this.oninitialValidation,
    this.textEditingController,
  }) : super(key: key);
  final String text;
  final String hintText;
  final String? Function(String?)? validation;
  final PhoneNumber? initialvalue;
  final Function(PhoneNumber)? onInputChanged;
  final Function(bool)? oninitialValidation;
  final TextEditingController? textEditingController;
  TextInputAction? keyboardAction;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: Styles.black50014,
          ),
          Dimens.boxHeight7,
          InternationalPhoneNumberInput(
            onInputChanged: onInputChanged,
            textStyle: Styles.black50018,
            onInputValidated: oninitialValidation,
            initialValue: initialvalue,
            keyboardAction: keyboardAction,
            selectorConfig: const SelectorConfig(
              selectorType: PhoneInputSelectorType.DROPDOWN,
              setSelectorButtonAsPrefixIcon: true,
              trailingSpace: false,
            ),
            ignoreBlank: false,
            autoValidateMode: AutovalidateMode.onUserInteraction,
            selectorTextStyle: const TextStyle(color: ColorsValue.color2E363F),
            textFieldController: textEditingController,
            formatInput: false,
            keyboardType: const TextInputType.numberWithOptions(
                signed: false, decimal: false),
            inputBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: ColorsValue.transparent)),
            inputDecoration: InputDecoration(
              contentPadding: Dimens.edgeInsets10,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: ColorsValue.transparent),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: ColorsValue.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: ColorsValue.transparent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: ColorsValue.transparent),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: ColorsValue.transparent),
              ),
              hintText: hintText,
              hintStyle: Styles.greyAAA40014,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(color: ColorsValue.transparent),
              ),
              filled: true,
              fillColor: ColorsValue.textfild,
            ),
            validator: validation,
          ),
        ],
      );
}
