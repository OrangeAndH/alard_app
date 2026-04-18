import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;

  const ListCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Text(
          trailing,
          style: const TextStyle(
            color: Color(0xFF7A8D2F),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}