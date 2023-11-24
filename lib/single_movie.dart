import 'package:flutter/material.dart';
import 'package:flutter_application_first/movie_model.dart';

class SingleMovie extends StatelessWidget {
  final MovieModel movie;
  final _scrollController = ScrollController();
  final double _appBarHeight = 476;

  SingleMovie({super.key, required this.movie});
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
            } else if (offset > _scrollController.offset &&
                _scrollController.offset < _appBarHeight) {
              Future.microtask(() {
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
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
              title: Text(movie.title ?? "No title found"),
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
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                ((context, index) => ListTile(title: Text("Text $index"))),
                childCount: 30,
              ),

              /*: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                itemBuilder: (context, index) {
                  return Text("Text $index");
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 16,
                    ),
                itemCount: 30*/
            )
          ],
        ),
      ),
    );
  }

  Widget _thumbnail() {
    if (movie.thumbnail?["path"] != null &&
        !movie.thumbnail!["path"]!.endsWith('image_not_available')) {
      return FadeInImage.assetNetwork(
        placeholder: 'assets/images/placeholder.jpg',
        image: '${movie.thumbnail?["path"]}.${movie.thumbnail?["extension"]}',
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
