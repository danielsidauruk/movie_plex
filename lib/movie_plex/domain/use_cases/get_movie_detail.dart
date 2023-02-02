import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_plex/core/failure.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie_detail.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/use_case.dart';

class GetMovieDetail extends UseCase<MovieDetail, Params>{
  final MovieRepository repository;
  GetMovieDetail(this.repository);

  @override
  Future<Either<Failure, MovieDetail>> call(Params params) {
    return repository.getMovieDetail(params.id);
  }
}

class Params extends Equatable {
  const Params({required this.id});
  final int id;

  @override
  List<Object?> get props => [id];
}

