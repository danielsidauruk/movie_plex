import 'package:get_it/get_it.dart';
import 'package:movie_plex/movie_plex/data/data_sources/movie_remote_data_sources.dart';
import 'package:movie_plex/movie_plex/data/repositories/movie_repository_impl.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_now_playing_movies.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/now_playing_movies_bloc/now_playing_movies_bloc.dart';
import 'package:http/http.dart' as http;

final locator = GetIt.instance;

Future<void> init() async {
  // bloc
  locator.registerFactory(() => NowPlayingMoviesBloc(locator()));

  // use cases
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(() =>
      MovieRepositoryImpl(movieRemoteDataSource: locator()));

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(() =>
      MovieRemoteDataSourceImpl(client: locator()));

  locator.registerLazySingleton<http.Client>(() => http.Client());
}