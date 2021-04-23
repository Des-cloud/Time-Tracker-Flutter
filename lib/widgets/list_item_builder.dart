import 'package:flutter/material.dart';
import 'package:time_tracker/widgets/empty_page_contents.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemBuilder<T> extends StatelessWidget {
  const ListItemBuilder({Key key, @required this.snapshot, @required this.itemBuilder}) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;

  @override
  Widget build(BuildContext context) {
    if(snapshot.hasData){
      final List<T> items= snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      }
      return EmptyPageContents();
    }
    else if(snapshot.hasError){
      return EmptyPageContents(
        title: "Oops! Something went wrong.",
        message: "Could not retrieve data",
      );
    }
    return Center(
      child: SizedBox(
        width: 100.0,
        height: 100.0,
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
          strokeWidth: 10.0,
        ),
      ),
    );
  }

  Widget _buildList(List<T> items){
    return ListView.separated(
      itemBuilder: (context, index){
        if(index==0 || index==items.length+1)
          return Container();
        return itemBuilder(context, items[index-1]);
      },
      itemCount: items.length+2,
      separatorBuilder: (context, index)=>Divider(
        height: 0.5,
        thickness: 0.5,
        // color: Colors.black54,
      ),
    );
  }

}
