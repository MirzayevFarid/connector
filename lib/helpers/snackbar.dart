import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
import 'package:connector/common/colors.dart';

enum SnackbarTypes { info, warning, error, success }

class SnackbarHelper {
  static Flushbar fb;

  static show({
    @required SnackbarTypes type,
    @required BuildContext context,
    String msg,
    Function onPressed,
    bool isDismissible: true,
    Duration duration: const Duration(seconds: 8),
    String buttonText: '',
    bool hasIcon: true,
  }) {
    fb?.dismiss();

    bool isClicked = false;
    Color mainColor;
    Color actionColor;
    Icon icon;

    switch (type) {
      case SnackbarTypes.warning:
        mainColor = Colors.yellow.shade100;
        actionColor = Colors.yellow.shade600;
        icon = Icon(
          MdiIcons.alertOutline,
          color: actionColor,
        );
        break;

      case SnackbarTypes.success:
        mainColor = Colors.green.shade100;
        actionColor = Colors.green.shade600;
        icon = Icon(
          MdiIcons.checkCircleOutline,
          color: actionColor,
        );
        break;

      case SnackbarTypes.error:
        mainColor = Colors.red.shade100;
        actionColor = Colors.red.shade600;
        icon = Icon(
          MdiIcons.alert,
          color: actionColor,
        );
        break;

      default:
        mainColor = Colors.blue.shade100;
        actionColor = Colors.blue.shade600;
        icon = Icon(
          MdiIcons.informationOutline,
          color: actionColor,
        );
    }

    fb = Flushbar(
      duration: duration,
      isDismissible: isDismissible,
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: mainColor,
      boxShadows: [
        BoxShadow(
          color: ORColorStyles.white,
          spreadRadius: 0,
          blurRadius: 10,
          offset: Offset(0, 0),
        ),
      ],
      icon: hasIcon ? icon : null,
      mainButton: buttonText != ''
          ? FlatButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                if (!isClicked) {
                  if (onPressed != null) {
                    onPressed();
                  }
                  isClicked = true;
                }
              },
              child: Text(
                buttonText,
                style: TextStyle(
                  fontFamily: 'Muli',
                  color: actionColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      messageText: Text(
        msg,
        style: TextStyle(
          fontFamily: 'Muli',
          fontSize: 12,
          color: ORColorStyles.main,
          fontWeight: FontWeight.w600,
          height: 1.50,
        ),
      ),
      onTap: (fb) {
        if (!isClicked) {
          if (onPressed != null) {
            onPressed();
          }
          isClicked = true;
        }
      },
    );

    return fb..show(context);
  }

  static showPlainText({
    @required BuildContext context,
    String msg,
    Function onPressed,
    bool isDismissible: true,
    Duration duration: const Duration(seconds: 5),
    isReverted = false,
  }) {
    fb?.dismiss();

    bool isClicked = false;
    Color mainColor;
    Color textColor;

    if (!isReverted) {
      mainColor = ORColorStyles.primary_blue;
      textColor = ORColorStyles.white;
    } else {
      mainColor = ORColorStyles.white;
      textColor = ORColorStyles.primary_blue;
    }

    fb = Flushbar(
      duration: duration,
      isDismissible: isDismissible,
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: mainColor,
      boxShadows: [
        BoxShadow(
          color: ORColorStyles.white,
          spreadRadius: 0,
          blurRadius: 10,
          offset: Offset(0, 0),
        ),
      ],
      messageText: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Muli',
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.w600,
          height: 1.285,
        ),
      ),
      onTap: (fb) {
        if (!isClicked) {
          if (onPressed != null) {
            onPressed();
          }
          isClicked = true;
        }
      },
    );

    return fb..show(context);
  }

// without context bars
  static Flushbar genericErrorBar({
    String msg,
  }) {
    return Flushbar(
      duration: Duration(seconds: 5),
      flushbarStyle: FlushbarStyle.GROUNDED,
      flushbarPosition: FlushbarPosition.TOP,
      isDismissible: true,
      backgroundColor: Colors.red.shade100,
      icon: Icon(
        MdiIcons.alert,
        color: Colors.red.shade600,
      ),
      messageText: Text(
        msg == null ? "Not Performed Correctly" : msg,
        style: TextStyle(
          fontFamily: 'Muli',
          fontSize: 12,
          color: ORColorStyles.main,
          fontWeight: FontWeight.w600,
          height: 1.50,
        ),
      ),
    );
  }
}
