class NumberUtils{
  static String getStrToWan(int popularity){
    //12345  1.23
    double b = 10000.0;
    double a = 9990000;
    if(popularity>a){
      return "999w+";
    }else if(popularity>=b){
      var stringAsFixed = (popularity/b).toStringAsFixed(2);
      return "${stringAsFixed}w";
    }else{
      return popularity.toString();
    }
  }
}