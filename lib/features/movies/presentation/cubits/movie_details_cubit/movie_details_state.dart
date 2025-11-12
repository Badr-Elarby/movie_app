import '../../../data/models/movie_details_model.dart';
import '../../../data/models/video_model.dart';

abstract class MovieDetailsState {
  const MovieDetailsState();
}

class MovieDetailsInitial extends MovieDetailsState {
  const MovieDetailsInitial();
}

class MovieDetailsLoading extends MovieDetailsState {
  const MovieDetailsLoading();
}

class MovieDetailsFailure extends MovieDetailsState {
  const MovieDetailsFailure(this.message);
  final String message;
}

class MovieDetailsSuccess extends MovieDetailsState {
  const MovieDetailsSuccess(this.details, {this.trailerKey, this.videos});

  final MovieDetailsModel details;
  final String? trailerKey;
  final List<VideoModel>? videos;
}
