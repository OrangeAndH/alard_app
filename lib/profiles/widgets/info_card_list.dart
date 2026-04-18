import 'package:flutter/material.dart';

class InfoCardList extends StatelessWidget {
  final List<Widget> children;

  const InfoCardList({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(children: children),
    );
  }
}