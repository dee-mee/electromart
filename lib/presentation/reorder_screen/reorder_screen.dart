import 'package:flutter/material.dart';

class ReorderScreen extends StatelessWidget {
  const ReorderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reorder'),
      ),
      body: const Center(
        child: Text('Reorder Screen'),
      ),
    );
  }
}
