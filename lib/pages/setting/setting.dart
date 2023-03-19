import 'package:chat/dal/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {

  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _tokenController;

  String _token = "";

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
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  void _saveToken() {
    final token = _tokenController.text.trim();
    SecureStorage.write(SecureStorage.keyOpenAiToken, token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Token',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            TextField(
              controller: _tokenController,
              decoration: const InputDecoration(
                hintText: 'Enter your token',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveToken,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
