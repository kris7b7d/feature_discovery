import 'package:flutter/material.dart';
import 'feature.dart';

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

