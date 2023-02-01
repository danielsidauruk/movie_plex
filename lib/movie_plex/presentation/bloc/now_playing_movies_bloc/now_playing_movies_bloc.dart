import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_now_playing_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/use_case.dart';

part 'now_playing_movies_event.dart';
part 'now_playing_movies_state.dart';

class NowPlayingMoviesBloc
    extends Bloc<NowPlayingMoviesEvent, NowPlayingMoviesState> {
  final GetNowPlayingMovies getNowPlayingMovies;

  NowPlayingMoviesBloc(this.getNowPlayingMovies)
      : super(NowPlayingMoviesEmpty()) {
    on<FetchNowPlayingMovies>(
      (event, emit) async {
        emit(NowPlayingMoviesLoading());

        final nowPlayingResult = await getNowPlayingMovies.call(NoParams());

        nowPlayingResult.fold(
            (failure) => emit(NowPlayingMoviesError(failure.message)),
            (data) => emit(NowPlayingMoviesHasData(data)));
      },
    );
  }
}
