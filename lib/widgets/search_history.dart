import 'package:flutter/material.dart';

class SearchHistory extends StatelessWidget {
  final Function onSearch, onDelete;
  final String query;
  final List<String> history;
  const SearchHistory({
    Key? key,
    required this.onSearch,
    required this.onDelete,
    required this.query,
    required this.history,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Card(
          child: Builder(
            builder: (context) {
              if (history.isEmpty && query.isEmpty) {
                return Container();
              } else if (history.isEmpty) {
                return ListTile(
                  title: Text(query),
                  leading: const Icon(Icons.search),
                  onTap: () {
                    onSearch(query);
                  },
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: history
                      .map(
                        (term) => ListTile(
                          title: Text(
                            term,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: const Icon(Icons.history),
                          trailing: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              onDelete(term);
                            },
                          ),
                          onTap: () {
                            onSearch(term);
                          },
                        ),
                      )
                      .toList(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
