import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_popular_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/use_case.dart';

part 'movie_popular_event.dart';
part 'movie_popular_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final GetPopularMovies getPopularMovies;

  PopularMoviesBloc(this.getPopularMovies) : super(PopularMoviesEmpty()) {
    on<FetchPopularMovies>(
      (event, emit) async {
        emit(PopularMoviesLoading());

        final popularResult = await getPopularMovies.call(NoParams());

        popularResult.fold(
          (failure) => emit(PopularMoviesError(failure.message)),
          (data) => emit(PopularMoviesHasData(data)));
      },
    );
  }
}
