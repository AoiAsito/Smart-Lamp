import 'package:flutter/material.dart';
import 'package:wifi_info_flutter/wifi_info_flutter.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(HelloWorldApp());
}

class HelloWorldApp extends StatefulWidget {
  @override
  _HelloWorldAppState createState() => _HelloWorldAppState();
}

class _HelloWorldAppState extends State<HelloWorldApp> {
  String _lampStatus = 'Unknown';

  Future<void> _getLampStatus() async {
    final String? ip = await WifiInfo().getWifiIP();
    final response = await http.get('http://$ip/status' as Uri);

    if (response.statusCode == 200) {
      setState(() {
        _lampStatus = response.body;
      });
    } else {
      throw Exception('Failed to load lamp status');
    }
  }

  Future<void> _switchLamp(String state) async {
    final String? ip = await WifiInfo().getWifiIP();
    await http.get('http://$ip/$state' as Uri);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart Diya'),
          backgroundColor: Colors.black,
        ),
        body: Container(
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    onPressed: _getLampStatus,
                    child: Text('Status: $_lampStatus'),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    onPressed: () => _switchLamp('on'),
                    child: const Text('Switch On'),
                  ),
                ),
                SizedBox(
                  width: 100,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                    ),
                    onPressed: () => _switchLamp('off'),
                    child: const Text('Switch Off'),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Center(
                  child: Image.asset('assets/images/diya.jpg'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
