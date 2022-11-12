import 'package:http/http.dart' as https;

import 'Api_manger.dart';

class API{
  Future get(String apiUrl) async{
    try{
      return https.get(
          Uri.parse(ApiManger.BaseUrl + apiUrl),
          headers: {
            'Content-type': 'application/json',
          }
      );
    }catch(e){
      print(['API exception get', e.toString()]);
    }
  }}