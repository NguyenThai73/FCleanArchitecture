import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../models/dog_image_model.dart';

abstract class DogRemoteDataSource {
  Future<List<DogImageModel>> getDogImages();
}

@LazySingleton(as: DogRemoteDataSource)
class DogRemoteDataSourceImpl implements DogRemoteDataSource {
  final Dio dio;

  DogRemoteDataSourceImpl(this.dio);

  @override
  Future<List<DogImageModel>> getDogImages() async {
    try {
      final response = await dio.get(
        'https://dog.ceo/api/breed/hound/images',
      );

      if (response.statusCode == 200) {
        final List<dynamic> imageUrls = response.data['message'];
        return imageUrls
            .map((url) => DogImageModel.fromJson(url as String))
            .toList();
      } else {
        throw Exception('Failed to load dog images');
      }
    } catch (e) {
      throw Exception('Failed to load dog images: $e');
    }
  }
}
