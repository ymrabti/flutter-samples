import 'package:flutter/material.dart';

import './screens/splash_screen.dart';
import './screens/sellers_screen.dart';
import './screens/product_screen.dart';
import './screens/product_details_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      routes: <String, Widget Function(BuildContext)>{
        SellersScreen.routeName: (_) => const SellersScreen(),
        ProductScreen.routeName: (_) => const ProductScreen(),
        ProductDetailsScreen.routeName: (_) => const ProductDetailsScreen(),
      },
    );
  }
}
