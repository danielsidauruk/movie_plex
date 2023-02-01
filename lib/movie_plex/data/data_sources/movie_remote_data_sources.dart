import 'dart:convert';
import 'package:movie_plex/core/exception.dart';
import 'package:movie_plex/movie_plex/data/models/movie_model.dart';
import 'package:http/http.dart' as http;
import 'package:movie_plex/core/constants.dart';
import 'package:movie_plex/movie_plex/data/models/movie_response.dart';

abstract class MovieRemoteDataSource {
  Future<List<MovieModel>> getNowPlayingMovies();
}

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  MovieRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MovieModel>> getNowPlayingMovies() async {
    final response =
        await client.get(Uri.parse('$baseURL/movie/now_playing?$apiKey'));

    if (response.statusCode == 200) {
      return MovieResponse.fromJson(json.decode(response.body)).movieList;
    } else {
      throw ServerException();
    }
  }
}