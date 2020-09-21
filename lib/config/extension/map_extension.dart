extension xtMap on Map {
  Map dealMap() {
    var tt = this;
    print("runtimeType--------1-----------");
    print(this.runtimeType.toString());
    print("runtimeType--------1-----------");

    tt = Map.from(tt);
    for (var key in tt.keys) {
      var result = tt[key];

      if (result.runtimeType.toString().contains("List")) {
        var tl = [];
        for (var temp in result) {
          if (temp.runtimeType.toString() ==
              "_InternalLinkedHashMap<String, dynamic>") {
            tl.add(Map.from(temp).dealMap());
          }
        }
        tt[key] = tl;
      } else if (result.runtimeType
          .toString()
          .contains("_InternalLinkedHashMap<String, dynamic>")) {
        tt[key] = Map.from(result).dealMap();
      }
    }

    return tt;
  }
}
