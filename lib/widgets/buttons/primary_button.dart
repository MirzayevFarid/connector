import 'package:flutter/material.dart';

// common
import 'package:connector/common/colors.dart';
import 'package:connector/common/constants.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/common/utils.dart';

class PrimaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double height;
  final double width;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final Color color;

  PrimaryButton({
    Key key,
    @required this.onPressed,
    this.text = '',
    this.height,
    this.width,
    this.textStyle,
    this.padding,
    this.color,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height != null ? height : Constants.BUTTON_HEIGHT,
        width: width != null ? width : screenUsableWidth(context),
        child: FlatButton(
          onPressed: onPressed,
          splashColor: ORColorStyles.splash,
          highlightColor: ORColorStyles.highlight,
          color: color != null ? color : ORColorStyles.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.BORDER_RADIUS),
          ),
          disabledColor: ORColorStyles.disabled,
          child: child != null
              ? child
              : Text(
                  text,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                  style: textStyle != null
                      ? textStyle
                      : ORTextStyles.darkButtonText,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
        ));
  }
}
