import 'package:equatable/equatable.dart';

abstract class DogImagesEvent extends Equatable {
  const DogImagesEvent();

  @override
  List<Object> get props => [];
}

class LoadDogImagesEvent extends DogImagesEvent {
  const LoadDogImagesEvent();
}

class RefreshDogImagesEvent extends DogImagesEvent {
  const RefreshDogImagesEvent();
}
