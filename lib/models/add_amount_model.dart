class AddAmountModel {
  final int id;
  final String title;
  final double amount;
  final DateTime date;

  AddAmountModel({required this.id, required this.title, required this.amount, required this.date});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory AddAmountModel.fromJson(Map<String, dynamic> json) {
    var amount = json['amount'];
    if (amount is int) {
      amount = amount.toDouble();
    }
    return AddAmountModel(
      id: json['id'],
      title: json['title'],
      amount: amount,
      date: DateTime.parse(json['date']),
    );
  }
}
