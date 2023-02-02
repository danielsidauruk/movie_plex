import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie_detail.dart';
import 'package:movie_plex/movie_plex/domain/use_cases/get_movie_detail.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      final id = event.id;

      emit(MovieDetailLoading());
      final detailResult = await getMovieDetail.call(Params(id: id));

      detailResult.fold(
              (failure) => emit(MovieDetailError(failure.message)),
              (data) => emit(MovieDetailHasData(data)));
      },
    );
  }
}