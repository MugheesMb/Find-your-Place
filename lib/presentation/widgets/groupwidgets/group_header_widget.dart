import 'package:flutter/material.dart';

class GroupHeaderWidget extends StatelessWidget {
  const GroupHeaderWidget({required this.title, Key? key}) : super(key: key);

  final String title;
  static const double padding = 16;
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(title, style: const TextStyle(fontSize: 26)),
      ),
    );
  }
}
