import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends HookWidget {
  late ValueNotifier<List<Candle>> candles;
  late ValueNotifier<bool> themeIsDark;

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useOrientation([DeviceOrientation.landscapeLeft]);
    candles = useState<List<Candle>>([]);
    themeIsDark = useState<bool>(true);
    fetchCandles().then((value) {
      candles.value = value;
    });
    return MaterialApp(
      theme: themeIsDark.value ? ThemeData.dark() : ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("BTCUSDT 1H Chart"),
          actions: [
            IconButton(
              onPressed: () {
                themeIsDark.value = !themeIsDark.value;
              },
              icon: Icon(
                themeIsDark.value ? Icons.wb_sunny_sharp : Icons.nightlight_round_outlined,
              ),
            )
          ],
        ),
        body: Center(
          child: Candlesticks(
            candles: candles.value,
          ),
        ),
      ),
    );
  }

  Future<List<Candle>> fetchCandles() async {
    final uri = Uri.parse(
      "https://api.binance.com/api/v3/klines?symbol=BTCUSDT&interval=1m",
    );
    final res = await http.get(uri);
    consoleLog(text: (jsonDecode(res.body) as List<dynamic>).length);
    return (jsonDecode(res.body) as List<dynamic>)
        .map((e) {
          return Candle.fromJson(e);
        })
        .toList()
        .reversed
        .toList();
  }
}

useOrientation(List<DeviceOrientation> orientations) {
  useEffect(
    () {
      SystemChrome.setPreferredOrientations(orientations);
      return () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);
      };
    },
  );
}

void consoleLog({required text, int color = 37}) {
  debugPrint('\x1B[${color}m $text\x1B[0m');
}
