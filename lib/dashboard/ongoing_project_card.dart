import 'package:flutter/material.dart';

class OngoingProjectCard extends StatelessWidget {
  final String title;
  final String dueDate;
  final double percent;

  const OngoingProjectCard({
    super.key,
    required this.title,
    required this.dueDate,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF455A64),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Section: Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "PilatExtended",
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),

          // Bottom Section: Due Date and Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Due on: $dueDate", style: const TextStyle(color: Colors.white)),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      value: percent / 100,
                      strokeWidth: 5,
                      color: const Color(0xFFFED36A),
                    ),
                  ),
                  Text("${percent.toDouble()}%", style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
