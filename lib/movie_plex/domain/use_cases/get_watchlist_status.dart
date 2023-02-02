import 'package:movie_plex/movie_plex/domain/repositories/movie_repository.dart';

class GetWatchListStatus {
  final MovieRepository repository;
  GetWatchListStatus(this.repository);

  Future<bool> execute(int id) async {
    return repository.isAddedToWatchlist(id);
  }
}
