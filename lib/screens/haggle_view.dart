/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/widgets/profile_avatar.dart';
import 'package:inf/styling_constants.dart';
import 'package:inf/widgets/blurred_network_image.dart';

import 'package:inf/widgets/progress_dialog.dart';
import 'package:inf_common/inf_common.dart';
import 'package:inf/widgets/image_uploader.dart';
import 'package:inf/widgets/network_status.dart';

class HaggleView extends StatefulWidget {
  const HaggleView({
    Key key,
    @required this.account,
    @required this.businessAccount,
    @required this.influencerAccount,
    @required this.offer,
    @required this.proposal,
    @required this.chats,
    @required this.processingAction,
    @required this.onSendPlain,
    @required this.onSendHaggle,
    @required this.onSendImageKey,
    @required this.onWantDeal,
    @required this.onReject,
    @required this.onReport,
    @required this.onBeginMarkDispute,
    @required this.onBeginMarkCompleted,
    @required this.onUploadImage,
    @required this.onPressedProfile,
    @required this.onPressedOffer,
  }) : super(key: key);

  final DataAccount account;
  final DataAccount businessAccount;
  final DataAccount influencerAccount;

  final DataOffer offer;
  final DataProposal proposal;

  final Iterable<DataProposalChat> chats;

  final bool processingAction;

  final Function(String text) onSendPlain;
  final Function(String deliverables, String reward, String rewarks)
      onSendHaggle;
  final Function(String key) onSendImageKey;

  // final Function(DataProposalChat haggleChat) onBeginHaggle;
  final Future<void> Function(DataProposalChat haggleChat) onWantDeal;

  final Function() onReject;
  final Future<void> Function(String message) onReport;
  // final Function() onBeginReport;
  final Function() onBeginMarkDispute;
  final Function() onBeginMarkCompleted;

  final Future<NetUploadImageRes> Function(FileImage fileImage) onUploadImage;

  final Function(DataAccount account) onPressedProfile;
  final Function(DataOffer offer) onPressedOffer;

  @override
  _HaggleViewState createState() => _HaggleViewState();
}

class _HaggleViewState extends State<HaggleView> {
  TextEditingController _lineController = TextEditingController();
  TextEditingController _uploadKey = TextEditingController();

  TextEditingController _reportController = TextEditingController();

  bool _uploadAttachment = false;

  // List<DataProposalChat> _testingData = new List<DataProposalChat>();

  Int64 get influencerAccountId {
    return widget.influencerAccount.accountId;
  }

  Int64 get businessAccountId {
    return widget.businessAccount.accountId;
  }

  Int64 get accountId {
    return widget.account.accountId;
  }

  Int64 get otherAccountId {
    if (influencerAccountId == accountId) return businessAccountId;
    return influencerAccountId;
  }

  DataAccount getAccount(Int64 accountId) {
    if (accountId == this.accountId) return widget.account;
    if (accountId == influencerAccountId) return widget.influencerAccount;
    if (accountId == businessAccountId) return widget.businessAccount;
    return DataAccount(); // Blank
  }

  void _uploadKeyChanged() {
    if (_uploadAttachment && _uploadKey.text.isNotEmpty) {
      setState(() {
        _uploadAttachment = false;
      });
      widget.onSendImageKey(_uploadKey.text);
    }
  }

  @override
  void initState() {
    super.initState();
    _uploadKey.addListener(_uploadKeyChanged);
/*
    DataProposalChat chat;

    chat = new DataProposalChat();
    chat.senderId = influencerAccountId;
    chat.type = ProposalChatType.ACT_HAGGLE;
    chat.text =
        "deliverables=test+deliverables+text+here&reward=three+fifty&remarks=I+am+the+mostest+awesomester+influencer!";
    chat.chatId = new Int64(1);
    _testingData.add(chat);

    chat = new DataProposalChat();
    chat.senderId = influencerAccountId;
    chat.type = ProposalChatType.ACT_PLAIN;
    chat.text = "This is a plain text message.";
    chat.chatId = new Int64(2);
    _testingData.add(chat);

    chat = new DataProposalChat();
    chat.senderId = influencerAccountId;
    chat.type = ProposalChatType.ACT_PLAIN;
    chat.text =
        "This is a plain text message. But it is very long. Much longer, in fact.";
    chat.chatId = new Int64(3);
    _testingData.add(chat);

    chat = new DataProposalChat();
    chat.senderId = businessAccountId;
    chat.type = ProposalChatType.ACT_PLAIN;
    chat.text = "I can talk too.";
    chat.chatId = new Int64(4);
    _testingData.add(chat);

    chat = new DataProposalChat();
    chat.senderId = influencerAccountId;
    chat.type = ProposalChatType.ACT_MARKER;
    chat.text = "marker=1";
    chat.chatId = new Int64(5);
    _testingData.add(chat);

    chat = new DataProposalChat();
    chat.senderId = businessAccountId;
    chat.type = ProposalChatType.ACT_PLAIN;
    chat.text = "That's cool.";
    chat.chatId = new Int64(5);
    _testingData.add(chat);

    chat = new DataProposalChat();
    chat.senderId = influencerAccountId;
    chat.type = ProposalChatType.ACT_IMAGE_KEY;
    chat.text = "url=" +
        Uri.encodeQueryComponent(
            "https://res.cloudinary.com/inf-marketplace/image/upload/c_lfill,g_face:center,h_360,w_360,q_auto/dev/user/10/11c524fc7018d93f13593a5fbe301ea79bc66522c44a593f96c077c16e7ac02b.jpg");
    chat.chatId = new Int64(6);
    _testingData.add(chat);

    chat = new DataProposalChat();
    chat.senderId = influencerAccountId;
    chat.type = ProposalChatType.ACT_PLAIN;
    chat.text = "Here's a picture of me.";
    chat.chatId = new Int64(7);
    _testingData.add(chat);
    */
  }

  Future<void> _reportProposal() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Report'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: TextField(
                controller: _reportController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Message'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Report'.toUpperCase())],
                  ),
                  onPressed: () async {
                    bool success = false;
                    final dynamic progressDialog = showProgressDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                  padding: const EdgeInsets.all(24.0),
                                  child: const CircularProgressIndicator()),
                              const Text("Sending report..."),
                            ],
                          ),
                        );
                      },
                    );
                    try {
                      await widget.onReport(_reportController.text);
                      success = true;
                    } catch (error, stackTrace) {
                      print(
                          "[INF] Exception sending report': $error\n$stackTrace");
                    }
                    closeProgressDialog(progressDialog);
                    if (!success) {
                      await showDialog<Null>(
                        context: this.context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Send Report Failed'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  const Text('An error has occured.'),
                                  const Text('Please try again later.'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('Ok'.toUpperCase())],
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.of(context).pop();
                      _reportController.text = "";
                      await showDialog<void>(
                        context: this.context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Report Sent'),
                            content: SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  const Text('Your report has been sent.'),
                                  const Text(
                                      'Further correspondence on this matter will be done by e-mail.'),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [Text('Ok'.toUpperCase())],
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> _wantDeal(DataProposalChat chat) async {
    bool success = false;
    final dynamic progressDialog = showProgressDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: const EdgeInsets.all(24.0),
                  child: const CircularProgressIndicator()),
              const Text("Sending..."),
            ],
          ),
        );
      },
    );
    try {
      await widget.onWantDeal(chat);
      success = true;
    } catch (error, stackTrace) {
      print("[INF] Exception sending deal': $error\n$stackTrace");
    }
    closeProgressDialog(progressDialog);
    if (!success) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Deal Failed'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  const Text('An error has occured.'),
                  const Text('Please try again later.'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text('Ok'.toUpperCase())],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _haggle(DataProposalChat chat) async {
    final Map<String, String> query = Uri.splitQueryString(chat.text);
    final TextEditingController haggleDeliverablesController =
        TextEditingController();
    haggleDeliverablesController.text = query['deliverables'].toString();
    final TextEditingController haggleRewardController =
        TextEditingController();
    haggleRewardController.text = query['reward'].toString();
    final TextEditingController haggleRemarksController =
        TextEditingController();
    haggleRemarksController.text = query['remarks'].toString();
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          // title: new Text('Haggle'),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: TextField(
                controller: haggleDeliverablesController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Deliverables'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: TextField(
                controller: haggleRewardController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Reward'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
              child: TextField(
                controller: haggleRemarksController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Remarks'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text('Haggle'.toUpperCase())],
                  ),
                  onPressed: () async {
                    // TODO: Handle failure in case offline
                    widget.onSendHaggle(
                        haggleDeliverablesController.text,
                        haggleRewardController.text,
                        haggleRemarksController.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _uploadKey.removeListener(_uploadKeyChanged);
    super.dispose();
  }

  Widget _buildChatMessage(DataProposalChat current, DataProposalChat previous,
      DataProposalChat next) {
    final ThemeData theme = Theme.of(context);
    final bool ghost = current.chatId == 0;
    if (current.type == ProposalChatType.marker) {
      final Map<String, String> query = Uri.splitQueryString(current.text);
      String message;
      switch (ProposalChatMarker.valueOf(int.tryParse(query['marker']))) {
        case ProposalChatMarker.applied:
          message = current.senderId == accountId
              ? "You have applied for ${widget.offer.title}."
              : "${getAccount(current.senderId).name} has applied for ${widget.offer.title}.";
          break;
        case ProposalChatMarker.wantDeal:
          message = current.senderId == accountId
              ? "You want to make a deal."
              : "${getAccount(current.senderId).name} wants to make a deal.";
          break;
        case ProposalChatMarker.dealMade:
          message = "A deal has been made. Congratulations!";
          break;
        case ProposalChatMarker.rejected:
          message = current.senderId == accountId
              ? "You have rejected the application."
              : "${getAccount(current.senderId).name} has rejected the application.";
          break;
        case ProposalChatMarker.markedComplete:
          message = current.senderId == accountId
              ? "You have marked the deal as completed."
              : "${getAccount(current.senderId).name} has marked the deal as completed.";
          break;
        case ProposalChatMarker.complete:
          message = "The offer has been completed. Well done!";
          break;
        case ProposalChatMarker.markedDispute:
          message = "..."; // Should be silent, perhaps.
          break;
        case ProposalChatMarker.resolved:
          message =
              "The dispute has been resolved through customer support. Case closed.";
          break;
        case ProposalChatMarker.messageDropped:
          message = "...";
          break;
        default:
          message = "...";
          break;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Text(message),
          ),
        ],
      );
    }
    final bool mine = current.senderId == accountId;
    final bool preceeded = previous != null &&
        previous.senderId == current.senderId &&
        previous.type != ProposalChatType.marker;
    final bool followed = next != null &&
        next.senderId == current.senderId &&
        next.type != ProposalChatType.marker;
    Widget card;
    Widget content;
    final BorderRadius shapeRadius = BorderRadius.only(
      topLeft: Radius.circular(!mine && preceeded ? 4.0 : 16.0),
      topRight: Radius.circular(mine && preceeded ? 4.0 : 16.0),
      bottomLeft: Radius.circular(!mine && followed ? 4.0 : 16.0),
      bottomRight: Radius.circular(mine && followed ? 4.0 : 16.0),
    );
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: shapeRadius,
    );
    if (current.type == ProposalChatType.imageKey) {
      final Map<String, String> query = Uri.splitQueryString(current.text);
      card = Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          elevation: 1.0,
          shape: shape,
          child: query['url'] != null
              ? ClipRRect(
                  borderRadius: shapeRadius,
                  child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder_photo_select.png',
                      image: query['url']))
              : Material(
                  color: theme.cardColor,
                  shape: shape,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
        ),
      );
    } else {
      TextStyle messageTextStyle = theme.textTheme.subhead; // Odd theme
      if (ghost) {
        messageTextStyle = messageTextStyle.copyWith(
            color: messageTextStyle.color.withAlpha(128));
      }
      if (current.type == ProposalChatType.terms) {
        Map<String, String> query = Uri.splitQueryString(current.text);
        final Widget info = Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
          children: <Widget>[
            Text("Deliverables", style: theme.textTheme.caption),
            Text(query['deliverables'].toString(), style: messageTextStyle),
            const SizedBox(height: 12.0),
            Text("Reward", style: theme.textTheme.caption),
            Text(query['reward'].toString(), style: messageTextStyle),
            const SizedBox(height: 12.0),
            Text("Remarks", style: theme.textTheme.caption),
            Text(query['remarks'].toString(), style: messageTextStyle),
          ],
        );
        if (current.chatId == widget.proposal.termsChatId) {
          final bool wantDealSent = (accountId == influencerAccountId)
              ? widget.proposal.influencerWantsDeal
              : widget.proposal.businessWantsDeal;
          final bool dealMade = widget.proposal.influencerWantsDeal &&
              widget.proposal.businessWantsDeal;
          if (dealMade) {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
              children: <Widget>[
                info,
                const SizedBox(height: 12.0),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                  child: Text(
                    "Deal!",
                  ),
                ),
              ],
            );
          } else {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
              children: <Widget>[
                info,
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment:
                      mine ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: <Widget>[
                    RaisedButton(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      color: !mine ? theme.buttonColor : theme.cardColor,
                      child: Text("Haggle".toUpperCase()),
                      onPressed: () {
                        _haggle(current);
                      },
                    ),
                    const SizedBox(width: 12.0),
                    wantDealSent
                        ? const Text("Awaiting reply.")
                        : RaisedButton(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            color: !mine ? theme.buttonColor : theme.cardColor,
                            child: Text(
                              "Make a deal".toUpperCase(),
                              /*style: theme
                        .textTheme
                        .button
                        .copyWith(color: theme.accentColor),*/
                            ),
                            onPressed: () {
                              _wantDeal(current);
                            },
                          ),
                  ],
                ),
              ],
            );
          }
        } else if (current.chatId == 0) {
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
            children: <Widget>[
              info,
              const SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  CircularProgressIndicator(),
                ],
              ),
            ],
          );
        } else {
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
            children: <Widget>[
              info,
              const SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                child: Text(
                  "Another offer has been made.",
                  style: theme.textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }
      } else {
        // Plain text message
        content = Text(current.text, style: messageTextStyle);
      }
      card = Card(
        color: mine ? theme.primaryColor : theme.cardColor,
        shape: shape,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          child: content,
        ),
      );
    }
    return Container(
      padding:
          EdgeInsets.only(left: mine ? 52.0 : 0.0, right: mine ? 0.0 : 52.0),
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          card,
        ],
      ),
    );
  }

  List<Widget> _buildChatMessages() {
    final List<Widget> result = <Widget>[];
    final List<DataProposalChat> chatsSorted = widget.chats.toList();
    chatsSorted.sort((a, b) {
      if (a.chatId == 0 && b.chatId != 0) {
        return 1;
      }
      if (b.chatId == 0 && a.chatId != 0) {
        return -1;
      }
      if (a.chatId == 0 && b.chatId == 0)
        return a.sessionGhostId.compareTo(b.sessionGhostId);
      return a.chatId.compareTo(b.chatId);
    });
    for (int i = 0; i < chatsSorted.length; ++i) {
      result.add(_buildChatMessage(
          chatsSorted[i],
          i > 0 ? chatsSorted[i - 1] : null,
          i + 1 < chatsSorted.length ? chatsSorted[i + 1] : null));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final DataAccount otherAccount =
        widget.account.accountId == widget.businessAccount.accountId
            ? widget.influencerAccount
            : widget.businessAccount;
    String statusText;
    final ThemeData theme = Theme.of(context);
    switch (widget.proposal.state) {
      case ProposalState.negotiating:
        if (widget.proposal.influencerWantsDeal !=
            widget.proposal.businessWantsDeal) {
          if ((businessAccountId == accountId &&
                  widget.proposal.businessWantsDeal) ||
              (influencerAccountId == accountId &&
                  widget.proposal.influencerWantsDeal)) {
            statusText = "You want to make a deal.";
          } else {
            statusText =
                "${otherAccount.name} wants to make a deal.\nHaggle or make a deal?";
          }
        } else if (!widget.proposal.influencerWantsDeal) {
          // Neither parties have decided yet (no need to check both)
          statusText = "Haggle or make a deal?";
        } else {
          statusText =
              "Deal!"; // This text is only shortly visible while waiting for server
        }
        break;
      case ProposalState.rejected:
        statusText = "This deal has been rejected.";
        break;
      case ProposalState.deal:
        if (accountId == influencerAccountId)
          statusText = "A deal has been made.\nDeliver and get rewarded!";
        else
          statusText =
              "A deal has been made.\nStay in touch with your influencer!";
        break;
      case ProposalState.complete:
        statusText = "This deal has been completed successfully!";
        break;
      case ProposalState.dispute:
        statusText =
            "A dispute is ongoing. You may be contaced by e-mail by our support staff.\nsupport@infmarketplace.app";
        break;
      case ProposalState.resolved:
        statusText = "This deal is now closed.";
        break;
    }
    return Scaffold(
      appBar: AppBar(
        // titleSpacing: 0.0,
        title: InkWell(
          child: Row(
            children: [
              ProfileAvatar(size: 40.0, account: otherAccount),
              const SizedBox(width: 8.0),
              Flexible(
                  fit: FlexFit.loose,
                  child:
                      Text(otherAccount.name, overflow: TextOverflow.ellipsis)),
            ],
          ),
          onTap: () {
            widget.onPressedProfile(otherAccount);
          },
        ),
        actions: <Widget>[
          /*new IconButton(
            icon: new Icon(Icons.account_circle),
            onPressed: () {
              widget.onPressedProfile(otherAccount);
            },
          ),*/
          PopupMenuButton<void>(itemBuilder: (BuildContext context) {
            return <PopupMenuEntry>[
              PopupMenuItem<void>(
                value: _reportProposal,
                child: const Text("Report"),
              ),
            ];
          }, onSelected: (dynamic f) {
            f();
          }),
        ],
      ),
      bottomSheet: NetworkStatus.buildOptional(
          context), // TODO: Also show loading progress for chats
      body: Column(
        children: <Widget>[
          Material(
            color: theme.cardColor,
            elevation: 8.0,
            child: InkWell(
              onTap: () {
                widget.onPressedOffer(widget.offer);
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  /*new OfferCard(
                  businessOffer: widget.offer,
                  inner: true,
                  onPressed: () {
                    widget.onPressedOffer(widget.offer);
                  },
                ),*/
                  /*new Flexible(
                  fit: FlexFit.tight,
                  child: new Column(),
                ),*/
                  Padding(
                    padding: const EdgeInsets.all(kInfPadding),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 56.0, // 72.0,
                          height: 56.0,
                          child: Material(
                            type: MaterialType.card,
                            elevation: 1.0,
                            borderRadius: kInfImageThumbnailBorder,
                            child: ClipRRect(
                              borderRadius: kInfImageThumbnailBorder,
                              child: BlurredNetworkImage(
                                url: widget.offer.thumbnailUrl,
                                blurredData: widget.offer.thumbnailBlurred,
                                placeholderAsset:
                                    'assets/placeholder_photo.png',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: kInfPadding),
                        Flexible(
                          fit: FlexFit.tight,
                          child: SizedBox(
                            // height: 88.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    // new SizedBox(height: kInfPaddingText),
                                    Text(
                                      widget.offer.title,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.subhead,
                                    ),
                                    const SizedBox(height: kInfPaddingText),
                                    Text(
                                      widget.offer.description,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: theme.textTheme.body1.copyWith(
                                          color: theme.textTheme.caption.color),
                                    ),
                                  ],
                                ),
                                // new SizedBox(height: kInfPaddingText),
                                /*new Padding(
                                  padding: const EdgeInsets.all(kInfPaddingText),
                                  child: new Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: statusText != null
                                        ? <Widget>[
                                            new SizedBox(
                                                height: kInfPaddingText),
                                            new Text(
                                              statusText,
                                              style: theme.textTheme.caption,
                                              textAlign: TextAlign.left,
                                            ),
                                            new SizedBox(
                                                height: kInfPaddingText),
                                          ]
                                        : <Widget>[],
                                  ),
                                ),*/
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: kInfPadding),
                      ],
                    ),
                  ),

                  // TODO: In case of action, status text here instead of other one
                  statusText != null
                      ? Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                          child: Text(
                            statusText,
                            style: theme.textTheme.caption,
                            textAlign: TextAlign.center,
                          ),
                        )
                      : null,
                ].where((w) => w != null).toList(),
              ),
            ),
          ),
          Flexible(
            child: ListView(
              reverse: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              children: _buildChatMessages().reversed.toList(),
            ),
          ),
          Material(
            color: theme.cardColor,
            elevation: 8.0,
            child: Row(
              children: <Widget>[
                SizedBox(width: _uploadAttachment ? 16.0 : 8.0),
                Flexible(
                  child: _uploadAttachment
                      ? ImageUploader(
                          light: true,
                          uploadKey: _uploadKey,
                          onUploadImage: widget.onUploadImage,
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextField(
                            controller: _lineController,
                            onChanged: (text) {
                              setState(() {});
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Send a message...",
                            ),
                            onSubmitted: (String msg) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              widget.onSendPlain(_lineController.text);
                              _lineController.text = '';
                            },
                          ),
                        ),
                ),
                // TODO: Animate between these two, like Telegram
                _lineController.text.isEmpty
                    ? Builder(builder: (context) {
                        final ThemeData theme = Theme.of(context);
                        return IconButton(
                          icon: Icon(
                            _uploadAttachment ? Icons.close : Icons.attach_file,
                            // color: theme.primaryColor,
                            color: theme.primaryTextTheme.caption.color,
                          ),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              _uploadKey.text = '';
                              _uploadAttachment = !_uploadAttachment;
                            });
                            // TODO: Maybe use pop up instead
                            /*Scaffold.of(context).showBottomSheet((context) {
                              return new Material(
                                child: Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: new ImageUploader(
                                    light: true,
                                    uploadKey: _uploadKey,
                                    onUploadImage: (fileImage) {
                                      throw new Exception();
                                    },
                                  ),
                                ),
                              );
                            });*/
                          },
                        );
                      })
                    : IconButton(
                        icon: Icon(
                          Icons.send,
                          // color: theme.primaryColor,
                          color: theme.accentColor,
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          widget.onSendPlain(_lineController.text);
                          _lineController.text = '';
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* end of file */
