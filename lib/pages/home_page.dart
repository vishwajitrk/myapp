import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  IconData _searchIcon = Icons.search;
  // ignore: unused_field
  late Widget _appBarTitle;
  late HomeBloc _homeBloc;

  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of(context);
    WidgetsBinding.instance?.addPostFrameCallback((_) => fetchArticles());
    WidgetsBinding.instance
        ?.addPostFrameCallback((_) => buildAppBarTitle());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text("Home"),),
          body: Container(
            child: buildListView(context, state),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void buildAppBarTitle() {
    setState(() {
      if (_searchIcon == Icons.search) {
        _appBarTitle = const Text("Home");
      } else {
        _appBarTitle = TextField(
          onChanged: (String inputValue) {
            debugPrint("Search term has changed $inputValue");
            //homeBloc.fetchArticles(filter: inputValue);
          },
          style: const TextStyle(
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            hintText: "Search",
          ),
        );
      }
    });
  }

  Widget buildAppBarSearchIcon() {
    return IconButton(
        icon: Icon(
          _searchIcon,
          color: Colors.white,
        ),
        onPressed: () {
          if (_searchIcon == Icons.search) {
            //display the search text field and close icons

            setState(() {
              _searchIcon = Icons.close;
              buildAppBarTitle();
              //homeBloc.toggleFiltering();
            });
          } else {
            fetchArticles();
            setState(() {
              _searchIcon = Icons.search;
              buildAppBarTitle();
              //homeBloc.toggleFiltering();
            });
          }
        });
  }

  Widget buildListView(
      BuildContext context, HomeState state) {
    if (state.articles.isNotEmpty) {
      var listView = ListView.builder(
          itemCount: state.articles.length,
          itemBuilder: (context, index) {
            var item = state.articles[index];

            if (item is String) {
              return buildListFirstInitialView(item);
            }

            Article article = item as Article;

            return buildListArticleView(article);
          });

      return listView;
    } else {
      return const Center(
        child: Text("No resources found."),
      );
    }
  }

  Widget buildListFirstInitialView(String initial) {
    return ListTile(
      title: Text(initial),
    );
  }

  Widget buildListArticleView(Article article) {
    return ListTile(
      title: Text('${article.title}'),
    );
  }

  Widget buildBottomNavigationBar() {
    return BottomNavigationBar(
        currentIndex: 0,
        onTap: (int position) {},
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ]);
  }

  void fetchArticles({String filter = ""}) {
    HomeEvent event = HomeEvent();
    event.event = HomeEvent.FETCH_ARTICLES;
    _homeBloc.add(event);
  }
}

class HomeEvent {
  static const int FETCH_ARTICLES = 1;
  static const int TOGGLE_IS_FILTERING = 2;
  int _event = 0;
  String _filterKeyword = "";

  int get event => _event;

  void set event(int event) {
    this._event = event;
  }

  String get filterKeyword => _filterKeyword;

  void set filterKeyword(String filterKeyword) {
    this._filterKeyword = filterKeyword;
  }
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository repository;

  HomeState get initialState => HomeState();

  HomeBloc({required this.repository}) : super(HomeState()) {
    on<HomeEvent>((event, emit) async {
      switch (event.event) {
      case HomeEvent.FETCH_ARTICLES:
        {
          List<dynamic> articles =[];
          fetchArticles(filter: event.filterKeyword).listen((dynamic article) {
            articles.add(article);
          });
          emit(state.copyWith(articles: articles));
          break;
        }
      case HomeEvent.TOGGLE_IS_FILTERING:
        {
          state.isFiltering = ! state.isFiltering;
          emit(state.copyWith());
          break;
        }
      default:
        {
          emit(state.initial());
          break;
        }
    }

    emit(state);
    });
  }


  Stream<dynamic> fetchArticles({String filter = ""}) async* {
    List<dynamic> list = (state.articles.isNotEmpty)
        ? state.articles
        : await repository.getArticles();
    if (filter.isNotEmpty) {
      for (var article in list) {
        if (article is String) {
          yield article;
        } else if (article.title.contains(filter)) {
          yield article;
        }
      }
    } else {
      for (var article in list) {
        yield article;
      }
    }
  }
}

class HomeState {
  bool _isFiltering = false;
  List<dynamic> _articles =[];

  bool get isFiltering => _isFiltering;

  void set isFiltering(bool isFiltering) {
    this._isFiltering = isFiltering;
  }

  List<dynamic> get articles => _articles;

  void set articles(List<dynamic> list) {
    this._articles = list;
  }

  HomeState initial() {
    HomeState state = HomeState();
    state.isFiltering = false;
    state.articles =[];

    return state;
  }

  HomeState copyWith({ bool? isFiltering, List<dynamic>? articles }) {
    HomeState state = HomeState();
    state.isFiltering = isFiltering != null? isFiltering: this._isFiltering;
    state.articles = articles!=null && articles.length > 0? articles: this._articles;

    return state;
  }
}

class HomeRepository {
  Future<List<dynamic>> getArticles() async {
    List<dynamic> list =[];
    list.add("A");

    Article article1 = Article();
    article1.id = 1;
    article1.title = "A start is born";
    list.add(article1);

    Article article2 = Article();
    article2.id = 2;
    article2.title = "Asking for help";
    list.add(article2);

    Article article3 = Article();
    article3.id = 3;
    article3.title = "Angel is comming";
    list.add(article3);

    list.add("B");

    Article article4 = Article();
    article4.id = 4;
    article4.title = "Baby Boss";
    list.add(article4);

    Article article5 = Article();
    article5.id = 5;
    article5.title = "Beginner guide to Staying at Home";
    list.add(article5);

    list.add("C");

    Article article6 = Article();
    article6.id = 6;
    article6.title = "Care each other";
    list.add(article6);

    Article article7 = Article();
    article7.id = 7;
    article7.title = "Controlling the world";
    list.add(article7);

    Article article8 = Article();
    article8.id = 8;
    article8.title = "Chasing the dream";
    list.add(article8);

    return list;
  }
}

class Article {
  int? id;
  String? title;

  Article({this.id, this.title});
}