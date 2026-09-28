import 'package:get/get.dart';

enum OtpType { register, forgetPass }

enum RegisterType { normal, social }

enum WalletStatus {
  pending,
  charged,
  pulled;

  String toJson() {
    return name.capitalizeFirst!;
  }

  static WalletStatus fromJson(String json) =>
      values.byName(json.toLowerCase());
}

enum OrderStatus {
  pending,
  pendingPayment,
  waitingforDriver,
  driverAccepted,
  delivered,
  cancelled;

  String toJson() {
    String status = name.replaceAllMapped(
        RegExp(r'(?<!^)([A-Z])'), (Match match) => ' ${match.group(1)}');

    return status[0].toUpperCase() + status.substring(1);
  }

  static OrderStatus fromJson(String json) =>
      values.byName(json.replaceAll(' ', '')[0].toLowerCase() +
          json.replaceAll(' ', '').substring(1));
}

enum RequestType { wayaak, goodealz }

enum MesssageStatus { sent, loading, failed }
