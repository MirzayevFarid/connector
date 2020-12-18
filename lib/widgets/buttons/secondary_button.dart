import 'package:flutter/material.dart';

// common
import 'package:connector/common/colors.dart';
import 'package:connector/common/constants.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/common/utils.dart';

class SecondaryButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final double height;
  final double width;
  final TextStyle textStyle;
  final EdgeInsetsGeometry padding;
  final Widget child;
  final Color color;
  final bool isTransparent;

  SecondaryButton({
    Key key,
    @required this.onPressed,
    this.text = '',
    this.height,
    this.width,
    this.textStyle,
    this.padding,
    this.child,
    this.color,
    this.isTransparent = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      height: height != null ? height : Constants.BUTTON_HEIGHT,
      width: width != null ? width : screenUsableWidth(context),
      child: FlatButton(
        onPressed: onPressed,
        splashColor: isTransparent
            ? Colors.transparent
            : Color.fromRGBO(236, 236, 236, 0.3),
        highlightColor: isTransparent
            ? Colors.transparent
            : Color.fromRGBO(236, 236, 236, 0.3),
        color: color != null
            ? color
            : isTransparent ? Colors.transparent : ORColorStyles.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.BORDER_RADIUS),
        ),
        child: child != null
            ? child
            : Text(
                text,
                style: textStyle != null
                    ? textStyle
                    : isTransparent
                        ? ORTextStyles.darkButtonText
                        : ORTextStyles.lightButtonText,
                textAlign: TextAlign.center,
                maxLines: 1,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}
