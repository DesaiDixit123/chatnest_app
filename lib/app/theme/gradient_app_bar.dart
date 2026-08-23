import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final bool centerTitle;
  final double elevation;
  final PreferredSizeWidget? bottom;
  final Widget? leading;

  const GradientAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.bottom,
    this.centerTitle = false,
    this.elevation = 0,
  });

  static const LinearGradient logoGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF34D058), // Green
      Color(0xFF7B61FF), // Purple
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: logoGradient),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: elevation,
        title: title,
        centerTitle: centerTitle,
        actions: actions,
        leading: leading,
        bottom: bottom,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}
