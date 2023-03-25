import 'package:chat/dal/openai/open_ai_repository.dart';
import 'package:chat/dal/preferences/common_preferences.dart';
import 'package:chat/dal/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _token = "";

  late TextEditingController _tokenController =
      TextEditingController(text: _token);

  final TextEditingController _ipController = TextEditingController();

  final TextEditingController _portController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController(text: _token);
    SecureStorage.read(SecureStorage.keyOpenAiToken).then((value) => {
          //show token
          setState(() {
            _token = value;
            _tokenController.text = _token;
          })
        });
    CommonPreferences.getString(CommonPreferences.keyProxyIp).then((value) => {
          //show ip
          setState(() {
            _ipController.text = value ?? "";
          })
        });
    //get port
    CommonPreferences.getString(CommonPreferences.keyProxyPort)
        .then((value) => {
              //show port
              setState(() {
                _portController.text = value ?? "";
              })
            });
  }

  @override
  void dispose() {
    _tokenController.dispose();
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Row tokenRow = _buildTokenRow();
    Row proxyRow = _buildProxyView();
    SizedBox space = const SizedBox(
      height: 16,
    );
    Row saveRow = _buildSaveRow();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [tokenRow, proxyRow, space, saveRow],
          ),
        ),
      ),
    );
  }

  ///设置token
  Row _buildTokenRow() {
    Text tokenLabel = const Text(
      'Token',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
    TextField tokenTextField = TextField(
      controller: _tokenController,
      decoration: const InputDecoration(
        hintText: 'Enter your token',
      ),
    );
    Row tokenRow = Row(
      children: [
        tokenLabel,
        const SizedBox(
          width: 16,
        ),
        Expanded(child: tokenTextField)
      ],
    );
    return tokenRow;
  }

  ///代理设置
  Row _buildProxyView() {
    SizedBox space = const SizedBox(width: 16);
    List<Widget> childViews = [];
    Text proxyLabel = const Text(
      'Proxy',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16.0,
      ),
    );
    childViews.add(proxyLabel);
    childViews.add(space);
    TextField ipField = TextField(
      controller: _ipController,
      decoration: const InputDecoration(
        labelText: 'IP Address',
      ),
    );
    Expanded ipExpanded = Expanded(
      child: ipField,
      flex: 3,
    );
    childViews.add(ipExpanded);
    childViews.add(space);
    TextField portField = TextField(
      controller: _portController,
      decoration: const InputDecoration(
        labelText: 'Port',
      ),
    );
    Expanded portExpanded = Expanded(
      child: portField,
      flex: 1,
    );
    childViews.add(portExpanded);
    childViews.add(space);
    ElevatedButton checkButton = ElevatedButton(
      onPressed: _checkOpenAIConnection,
      child: const Text('Check'),
    );
    childViews.add(checkButton);
    Row proxyRow = Row(
      children: childViews,
    );
    return proxyRow;
  }

  ///保存
  Row _buildSaveRow() {
    ElevatedButton saveButton = ElevatedButton(
      onPressed: _saveSettings,
      child: const Text('Save'),
    );
    Row row = Row(
      children: [saveButton],
    );
    return row;
  }

  ///检查openai连接
  void _checkOpenAIConnection() {
    OpenAiRepository.checkConnection(
        _ipController.text.trim(), _portController.text.trim());
  }

  void _saveSettings() {
    final token = _tokenController.text.trim();
    if (token.isNotEmpty) {
      SecureStorage.write(SecureStorage.keyOpenAiToken, token);
    }
    String proxyIp = _ipController.text.trim();
    String proxyPort = _portController.text.trim();
    CommonPreferences.setString(CommonPreferences.keyProxyIp, proxyIp);
    CommonPreferences.setString(CommonPreferences.keyProxyPort, proxyPort);
  }
}
