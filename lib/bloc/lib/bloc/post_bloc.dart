import 'dart:async';
import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import '../bloc/bloc.dart';
import '../models/models.dart';
import '../../../utils/api.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final http.Client httpClient;
  final api = Api();
  PostBloc({@required this.httpClient});

  @override
  Stream<PostState> transform(
    Stream<PostEvent> events,
    Stream<PostState> Function(PostEvent event) next,
  ) {
    return super.transform(
      (events as Observable<PostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  get initialState => PostUninitialized();
  int page = 0;

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    if (event is PostRefresh) {
      print('refresh');
      page = 0;
      yield RefreshState();

      final postsLoad = await _fetchPosts(0, 5);
      yield PostLoaded(posts: postsLoad, hasReachedMax: false);
      return;
    }

    if (event is Fetch && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          print('inicial');
          final postsLoad = await _fetchPosts(0, 5);
          yield PostLoaded(posts: postsLoad, hasReachedMax: false);
        }
        if (currentState is PostLoaded) {
          page++;
          final posts = await _fetchPosts(page, 5);
          yield posts.isEmpty
              ? (currentState as PostLoaded).copyWith(hasReachedMax: true)
              : PostLoaded(
                  posts: (currentState as PostLoaded).posts + posts,
                  hasReachedMax: false,
                );
        }
      } catch (_) {
        yield PostError();
      }
    }
  }

  bool _hasReachedMax(PostState state) =>
      state is PostLoaded && state.hasReachedMax;

  Future<List<Post>> _fetchPosts(int startIndex, int limit) async {
    final response = await httpClient
        .get(api.getUrl() + 'posts/get/?size=$limit&page=$startIndex');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final posts =
          data["content"].map<Post>((json) => Post.fromJson(json)).toList();

      return posts;
    } else {
      throw Exception(
          'Ops! Aconteceu um erro! reinicie o App! a BuracosApp esta trabalhando nisso!');
    }
  }
}
