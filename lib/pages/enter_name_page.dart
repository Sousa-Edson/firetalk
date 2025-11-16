import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'rooms_page.dart';

class EnterNamePage extends StatefulWidget {
  const EnterNamePage({super.key});

  @override
  State<EnterNamePage> createState() => _EnterNamePageState();
}

class _EnterNamePageState extends State<EnterNamePage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = _nameController.text.trim();

    if (name.isEmpty) return;

    await prefs.setString('username', name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const RoomsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Bem-vindo ao FireTalk 🔥",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Digite seu nome",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveName, child: const Text("Entrar")),
            ],
          ),
        ),
      ),
    );
  }
}
