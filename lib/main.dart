import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  Future<List<ui.Image>> assetMeasureFuture;
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    Image assetImageLeft = Image.asset('assets/media/chat_baloon_left.png');
    Image assetImageRight = Image.asset('assets/media/chat_baloon_right.png');
    Completer<ui.Image> leftAssetMeasure = new Completer<ui.Image>();
    Completer<ui.Image> rightAssetMeasure = new Completer<ui.Image>();

    _scrollController = new ScrollController();
    assetMeasureFuture =
        Future.wait([leftAssetMeasure.future, rightAssetMeasure.future]);
    assetImageLeft.image.resolve(new ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => leftAssetMeasure.complete(info.image));
    assetImageRight.image.resolve(new ImageConfiguration()).addListener(
        (ImageInfo info, bool _) => rightAssetMeasure.complete(info.image));
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          ),
      body: FutureBuilder<List<ui.Image>>(
        future: assetMeasureFuture,
        builder: (contextFuture, snap) {
          AsyncSnapshot<List<ui.Image>> snapshotImageDimensions = snap;
          if (snap.data != null) {
            double wLeft = snapshotImageDimensions.data[0].width.toDouble();
            double hLeft = snapshotImageDimensions.data[0].height.toDouble();
            double wRight = snapshotImageDimensions.data[1].width.toDouble();
            double hRight = snapshotImageDimensions.data[1].height.toDouble();

            return buildCommentWidget(
                "sdfas", wLeft, hLeft, wRight, hRight, context);
          } else {
            return Text('loading...');
          }
        },
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Widget buildCommentWidget(
    String text, double wLeft, hLeft, wRight, hRight, BuildContext c) {
  Widget commentWidget;
  commentWidget = Container(
    margin: EdgeInsets.only(right: 12.0, left: 75.0, bottom: 8.0),
    child: Container(
      constraints: BoxConstraints.tightFor(width: 80.0, height: 80.0),
      margin: EdgeInsets.only(right: 8.0),
      decoration: BoxDecoration(
          image: DecorationImage(
              centerSlice: new Rect.fromLTRB(wRight / 2 - 1, hRight / 2 - 1,
                  wRight / 2 + 1, hRight / 2 + 1),
              image: AssetImage('assets/media/chat_baloon_right.png'))),
      child: new Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(text),
      ),
    ),
  );
  return commentWidget;
}
