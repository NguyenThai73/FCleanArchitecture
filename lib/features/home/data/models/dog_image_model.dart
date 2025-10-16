import '../../domain/entities/dog_image.dart';

class DogImageModel extends DogImage {
  const DogImageModel({
    required super.url,
  });

  factory DogImageModel.fromJson(String json) {
    return DogImageModel(
      url: json,
    );
  }

  String toJson() {
    return url;
  }
}
