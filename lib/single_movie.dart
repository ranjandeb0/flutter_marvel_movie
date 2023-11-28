import 'package:flutter/material.dart';
import 'package:flutter_application_first/movie_model.dart';

class SingleMovie extends StatefulWidget {
  final MovieModel movie;

  const SingleMovie({super.key, required this.movie});

  @override
  State<SingleMovie> createState() => _SingleMovieState();
}

class _SingleMovieState extends State<SingleMovie>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();

  final double _appBarHeight = 476;

  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: ((notification) {
          final double offset = _scrollController.offset;
          Future.delayed(const Duration(microseconds: 10), () {
            // debugPrint("$offset, ${_scrollController.offset}");
            if (offset < _scrollController.offset &&
                _scrollController.offset < _appBarHeight - kToolbarHeight) {
              Future.microtask(() => _scrollController.animateTo(
                  _appBarHeight - kToolbarHeight,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn));
              setState(() {
                _expanded = false;
              });
            } else if (offset > _scrollController.offset &&
                _scrollController.offset < _appBarHeight) {
              Future.microtask(() {
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              });
              setState(() {
                _expanded = true;
              });
            }
          });

          return false;
        }),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              expandedHeight: _appBarHeight,
              collapsedHeight: 60,
              stretch: true,
              pinned: true,
              title: AnimatedOpacity(
                opacity: _expanded ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 500),
                child: Text(
                  widget.movie.title ?? "No title found",
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontSize: 18),
                ),
              ),

              // floating: true,
              flexibleSpace: Stack(
                children: [
                  SizedBox(
                    height: 476,
                    child: _thumbnail(),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: !_expanded ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 56, left: 30, right: 30, bottom: 12),
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        fit: StackFit.expand,
                        children: [
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Text(
                              widget.movie.title ?? "No title found",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(fontSize: 22),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Opacity(
                              opacity: 0.7,
                              child: MaterialButton(
                                onPressed: () {},
                                child:
                                    Image.asset("assets/images/play_btn.png"),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _expanded ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, left: 16.0, right: 16.0, bottom: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 30),
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3,
                            ),
                            shape: const RoundedRectangleBorder(),
                          ),
                          child: Text(
                            "Download",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            '+Add to Watchlist',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      widget.movie.description ??
                          "The series is a blend of classic television and the Marvel Cinematic Universe in which Wanda Maximoff and Vision—two super-powered beings living idealized suburban lives—begin to suspect that everything is not as it seems.",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        const MyTabs(),
                        SizedBox(
                          height: 950,
                          child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                Container(
                                  height: 50,
                                  color: Colors.amber,
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.red,
                                ),
                                Container(
                                  height: 50,
                                  color: Colors.yellow,
                                ),
                                // Expanded(
                                //   child: ListView.builder(
                                //     itemBuilder: (context, index) => ListTile(
                                //       title: Text("Item $index"),
                                //     ),
                                //     itemCount: 10,
                                //   ),
                                // ),
                              ]),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnail() {
    if (widget.movie.thumbnail?["path"] != null &&
        !widget.movie.thumbnail!["path"]!.endsWith('image_not_available')) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/placeholder.jpg',
        image:
            '${widget.movie.thumbnail?["path"]}.${widget.movie.thumbnail?["extension"]}',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/images/placeholder.jpg',
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }
}

class MyTabs extends StatefulWidget {
  const MyTabs({
    super.key,
  });

  @override
  State<MyTabs> createState() => _MyTabsState();
}

class _MyTabsState extends State<MyTabs> {
  int _activeTab = 0;
  void _toggleActive(int index) {
    setState(() {
      _activeTab = index;
    });
  }

  bool _checkActive(index) => _activeTab == index;

  @override
  Widget build(BuildContext context) {
    return TabBar(
      onTap: (index) => _toggleActive(index),
      labelPadding: EdgeInsets.zero,
      labelColor: Colors.white,
      unselectedLabelColor: Colors.white,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: [
        TabHeader(
          title: 'Trailer',
          active: _checkActive(0),
        ),
        TabHeader(
          title: 'Cast',
          active: _checkActive(1),
        ),
        TabHeader(
          title: 'More',
          active: _checkActive(2),
        ),
      ],
    );
  }
}

class TabHeader extends StatelessWidget {
  const TabHeader({super.key, required this.title, required this.active});
  final String title;
  final bool active;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
          color: active
              ? const Color(0xFF252521)
              : const Color.fromRGBO(255, 255, 255, 0.15),
          border: const Border.symmetric(
              vertical: BorderSide(
                  width: 0.5, color: Color.fromRGBO(255, 255, 255, 0.25)))),
      child: Tab(
        child: Text(
          title,
        ),
      ),
    );
  }
}
