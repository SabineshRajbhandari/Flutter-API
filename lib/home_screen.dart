import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hello, ${name ?? "World"}!",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                name = _nameController.text;
              });
            },
            child: Text("Greet!"),
          ),
        ],
      ),
    );
  }
}
