import 'package:flutter/material.dart';

import '../../core/model/api_models.dart';
import '../../core/network/moneylog_api.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late final MoneylogApi _api;
  late Future<List<TransactionItem>> _transactions;

  @override
  void initState() {
    super.initState();
    _api = MoneylogApi();
    _transactions = _api.fetchTransactions(month: '2026-03');
  }

  String won(int v) => '-${v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원';

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
              Chip(label: Text('미분류')),
              Chip(label: Text('분류완료')),
              Chip(label: Text('제외/이체')),
            ],
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<TransactionItem>>(
            future: _transactions,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
              }
              if (snap.hasError) {
                return Column(children: [
                  Text('내역을 불러오지 못했어요\n${snap.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => setState(() => _transactions = _api.fetchTransactions(month: '2026-03')),
                    child: const Text('다시 시도'),
                  )
                ]);
              }

              final items = snap.data!;
              return Column(
                children: items
                    .map((tx) => Card(
                          child: ListTile(
                            leading: const CircleAvatar(child: Icon(Icons.store_mall_directory_outlined)),
                            title: Text(tx.merchant),
                            subtitle: Text(tx.tags.isEmpty ? '미분류' : tx.tags.join(',')),
                            trailing: Text(won(tx.amount), style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
