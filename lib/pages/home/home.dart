import 'package:flutter/material.dart';

import '../setting/setting.dart';


class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _inputText = '';
  String _outputText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // TODO: implement settings
              //go to setting page
              Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: '请输入文本',
              ),
              onChanged: (text) {
                setState(() {
                  _inputText = text;
                });
              },
            ),
            SizedBox(height: 20),
            Text(_outputText),
          ],
        ),
      ),
    );
  }
}
