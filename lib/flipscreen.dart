import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart';

class MyHomePage extends StatefulWidget {
  final Set<WordPair> savedWords;
  MyHomePage({this.savedWords});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<bool> _showFrontSide = [true, true, true, true];
  bool _flipXAxis;

  @override
  void initState() {
    super.initState();
    _showFrontSide[0] = true;
    _showFrontSide[1] = true;
    _showFrontSide[2] = true;
    _showFrontSide[3] = true;
    _flipXAxis = true;
  }

  @override
  Widget build(BuildContext context) {
    final List<WordPair> pair = widget.savedWords.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Saved Suggestions"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: RotatedBox(
              child: Icon(Icons.flip),
              quarterTurns: _flipXAxis ? 0 : 1,
            ),
            onPressed: _changeRotationAxis,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => {Navigator.pop(context)},
        label: Text('Go Back to Home Page'),
      ),
      body: DefaultTextStyle(
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Row(
              //ROW 1
              children: [
                getContainer(pair[0], 0),
                getContainer(pair[1], 1),
              ],
            ),
            Row(//ROW 2
                children: [
              getContainer(pair[2], 2),
              getContainer(pair[3], 3),
            ]),
          ]),
        ),
      ),
    );
  }

  void _changeRotationAxis() {
    setState(() {
      _flipXAxis = !_flipXAxis;
    });
  }

  void _switchCard(int i) {
    setState(() {
      _showFrontSide[i] = !_showFrontSide[i];
    });
  }

  Widget _buildFlipAnimation(WordPair pair, int i) {
    return GestureDetector(
      onTap: () {
        _switchCard(i);
      },
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 800),
        transitionBuilder: __transitionBuilder,
        layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
        child: _showFrontSide[i] ? _buildFront(i) : _buildRear(pair),
        switchInCurve: Curves.easeInBack,
        switchOutCurve: Curves.easeInBack.flipped,
      ),
    );
  }

  Widget __transitionBuilder(Widget widget, Animation<double> animation) {
    final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
    return AnimatedBuilder(
      animation: rotateAnim,
      child: widget,
      builder: (context, widget) {
        final isUnder = (ValueKey(_showFrontSide) != widget.key);
        var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
        tilt *= isUnder ? -1.0 : 1.0;
        final value =
            isUnder ? min(rotateAnim.value, pi / 2) : rotateAnim.value;
        return Transform(
          transform: _flipXAxis
              ? (Matrix4.rotationY(value)..setEntry(3, 0, tilt))
              : (Matrix4.rotationX(value)..setEntry(3, 1, tilt)),
          child: widget,
          alignment: Alignment.center,
        );
      },
    );
  }

  Widget _buildFront(int i) {
    return __buildLayout(
      key: ValueKey(true),
      backgroundColor: Colors.transparent,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30.0),
          child: Image.asset(
            'asset/' + (i + 1).toString() + '.jpg',
            fit: BoxFit.fill,
            width: 200.0,
            height: 200.0,
          ),
        ),
      ),
    );
  }

  Widget _buildRear(WordPair pair) {
    return __buildLayout(
      key: ValueKey(false),
      backgroundColor: Colors.blue.shade700,
      child: Center(
        child: Text(pair.asPascalCase, style: TextStyle(fontSize: 30.0)),
      ),
    );
  }

  Widget __buildLayout({Key key, Widget child, Color backgroundColor}) {
    return Container(
      margin: EdgeInsets.all(30.0),
      constraints: BoxConstraints.tight(Size.square(200.0)),
      key: key,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(20.0),
        color: backgroundColor,
      ),
      child: child,
    );
  }

  Widget getContainer(WordPair pair, int i) {
    return Container(
      child: _buildFlipAnimation(pair, i),
      height: 200,
      width: 200,
      //color: Colors.blue,
      margin: EdgeInsets.all(25.0),
    );
  }
}
