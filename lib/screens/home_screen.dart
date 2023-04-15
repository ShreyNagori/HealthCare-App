import 'dart:async';
import 'dart:convert';
import 'package:finalapp/screens/signin_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Hello, Shrey'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Timer timer;
  int heartRate = 0;
  int spo2 = 0;
  double temperature = 0.0;
  List<charts.Series<ChartData, String>> seriesList = [];

  @override
  void initState() {
    super.initState();
    fetchReadings();
    startTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => fetchReadings());
  }

  Future<void> fetchReadings() async {
    try {
      final heartRateResponse = await http.get(
        Uri.parse(
            'https://io.adafruit.com/api/v2/ShreyNagori/feeds/heart-rate-bpm'),
        headers: {'X-AIO-Key': 'aio_dJai07tS0YAYGSmyXkYBgiP9SYkz'},
      );
      final spo2Response = await http.get(
        Uri.parse(
            'https://io.adafruit.com/api/v2/ShreyNagori/feeds/oxygen-level-spo2'),
        headers: {'X-AIO-Key': 'aio_dJai07tS0YAYGSmyXkYBgiP9SYkz'},
      );
      final temperatureResponse = await http.get(
        Uri.parse(
            "https://io.adafruit.com/api/v2/ShreyNagori/feeds/body-temperature-degrees-c"),
        headers: {'X-AIO-Key': 'aio_dJai07tS0YAYGSmyXkYBgiP9SYkz'},
      );

      if (heartRateResponse.statusCode == 200 &&
          spo2Response.statusCode == 200 &&
          temperatureResponse.statusCode == 200) {
        final heartRateData = jsonDecode(heartRateResponse.body);
        final spo2Data = jsonDecode(spo2Response.body);
        final temperatureData = jsonDecode(temperatureResponse.body);

        setState(() {
          heartRate = heartRateData['value'].round();
          print(heartRate);
          spo2 = spo2Data['value'].round();
          temperature =
              double.parse(temperatureData['value'].toStringAsFixed(1));
          seriesList = [
            new charts.Series<ChartData, String>(
              id: 'Data',
              colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
              domainFn: (ChartData data, _) => data.label,
              measureFn: (ChartData data, _) => data.value,
              data: [
                new ChartData('Heart Rate', heartRate),
                new ChartData('SpO2', spo2),
                new ChartData('Temperature', temperature.round()),
              ],
            )
          ];
        });
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 4, 138, 248),
        title: Text("BodyBudE"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30.0,
              ),
            ),
            Expanded(
              flex: 2,
              child: charts.BarChart(
                seriesList,
                animate: true,
                vertical: false,
                barRendererDecorator: new charts.BarLabelDecorator<String>(
                    insideLabelStyleSpec: new charts.TextStyleSpec(
                      color: charts.MaterialPalette.white,
                      fontSize: 12,
                    ),
                    outsideLabelStyleSpec: new charts.TextStyleSpec(
                      color: charts.MaterialPalette.black,
                      fontSize: 12,
                    )),
                domainAxis: new charts.OrdinalAxisSpec(),
                behaviors: [new charts.PanAndZoomBehavior()],
              ),
            ),
            SizedBox(height: 30.0),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.heartbeat,
                          color: Colors.red, size: 50),
                      SizedBox(width: 50),
                      Text(
                        'Heart Rate: $heartRate bpm',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Row(
                    children: <Widget>[
                      Icon(FontAwesomeIcons.lungs,
                          color: Colors.blue, size: 30),
                      SizedBox(width: 10),
                      Text(
                        'SpO2: $spo2 %',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.0),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.thermostat,
                        color: Colors.orange,
                        size: 50,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Temperature: $temperature °C',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChartData {
  final String label;
  final int value;

  ChartData(this.label, this.value);
}
