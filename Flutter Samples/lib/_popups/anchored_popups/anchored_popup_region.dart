import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'anchored_popups.dart';

enum PopUpMode {
  clickToToggle, // Click a region to open PopOver, click barrier to close.
  hover, // Open on hoverIn (slightly delayed), close on hoverOut
}

class AnchoredPopUpRegion extends StatefulWidget {
  const AnchoredPopUpRegion(
      {Key? key,
      required this.child,
      required this.popChild,
      this.anchor,
      this.popAnchor,
      this.barrierDismissable,
      this.barrierColor,
      this.mode = PopUpMode.hover})
      : super(key: key);
  final Widget child;
  final Widget popChild;
  final bool? barrierDismissable;
  final Color? barrierColor;
  final Alignment? anchor;
  final Alignment? popAnchor;
  final PopUpMode mode;
  @override
  AnchoredPopUpRegionState createState() => AnchoredPopUpRegionState();

  // Non-interactive tool-tips, triggered on a delayed hover. Auto-close when you roll-out of the PopOverRegion
  static AnchoredPopUpRegion hover(
      {Key? key,
      required Widget child,
      required Widget popChild,
      Alignment? anchor,
      Alignment? popAnchor}) {
    return AnchoredPopUpRegion(
        key: key,
        child: child,
        popChild: popChild,
        anchor: anchor,
        popAnchor: popAnchor,
        mode: PopUpMode.hover);
  }

  // Click to open/close. Use for interactive panels, or other elements that should close themselves
  static AnchoredPopUpRegion click(
      {Key? key,
      required Widget child,
      required Widget popChild,
      Alignment? anchor,
      Alignment? popAnchor,
      bool? barrierDismissable,
      Color? barrierColor}) {
    return AnchoredPopUpRegion(
      key: key,
      child: child,
      popChild: popChild,
      anchor: anchor,
      popAnchor: popAnchor,
      mode: PopUpMode.clickToToggle,
      barrierColor: barrierColor,
      barrierDismissable: barrierDismissable,
    );
  }

  static AnchoredPopUpRegion hoverWithClick({
    Key? key,
    required Widget child,
    required Widget hoverPopChild,
    required Widget clickPopChild,
    bool barrierDismissable = true,
    Color? barrierColor,
    Alignment? hoverAnchor,
    Alignment? hoverPopAnchor,
    Alignment? clickAnchor,
    Alignment? clickPopAnchor,
  }) {
    return click(
        key: key,
        anchor: clickAnchor,
        barrierColor: barrierColor,
        barrierDismissable: barrierDismissable,
        popChild: clickPopChild,
        popAnchor: clickPopAnchor,
        child: hover(
            popAnchor: hoverPopAnchor,
            popChild: hoverPopChild,
            anchor: hoverAnchor,
            child: child));
  }
}

// TODO: Support for some sort of dualMode widget would be nice, has both a tooltip and a panel.
class AnchoredPopUpRegionState extends State<AnchoredPopUpRegion> {
  Timer? _timer;
  AnchoredPopupsController? _popups;

  @override
  Widget build(BuildContext context) {
    Widget content;
    // If Hover, add a MouseRegion
    if (widget.mode == PopUpMode.hover) {
      content = MouseRegion(
        opaque: true,
        onEnter: (_) => _handleHoverStart(),
        onExit: (_) => _handleHoverEnd(),
        child: widget.child,
      );
    } else {
      //TODO: A button builder would be nice here.
      content = TextButton(onPressed: show, child: widget.child);
    }
    return content;
  }

  @override
  void dispose() {
    if (widget.mode == PopUpMode.hover) {
      _handleHoverEnd();
    }
    super.dispose();
  }

  void show() {
    if (mounted == false) {
      if (kDebugMode) {
        print("PopoverRegion: Exiting early not mounted anymore");
      }
      return;
    }
    _popups = AnchoredPopups.of(context);
    _popups?.show(context,
        popUpMode: widget.mode,
        popContent: widget.popChild,
        anchor: widget.anchor ?? Alignment.bottomCenter,
        popAnchor: widget.popAnchor ?? Alignment.topCenter,
        useBarrier: widget.mode != PopUpMode.hover,
        barrierColor: widget.barrierColor ?? Colors.transparent,
        dismissOnBarrierClick: widget.barrierDismissable ?? true);
  }

  void _handleHoverStart() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      show();
      _timer?.cancel();
    });
  }

  void _handleHoverEnd() {
    _timer?.cancel();
    bool isStillOpen = _popups?.currentPopup?.context == context;
    if (isStillOpen) _popups?.hide();
  }
}
