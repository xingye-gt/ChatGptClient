import 'package:chat/dal/openai/model/general_request.dart';
import 'package:chat/dal/openai/open_ai_repository.dart';
import 'package:chat/dal/secure_storage/secure_storage.dart';
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
              //go to setting page
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Text("123")),
            Row(children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '请输入文本',
                  ),
                  onChanged: (text) {
                    setState(() {
                      _inputText = text;
                    });
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _makeRequest(_inputText);
                },
                child: const Text('Chat'),
              ),
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _makeRequest(String message) {
    SecureStorage.read(SecureStorage.keyOpenAiToken).then((value){
      GeneralRequest request = GeneralRequest();
      request.apiKey = value;
      request.message = message;
      OpenAiRepository.makeHttpRequest(request);
    });
  }
}
