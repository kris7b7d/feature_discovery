import 'package:flutter/material.dart';
import 'layout.dart';

class FeatureDiscovery extends StatefulWidget {
  final Widget child;

  FeatureDiscovery({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  static String activeStep(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedFeatureDiscovery) as _InheritedFeatureDiscovery)
        .activeStepId;
  }

  static void discoveryFeature(BuildContext context, List<String> steps) {
    _FeatureDiscoveryState state =
        context.ancestorStateOfType(TypeMatcher<_FeatureDiscoveryState>()) as _FeatureDiscoveryState;

    state.discoverFeatures(steps);
  }

  static void markStepCompleted(BuildContext context, String stepId) {
    _FeatureDiscoveryState state =
        context.ancestorStateOfType(TypeMatcher<_FeatureDiscoveryState>()) as _FeatureDiscoveryState;

    state.markStepComplete(stepId);
  }

  static void dismiss(BuildContext context) {
    _FeatureDiscoveryState state =
        context.ancestorStateOfType(TypeMatcher<_FeatureDiscoveryState>()) as _FeatureDiscoveryState;

    state.dismiss();
  }

  @override
  _FeatureDiscoveryState createState() => _FeatureDiscoveryState();
}

class _FeatureDiscoveryState extends State<FeatureDiscovery> {
  List<String> steps;
  int activeStepIndex;

  void discoverFeatures(List<String> step) {
    setState(() {
      this.steps = steps;
      activeStepIndex = 0;
    });
  }

  void markStepComplete(String stepId) {
    if (steps != null && steps[activeStepIndex] == stepId) {
      setState(() {
        ++activeStepIndex;
        if (activeStepIndex >= steps.length) {
          _cleanUpAfterSteps();
        }
      });
    }
  }

  void dismiss() {
    setState(() {
      _cleanUpAfterSteps();
    });
  }

  void _cleanUpAfterSteps() {
    steps = null;
    activeStepIndex = null;
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedFeatureDiscovery(
      activeStepId: steps?.elementAt(activeStepIndex),
      child: widget.child,
    );
  }
}

class _InheritedFeatureDiscovery extends InheritedWidget {
  final String activeStepId;

  _InheritedFeatureDiscovery({
    @required this.activeStepId,
    @required child,
  }) : super(child: child);

  @override
  bool updateShouldNotify(_InheritedFeatureDiscovery oldWidget) {
    return oldWidget.activeStepId != activeStepId;
  }
}

class DescribedFeatureOverlay extends StatefulWidget {
  final String featureId;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final Widget child;

  DescribedFeatureOverlay({
    Key key,
    this.featureId,
    this.icon,
    this.color,
    this.title,
    this.description,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _DescribeFeatureOverlayState();
}

class _DescribeFeatureOverlayState extends State<DescribedFeatureOverlay> {
  bool showOverlay = false;
  Size screenSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;

    showOverlayIfActiveStep();
  }

  void showOverlayIfActiveStep() {
    String activeStep = FeatureDiscovery.activeStep(context);
    setState(() => showOverlay = activeStep == widget.featureId);
  }

  bool isCloseToTopOrBottom(position) {
    return position.dy <= 88.0 || (screenSize.height - position.dy) <= 88.0;
  }

  bool isOnTopHalfOfScreen(position) {
    return position.dy < (screenSize.height / 2.0);
  }

  bool isOnLeftHalfOfScreen(position) {
    return position.dx < (screenSize.width / 2.0);
  }

  DescribedFeatureContentOrientation getContentOrientation(Offset position) {
    if (isCloseToTopOrBottom(position)) {
      if (isOnTopHalfOfScreen(position)) {
        return DescribedFeatureContentOrientation.below;
      } else {
        return DescribedFeatureContentOrientation.above;
      }
    } else {
      if (isOnTopHalfOfScreen(position)) {
        return DescribedFeatureContentOrientation.above;
      } else {
        return DescribedFeatureContentOrientation.below;
      }
    }
  }

  void activate() {
    FeatureDiscovery.markStepCompleted(context, widget.featureId);
  }

  void dismiss() {
    FeatureDiscovery.dismiss(context);
  }

  @override
  Widget build(BuildContext context) {
    return AnchorOverlay(
        child: widget.child,
        showOverlay: showOverlay,
        overlayBuilder: (BuildContext context, Offset anchor) {
          final touchTargetRadius = 44.0;
          final contentOrientation = getContentOrientation(anchor);
          final contentOffsetMultiplier = contentOrientation == DescribedFeatureContentOrientation.below ? 1.0 : -1.0;
          final contentY = anchor.dy + (contentOffsetMultiplier * (touchTargetRadius + 20.0));
          final contentFractionalOffset = contentOffsetMultiplier.clamp(-1.0, 0.0);
          final isBackgroundCentered = isCloseToTopOrBottom(anchor);
          final backgroundRadius =
              screenSize.width * (isBackgroundCentered ? 1.0 : 0.75) * 1.0; // screenSize.width * 1.0;
          final backgroundPosition = isBackgroundCentered
              ? anchor
              : Offset(
                  screenSize.width / 2.0 + (isOnLeftHalfOfScreen(anchor) ? -20.0 : 20.0),
                  anchor.dy +
                      (isOnTopHalfOfScreen(anchor)
                          ? -(screenSize.width / 2.0) + 40.0
                          : (screenSize.width / 2.0) - 40.0));

          return Stack(
            children: <Widget>[
              GestureDetector(
                onTap: dismiss,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.transparent,
                ),
              ),
              CenterAbout(
                position: backgroundPosition,
                child: Container(
                  width: 2 * backgroundRadius,
                  height: 2 * backgroundRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withOpacity(0.96),
                  ),
                ),
              ),
              Positioned(
                top: contentY,
                child: Container(
                  width: screenSize.width,
                  child: FractionalTranslation(
                    translation: Offset(0.0, contentFractionalOffset),
                    child: Material(
                      color: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0, right: 40.0),
                        /*top: 40.0, left: 60.0, right: 60.0*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Text(
                                widget.title,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white.withOpacity(0.7),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              CenterAbout(
                position: anchor,
                child: Container(
                  width: 2 * touchTargetRadius,
                  height: 2 * touchTargetRadius,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: Colors.white,
                    child: Icon(
                      widget.icon,
                      color: widget.color,
                    ),
                    onPressed: activate,
                  ),
                ),
              ),
            ],
          );
        });
  }
}

enum DescribedFeatureContentOrientation {
  above,
  below,
}
