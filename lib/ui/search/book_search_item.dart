

import 'package:flutter/material.dart';
import 'package:zyuedu/data/model/sources/detail_source.dart';
import 'package:zyuedu/data/model/sources/search_source.dart';
import 'package:zyuedu/res/colors.dart';
import 'package:zyuedu/res/dimens.dart';

// ignore: must_be_immutable
class BookSearchItem extends StatefulWidget {
  final url;
  BookSearchItem(this.url, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => BookSearchItemState();
}

class BookSearchItemState extends State<BookSearchItem> {
  String name = "";
  String url = "";
  String author = "";
  String cover = "";
  String introduce = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      url = widget.url;
    });
    this.asyncDetailInfo();
  }

  void asyncDetailInfo() async {
    await DetailSource.fromUrl(widget.url)
        .getAsyncInfo()
        .then((item) {
      setState(() {
        name = item.name;
        cover = item.cover;
        introduce = item.introduce;
        author = item.author;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      //   Navigator.push(
      //     context,
      //     new MaterialPageRoute(
      //         builder: (context) => BookInfoPage(_list[position].id, false)),
      //   );
      // },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            this.cover == "" ? SizedBox() : Image.network(
              this.cover,
              height: 99,
              width: 77,
              fit: BoxFit.cover,
            ),
            SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    this.name,
                    style: TextStyle(color: MyColors.textBlack3, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          this.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: MyColors.textBlack6, fontSize: 14),
                        ),
                      ),
                      MaterialButton(
                        color: MyColors.textPrimaryColor,
                        onPressed: null,
                        minWidth: 10,
                        height: 32,
                        child: Text(
                          "阅读",
                          style: TextStyle(
                              color: MyColors.white,
                              fontSize: Dimens.textSizeL),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // tagView(_list[position].cat),
                      SizedBox(
                        width: 6,
                      ),
                      // tagView(getWordCount(_list[position].wordCount)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}