class CycleRange {
  final DateTime? startAt;
  final DateTime? endAt;

  CycleRange({required this.startAt, required this.endAt});

  factory CycleRange.fromJson(Map<String, dynamic> j) => CycleRange(
        startAt: DateTime.tryParse((j['startAt'] ?? '').toString()),
        endAt: DateTime.tryParse((j['endAt'] ?? '').toString()),
      );
}

class HomeSummary {
  final int monthlyBudget;
  final int weeklySpent;
  final int weeklyLimit;
  final int livingAccountBalance;
  final CycleRange? cycle;

  HomeSummary({
    required this.monthlyBudget,
    required this.weeklySpent,
    required this.weeklyLimit,
    required this.livingAccountBalance,
    required this.cycle,
  });

  factory HomeSummary.fromJson(Map<String, dynamic> j) => HomeSummary(
        monthlyBudget: (j['monthlyBudget'] ?? 0) as int,
        weeklySpent: (j['weeklySpent'] ?? 0) as int,
        weeklyLimit: (j['weeklyLimit'] ?? 0) as int,
        livingAccountBalance: (j['livingAccountBalance'] ?? 0) as int,
        cycle: j['cycle'] is Map<String, dynamic>
            ? CycleRange.fromJson(j['cycle'] as Map<String, dynamic>)
            : null,
      );
}

class TransactionItem {
  final int id;
  final String merchant;
  final int amount;
  final String occurredAt;
  final List<String> tags;
  final bool excluded;

  TransactionItem({
    required this.id,
    required this.merchant,
    required this.amount,
    required this.occurredAt,
    required this.tags,
    required this.excluded,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> j) => TransactionItem(
        id: (j['id'] ?? 0) as int,
        merchant: (j['merchant'] ?? '') as String,
        amount: (j['amount'] ?? 0) as int,
        occurredAt: (j['occurredAt'] ?? '') as String,
        tags: ((j['tags'] ?? []) as List).map((e) => e.toString()).toList(),
        excluded: (j['excluded'] ?? false) as bool,
      );
}

class TagReportItem {
  final String tag;
  final int amount;

  TagReportItem({required this.tag, required this.amount});

  factory TagReportItem.fromJson(Map<String, dynamic> j) => TagReportItem(
      tag: (j['tag'] ?? '') as String, amount: (j['amount'] ?? 0) as int);
}

class DailySpendingItem {
  final String date;
  final int income;
  final int expense;

  DailySpendingItem({
    required this.date,
    required this.income,
    required this.expense,
  });

  factory DailySpendingItem.fromJson(Map<String, dynamic> j) =>
      DailySpendingItem(
        date: (j['date'] ?? '') as String,
        income: (j['income'] ?? 0) as int,
        expense: (j['expense'] ?? 0) as int,
      );
}
