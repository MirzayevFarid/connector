import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

// commons
import 'package:connector/common/colors.dart';
import 'package:connector/helpers/debounce.dart';

class FullScreenLoader extends StatefulWidget {
  final Widget child;
  final Color color;
  final bool isLoading;

  FullScreenLoader({
    Key key,
    @required this.child,
    this.isLoading = false,
    this.color = ORColorStyles.green,
  }) : super(key: key);

  @override
  _FullScreenLoaderState createState() => _FullScreenLoaderState();
}

class _FullScreenLoaderState extends State<FullScreenLoader> {
  bool _isLoading = false;

  final DebounceHelper _showDebouncer = DebounceHelper(milliseconds: 300);
  final DebounceHelper _hideDebouncer = DebounceHelper(milliseconds: 150);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      _showDebouncer.run(() {
        setState(() {
          _isLoading = widget.isLoading;
        });
      });
    } else {
      _hideDebouncer.run(() {
        setState(() {
          _isLoading = widget.isLoading;
        });
      });
    }

    return ModalProgressHUD(
      child: widget.child,
      inAsyncCall: _isLoading,
      color: widget.color,
      opacity: 0.6,
      progressIndicator: Container(
        width: 48,
        height: 48,
        child: CircularProgressIndicator(
          strokeWidth: 6,
        ),
      ),
    );
  }
}
