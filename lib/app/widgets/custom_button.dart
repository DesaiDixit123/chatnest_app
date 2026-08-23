import 'package:flutter/material.dart';
import '../theme/theme.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.text,
    required this.onTap,
    this.height,
    this.backgroundColor,
    this.radius,
    this.style,
  }) : super(key: key);
  final String? text;
  final double? height;
  final Color? backgroundColor;
  final BorderRadiusGeometry? radius;
  final Function()? onTap;
  final TextStyle? style;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) => Column(
        children: [
          InkWell(
            onTap: widget.onTap,
            child: Container(
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.backgroundColor == null
                      ? ColorsValue.maincolor1
                      : widget.backgroundColor,
                  borderRadius: widget.radius == null
                      ? BorderRadius.circular(Dimens.five)
                      : widget.radius,
                ),
                child: Center(
                  child: Text(widget.text!,
                      style: widget.style == null
                          ? Styles.whitebold18
                          : widget.style),
                )),
          ),
        ],
      );
}
