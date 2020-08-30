import 'package:flutter/material.dart';
import 'package:zyuedu/data/model/sources/search_source.dart';
import 'package:zyuedu/res/colors.dart';
import 'package:zyuedu/res/dimens.dart';
import 'package:zyuedu/widget/load_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'book_search_item.dart';

class BookSearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BookSearchPageState();
}

class BookSearchPageState extends State<BookSearchPage> {
  LoadStatus _loadStatus = LoadStatus.SUCCESS;
  List<SearchItem> _list = [];
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          titleView(),
          Divider(height: 1, color: MyColors.dividerDarkColor),
          Expanded(
            child: contentView(),
          ),
        ],
      )),
    );
  }

  void getData(String text) async {
    if (text.isEmpty) {
      Fluttertoast.showToast(msg: "请输入要搜索的书籍", fontSize: 14.0);
      return;
    }
    setState(() {
      _loadStatus = LoadStatus.LOADING;
    });
    await SearchSource.fromKey(text)
        .setExactQuery(true)
        .getAsyncInfo()
        .then((item) {
          setState(() {
            _loadStatus = LoadStatus.SUCCESS;
            _list = item.searchList;
          });
    });

    // FuzzySearchReq categoriesReq = FuzzySearchReq(text);
    // await Repository()
    //     .getFuzzySearchBookList(categoriesReq.toJson())
    //     .then((json) {
    //   var fuzzySearchResp = FuzzySearchResp.fromJson(json);
    //   print(fuzzySearchResp);
    //   if (fuzzySearchResp != null && fuzzySearchResp.books != null) {
    //     setState(() {
    //       _loadStatus = LoadStatus.SUCCESS;
    //       // _list = fuzzySearchResp.books;
    //     });
    //   }
    // }).catchError((e) {
    //   print("2-------------------");
    //   print(e.toString());
    // });
  }

  Widget titleView() {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints.expand(height: Dimens.titleHeight),
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    Dimens.leftMargin, 0, Dimens.rightMargin, 0),
                child: Image.asset(
                  'images/icon_title_back.png',
                  color: MyColors.black,
                  width: 20,
                  height: Dimens.titleHeight,
                ),
              ),
            ),
          ),
          Expanded(
              child: Container(
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: MyColors.homeGrey,
            ),
            padding: EdgeInsets.fromLTRB(7, 0, 0, 0),
            // alignment: Alignment.center,
            child: TextField(
              controller: _controller,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              onSubmitted: (s) {
                getData(_controller.text);
              },
              decoration: InputDecoration(
                  icon: Image.asset(
                    "images/icon_home_search.png",
                    width: 15,
                    height: 15,
                  ),
                  isDense: true,
                  hintText: "斗破苍穹",
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  border: InputBorder.none),
              style: TextStyle(
                color: MyColors.textBlack6,
                fontSize: Dimens.textSizeM,
              ),
            ),
          )),
          MaterialButton(
            minWidth: 10,
            onPressed: () {
              getData(_controller.text);
            },
            child: Text(
              "搜索",
              style: TextStyle(
                  fontSize: Dimens.textSizeM, color: MyColors.textPrimaryColor),
            ),
            height: Dimens.titleHeight,
          )
        ],
      ),
    );
  }

  Widget contentView() {
    if (_loadStatus == LoadStatus.LOADING) {
      return LoadingView();
    } else {
      return ListView.builder(
        itemBuilder: (context, index) => BookSearchItem(_list[index].url),
        padding:
            EdgeInsets.fromLTRB(Dimens.leftMargin, 0, Dimens.leftMargin, 0),
        itemCount: _list.length,
      );
    }
  }

  Widget tagView(String tag) {
    return Container(
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

  String getWordCount(int wordCount) {
    if (wordCount > 10000) {
      return (wordCount / 10000).toStringAsFixed(1) + "万字";
    }
    return wordCount.toString() + "字";
  }
}
