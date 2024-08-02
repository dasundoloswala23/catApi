// model/images.dart
class Images {
  String? id;
  String? name;
  String? url;
  int? width;
  int? height;

  Images({this.id, this.name, this.url, this.width, this.height});

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id'],
      name: json['breeds'][0]['name'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'width': width,
      'height': height,
    };
  }
}
