import 'package:flutter/material.dart';

class Goods extends StatelessWidget {
  Goods(this.count, this.top, this.bottom);
  final int count;
  final double top;
  final double bottom;

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
            itemCount: count,
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
                      "https://pics7.baidu.com/feed/50da81cb39dbb6fdd27c01c33e61f81f962b37f8.jpeg?token=660ec63b4187d1d92cd384f634b09c29",
                      fit: BoxFit.fill,
                    ),
                    Text("好好的哈" + index.toString()),
                  ],
                ),
              );
            }));
  }
}
