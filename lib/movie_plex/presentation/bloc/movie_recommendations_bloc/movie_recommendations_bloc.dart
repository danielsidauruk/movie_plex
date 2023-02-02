import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_movie_recommendations.dart';

part 'movie_recommendations_event.dart';
part 'movie_recommendations_state.dart';

class MovieRecommendationBloc
    extends Bloc<MovieRecommendationEvent, MovieRecommendationState> {
  final GetMovieRecommendations getMovieRecommendations;

  MovieRecommendationBloc(this.getMovieRecommendations)
      : super(MovieRecommendationEmpty()) {
    on<FetchMovieRecommendation>((event, emit) async {
      final id = event.id;

      emit(MovieRecommendationLoading());

      final recommendationResult = await getMovieRecommendations.call(Params(id: id));

      recommendationResult.fold(
        (failure) => emit(MovieRecommendationError(failure.message)),
        (data) => emit(MovieRecommendationHasData(data)),
      );
    });
  }
}
