class EventModel {
  String title;
  int price;
  bool status;

  EventModel({this.title, this.price, this.status});

  EventModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    price = json['price'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['price'] = this.price;
    data['status'] = this.status;
    return data;
  }
}
