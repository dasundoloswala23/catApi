class Images {
  String? id;
  String? url;
  int? width;
  int? height;
  String? name;
  List<Breed>? breeds;

  Images({this.id, this.url, this.width, this.height, this.name, this.breeds});

  factory Images.fromJson(Map<String, dynamic> json) {
    List<Breed> breeds = [];
    if (json['breeds'] != null) {
      breeds = (json['breeds'] as List).map((i) => Breed.fromJson(i)).toList();
    }

    return Images(
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
      breeds: breeds,
      name: breeds.isNotEmpty ? breeds[0].name : 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'width': width,
      'height': height,
      'name': name,
      'breeds': breeds?.map((breed) => breed.toJson()).toList(),
    };
  }
}

class Breed {
  String? id;
  String? name;
  String? description;
  String? origin;
  String? temperament;
  String? lifeSpan;

  Breed({this.id, this.name, this.description, this.origin, this.temperament, this.lifeSpan});

  factory Breed.fromJson(Map<String, dynamic> json) {
    return Breed(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      origin: json['origin'],
      temperament: json['temperament'],
      lifeSpan: json['life_span'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'origin': origin,
      'temperament': temperament,
      'life_span': lifeSpan,
    };
  }
}
