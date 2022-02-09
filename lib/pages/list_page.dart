// import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/blocs/list/list_bloc.dart';
import 'package:myapp/blocs/list/list_event.dart';
import 'package:myapp/blocs/list/list_state.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ListPageState();
  }
}

class _ListPageState extends State<ListPage> {
  late ListBloc _listBloc;

  @override
  void initState() {
    super.initState();
    _listBloc = BlocProvider.of<ListBloc>(context);
    _listBloc.add(Fetch());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Langauge List'),
      ),
      body: BlocBuilder<ListBloc, ListState>(
        builder: (context, state) {
          if (state is Failure) {
            return const Center(
              child: Text('Oops something went wrong!'),
            );
          }
          if (state is Loaded) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text('no content'),
              );
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                var item = state.items[index];
                return ListTile(
                  leading: Text(item.id),
                  title: Text(item.value),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        item.isEditing
                            ? const CircularProgressIndicator()
                            : IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.black),
                                onPressed: () =>
                                    BlocProvider.of<ListBloc>(context)
                                        .add(Update(id: item.id)),
                              ),
                        item.isDeleting
                            ? const CircularProgressIndicator()
                            : IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    BlocProvider.of<ListBloc>(context)
                                        .add(Delete(id: item.id)),
                              ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: state.items.length,
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
