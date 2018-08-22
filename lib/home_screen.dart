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
      // leading: IconButton(
      //   icon: Icon(Icons.menu),
      //   onPressed: () {},
      // ),
      leading: DescribedFeatureOverlay(
        showOverlay: false,
        icon: Icons.menu,
        color: Colors.green,
        title: 'The title',
        description: 'The description',
        child: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      title: Text(widget.title),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );

    return OverlayBuilder(
      showOverlay: false,
      overlayBuilder: (BuildContext context) {
        return CenterAbout(
          position: Offset(200.0, 300.0),
          child: Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple,
            ),
          ),
        );
      },
      child: Scaffold(
        appBar: appBar,
        body: Content(
          onReveal: () {
            // addToOverlay(overlayEntry);
          },
        ),
        floatingActionButton: AnchorOverlay(
          showOverlay: true,
          overlayBuilder: (BuildContext context, Offset anchor) {
            return CenterAbout(
              position: anchor,
              child: Text('++'),
            );
          },
          child: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {},
          ),
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
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
              child: Icon(Icons.drive_eta),
              onPressed: () {},
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
  @override
  Widget build(BuildContext context) {
    return AnchorOverlay(
        child: widget.child,
        showOverlay: widget.showOverlay,
        overlayBuilder: (BuildContext context, Offset anchor) {
          final backgroundRadius = MediaQuery.of(context).size.width;
          final touchTargetRadius = 44.0;
          final contentY = anchor.dy + touchTargetRadius + 20.0;

          return Stack(
            children: <Widget>[
              CenterAbout(
                position: anchor,
                child: Container(
                  width: 2 * backgroundRadius,
                  height: 2 * backgroundRadius,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color,
                  ),
                ),
              ),
              Positioned(
                top: contentY,
                child: Material(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 40.0,
                      right: 40.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Text(
                          widget.description,
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white.withOpacity(0.8)),
                        )
                      ],
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
                  )),
            ],
          );
        });
  }
}
