import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:movie_plex/core/constants.dart';
import 'package:movie_plex/movie_plex/domain/entities/genre.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie_detail.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_detail_bloc/movie_detail_bloc.dart';

class MovieDetailPage extends StatefulWidget {
  const MovieDetailPage({super.key, required this.id});
  final int id;

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<MovieDetailBloc>(context, listen: false)
          .add(FetchMovieDetail(widget.id));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MovieDetailBloc, MovieDetailState>(
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const DetailLoadingAnimation();
          } else if (state is MovieDetailHasData) {
            final movieDetail = state.result;
            return buildDetailMovie(movieDetail, context);
          } else if (state is MovieDetailError) {
            return Text(state.message);
          } else {
            return const Center();
          }
        },
      ),
    );
  }

  SafeArea buildDetailMovie(MovieDetail detail, context) {
    return SafeArea(
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: baseImageURL(detail.posterPath),
            width: double.infinity,
            placeholder: (context, url) => Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey,
            ),
            errorWidget: (context, url, error) => Image.asset(
              'assets/images/not_applicable_icon.png',
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 48 + 8),
            child: DraggableScrollableSheet(
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    left: 16,
                    top: 16,
                    right: 16,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 16),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                detail.title,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              
                              const SizedBox(height: 8.0),

                              Text(
                                _showGenres(detail.genres),
                                style: Theme.of(context).textTheme.subtitle1?.
                                copyWith(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 2.0),

                              Text(
                                _showDuration(detail.runtime),
                              ),

                              const SizedBox(height: 2.0),

                              Row(
                                children: [
                                  RatingBarIndicator(
                                    rating: detail.voteAverage / 2,
                                    itemCount: 5,
                                    itemBuilder: (context, index) =>
                                    const Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    ),
                                    itemSize: 24,
                                  ),
                                  Text(
                                    '${detail.voteAverage}',
                                    style: Theme.of(context).textTheme.subtitle2?.
                                    copyWith(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),

                              const SizedBox(height: 8),

                              Text(
                                'Overview',
                                style: Theme.of(context).textTheme.subtitle1?.
                                copyWith(fontWeight: FontWeight.bold),
                              ),

                              Text(detail.overview),

                              const SizedBox(height: 8),

                              Text(
                                'Recommendations',
                                style: Theme.of(context).textTheme.subtitle1?.
                                copyWith(fontWeight: FontWeight.bold),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          color: Colors.white,
                          height: 4,
                          width: 48,
                        ),
                      ),
                    ],
                  ),
                );
              },
              minChildSize: 0.25,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _showGenres(List<Genre> genres) {
    String result = '';
    for (var genre in genres) {
      result += '${genre.name}, ';
    }

    if (result.isEmpty) {
      return result;
    }

    return result.substring(0, result.length - 2);
  }

  String _showDuration(int runtime) {
    final int hours = runtime ~/ 60;
    final int minutes = runtime % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}

class DetailLoadingAnimation extends StatelessWidget {
  const DetailLoadingAnimation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.grey,
        ),

        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
