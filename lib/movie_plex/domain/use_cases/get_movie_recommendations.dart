import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_plex/core/failure.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/use_case.dart';

class GetMovieRecommendations extends UseCase<List<Movie>, Params>{
  final MovieRepository repository;
  GetMovieRecommendations(this.repository);

  @override
  Future<Either<Failure, List<Movie>>> call(Params params) {
    return repository.getMovieRecommendations(params.id);
  }
}

class Params extends Equatable {
  const Params({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}
