// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_application_first/single_movie.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'globar_movie_app_bar.dart';
import 'movie_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: const ColorScheme.dark(
          background: Colors.black,
          primary: Color(0xFFED1B24),
          onBackground: Color.fromRGBO(255, 255, 255, 0.5),
          secondaryContainer: Color.fromRGBO(217, 217, 217, 0.1),
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Color.fromRGBO(255, 255, 255, 0.5),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(255, 255, 255, 0.5),
          ),
          labelMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      home: FutureBuilder(
        future: MovieModel.fetchMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return MyHomePage(
              title: 'Flutter Demo Home Page',
              movies: snapshot.data!,
            );
          } else if (snapshot.hasError) {
            return ErrorWidget.withDetails(
                message: "Seems there was an error loading data");
          }
          return const Center(
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title, required this.movies});

  final String title;
  final List<MovieModel> movies;
  final TextEditingController _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MovieAppBar(),
      body: DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyMedium!,
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Container(
                color: Theme.of(context).colorScheme.primary,
                child: const TabBar(
                  padding: EdgeInsets.all(2),
                  labelPadding: EdgeInsets.zero,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(color: Colors.black),
                  enableFeedback: false,
                  tabs: [
                    SwitcherTabs("Downloads"),
                    SwitcherTabs("Watchlist"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    MovieListView(
                        movies:
                            movies.where((movie) => !movie.watchList).toList()),
                    Column(
                      children: [
                        TextField(
                          controller: _date,
                          readOnly: true,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_month_rounded),
                            labelText: "Select Date",
                          ),
                          onTap: () async {
                            DateTime? datePicked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(DateTime.now().year + 1000));

                            if (datePicked != null) {
                              _date.text =
                                  DateFormat('dd/MM/yyyy').format(datePicked);
                            }
                          },
                        ),
                        Expanded(
                          child: MovieListView(
                              movies: movies
                                  .where((movie) => movie.watchList)
                                  .toList()),
                        ),
                      ],
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
}

class MovieListView extends StatelessWidget {
  const MovieListView({
    super.key,
    required this.movies,
  });

  final List<MovieModel> movies;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: movies.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: 16,
      ),
      itemBuilder: (context, index) {
        return MovieTile(
          movie: movies[index],
        );
      },
    );
  }
}

class MovieTile extends StatelessWidget {
  const MovieTile({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleMovie(
                      movie: movie,
                    )));
      },
      child: Container(
        height: 130,
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            () {
              if (movie.thumbnail?["path"] != null &&
                  !movie.thumbnail!["path"]!.endsWith('image_not_available')) {
                return FadeInImage.assetNetwork(
                  placeholder: 'assets/images/placeholder.jpg',
                  image:
                      '${movie.thumbnail?["path"]}.${movie.thumbnail?["extension"]}',
                  width: 95,
                  fit: BoxFit.cover,
                );
              } else {
                return Image.asset(
                  'assets/images/placeholder.jpg',
                  width: 95,
                  fit: BoxFit.cover,
                );
              }
            }(),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title ?? "Name of the movie",
                          maxLines: 1,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const Gap(4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 150,
                              child: LinearProgressIndicator(
                                backgroundColor:
                                    const Color.fromRGBO(255, 255, 255, 0.3),
                                value: movie.watchPercentage / 100,
                                color: Theme.of(context).colorScheme.primary,
                                minHeight: 5,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            const Gap(20),
                            Text('${movie.size} GB'),
                          ],
                        ),
                        Text(
                          '${movie.watchPercentage}% Watched',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Opacity(
                      opacity: 0.5,
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: MaterialButton(
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          child: SvgPicture.asset(
                            'assets/images/trash.svg',
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitcherTabs extends StatelessWidget {
  const SwitcherTabs(
    this.title, {
    super.key,
  });
  final String title;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Tab(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}
