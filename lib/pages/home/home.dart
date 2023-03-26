import 'package:chat/dal/openai/model/chat_request.dart';
import 'package:chat/dal/openai/open_ai_repository.dart';
import 'package:chat/dal/preferences/common_preferences.dart';
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
  void initState() {
    super.initState();
    _initDio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.settings),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Text(_outputText)),
              _buildInputRow(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildInputRow(){
    return Row(children: [
      Expanded(
        child: TextField(
          decoration: const InputDecoration(
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
    ]);
  }

  void _makeRequest(String message) {
    SecureStorage.read(SecureStorage.keyOpenAiToken).then((value) {
      ChatRequest request = ChatRequest();
      request.apiKey = value;
      request.message = message;
      OpenAiRepository.makeHttpRequest(request).then((value) {
        setState(() {
          _outputText = value!.choices[0].message.content;
        });
      });
    });
  }

  void _initDio() async{
    String? ip = await CommonPreferences.getString(CommonPreferences.keyProxyIp);
    String? port = await CommonPreferences.getString(CommonPreferences.keyProxyPort);
    OpenAiRepository.init(ip, port);
  }
}
