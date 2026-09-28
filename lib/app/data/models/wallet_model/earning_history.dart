import 'package:wayaak_delivery/app/core/enums/enums.dart';

class EarningHistory {
  String? orderNum;
  String? profit;
  DateTime? date;
  WalletStatus? status;

  EarningHistory({this.orderNum, this.profit, this.date, this.status});

  factory EarningHistory.fromJson(Map<String, dynamic> json) {
    return EarningHistory(
      orderNum: json['order_num'] as String?,
      profit: json['profit'].toString(),
      status: WalletStatus.fromJson(json['status'].toString()),
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'order_num': orderNum,
        'profit': profit,
        'date': date?.toIso8601String(),
        'status': status?.toJson(),
      };
}
