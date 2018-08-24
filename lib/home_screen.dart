import 'package:flutter/material.dart';
import 'layout.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  HomeScreen({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    var appBar = AppBar(
      leading: DescribedFeatureOverlay(
        showOverlay: false,
        icon: Icons.menu,
        color: Colors.green,
        title: 'Just how you want it',
        description: 'Tap the menu icon to switch accounts, change settings & more',
        child: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      title: Text(widget.title),
      actions: <Widget>[
        DescribedFeatureOverlay(
          showOverlay: false,
          icon: Icons.search,
          color: Colors.green,
          title: 'Just how you want it',
          description: 'Tap the menu icon to switch accounts, change settings & more',
          child: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: Content(
        onReveal: () {
          // addToOverlay(overlayEntry);
        },
      ),
      floatingActionButton: DescribedFeatureOverlay(
        showOverlay: false,
        icon: Icons.add,
        color: Colors.green,
        title: 'Just how you want it',
        description: 'Tap the menu icon to switch accounts, change settings & more',
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {},
        ),
      ),
    );
  }
}

typedef void FeatureRevealCallback();

class Content extends StatefulWidget {
  final FeatureRevealCallback onReveal;

  Content({
    Key key,
    this.onReveal,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            Image.network(
              'https://images.pexels.com/photos/130128/pexels-photo-130128.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
              fit: BoxFit.cover,
              width: double.infinity,
              height: 200.0,
            ),
            Container(
              width: double.infinity,
              color: Colors.lightGreen,
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Landscape',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  Text(
                    'Sunset in the forest',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.0),
              child: RaisedButton(
                color: Colors.grey,
                child: Text('Do feature discovery'),
                onPressed: () {
                  widget.onReveal();
                },
              ),
            ),
          ],
        ),
        Positioned(
          top: 200.0,
          right: 0.0,
          child: FractionalTranslation(
            translation: Offset(-0.5, -0.5),
            child: DescribedFeatureOverlay(
              showOverlay: true,
              icon: Icons.drive_eta,
              color: Colors.green,
              title: 'Just how you want it',
              description: 'Tap the menu icon to switch accounts, change settings & more',
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                foregroundColor: Colors.green,
                child: Icon(Icons.drive_eta),
                onPressed: () {},
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DescribedFeatureOverlay extends StatefulWidget {
  final bool showOverlay;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final Widget child;

  DescribedFeatureOverlay({
    Key key,
    this.showOverlay,
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
  Size screenSize;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.of(context).size;
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

  @override
  Widget build(BuildContext context) {
    return AnchorOverlay(
        child: widget.child,
        showOverlay: widget.showOverlay,
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
                    onPressed: () {},
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
