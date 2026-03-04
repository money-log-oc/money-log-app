import 'package:flutter/material.dart';

import '../../core/model/api_models.dart';
import '../../core/network/moneylog_api.dart';

enum TxFilter { all, unclassified, classified, excluded }

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late final MoneylogApi _api;
  late Future<List<TransactionItem>> _transactions;
  late String _month;
  TxFilter _filter = TxFilter.all;

  @override
  void initState() {
    super.initState();
    _api = MoneylogApi();
    final now = DateTime.now();
    _month = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    _transactions = _api.fetchTransactions(month: _month);
  }

  Future<void> _reload() async {
    setState(() => _transactions = _api.fetchTransactions(month: _month));
    await _transactions;
  }

  List<TransactionItem> _applyFilter(List<TransactionItem> items) {
    switch (_filter) {
      case TxFilter.all:
        return items;
      case TxFilter.unclassified:
        return items.where((e) => !e.excluded && e.tags.isEmpty).toList();
      case TxFilter.classified:
        return items.where((e) => !e.excluded && e.tags.isNotEmpty).toList();
      case TxFilter.excluded:
        return items.where((e) => e.excluded).toList();
    }
  }

  Future<void> _classify(TransactionItem tx) async {
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Wrap(children: [
          const ListTile(title: Text('태그 선택')),
          ...['음식', '카페', '생활', '교통', '쇼핑', '회식'].map((t) =>
              ListTile(title: Text(t), onTap: () => Navigator.pop(ctx, t))),
          if (tx.excluded)
            ListTile(
              title: const Text('제외 해제'),
              onTap: () => Navigator.pop(ctx, '__unexclude__'),
            ),
          ListTile(
            title: const Text('제외 처리(이체)'),
            textColor: Colors.red,
            onTap: () => Navigator.pop(ctx, '__exclude__'),
          )
        ]),
      ),
    );

    if (picked == null) return;

    try {
      if (picked == '__exclude__') {
        await _api.updateTransactionExcluded(tx.id, true, reason: 'TRANSFER');
      } else if (picked == '__unexclude__') {
        await _api.updateTransactionExcluded(tx.id, false);
      } else {
        await _api.updateTransactionTag(tx.id, [picked]);
      }
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('반영 완료')));
      }
      await _reload();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('반영 실패: $e')));
      }
    }
  }

  String won(int v) =>
      '-${v.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',')}원';

  String _filterLabel(TxFilter f) {
    switch (f) {
      case TxFilter.all:
        return '전체';
      case TxFilter.unclassified:
        return '미분류';
      case TxFilter.classified:
        return '분류완료';
      case TxFilter.excluded:
        return '제외/이체';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('내역',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              DropdownButton<String>(
                value: _month,
                onChanged: (v) {
                  if (v == null) return;
                  setState(() {
                    _month = v;
                    _transactions = _api.fetchTransactions(month: _month);
                  });
                },
                items: List.generate(3, (i) {
                  final d = DateTime.now().subtract(Duration(days: i * 30));
                  final v = '${d.year}-${d.month.toString().padLeft(2, '0')}';
                  return DropdownMenuItem(value: v, child: Text(v));
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: TxFilter.values
                .map((f) => ChoiceChip(
                      label: Text(_filterLabel(f)),
                      selected: _filter == f,
                      onSelected: (_) => setState(() => _filter = f),
                    ))
                .toList(),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<TransactionItem>>(
            future: _transactions,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator()));
              }
              if (snap.hasError) {
                return Column(children: [
                  Text('내역을 불러오지 못했어요\n${snap.error}',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => _reload(),
                    child: const Text('다시 시도'),
                  )
                ]);
              }

              final items = _applyFilter(snap.data!);
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: Text('조건에 맞는 내역이 없어요.')),
                );
              }
              return Column(
                children: items
                    .map((tx) => Card(
                          child: ListTile(
                            onTap: () => _classify(tx),
                            leading: const CircleAvatar(
                                child:
                                    Icon(Icons.store_mall_directory_outlined)),
                            title: Text(tx.merchant),
                            subtitle: Text(tx.excluded
                                ? '제외됨'
                                : (tx.tags.isEmpty
                                    ? '미분류'
                                    : tx.tags.join(','))),
                            trailing: Text(won(tx.amount),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
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
