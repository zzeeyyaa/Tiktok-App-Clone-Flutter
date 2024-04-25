import 'package:flutter/material.dart';

class UploadCustomIcon extends StatelessWidget {
  const UploadCustomIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 46,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12),
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.deepPurple.shade300,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 12),
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellow.shade300,
            ),
          ),
          Center(
            child: Container(
              height: double.infinity,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}
