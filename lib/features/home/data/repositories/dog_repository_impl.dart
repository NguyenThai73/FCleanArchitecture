import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/dog_image.dart';
import '../../domain/repositories/dog_repository.dart';
import '../datasources/dog_remote_data_source.dart';

@LazySingleton(as: DogRepository)
class DogRepositoryImpl implements DogRepository {
  final DogRemoteDataSource remoteDataSource;

  DogRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<DogImage>>> getDogImages() async {
    try {
      final dogImages = await remoteDataSource.getDogImages();
      return Right(dogImages);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch dog images: ${e.toString()}'));
    }
  }
}
