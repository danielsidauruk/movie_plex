import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie_detail.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_watchlist_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_watchlist_status.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/remove_from_watchlist.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/save_to_watchlist.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/use_case.dart';

part 'movie_watchlist_event.dart';
part 'movie_watchlist_state.dart';

class MovieWatchlistBloc
    extends Bloc<MovieWatchlistEvent, MovieWatchlistState> {
  final GetWatchlistMovies getMovieWatchlist;
  final GetWatchListStatus getWatchListMovieStatus;
  final SaveToWatchlist saveWatchlist;
  final RemoveFromWatchlist removeWatchlist;

  MovieWatchlistBloc(this.getMovieWatchlist, this.getWatchListMovieStatus,
      this.saveWatchlist, this.removeWatchlist)
      : super(MovieWatchlistEmpty()) {


    on<FetchMovieWatchlist>((event, emit) async {
      emit(MovieWatchlistLoading());
      final watchlistResult = await getMovieWatchlist.call(NoParams());

      watchlistResult.fold(
            (failure) => emit(MovieWatchlistError(failure.message)),
            (data) => emit(MovieWatchlistHasData(data)),
      );});

    on<LoadWatchlistStatus>(((event, emit) async {
      final id = event.id;
      final result = await getWatchListMovieStatus.execute(id);

      emit(WatchlistHasData(result));
    }));

    on<AddMovieWatchlist>((event, emit) async {
      final movie = event.movie;
      final result = await saveWatchlist.call(SaveParams(movieDetail: movie));

      result.fold(
        (failure) => emit(WatchlistFailure(failure.message)),
        (successMessage) => emit(const WatchlistSuccess('Added to Watchlist')),
      );

      add(LoadWatchlistStatus(movie.id));
    });

    on<DeleteMovieWatchlist>((event, emit) async {
      final movie = event.movie;
      final result = await removeWatchlist.call(RemoveParams(movieDetail: movie));

      result.fold(
        (failure) => emit(WatchlistFailure(failure.message)),
        (successMessage) =>
            emit(const WatchlistSuccess('Removed from Watchlist')),
      );
      add(LoadWatchlistStatus(movie.id));
    });
  }
}
