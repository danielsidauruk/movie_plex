import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:movie_plex/core/constants.dart';
import 'package:movie_plex/core/exception.dart';
import 'package:movie_plex/core/failure.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/data/data_sources/movie_remote_data_sources.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource movieRemoteDataSource;

  MovieRepositoryImpl({required this.movieRemoteDataSource});

  @override
  Future<Either<Failure, List<Movie>>> getNowPlayingMovies() async {
    try {
      final result = await movieRemoteDataSource.getNowPlayingMovies();
      return Right(result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return const Left(ServerFailure(serverFailureMessage));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to the network'));
    }
  }
}