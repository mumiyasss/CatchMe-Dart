import 'package:catch_me/main.dart';
import 'package:catch_me/ui/pageview/PageView.dart';
import 'package:flutter/material.dart';
import 'package:catch_me/values/Styles.dart';
import 'dart:async';
import 'package:catch_me/values/Dimens.dart';

class MyAppBar extends StatelessWidget {
    MyAppBar(this.controller);

    final StreamController controller;

    @override
    Widget build(BuildContext context) {
        return SafeArea(
            bottom: false,
            child: Container(
                alignment: Alignment.bottomLeft,
                height: Dimens.appBarHeight,
                color: Colors.white,
                padding: EdgeInsets.only(bottom: 20),
                child: TitleSubtitleContainer(controller),
            ),
        );
        // todo: title/subitle into container, which change margin
        // todo: due to context size and MediaQuery size
    }
}

class TitleSubtitleContainer extends StatefulWidget {
    TitleSubtitleContainer(this.controller);

    final StreamController controller;


    @override
    _TitleSubtitleContainerState createState() =>
        _TitleSubtitleContainerState();
}

class _TitleSubtitleContainerState extends State<TitleSubtitleContainer> {
    @override
    Widget build(BuildContext context) {
        var title = Title(
            App.lang.dialogTitle,
            TitleState(Dimens.leftMarginTitle, Dimens.bottomMarginTitle,
                Styles.defaultTitle));
        var subtitle = Title(
            App.lang.settingsTitle,
            SubtitleState(
                Dimens.leftMarginSubtitle, Dimens.bottomMarginSubtitle,
                Styles.defaultSubtitle));
        return Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[title, subtitle],
            ),
        );
    }
}

class Title extends StatefulWidget {
    Title(this.titleName, this.state) : super();
    final String titleName;
    final TitleState state;

    @override
    State<Title> createState() => state;
}

class TitleState extends State<Title> {
    TitleState(this.leftMargin, this._bottomMargin, this.style);

    double leftMargin;
    double _bottomMargin;
    TextStyle style;
    Size screenSize;

    void update(double leftMargin, double bottomMargin, TextStyle style) {
        setState(() {
            this.leftMargin = leftMargin;
            this._bottomMargin = bottomMargin;
            this.style = style;
        });
    }

    var lastPositionOffset = 0.0;

    _pageViewListener(double pixels) {
        var positionOffset = pixels / screenSize.width;
        var difference = lastPositionOffset - positionOffset;
        if (difference > 0.001 || -difference > 0.001) {
            if (positionOffset < 0)
                positionOffset *= -1;
            else if (positionOffset >= 1) positionOffset = 0.99;
            calculateNewValues(positionOffset);
            lastPositionOffset = positionOffset;
        }
    }

    final titleSize = Dimens.titleSize;
    final subtitleSize = Dimens.subtitleSize;
    final titleSubtitleSizeDelta = Dimens.titleSize - Dimens.subtitleSize;
    final subtitleColorShade = 0x7d;
    final bottomMargin = Dimens.bottomMarginSubtitle;

    void calculateNewValues(double positionOffset) {
        final newTitleStyle = Styles.getToolbarTextStyle(
            fontSize: titleSize - titleSubtitleSizeDelta * positionOffset,
            shade: (subtitleColorShade * positionOffset).toInt());
        var titleBottomMargin = bottomMargin * positionOffset;
        var translation = screenSize.width - Dimens.maxValidShiftForAppBarTitle;
        //var leftMargin = 26 + translation * positionOffset;
        update(leftMargin, titleBottomMargin, newTitleStyle);
    }

    void plugPositionListener() {
        MainPage.pageViewStreamController.stream.listen((pixels) =>
            _pageViewListener(pixels));
    }

    @override
    void initState() {
        plugPositionListener();
        super.initState();
    }

    @override
    Widget build(BuildContext context) {
        screenSize = MediaQuery
            .of(context)
            .size;
        return Container(
            margin: EdgeInsets.only(left: leftMargin, bottom: _bottomMargin),
            child: Text(
                widget.titleName,
                style: style,
            ));
    }
}

class SubtitleState extends TitleState {
    SubtitleState(double leftMargin, double bottomMargin, TextStyle style)
        : super(leftMargin, bottomMargin, style);

    @override
    void calculateNewValues(double positionOffset) {
        final newSubtitleStyle = Styles.getToolbarTextStyle(
            fontSize: subtitleSize + titleSubtitleSizeDelta * positionOffset,
            shade: (subtitleColorShade * (1 - positionOffset)).toInt(),
        );
        var subtitleBottomMargin = bottomMargin * (1 - positionOffset);
        var leftMargin = super.leftMargin;
        super.update(leftMargin, subtitleBottomMargin, newSubtitleStyle);
    }
}
