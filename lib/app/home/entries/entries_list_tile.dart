import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class EntriesListTileModel {
  const EntriesListTileModel({
    @required this.leadingText,
    @required this.trailingText,
    this.middleText,
    this.isHeader = false,
  });
  final String leadingText;
  final String trailingText;
  final String middleText;
  final bool isHeader;
}

class EntriesListTile extends StatelessWidget {
  const EntriesListTile({@required this.model});
  final EntriesListTileModel model;

  @override
  Widget build(BuildContext context) {
    const fontSize = 16.0;
    final bool isHeader= model.leadingText == "All Entries";
    return Container(
      color: model.isHeader ? Colors.indigo[100] : null,
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: <Widget>[
          if (!isHeader) Padding(
            padding: EdgeInsets.fromLTRB(8.0, 0, 0, 0),
            child: Text(
                  model.leadingText,
                  style: TextStyle(
                      fontSize: !isHeader&& !model.isHeader?12.0:fontSize,
                  )
              ),
          ) else Text(
                  model.leadingText,
              style: TextStyle(
                fontSize: !isHeader&& !model.isHeader?12.0:fontSize,
                fontWeight: FontWeight.bold,
              )
            ),
            Expanded(child: Container()),
            if (model.middleText != null)
              Text(
                model.middleText,
                style: TextStyle(
                    color: Colors.indigo[700],
                    fontSize: !isHeader&& !model.isHeader?12.0:14.0,
                ),
                textAlign: TextAlign.right,
              ),
            SizedBox(
              width: 60.0,
              child: Text(
                model.trailingText,
                style: TextStyle(
                  fontSize: !isHeader&& !model.isHeader?12.0:14.0,
                ),
                textAlign: TextAlign.right,
              ),
            ),
        ],
      ),
    );
  }
}
