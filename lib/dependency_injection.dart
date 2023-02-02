import 'package:get_it/get_it.dart';
import 'package:movie_plex/movie_plex/data/data_sources/movie_remote_data_sources.dart';
import 'package:movie_plex/movie_plex/data/repositories/movie_repository_impl.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_movie_detail.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_movie_recommendations.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_now_playing_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_popular_movies.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/search_the_movies.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_recommendations_bloc/movie_recommendations_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/now_playing_movies_bloc/now_playing_movies_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:movie_plex/movie_plex/presentation/bloc/popular_movies_bloc/movie_popular_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/search_the_movie_bloc/search_the_movie_bloc.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // bloc
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));
  locator.registerFactory(() => MovieDetailBloc(locator()));
  locator.registerFactory(() => SearchTheMovieBloc(locator()));
  locator.registerFactory(() => PopularMoviesBloc(locator()));
  locator.registerFactory(() => MovieRecommendationBloc(locator()));

  // use cases
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => SearchTheMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(() =>
      MovieRepositoryImpl(movieRemoteDataSource: locator()));

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(() =>
      MovieRemoteDataSourceImpl(client: locator()));

  locator.registerLazySingleton<http.Client>(() => http.Client());
}