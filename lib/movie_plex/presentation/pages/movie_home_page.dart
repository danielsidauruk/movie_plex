import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_plex/core/constants.dart';
import 'package:movie_plex/core/routes.dart';
import 'package:movie_plex/movie_plex/domain/entities/movie.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/now_playing_movies_bloc/now_playing_movies_bloc.dart';
import 'package:movie_plex/shared/presentation/widget/horizontal_loading_animation.dart';
import 'package:movie_plex/shared/presentation/widget/search_tile.dart';
import 'package:movie_plex/shared/presentation/widget/sub_heading_tile.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({super.key});

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      BlocProvider.of<NowPlayingMoviesBloc>(context, listen: false)
          .add(FetchNowPlayingMovies());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Movies Plex',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, watchlistMoviesRoute),
            icon: const Icon(Icons.bookmark_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              SearchTile(
                context: context,
                title: 'Search your Movie',
                routeName: searchTheMovieRoute,
              ),

              Container(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.white),
                ),
                child: Column(
                  children: [

                    SubHeadingTile(context: context, title: 'Now Playing Movies', routeName: nowPlayingMoviesRoute),

                    BlocBuilder<NowPlayingMoviesBloc, NowPlayingMoviesState>(
                      builder: (context, state) {
                        if (state is NowPlayingMoviesLoading) {
                          return const HorizontalLoadingAnimation();
                        } else if (state is NowPlayingMoviesHasData) {
                          final movieResult = state.result;
                          return buildMovieResult(movieResult);
                        } else if (state is NowPlayingMoviesError) {
                          return Text(state.message);
                        } else {
                          return const Center();
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  SizedBox buildMovieResult(List<Movie> movieResult) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () => Navigator.pushNamed(
              context,
              movieDetailRoute,
              arguments: movieResult[index].id,
            ),
            child: movieResult[index].posterPath != null ?
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                width: 80,
                imageUrl: baseImageURL(movieResult[index].posterPath!),
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 126,
                  color: Colors.grey,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/not_applicable_icon.png',
                ),
              ),
            ) : const Center(),
          );
        },
      ),
    );
  }
}
