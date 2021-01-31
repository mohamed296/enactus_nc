class EventModel {
  String title;
  int price;
  bool status;

  EventModel({this.title, this.price, this.status});

  EventModel.fromJson(Map<String, dynamic> json) {
    title = json['title'] as String;
    price = json['price'] as int;
    status = json['status'] as bool;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['price'] = price;
    data['status'] = status;
    return data;
  }
}
