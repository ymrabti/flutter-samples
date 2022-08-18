import 'package:flutter/material.dart';

import '../popup_shapes/popup_shapes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CustomPopupMenu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const Scaffold(
        body: Center(
          child: ExamplePupUpShapes(),
        ),
      ),
    );
  }
}

class ExamplePupUpShapes extends StatefulWidget {
  const ExamplePupUpShapes({Key? key}) : super(key: key);

  @override
  State<ExamplePupUpShapes> createState() => _ExamplePupUpShapesState();
}

class _ExamplePupUpShapesState extends State<ExamplePupUpShapes> {
  @override
  Widget build(BuildContext context) {
    return PopupShapes(
      child: Column(
        children: const [
          Icon(Icons.abc_rounded),
          Icon(Icons.abc_rounded),
          Icon(Icons.abc_rounded),
          Icon(Icons.abc_rounded),
          Icon(Icons.abc_rounded),
          Icon(Icons.abc_rounded),
          Icon(Icons.abc_rounded),
        ],
      ),
      width: 200,
      height: 300,
      position: PopupArrowPosition.bottomLeft,
    );
  }
}
