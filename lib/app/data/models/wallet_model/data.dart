import 'earning_history.dart';

class Data {
  String? balance;
  DateTime? lastUpdate;
  int? transactionsCount;
  List<EarningHistory>? earningHistory;

  Data({
    this.balance,
    this.lastUpdate,
    this.transactionsCount,
    this.earningHistory,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        balance: json['balance'].toString(),
        lastUpdate: json['last_update'] == null
            ? null
            : DateTime.parse(json['last_update'] as String),
        transactionsCount: json['transactions_count'] as int?,
        earningHistory: (json['earning_history'] as List<dynamic>?)
            ?.map((e) => EarningHistory.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'balance': balance,
        'last_update': lastUpdate?.toIso8601String(),
        'transactions_count': transactionsCount,
        'earning_history': earningHistory?.map((e) => e.toJson()).toList(),
      };
}
