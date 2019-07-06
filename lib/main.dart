import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'message.dart';
import 'chat_stream.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(title: 'Chat Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ChatStream chatStream;
  List chatList;
  List<Widget> chatWidgetList;
  String textField;
  String me;

  @override
  void initState() {
    super.initState();
    me = "";
    textField = "";
    chatStream = ChatStream();
    chatList = [];
    chatWidgetList = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person_add),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (cont) {
                    return AlertDialog(
                      content: TextField(
                        onChanged: (text) {
                          me = text;
                        },
                        onSubmitted: (text) {
                          me = text;
                        },
                      ),
                    );
                  });
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: StreamBuilder<List>(
                stream: chatStream.chatStream,
                builder: (cont, snap) {
                  if (snap.hasData) {
                    chatList = snap.data;
                    chatWidgetList = [];
                    var msg;
                    for (var k in chatList) {
                        if (k['who'] == me) {
                          msg = Container(
                            padding: EdgeInsets.fromLTRB(
                                MediaQuery.of(context).size.width / 4, 5, 5, 5),
                            child: MessageContainer(
                              me: me,
                              text: k['message'],
                              who: k['who'],
                            ),
                          );
                        } else {
                          msg = Container(
                            padding: EdgeInsets.fromLTRB(
                                5, 5, MediaQuery.of(context).size.width / 4, 5),
                            child: MessageContainer(
                              me: me,
                              text: k['message'],
                              who: k['who'],
                            ),
                          );
                        }
                        chatWidgetList.add(msg);
                      
                    }
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        reverse: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: chatWidgetList,
                        ),
                      ),
                    );
                  } else if (snap.hasError) {
                    return Center(
                      child: MessageContainer(
                        text: "Error: ${snap.error}",
                        who: "2",
                      ),
                    );
                  }
                  return Center(
                    child: MessageContainer(
                      text: "Waiting",
                      who: "0",
                      me: me,
                    ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  onChanged: (text) {
                    textField = text;
                  },
                  onSubmitted: (text) {
                    if (text != "") {
                      textField = text;
                      var faza = {"message": textField, "who": me};
                      textField = "";
                      chatList.add(faza);
                      chatStream.sendMessages(chatList);
                    }
                  },
                ),
              ),
              FlatButton(
                color: blue,
                child: Container(
                  color: blue,
                  padding: EdgeInsets.all(5),
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (textField != "") {
                    var faza = {"message": textField, "who": me};
                    textField = "";
                    chatList.add(faza);
                    chatStream.sendMessages(chatList);
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
