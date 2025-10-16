import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/dog_image.dart';
import '../repositories/dog_repository.dart';

@lazySingleton
class GetDogImages implements UseCase<List<DogImage>, NoParams> {
  final DogRepository repository;

  GetDogImages(this.repository);

  @override
  Future<Either<Failure, List<DogImage>>> call(NoParams params) async {
    return await repository.getDogImages();
  }
}
