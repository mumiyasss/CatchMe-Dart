import 'package:flutter/material.dart';
import 'package:catch_me/values/Styles.dart';

class MyAppBar extends StatefulWidget {
  MyAppBar(Size screenSize, {Key key}) : super(key: key) {
    titleLayoutTranslation = screenSize.width - (225 + 26 * 2);
    searchIconTranslation = -(screenSize.height / 9);
  }

  final _MyAppBarState state = _MyAppBarState();
  var titleLayoutTranslation;
  var searchIconTranslation;

  @override
  _MyAppBarState createState() => state;

  // Updating Toolbar
  static final titleSize = 40.0;
  static final subtitleSize = 20.0;
  static final titleSubtitleSizeDelta = titleSize - subtitleSize;
  static final subtitleColorShade = 0x7d;
  static final bottomMargin = 5.0;
  var lastPositionOffset = 0.0;

  void update(double positionOffset, Size screenSize) {
    var difference = lastPositionOffset - positionOffset;
    if (difference > 0.01 || -difference > 0.01) {
      if (positionOffset < 0) positionOffset *= -1;
      else if (positionOffset >= 1) positionOffset = 0.99;

      final newTitleStyle = Style.getToolbarTextStyle(
          fontSize: titleSize - titleSubtitleSizeDelta * positionOffset,
          shade: (subtitleColorShade * positionOffset).toInt());
      var titleBottomMargin = bottomMargin * positionOffset;

      final newSubtitleStyle = Style.getToolbarTextStyle(
        fontSize: subtitleSize + titleSubtitleSizeDelta * positionOffset,
        shade: (subtitleColorShade * (1 - positionOffset)).toInt(),
      );
      var subtitleBottomMargin = bottomMargin * (1 - positionOffset);

      var searchIconShift = searchIconTranslation * positionOffset;
      var titleLayoutShift = titleLayoutTranslation * positionOffset;
      print("HERE");

      state.update(newTitleStyle, newSubtitleStyle, titleBottomMargin,
          subtitleBottomMargin, titleLayoutShift, searchIconShift);
      lastPositionOffset = positionOffset;
    }
  }
}

class _MyAppBarState extends State<MyAppBar> {
  var titleName;

  var subtitleName;
  var titleStyle;
  var subtitleStyle;
  var titleBottomMargin;
  var subtitleBottomMargin;
  var titleLayoutShift;

  @override
  void initState() {
    titleName = 'Dialogs';
    subtitleName = 'Settings';
    titleStyle = Style.defaultTitle;
    subtitleStyle = Style.defaultSubtitle;
    titleBottomMargin = 0.0;
    subtitleBottomMargin = 5.0;
    titleLayoutShift = 0.0;
    super.initState();
  }

  void update(
      TextStyle newTitleStyle,
      TextStyle newSubtitleStyle,
      double newTitleBottomMargin,
      double newSubtitleBottomMargin,
      double newTitleLayoutShift,
      double newSearchIconShift) {
    setState(() {
      print("There");
      titleStyle = newTitleStyle;
      subtitleStyle = newSubtitleStyle;
      titleBottomMargin = newTitleBottomMargin;
      subtitleBottomMargin = newSubtitleBottomMargin;
      titleLayoutShift = newTitleLayoutShift;
    });
  }

  @override
  Widget build(BuildContext context) {
    var title = Container( // Statefull widget
        margin: EdgeInsets.only(
            left: 26 + titleLayoutShift, bottom: titleBottomMargin),
        child: Text(
          titleName,
          style: titleStyle,
        ));

    var subtitle = Container( // Statefull widget
        margin: EdgeInsets.only(left: 10, bottom: subtitleBottomMargin),
        child: Text(
          subtitleName,
          style: subtitleStyle,
        ));

    return Container(
      alignment: Alignment.centerLeft,
      height: 87,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[title, subtitle],
      ),
    );
  }
}
