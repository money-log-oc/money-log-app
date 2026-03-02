import 'package:flutter/material.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          const Text('내역', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: const [
              Chip(label: Text('전체')),
              Chip(label: Text('미분류 8')),
              Chip(label: Text('분류완료')),
              Chip(label: Text('제외/이체')),
            ],
          ),
          const SizedBox(height: 8),
          ...['파리바게뜨','GS25','쿠팡','계좌이체'].map((m)=>Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.store_mall_directory_outlined)),
              title: Text(m),
              subtitle: const Text('미분류'),
              trailing: const Text('-2,700원', style: TextStyle(fontWeight: FontWeight.w700)),
            ),
          )),
        ],
      ),
    );
  }
}
