import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/dog_image.dart';

abstract class DogRepository {
  Future<Either<Failure, List<DogImage>>> getDogImages();
}
