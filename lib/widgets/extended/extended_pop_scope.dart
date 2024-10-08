import 'package:flutter/widgets.dart';
import 'package:pro_image_editor/pro_image_editor.dart';


/// A widget that provides a custom pop behavior when a pop action is invoked
/// and optionally returns a result.
import 'package:flutter/widgets.dart';
import 'package:pro_image_editor/pro_image_editor.dart';

/// A widget that provides a custom pop behavior when a pop action is invoked
/// and optionally returns a result.
class ExtendedPopScope<T> extends StatelessWidget {
  /// Creates an instance of [ExtendedPopScope].
  ///
  /// The [child] parameter is required and specifies the widget to be displayed
  /// within the pop scope. The other parameters are optional:
  const ExtendedPopScope({
    super.key,
    required this.child,
    this.canPop = true
  });

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget child;

  /// Determines whether the route can be popped or not.
  ///
  /// If false, this will block the current route from being popped.
  final bool canPop;

  /// Handle the back press and navigation pop.
  Future<bool> _onWillPop(BuildContext context) async {
    if (!canPop) {
      // If pop is disabled, prevent the pop action.
      return Future.value(false);
    }

    if (LoadingDialog.instance.hasActiveOverlay &&
        LoadingDialog.instance.isDismissible) {
      // If there's an active overlay and it's dismissible, hide it and block the pop.
      LoadingDialog.instance.hide();
      return Future.value(false);
    }

    // Allow the pop action.
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Handle whether the route can pop using the _onWillPop method.
      onWillPop: () => _onWillPop(context),
      child: ListenableBuilder(
        listenable: LoadingDialog.instance,
        builder: (_, __) {
          return IgnorePointer(
            // Disable interaction with the widget if the overlay is active.
            ignoring: LoadingDialog.instance.hasActiveOverlay,
            child: child,
          );
        },
      ),
    );
  }
}

