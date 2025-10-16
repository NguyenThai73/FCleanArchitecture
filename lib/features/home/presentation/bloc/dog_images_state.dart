import 'package:equatable/equatable.dart';
import '../../domain/entities/dog_image.dart';

abstract class DogImagesState extends Equatable {
  const DogImagesState();

  @override
  List<Object> get props => [];
}

class DogImagesInitial extends DogImagesState {
  const DogImagesInitial();
}

class DogImagesLoading extends DogImagesState {
  const DogImagesLoading();
}

class DogImagesLoaded extends DogImagesState {
  final List<DogImage> images;

  const DogImagesLoaded(this.images);

  @override
  List<Object> get props => [images];
}

class DogImagesError extends DogImagesState {
  final String message;

  const DogImagesError(this.message);

  @override
  List<Object> get props => [message];
}
