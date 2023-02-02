import 'package:dartz/dartz.dart';
import 'package:movie_plex/core/failure.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/use_case.dart';

class GetTopRatedMovies extends UseCase<List<Movie>, NoParams>{
  final MovieRepository repository;
  GetTopRatedMovies(this.repository);
  
  @override
  Future<Either<Failure, List<Movie>>> call(NoParams params) {
    return repository.getTopRatedMovies();
  }
}
