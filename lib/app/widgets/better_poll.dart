library better_polls;

import 'package:chatnest/app/theme/theme.dart';
import 'package:chatnest/data/data.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

typedef PollCallBack = void Function(int choice);

typedef PollTotal = void Function(int total);

late int userPollChoice;

class Polls extends StatefulWidget {
  /// The poll question visible above the poll options.
  final Widget? question;

  /// This determines what type of view user should see
  /// if its creator, or view requiring you to vote or view showing your vote
  final PollsType? viewType;

  /// This takes in vote data which should be a Map
  /// with this, polls widget determines what type of view the user should see
  final Map<String, int>? voteData;

  final String? currentUser;

  final String? creatorID;

  /// This takes in poll options array
  final List<PollOption> children;

  /// This call back returns user choice after voting
  final PollCallBack? onVote;

  /// This is takes in current user choice
  final List<int>? userChoice;

  /// This determines if the creator of the poll can vote or not
  final bool allowCreatorVote;

  /// This returns total votes casted
  final PollTotal? getTotal;

  /// This returns highest votes casted
  final PollTotal? getHighest;

  @protected
  final double? highest;

  /// Text Styles
  final TextStyle? pollStyle;
  final TextStyle? leadingPollStyle;

  /// Radius of each poll option
  final double optionBarRadius;

  /// Width of the border for each option
  final double borderWidth;

  /// Height of each option bar
  final double optionHeight;

  /// Space between each option
  final double optionSpacing;

  /// Colors setting for polls widget
  final Color onVoteBorderColor;
  final Color voteCastedBorderColor;
  final Color backgroundColor;
  final Color? onVoteBackgroundColor;
  final Color? iconColor;
  final Color? leadingBackgroundColor;
  final Color? voteCastedBackgroundColor;

  /// Polls contruct by default get view for voting
  const Polls({
    Key? key,
    required this.children,
    required this.voteData,
    required this.currentUser,
    required this.creatorID,
    this.question,
    this.userChoice,
    this.allowCreatorVote = false,
    this.onVote,
    this.onVoteBorderColor = Colors.blue,
    this.voteCastedBorderColor = Colors.white,
    this.backgroundColor = Colors.white,
    this.voteCastedBackgroundColor = Colors.white,
    this.onVoteBackgroundColor = Colors.blue,
    this.leadingPollStyle,
    this.pollStyle,
    this.iconColor = Colors.black,
    this.leadingBackgroundColor = Colors.white,
    this.optionBarRadius = 16,
    this.borderWidth = .25,
    this.optionHeight = 35,
    this.optionSpacing = 8,
  })  : highest = null,
        getHighest = null,
        getTotal = null,
        viewType = null,
        assert(onVote != null),
        assert(voteData != null),
        assert(currentUser != null),
        assert(creatorID != null),
        super(key: key);

  /// Polls.option is used to set polls options
  static PollOption options(
      {required String title,
      required double value,
      required List<String> img}) {
    return PollOption(name: title, value: value, img: img);
  }

  /// this creates view for see polls result
  const Polls.viewPolls({
    Key? key,
    required this.children,
    required this.question,
    this.userChoice,
    this.leadingPollStyle,
    this.pollStyle,
    this.backgroundColor = Colors.blue,
    this.voteCastedBackgroundColor = Colors.white,
    this.leadingBackgroundColor = Colors.blueAccent,
    this.onVoteBackgroundColor = Colors.white,
    this.iconColor = Colors.black,
    this.optionBarRadius = 16,
    this.borderWidth = .25,
    this.optionHeight = 35,
    this.optionSpacing = 8,
  })  : allowCreatorVote = false,
        getTotal = null,
        highest = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        getHighest = null,
        onVoteBorderColor = Colors.white,
        voteCastedBorderColor = Colors.white,
        viewType = PollsType.readOnly,
        onVote = null,
        super(key: key);

  /// This creates view for the creator of the polls
  const Polls.creator({
    Key? key,
    required this.children,
    required this.question,
    this.leadingPollStyle,
    this.pollStyle,
    this.backgroundColor = Colors.blue,
    this.voteCastedBackgroundColor = Colors.white,
    this.leadingBackgroundColor = Colors.blueAccent,
    this.onVoteBackgroundColor = Colors.white,
    this.allowCreatorVote = false,
    this.optionBarRadius = 16,
    this.borderWidth = .25,
    this.optionHeight = 35,
    this.optionSpacing = 8,
  })  : viewType = PollsType.creator,
        onVote = null,
        userChoice = null,
        highest = null,
        getHighest = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        getTotal = null,
        iconColor = null,
        onVoteBorderColor = Colors.white,
        voteCastedBorderColor = Colors.white,
        super(key: key);

  /// this creates view for users to cast votes
  const Polls.castVote({
    Key? key,
    required this.children,
    required this.question,
    required this.onVote,
    this.allowCreatorVote = false,
    this.onVoteBorderColor = Colors.blue,
    this.backgroundColor = Colors.white,
    this.voteCastedBackgroundColor = Colors.white,
    this.pollStyle,
    this.optionBarRadius = 16,
    this.borderWidth = .25,
    this.optionHeight = 35,
    this.optionSpacing = 8,
  })  : viewType = PollsType.voter,
        userChoice = null,
        highest = null,
        getHighest = null,
        getTotal = null,
        iconColor = null,
        voteData = null,
        currentUser = null,
        creatorID = null,
        leadingBackgroundColor = null,
        leadingPollStyle = null,
        onVoteBackgroundColor = null,
        voteCastedBorderColor = Colors.white,
        assert(onVote != null),
        super(key: key);

  @override
  State<Polls> createState() => _PollsState();
}

class _PollsState extends State<Polls> {
  Object? vote;

  @protected
  List<String> choiceNames = [];

  @protected
  List<Map<double, List<String>>> choiceValues = [];

  /// style
  late TextStyle pollStyle;
  late TextStyle leadingPollStyle;

  late double highest;

  @override
  void initState() {
    super.initState();

    /// if polls style is null, it sets default pollstyle and leading pollstyle
    pollStyle = widget.pollStyle ??
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w300);
    leadingPollStyle = widget.leadingPollStyle ??
        const TextStyle(color: Colors.black, fontWeight: FontWeight.w800);

    for (int i = 0; i < widget.children.length; i++) {
      choiceNames.add(widget.children[i].name);
      choiceValues.add({widget.children[i].value: widget.children[i].img});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewType == null) {
      var viewType = (widget.voteData?.containsKey(widget.currentUser) ?? false)
          ? PollsType.readOnly
          : widget.currentUser == widget.creatorID
              ? PollsType.creator
              : PollsType.voter;
      if (viewType == PollsType.voter) {
        //user can cast vote with this widget
        return voterWidget(context);
      }
      if (viewType == PollsType.creator) {
        //mean this is the creator of the polls and cannot vote
        if (widget.allowCreatorVote) {
          return voterWidget(context);
        }
        return pollCreator(context);
      }

      if (viewType == PollsType.readOnly) {
        //user can view his votes with this widget
        return voteCasted(context);
      }
    } else {
      if (widget.viewType == PollsType.voter) {
        //user can cast vote with this widget
        return voterWidget(context);
      }
      if (widget.viewType == PollsType.creator) {
        //mean this is the creator of the polls and cannot vote
        if (widget.allowCreatorVote) {
          return voterWidget(context);
        }
        return pollCreator(context);
      }

      if (widget.viewType == PollsType.readOnly) {
        //user can view his votes with this widget
        return voteCasted(context);
      }
    }
    return Container();
  }

  /// voterWidget creates view for users to cast their votes

  Widget voterWidget(context) {
    double current = 0;
    for (var i = 0; i < choiceValues.length; i++) {
      double s = double.parse(choiceValues[i].keys.toList()[0].toString());
      if ((choiceValues[i].keys.toList()[0]) >= current) {
        current = s;
      }
    }

    highest = current;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.question ?? const SizedBox.shrink(),
        ...widget.children.mapIndexed(
          (ind, _) {
            bool isHighest = highest == choiceValues[ind].keys.toList()[0];
            print(isHighest);
            return Padding(
              padding: EdgeInsets.only(bottom: widget.optionSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              activeColor: ColorsValue.maincolor1,
                              checkColor: ColorsValue.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.hundred)),
                              side: BorderSide(
                                color: ColorsValue.maincolor1,
                                width: Dimens.one,
                              ),
                              value:
                                  widget.userChoice?[ind] != 0 ? true : false,
                              onChanged: (value) {
                                setState(() {
                                  vote = value;
                                  userPollChoice = ind;
                                  if (value == true) {
                                    choiceValues[ind].keys.toList()[0] += 1;
                                  } else {
                                    choiceValues[ind].keys.toList()[0] -= 1;
                                  }
                                });
                                widget.onVote!(userPollChoice);
                              },
                            ),
                          ),
                          Dimens.boxWidth10,
                          Text(choiceNames[ind]),
                        ],
                      ),
                      Dimens.boxHeight5,
                      Row(
                        children: [
                          if (choiceValues[ind].values.toList().isNotEmpty) ...[
                            if (choiceValues[ind].values.toList()[0].length ==
                                1) ...[
                              Container(
                                width: 30,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: ColorsValue.maincolor1,
                                      radius: 7,
                                      foregroundImage: NetworkImage(
                                        ApiWrapper.imageUrl +
                                            choiceValues[ind].values.toList()[0]
                                                [0],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else if (choiceValues[ind]
                                    .values
                                    .toList()[0]
                                    .length >
                                1) ...[
                              Container(
                                width: 30,
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: ColorsValue.maincolor1,
                                      radius: 7,
                                      foregroundImage: NetworkImage(
                                        ApiWrapper.imageUrl +
                                            choiceValues[ind].values.toList()[0]
                                                [0],
                                      ),
                                    ),
                                    Positioned(
                                      right: 10,
                                      child: CircleAvatar(
                                        radius: 7,
                                        foregroundImage: NetworkImage(
                                          ApiWrapper.imageUrl +
                                              choiceValues[ind]
                                                  .values
                                                  .toList()[0][1],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                          Text(choiceValues[ind]
                              .keys
                              .toList()[0]
                              .toStringAsFixed(0)),
                        ],
                      ),
                    ],
                  ),
                  Dimens.boxHeight5,
                  Container(
                    width: double.infinity,
                    height: widget.optionHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.optionBarRadius),
                      ),
                      border: Border.all(
                        width: widget.borderWidth,
                        color: widget.voteCastedBorderColor,
                      ),
                    ),
                    child: Container(
                      height: widget.optionHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          widget.optionBarRadius,
                        ),
                        color: widget.backgroundColor,
                      ),
                      child: LinearPercentIndicator(
                        backgroundColor: widget.voteCastedBackgroundColor,
                        padding: EdgeInsets.zero,
                        barRadius: Radius.circular(widget.optionBarRadius),
                        animation: true,
                        lineHeight: widget.optionHeight,
                        animationDuration: 500,
                        percent: PollMath.getPercent(choiceValues, ind),
                        progressColor: isHighest
                            ? widget.leadingBackgroundColor
                            : widget.onVoteBackgroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ],
    );
  }

  /// pollCreator creates view for the creator of the polls,
  /// to see poll activities
  Widget pollCreator(context) {
    double current = 0;

    for (var i = 0; i < choiceValues.length; i++) {
      double s = double.parse(choiceValues[i].keys.toList()[0].toString());

      if ((choiceValues[i].keys.toList()[0]) >= current) {
        current = s;
      }
    }

    highest = current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.question ?? const SizedBox.shrink(),
        ...widget.children.mapIndexed(
          (ind, _) {
            bool isHighest = highest == choiceValues[ind].keys.toList()[0];
            return Padding(
              padding: EdgeInsets.only(bottom: widget.optionSpacing),
              child: Container(
                width: double.infinity,
                height: widget.optionHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(widget.optionBarRadius),
                  ),
                  border: Border.all(
                    width: widget.borderWidth,
                    color: widget.voteCastedBorderColor,
                  ),
                ),
                child: LinearPercentIndicator(
                  backgroundColor: widget.voteCastedBackgroundColor,
                  padding: EdgeInsets.zero,
                  animation: true,
                  lineHeight: widget.optionHeight,
                  animationDuration: 500,
                  barRadius: Radius.circular(widget.optionBarRadius),
                  percent: PollMath.getPercent(choiceValues, ind),
                  center: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            choiceNames[ind],
                            style: isHighest
                                ? widget.leadingPollStyle
                                : widget.pollStyle,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            "${PollMath.getMainPercent(
                              choiceValues,
                              ind,
                            )}%",
                            style: isHighest
                                ? widget.leadingPollStyle
                                : widget.pollStyle,
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                    ],
                  ),
                  progressColor: isHighest
                      ? widget.leadingBackgroundColor
                      : widget.onVoteBackgroundColor,
                ),
              ),
            );
          },
        ).toList(),
      ],
    );
  }

  /// voteCasted created view for user to see votes they casted including other peoples vote
  Widget voteCasted(context) {
    double current = 0;
    for (var i = 0; i < choiceValues.length; i++) {
      double s = double.parse(choiceValues[i].keys.toList()[0].toString());
      if ((choiceValues[i].keys.toList()[0]) >= current) {
        current = s;
      }
    }

    highest = current;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.question ?? const SizedBox.shrink(),
        ...widget.children.mapIndexed(
          (int ind, _) {
            bool isHighest = highest == choiceValues[ind].keys.toList()[0];
            return Padding(
              padding: EdgeInsets.only(bottom: widget.optionSpacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 1.2,
                            child: Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: const VisualDensity(
                                horizontal: VisualDensity.minimumDensity,
                                vertical: VisualDensity.minimumDensity,
                              ),
                              activeColor: ColorsValue.maincolor1,
                              checkColor: ColorsValue.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.hundred)),
                              side: BorderSide(
                                color: ColorsValue.maincolor1,
                                width: Dimens.one,
                              ),
                              value: widget.userChoice == ind ? true : false,
                              onChanged: (value) {
                                setState(() {
                                  vote = value;
                                  userPollChoice = ind;
                                  choiceValues[ind].keys.toList()[0] += 1;
                                });
                                widget.onVote!(userPollChoice);
                              },
                            ),
                          ),
                          Dimens.boxWidth10,
                          Text(choiceNames[ind]),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: 30,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: ColorsValue.maincolor1,
                                  radius: 7,
                                ),
                                Positioned(
                                  right: 10,
                                  child: CircleAvatar(
                                    backgroundColor: ColorsValue.blackColor,
                                    radius: 7,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text("2"),
                        ],
                      ),
                    ],
                  ),
                  Dimens.boxHeight5,
                  Container(
                    width: double.infinity,
                    height: widget.optionHeight,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.optionBarRadius),
                      ),
                      border: Border.all(
                        width: widget.borderWidth,
                        color: widget.voteCastedBorderColor,
                      ),
                    ),
                    child: LinearPercentIndicator(
                      backgroundColor: widget.voteCastedBackgroundColor,
                      padding: EdgeInsets.zero,
                      barRadius: Radius.circular(widget.optionBarRadius),
                      animation: true,
                      lineHeight: widget.optionHeight,
                      animationDuration: 500,
                      percent: PollMath.getPercent(choiceValues, ind),
                      progressColor: isHighest
                          ? widget.leadingBackgroundColor
                          : widget.onVoteBackgroundColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ).toList(),
      ],
    );
  }

  /// simple logic to detect users choice and return a check icon
  Widget myOwnChoice(bool choice) {
    if (choice) {
      return const Icon(
        Icons.check_circle_outline,
        color: Colors.white,
        size: 17,
      );
    } else {
      return Container();
    }
  }
}

/// Help detect type of view user wants
enum PollsType {
  creator,
  voter,
  readOnly,
}

/// Handles the math for the percentages of the polls.
class PollMath {
  static double getMainPercent(
      List<Map<double, List<String>>> choiceValues, int choice) {
    double div = choiceValues[choice].keys.sum == 0
        ? 0
        : (100 / choiceValues[choice].keys.sum) *
            choiceValues[choice].keys.toList()[0];
    return div == 0 ? 0 : double.parse(div.toStringAsFixed(1));
  }

  static double getPercent(
      List<Map<double, List<String>>> choiceValues, int choice) {
    double div = choiceValues[choice].keys.sum == 0
        ? 0
        : (1 / choiceValues[choice].keys.sum) *
            choiceValues[choice].keys.toList()[0];
    return div.toDouble();
  }
}

class PollOption {
  final String name;
  final double value;
  final List<String> img;

  PollOption({
    required this.name,
    required this.value,
    required this.img,
  });
}
