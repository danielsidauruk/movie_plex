import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_plex/core/routes.dart';
import 'package:movie_plex/core/utils.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_detail_bloc/movie_detail_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_recommendations_bloc/movie_recommendations_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/movie_watchlist_bloc/movie_watchlist_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/now_playing_movies_bloc/now_playing_movies_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/popular_movies_bloc/movie_popular_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/bloc/search_the_movie_bloc/search_the_movie_bloc.dart';
import 'package:movie_plex/movie_plex/presentation/pages/movie_detail_page.dart';
import 'package:movie_plex/movie_plex/presentation/pages/movie_home_page.dart';
import 'package:movie_plex/dependency_injection.dart' as di;
import 'package:movie_plex/movie_plex/presentation/pages/movie_now_playing_page.dart';
import 'package:movie_plex/movie_plex/presentation/pages/movie_popular_page.dart';
import 'package:movie_plex/movie_plex/presentation/pages/movie_search_page.dart';
import 'package:movie_plex/movie_plex/presentation/pages/watchlist_page.dart';

void main() async {
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.locator<NowPlayingMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieDetailBloc>()),
        BlocProvider(create: (_) => di.locator<SearchTheMovieBloc>()),
        BlocProvider(create: (_) => di.locator<PopularMoviesBloc>()),
        BlocProvider(create: (_) => di.locator<MovieRecommendationBloc>()),
        BlocProvider(create: (_) => di.locator<MovieWatchlistBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Media Flex',
        theme: ThemeData(

          fontFamily: 'Roboto',
          scaffoldBackgroundColor: Colors.black,
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 56),
            headline2: TextStyle(fontSize: 45),
            bodyText1: TextStyle(fontSize: 28),
            subtitle1: TextStyle(fontSize: 16),
            subtitle2: TextStyle(fontSize: 14),
            button: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),

          brightness: Brightness.dark,
          primaryColor: Colors.black,
          accentColor: Colors.white,
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
        home: const MovieHomePage(),

        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case movieHomeRoute:
              return MaterialPageRoute(builder: (_) => const MovieHomePage());
            case nowPlayingMoviesRoute:
              return MaterialPageRoute(builder: (_) => const NowPlayingMoviesPage());
            case searchTheMovieRoute:
              return MaterialPageRoute(builder: (_) => const SearchTheMoviePage());
            case popularMoviesRoute:
              return MaterialPageRoute(builder: (_) => const PopularMoviesPage());
            case watchlistMoviesRoute:
              return MaterialPageRoute(builder: (_) => const WatchlistPage());
            case movieDetailRoute:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
          }
        },
      ),
    );
  }
}