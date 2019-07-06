import 'dart:async';

import 'package:dio/dio.dart';

class ChatStream {
  List _messages = [];
  final _chatStream = StreamController<List>();
  final _chatStreamGetter = StreamController<List>();
  Timer timer;

  Stream<List> get chatGetter => _chatStreamGetter.stream;
  Stream<List> get chatStream => _chatStream.stream;
  StreamSink<List> get chatSink => _chatStream.sink;
  StreamSink<List> get chatSetter => _chatStreamGetter.sink;

  ChatStream() {
    _chatStream.add(_messages);
    _chatStreamGetter.stream.listen(getMessages);
    timer = Timer.periodic(Duration(milliseconds: 200), (timer)async{
      await getJSON().then((value){
        _messages = value;
        chatSink.add(_messages);
      }).catchError((error){print("error:$error");});
    });
  }

  getMessages(List map) async {
    _messages = await getJSON().catchError(() {
      return map;
    });
    chatSink.add(_messages);
  }

  sendMessages(List map) async {
    sendJSON(map).whenComplete(() {
      chatSink.add(map);
    });
  }

//--------------------------------------------------------------------------------------
//TODO: Go to http://www.myjson.com , create an empty list [], save it, and copy/past
//      your API link in getJSON() and sendJSON()'s --PLACE YOUR API LINK HERE-- fields
//---------------------------------------------------------------------------------------

  getJSON() async {
    var response = await Dio()
        .get("--PLACE YOUR API LINK HERE--")
        .catchError((error) {
      return Response(data: {
        "messages": [
          {"message": error.toString(), "who": 2}
        ]
      });
    });
    return response.data;
  }

  Future sendJSON(List map) async {
    await Dio()
        .put("--PLACE YOUR API LINK HERE--", data: map)
        .catchError((error) {
      print("error: $error");
    });
  }

  dispose(){
    _chatStream.close();
    _chatStreamGetter.close();
    timer.cancel();
  }
}
