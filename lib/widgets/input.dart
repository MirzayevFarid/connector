import 'package:flutter/material.dart';

import 'package:connector/common/colors.dart';
import 'package:connector/common/constants.dart';
import 'package:connector/common/texts.dart';

class Input extends StatelessWidget {
  final String label, hintText, helperText;
  final bool autofocus;
  final bool obscureText;
  final bool filled;
  final bool hasFloatingPlaceholder;
  final Color fillColor;
  final Widget icon;
  final Widget suffixIcon;
  final FocusNode focusNode;
  final Function onFieldSubmitted;
  final Function onSaved;
  final Function onChanged;
  final Function onTap;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool enabled;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextStyle style;
  final TextStyle hintStyle;
  final TextEditingController controller;
  final Function validator;
  final EdgeInsets contentPadding;
  final int maxLines;
  final int minLines;
  final int maxLength;
  final bool alignLabelWithHint;
  final String prefixText;
  final bool readOnly;
  final Color textColor;
  final FloatingLabelBehavior floatingLabelBehavior;
  final bool isTransparent;

  Input({
    Key key,
    this.label,
    this.hintText,
    this.helperText,
    this.icon,
    this.filled: true,
    this.hasFloatingPlaceholder: true,
    this.fillColor = ORColorStyles.white,
    this.suffixIcon,
    this.focusNode,
    this.onFieldSubmitted,
    this.onSaved,
    this.onChanged,
    this.onTap,
    this.autofocus: false,
    this.obscureText: false,
    this.readOnly: false,
    this.keyboardType,
    this.textInputAction: TextInputAction.done,
    this.enabled: true,
    this.decoration,
    this.textCapitalization: TextCapitalization.none,
    this.textAlign: TextAlign.left,
    this.style,
    this.hintStyle,
    this.controller,
    this.validator,
    this.contentPadding: const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 18,
    ),
    this.maxLines: 1,
    this.minLines: 1,
    this.maxLength,
    this.alignLabelWithHint,
    this.textColor,
    this.prefixText,
    this.floatingLabelBehavior = FloatingLabelBehavior.auto,
    this.isTransparent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: ORColorStyles.main,
      ),
      child: TextFormField(
        readOnly: readOnly,
        autofocus: autofocus,
        obscureText: obscureText,
        cursorColor: isTransparent ? ORColorStyles.white : ORColorStyles.main,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        textCapitalization: textCapitalization,
        textAlign: textAlign,
        maxLines: maxLines,
        minLines: minLines,
        maxLength: maxLength,
        enabled: enabled,
        onSaved: onSaved,
        onTap: onTap,
        onChanged: onChanged,
        validator: validator != null
            ? (value) {
                return validator(value);
              }
            : null,
        focusNode: focusNode,
        onFieldSubmitted: onFieldSubmitted != null
            ? (val) {
                onFieldSubmitted(val);
              }
            : null,
        decoration: decoration != null
            ? decoration
            : InputDecoration(
                contentPadding: contentPadding,
                floatingLabelBehavior: floatingLabelBehavior,
                prefixText: prefixText,
                fillColor: fillColor,
                filled: filled,
                labelText: label,
                hintText: hintText,
                hintStyle: hintStyle != null ? hintStyle : ORTextStyles.hint,
                hintMaxLines: minLines,
                alignLabelWithHint: true,
                helperText: helperText,
                helperStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.166,
                  color:
                      isTransparent ? Colors.white : ORColorStyles.helper_text,
                ),
                labelStyle: focusNode != null && focusNode.hasFocus
                    ? TextStyle(
                        color:
                            isTransparent ? Colors.white : ORColorStyles.blue,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Muli",
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        height: 1.29,
                      )
                    : TextStyle(
                        color:
                            isTransparent ? Colors.white : ORColorStyles.gray,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Muli",
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        height: 1.125,
                      ),
                prefixIcon: icon,
                suffixIcon: suffixIcon,
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isTransparent ? Colors.white : ORColorStyles.border,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Constants.BORDER_RADIUS),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: isTransparent ? Colors.white : ORColorStyles.border,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Constants.BORDER_RADIUS),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(Constants.BORDER_RADIUS),
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: ORColorStyles.border_error,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(Constants.BORDER_RADIUS),
                  ),
                ),
                errorStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color:
                      isTransparent ? ORColorStyles.white : ORColorStyles.gray,
                  height: 1.166,
                ),
              ),
        style: style != null
            ? style
            : TextStyle(
                color: textColor != null
                    ? textColor
                    : isTransparent ? Colors.white : ORColorStyles.input_text,
                fontWeight: FontWeight.normal,
                fontFamily: "Muli",
                fontStyle: FontStyle.normal,
                fontSize: 16,
                height: 1.125,
              ),
        controller: controller,
      ),
    );
  }
}
