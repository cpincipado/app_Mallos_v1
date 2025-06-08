import 'package:flutter/material.dart';
import 'package:mi_app_velneo/utils/responsive_helper.dart';

/// Contenedor seguro que previene overflow
class SafeContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final BoxDecoration? decoration;
  final double maxWidthPercentage;

  const SafeContainer({
    super.key,
    required this.child,
    this.padding,
    this.decoration,
    this.maxWidthPercentage = 0.95,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth =
        ResponsiveHelper.getScreenWidth(context) * maxWidthPercentage;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Container(
        padding: padding ?? ResponsiveHelper.getHorizontalPadding(context),
        decoration: decoration,
        child: child,
      ),
    );
  }
}

/// Texto seguro que no hace overflow
class SafeText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow overflow;

  const SafeText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

/// Row seguro con Flexible automático
class SafeRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const SafeRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: children.map((child) {
        if (child is Text || child is RichText || child is SafeText) {
          return Flexible(child: child);
        }
        return child;
      }).toList(),
    );
  }
}

/// Column seguro con espaciado adaptativo
class SafeColumn extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;

  const SafeColumn({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.spacing = 20,
  });

  @override
  Widget build(BuildContext context) {
    double adaptiveSpacing = ResponsiveHelper.isDesktop(context)
        ? spacing
        : ResponsiveHelper.isTablet(context)
        ? spacing * 0.8
        : spacing * 0.7;

    List<Widget> spacedChildren = [];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(SizedBox(height: adaptiveSpacing));
      }
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: spacedChildren,
    );
  }
}

/// Botón seguro que se adapta al ancho de pantalla
class SafeButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double maxWidthPercentage;

  const SafeButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.maxWidthPercentage = 0.9,
  });

  @override
  Widget build(BuildContext context) {
    double maxWidth =
        ResponsiveHelper.getScreenWidth(context) * maxWidthPercentage;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: SizedBox(
        width: double.infinity,
        height: ResponsiveHelper.isDesktop(context) ? 56 : 48,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: FittedBox(
            child: Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: ResponsiveHelper.getMenuButtonTitleSize(context) + 2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Input field seguro
class SafeTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const SafeTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.getScreenWidth(context) * 0.95,
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: ResponsiveHelper.getMenuButtonTitleSize(context),
        ),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: const OutlineInputBorder(),
          contentPadding: ResponsiveHelper.getHorizontalPadding(context),
        ),
      ),
    );
  }
}
