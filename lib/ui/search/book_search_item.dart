import 'package:flutter/material.dart';
import 'package:zyuedu/data/model/sources/detail_source.dart';
import 'package:zyuedu/data/model/sources/search_source.dart';
import 'package:zyuedu/res/colors.dart';
import 'package:zyuedu/res/dimens.dart';
import 'package:zyuedu/ui/details/book_info_page.dart';

// ignore: must_be_immutable
class BookSearchItem extends StatefulWidget {
  SearchItem source;
  BookSearchItem(this.source, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => BookSearchItemState();
}

class BookSearchItemState extends State<BookSearchItem> {
  String author = "";
  String cover = "";
  String introduce = "";
  String category = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.source.author == "") {

    }
    this.author = widget.source.author != null ? widget.source.author : "";
    this.introduce = widget.source.introduce != null ? widget.source.introduce : "";
    this.asyncDetailInfo();
  }

  void asyncDetailInfo() async {
    await DetailSource.fromUrl(widget.source.url)
        .getAsyncInfo()
        .then((item) {
      setState(() {
        cover = item.cover;
        introduce = item.introduce;
        author = item.author;
        category = item.category;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => BookInfoPage(widget.source.url, false)),
        );
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              this.cover == "" ? widget.source.cover : this.cover,
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
                    widget.source.name,
                    style: TextStyle(color: MyColors.textBlack3, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  SizedBox(
                    height: 54,
                    child:Text(
                      this.introduce,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: MyColors.textBlack3, fontSize: 12),
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: this.author == ""  ? SizedBox() : Text(
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
                      ),
                      tagView(this.category)
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


  Widget tagView(String tag) {
    return tag == "" ? SizedBox() : Container(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      alignment: Alignment.center,
      child: Text(
        tag,
        style: TextStyle(color: MyColors.textBlack9, fontSize: 11.5),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(3)),
          border: Border.all(width: 0.5, color: MyColors.textBlack9)),
    );
  }
}