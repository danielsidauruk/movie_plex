import 'package:get_it/get_it.dart';
import 'package:movie_plex/movie_plex/data/data_sources/database/movie_database_helper.dart';
import 'package:movie_plex/movie_plex/data/data_sources/movie_local_data_source.dart';
import 'package:movie_plex/movie_plex/data/data_sources/movie_remote_data_sources.dart';
import 'package:movie_plex/movie_plex/data/repositories/movie_repository_impl.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_movie_detail.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_movie_recommendations.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_now_playing_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_popular_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_top_rated_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_watchlist_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_watchlist_status.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/remove_from_watchlist.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/save_to_watchlist.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/search_the_movies.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_recommendations_bloc/movie_recommendations_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_watchlist_bloc/movie_watchlist_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/now_playing_movies_bloc/now_playing_movies_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:movie_plex/movie_plex/presentation/bloc/popular_movies_bloc/movie_popular_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/search_the_movie_bloc/search_the_movie_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/top_rated_movies_bloc/movie_top_rated_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // bloc
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => MovieDetailBloc(locator()));
  locator.registerFactory(() => SearchTheMovieBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => MovieRecommendationBloc(locator()));
  locator.registerFactory(() => MovieWatchlistBloc(
    locator(),
    locator(),
    locator(),
    locator(),
  ));
  locator.registerFactory(() => TopRatedMoviesBloc(locator()));

  // use cases
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => SearchTheMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveToWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveFromWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(() =>
      MovieRepositoryImpl(
        remoteDataSource: locator(),
        localDataSource: locator(),
      ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(() =>
      MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
          () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  // external
  locator.registerLazySingleton<http.Client>(() => http.Client());
  locator.registerLazySingleton<MovieDatabaseHelper>(() => MovieDatabaseHelper());
}