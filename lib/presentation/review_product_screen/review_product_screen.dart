import 'package:flutter/material.dart';

class ReviewProductScreen extends StatelessWidget {
  const ReviewProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Product'),
      ),
      body: const Center(
        child: Text('Review Product Screen'),
      ),
    );
  }
}
