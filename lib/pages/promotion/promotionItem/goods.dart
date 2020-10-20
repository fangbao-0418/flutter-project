import 'package:flutter/material.dart';
import 'package:xtflutter/model/goods_model.dart';

class Goods extends StatelessWidget {
  Goods(this.top, this.bottom, this.list);

  final double top;
  final double bottom;
  final List<GoodsItemDataModel> list;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: this.top, bottom: this.bottom),
        child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              // childAspectRatio: 2,
            ),
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.red,
                  width: 2,
                )),
                child: Column(
                  children: <Widget>[
                    Image.network(
                      list[index].coverImage,
                      fit: BoxFit.fill,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
                      child: Text(
                        list[index].buyingPrice.toString(),
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}
