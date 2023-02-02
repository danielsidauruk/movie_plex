import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:movie_plex/core/failure.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie_detail.dart';
import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/use_case.dart';

class SaveToWatchlist extends UseCase<String, SaveParams>{
  final MovieRepository repository;
  SaveToWatchlist(this.repository);

  @override
  Future<Either<Failure, String>> call(SaveParams params) {
    return repository.saveToWatchlist(params.movieDetail);
  }
}

class SaveParams extends Equatable {
  final MovieDetail movieDetail;
  const SaveParams({required this.movieDetail});

  @override
  List<Object?> get props => [movieDetail];
}
