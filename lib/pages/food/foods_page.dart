import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/food/food_bloc.dart';
import 'package:myapp/blocs/food/search_bloc.dart';
import 'package:myapp/blocs/food/search_event.dart';
import 'package:myapp/blocs/food/search_state.dart';
import 'package:myapp/config/router.dart';
import 'package:myapp/models/food.dart';

class FoodsPage extends StatefulWidget {
  const FoodsPage({Key? key}) : super(key: key);

  @override
  _FoodsPageState createState() => _FoodsPageState();
}

class _FoodsPageState extends State<FoodsPage> {
  late FoodBloc foodBloc;

  @override
  void initState() {
    foodBloc = BlocProvider.of<FoodBloc>(context);
    foodBloc.add(FetchFoodEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: FoodSearch(
                  searchBloc: BlocProvider.of<FoodSearchBloc>(context),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<FoodBloc, FoodState>(builder: (context, state) {
          if (state is FoodInitialState) {
            return buildLoading();
          } else if (state is FoodLoadingState) {
            return buildLoading();
          } else if (state is FoodLoadedState) {
            return buildFoodList(state.recipes);
          } else if (state is FoodErrorState) {
            return buildError(state.message);
          }
          return Container();
        }),
      ),
    );
  }
}

class FoodSearch extends SearchDelegate<List> {
  FoodSearchBloc searchBloc;
  String? searchString;
  FoodSearch({required this.searchBloc, this.searchString});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            Navigator.maybePop(context);
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        close(context, []);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchBloc.add(FoodSearchEvent(food: query));
    return SingleChildScrollView(
        child: BlocBuilder<FoodSearchBloc, SearchState>(
      builder: (BuildContext context, SearchState state) {
        if (state is FoodSearchInitialState) {
          return buildLoading();
        }
        if (state is FoodSearchErrorState) {
          return buildError(state.message);
        }
        if (state is FoodSearchLoadedState) {
          if (state.recipes.isEmpty) {
            return buildError('No Results');
          }
          return buildFoodList(state.recipes);
        }
        return const Scaffold();
      },
    ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}

Widget buildLoading() {
  return const SizedBox(
    height: 100,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

Widget buildFoodList(List<Recipe> recipes) {
  return Column(
    children: [
      ListView.builder(
          itemCount: recipes.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, FOOD_DETAIL_ROUTE,
                      arguments: recipes[index]);
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: DecorationImage(
                                image: NetworkImage(recipes[index].imageUrl),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            width: 130,
                            height: 30,
                            padding: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                recipes[index].publisher,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(recipes[index].title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4)),
                              const SizedBox(height: 5),
                              Text(
                                recipes[index].publisherUrl,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const SizedBox(height: 5),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     SizedBox(
                //         height: 90,
                //         width: 100,
                //         child: Image.network(recipes[index].imageUrl)),
                //     Text(recipes[index].title),
                //   ],
                // ),
              ),
            );
          }),
    ],
  );
}

Widget buildError(String message) {
  return SizedBox(height: 100, child: Center(child: Text(message)));
}
