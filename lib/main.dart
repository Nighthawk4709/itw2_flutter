import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'flipscreen.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyTheme with ChangeNotifier {
  static bool _isDark = true;
  ThemeMode currentTheme() {
    return _isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void switchTheme() {
    _isDark = !_isDark;
    notifyListeners();
  }
}

MyTheme currentTheme = MyTheme();

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      print('Changed');
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: currentTheme.currentTheme(),
      home: RandomWords(),
    );
  }
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
            counter--;
          } else {
            _saved.add(pair);
            counter++;
          }
          //print(counter);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        actions: [
          FlatButton.icon(
              onPressed: () {
                currentTheme.switchTheme();
              },
              icon: Icon(Icons.brightness_1_sharp),
              label: Text("Switch Theme")),
          IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                //print(counter);
                if (counter != 4) {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          width: 300,
                          child: AlertDialog(
                            title: Text("You are required to select 4 tabs"),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('HIDE'),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                            backgroundColor: Colors.blueGrey,
                          ),
                        );
                      });
                } else {
                  _pushSaved();
                }
              }), // ye button alert dialog box ke liye hai
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (counter == 4) {
            nextPage(_saved);
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    width: 300,
                    child: AlertDialog(
                      title: Text("WARNING !!!"),
                      content: Text("Exactly 4 names should be selected..."),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('okay'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                      backgroundColor: Colors.blueGrey,
                    ),
                  );
                });
          }
        },
        label: Text('FlipScreen'),
      ),
      body: _buildSuggestions(),
    );
  }

  void nextPage(Set<WordPair> savedWords) {
    if (savedWords.length == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
                  savedWords: savedWords,
                )),
      );
    }
  }

  var counter = 0;
  List ls = [];
  //you have to push values from here into the 2*2 row
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}
