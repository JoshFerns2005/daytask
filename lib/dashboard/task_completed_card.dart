import 'package:flutter/material.dart';

class TaskCompletedCard extends StatelessWidget {
  final String title;

  const TaskCompletedCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 250,  // Set the fixed height you want
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF455A64),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              color: Colors.white,
              fontFamily: "PilatExtended",
              fontSize: 20,
            ),
          ),
          const Spacer(), // This pushes the following widgets to the bottom
          const Text(
            "Completed 100%",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 8),
          const LinearProgressIndicator(
            value: 1,
            backgroundColor: Color(0xFF6F8793),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      ),
    );
  }
}
