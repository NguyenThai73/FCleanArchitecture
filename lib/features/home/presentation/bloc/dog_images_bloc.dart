import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_dog_images.dart';
import 'dog_images_event.dart';
import 'dog_images_state.dart';

@injectable
class DogImagesBloc extends Bloc<DogImagesEvent, DogImagesState> {
  final GetDogImages getDogImages;

  DogImagesBloc(this.getDogImages) : super(const DogImagesInitial()) {
    on<LoadDogImagesEvent>(_onLoadDogImages);
    on<RefreshDogImagesEvent>(_onRefreshDogImages);
  }

  Future<void> _onLoadDogImages(
    LoadDogImagesEvent event,
    Emitter<DogImagesState> emit,
  ) async {
    emit(const DogImagesLoading());
    final result = await getDogImages(NoParams());
    result.fold(
      (failure) => emit(DogImagesError(failure.message)),
      (images) => emit(DogImagesLoaded(images)),
    );
  }

  Future<void> _onRefreshDogImages(
    RefreshDogImagesEvent event,
    Emitter<DogImagesState> emit,
  ) async {
    final result = await getDogImages(NoParams());
    result.fold(
      (failure) => emit(DogImagesError(failure.message)),
      (images) => emit(DogImagesLoaded(images)),
    );
  }
}
