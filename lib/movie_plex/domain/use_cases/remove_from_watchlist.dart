import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_plex/core/failure.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie_detail.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/use_case.dart';

class RemoveFromWatchlist extends UseCase<String, RemoveParams>{
  final MovieRepository repository;
  RemoveFromWatchlist(this.repository);

  @override
  Future<Either<Failure, String>> call(RemoveParams params) {
    return repository.removeFromWatchlist(params.movieDetail);
  }
}

class RemoveParams extends Equatable {
  const RemoveParams({required this.movieDetail});
  final MovieDetail movieDetail;

  @override
  List<Object?> get props => [movieDetail];

}
