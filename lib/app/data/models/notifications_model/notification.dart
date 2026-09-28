import 'message.dart';

class NotificationData {
  String? id;
  Message? message;
  String? url;
  dynamic type;
  String? orderNum;
  dynamic orderId;
  dynamic senderId;
  String? ticketNum;
  dynamic readAt;
  DateTime? createdAt;

  NotificationData({
    this.id,
    this.message,
    this.url,
    this.type,
    this.orderNum,
    this.orderId,
    this.senderId,
    this.ticketNum,
    this.readAt,
    this.createdAt,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json['id'] as String?,
        message: json['message'] == null
            ? null
            : Message.fromJson(json['message'] as Map<String, dynamic>),
        url: json['url'] as String?,
        type: json['type'] as dynamic,
        orderNum: json['order_num'] as String?,
        orderId: json['order_id'] as dynamic,
        senderId: json['sender_id'] as dynamic,
        ticketNum: json['ticket_num'] as String?,
        readAt: json['read_at'] as dynamic,
        createdAt: json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message?.toJson(),
        'url': url,
        'type': type,
        'order_num': orderNum,
        'order_id': orderId,
        'sender_id': senderId,
        'read_at': readAt,
        'created_at': createdAt?.toIso8601String(),
      };
}
