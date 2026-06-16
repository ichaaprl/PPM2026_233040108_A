import 'package:flutter/material.dart';

class GaleryWidget extends StatelessWidget {
  const GaleryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Widget Gallery")),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(15),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: List.generate(6, (index) {
          return Card(
            elevation: 0,
            color: Colors.pink.shade50.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.pink.shade100),
            ),
            child: Center(
              child: Icon(Icons.image, size: 40, color: Colors.pink.shade300),
            ),
          );
        }),
      ),
    );
  }
}