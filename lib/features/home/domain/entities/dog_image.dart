import 'package:equatable/equatable.dart';

class DogImage extends Equatable {
  final String url;

  const DogImage({
    required this.url,
  });

  @override
  List<Object?> get props => [url];
}
