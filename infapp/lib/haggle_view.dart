import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'network/inf.pb.dart';
import 'cards/offer_card.dart';
import 'widgets/image_uploader.dart';
import 'widgets/network_status.dart';

class HaggleView extends StatefulWidget {
  const HaggleView({
    Key key,
    @required this.account,
    @required this.businessAccount,
    @required this.influencerAccount,
    @required this.offer,
    @required this.applicant,
    @required this.chats,
    @required this.processingAction,
    @required this.onSendPlain,
    @required this.onSendImageKey,
    @required this.onBeginHaggle,
    @required this.onWantDeal,
    @required this.onReject,
    @required this.onBeginReport,
    @required this.onBeginMarkDispute,
    @required this.onBeginMarkCompleted,
    @required this.onUploadImage,
    @required this.onPressedProfile,
  }) : super(key: key);

  final DataAccount account;
  final DataAccount businessAccount;
  final DataAccount influencerAccount;

  final DataBusinessOffer offer;
  final DataApplicant applicant;

  final Iterable<DataApplicantChat> chats;

  final bool processingAction;

  final Function(String text) onSendPlain;
  final Function(String key) onSendImageKey;

  final Function(DataApplicantChat haggleChat) onBeginHaggle;
  final Function(DataApplicantChat haggleChat) onWantDeal;

  final Function() onReject;
  final Function() onBeginReport;
  final Function() onBeginMarkDispute;
  final Function() onBeginMarkCompleted;

  final Future<NetUploadImageRes> Function(FileImage fileImage) onUploadImage;

  final Function(DataAccount account) onPressedProfile;

  @override
  _HaggleViewState createState() => new _HaggleViewState();
}

class _HaggleViewState extends State<HaggleView> {
  TextEditingController _lineController = new TextEditingController();
  TextEditingController _uploadKey = new TextEditingController();

  bool _uploadAttachment = false;

  // List<DataApplicantChat> _testingData = new List<DataApplicantChat>();

  int get influencerAccountId {
    return widget.influencerAccount.state.accountId;
  }

  int get businessAccountId {
    return widget.businessAccount.state.accountId;
  }

  int get accountId {
    return widget.account.state.accountId;
  }

  int get otherAccountId {
    if (influencerAccountId == accountId) return businessAccountId;
    return influencerAccountId;
  }

  DataAccount getAccount(int accountId) {
    if (accountId == this.accountId) return widget.account;
    if (accountId == influencerAccountId) return widget.influencerAccount;
    if (accountId == businessAccountId) return widget.businessAccount;
    return new DataAccount(); // Blank
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
    DataApplicantChat chat;

    chat = new DataApplicantChat();
    chat.senderId = influencerAccountId;
    chat.type = ApplicantChatType.ACT_HAGGLE;
    chat.text =
        "deliverables=test+deliverables+text+here&reward=three+fifty&remarks=I+am+the+mostest+awesomester+influencer!";
    chat.chatId = new Int64(1);
    _testingData.add(chat);

    chat = new DataApplicantChat();
    chat.senderId = influencerAccountId;
    chat.type = ApplicantChatType.ACT_PLAIN;
    chat.text = "This is a plain text message.";
    chat.chatId = new Int64(2);
    _testingData.add(chat);

    chat = new DataApplicantChat();
    chat.senderId = influencerAccountId;
    chat.type = ApplicantChatType.ACT_PLAIN;
    chat.text =
        "This is a plain text message. But it is very long. Much longer, in fact.";
    chat.chatId = new Int64(3);
    _testingData.add(chat);

    chat = new DataApplicantChat();
    chat.senderId = businessAccountId;
    chat.type = ApplicantChatType.ACT_PLAIN;
    chat.text = "I can talk too.";
    chat.chatId = new Int64(4);
    _testingData.add(chat);

    chat = new DataApplicantChat();
    chat.senderId = influencerAccountId;
    chat.type = ApplicantChatType.ACT_MARKER;
    chat.text = "marker=1";
    chat.chatId = new Int64(5);
    _testingData.add(chat);

    chat = new DataApplicantChat();
    chat.senderId = businessAccountId;
    chat.type = ApplicantChatType.ACT_PLAIN;
    chat.text = "That's cool.";
    chat.chatId = new Int64(5);
    _testingData.add(chat);

    chat = new DataApplicantChat();
    chat.senderId = influencerAccountId;
    chat.type = ApplicantChatType.ACT_IMAGE_KEY;
    chat.text = "url=" +
        Uri.encodeQueryComponent(
            "https://res.cloudinary.com/inf-marketplace/image/upload/c_lfill,g_face:center,h_360,w_360,q_auto/dev/user/10/11c524fc7018d93f13593a5fbe301ea79bc66522c44a593f96c077c16e7ac02b.jpg");
    chat.chatId = new Int64(6);
    _testingData.add(chat);

    chat = new DataApplicantChat();
    chat.senderId = influencerAccountId;
    chat.type = ApplicantChatType.ACT_PLAIN;
    chat.text = "Here's a picture of me.";
    chat.chatId = new Int64(7);
    _testingData.add(chat);
    */
  }

  @override
  void dispose() {
    _uploadKey.removeListener(_uploadKeyChanged);
    super.dispose();
  }

  Widget _buildChatMessage(DataApplicantChat current,
      DataApplicantChat previous, DataApplicantChat next) {
    bool ghost = current.chatId == 0;
    if (current.type == ApplicantChatType.ACT_MARKER) {
      Map<String, String> query = Uri.splitQueryString(current.text);
      String message;
      switch (ApplicantChatMarker.valueOf(int.tryParse(query['marker']))) {
        case ApplicantChatMarker.ACM_APPLIED:
          message = current.senderId == accountId
              ? "You have applied for ${widget.offer.title}."
              : "${getAccount(current.senderId).summary.name} has applied for ${widget.offer.title}.";
          break;
        case ApplicantChatMarker.ACM_WANT_DEAL:
          message = current.senderId == accountId
              ? "You want to make a deal."
              : "${getAccount(current.senderId).summary.name} wants to make a deal.";
          break;
        case ApplicantChatMarker.ACM_DEAL_MADE:
          message = "A deal has been made. Congratulations!";
          break;
        case ApplicantChatMarker.ACM_REJECTED:
          message = current.senderId == accountId
              ? "You have rejected the application."
              : "${getAccount(current.senderId).summary.name} has rejected the application.";
          break;
        case ApplicantChatMarker.ACM_MARKED_COMPLETE:
          message = current.senderId == accountId
              ? "You have marked the deal as completed."
              : "${getAccount(current.senderId).summary.name} has marked the deal as completed.";
          break;
        case ApplicantChatMarker.ACM_COMPLETE:
          message = "The offer has been completed. Well done!";
          break;
        case ApplicantChatMarker.ACM_MARKED_DISPUTE:
          message = "..."; // Should be silent, perhaps.
          break;
        case ApplicantChatMarker.ACM_RESOLVED:
          message =
              "The dispute has been resolved through customer support. Case closed.";
          break;
        default:
          message = "...";
          break;
      }
      return new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Container(
            padding: EdgeInsets.all(12.0),
            child: new Text(message),
          ),
        ],
      );
    }
    bool mine = current.senderId == accountId;
    bool preceeded = previous != null &&
        previous.senderId == current.senderId &&
        previous.type != ApplicantChatType.ACT_MARKER;
    bool followed = next != null &&
        next.senderId == current.senderId &&
        next.type != ApplicantChatType.ACT_MARKER;
    Widget card;
    Widget content;
    RoundedRectangleBorder shape = new RoundedRectangleBorder(
      borderRadius: new BorderRadius.only(
        topLeft: Radius.circular(!mine && preceeded ? 4.0 : 16.0),
        topRight: Radius.circular(mine && preceeded ? 4.0 : 16.0),
        bottomLeft: Radius.circular(!mine && followed ? 4.0 : 16.0),
        bottomRight: Radius.circular(mine && followed ? 4.0 : 16.0),
      ),
    );
    if (current.type == ApplicantChatType.ACT_IMAGE_KEY) {
      Map<String, String> query = Uri.splitQueryString(current.text);
      card = new Padding(
        padding: EdgeInsets.all(4.0),
        child: Material(
          elevation: 1.0,
          shape: shape,
          child: query['url'] != null
              ? new FadeInImage.assetNetwork(
                  placeholder: 'assets/placeholder_photo.png',
                  image: query['url'])
              : null,
        ),
      );
    } else {
      if (current.type == ApplicantChatType.ACT_HAGGLE) {
        Map<String, String> query = Uri.splitQueryString(current.text);
        Widget info = new Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
          children: <Widget>[
            new Text("Deliverables",
                style: Theme.of(context).textTheme.caption),
            new Text(query['deliverables'].toString(),
                style: Theme.of(context).textTheme.subhead), // Odd theme
            new SizedBox(height: 12.0),
            new Text("Reward", style: Theme.of(context).textTheme.caption),
            new Text(query['reward'].toString(),
                style: Theme.of(context).textTheme.subhead), // Odd theme
            new SizedBox(height: 12.0),
            new Text("Remarks", style: Theme.of(context).textTheme.caption),
            new Text(query['remarks'].toString(),
                style: Theme.of(context).textTheme.subhead), // Odd theme
          ],
        );
        if (current.chatId == widget.applicant.haggleChatId) {
          content = new Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
            children: <Widget>[
              info,
              new SizedBox(height: 12.0),
              new Row(
                mainAxisAlignment:
                    mine ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: <Widget>[
                  new RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(4.0))),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: !mine
                        ? Theme.of(context).buttonColor
                        : Theme.of(context).cardColor,
                    child: new Text("Haggle".toUpperCase()),
                    onPressed: () {},
                  ),
                  new SizedBox(width: 12.0),
                  new RaisedButton(
                    shape: new RoundedRectangleBorder(
                        borderRadius:
                            new BorderRadius.all(new Radius.circular(4.0))),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    color: !mine
                        ? Theme.of(context).buttonColor
                        : Theme.of(context).cardColor,
                    child: new Text(
                      "Make a deal".toUpperCase(),
                      /*style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Theme.of(context).accentColor),*/
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          );
        } else {
          content = content = new Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
            children: <Widget>[
              info,
              new SizedBox(height: 12.0),
              new Padding(
                padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                child: new Text(
                  "Another offer has been made.",
                  style: Theme.of(context).textTheme.caption,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        }
      } else {
        content = new Text(current.text,
            style: Theme.of(context).textTheme.subhead); // Odd theme
      }
      card = new Card(
        color:
            mine ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
        shape: shape,
        child: new Container(
          padding: EdgeInsets.all(12.0),
          child: content,
        ),
      );
    }
    return new Container(
      padding:
          EdgeInsets.only(left: mine ? 52.0 : 0.0, right: mine ? 0.0 : 52.0),
      child: new Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          card,
        ],
      ),
    );
  }

  List<Widget> _buildChatMessages() {
    List<Widget> result = new List<Widget>();
    List<DataApplicantChat> chatsSorted = widget.chats.toList();
    chatsSorted.sort((a, b) {
      if (a.chatId == 0 && b.chatId != 0) return 1;
      if (b.chatId == 0 && a.chatId != 0) return -1;
      if (a.chatId == 0 && b.chatId == 0)
        return a.deviceGhostId.compareTo(b.deviceGhostId);
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
    DataAccount otherAccount =
        widget.account.state.accountId == widget.businessAccount.state.accountId
            ? widget.influencerAccount
            : widget.businessAccount;
    String statusText;
    switch (widget.applicant.state) {
      case ApplicantState.AS_HAGGLING:
        if (widget.applicant.influencerWantsDeal !=
            widget.applicant.businessWantsDeal) {
          if ((businessAccountId == accountId &&
                  widget.applicant.businessWantsDeal) ||
              (influencerAccountId == accountId &&
                  widget.applicant.influencerWantsDeal)) {
            statusText = "You want to make a deal.";
          } else {
            statusText =
                "${otherAccount.summary.name} wants to make a deal.\nHaggle or make a deal?";
          }
        } else if (!widget.applicant.influencerWantsDeal) {
          // Neither parties have decided yet (no need to check both)
          statusText = "Haggle or make a deal?";
        } else {
          statusText =
              "Deal!"; // This text is only shortly visible while waiting for server
        }
        break;
      case ApplicantState.AS_REJECTED:
        statusText = "This deal has been rejected.";
        break;
      case ApplicantState.AS_DEAL:
        if (accountId == influencerAccountId)
          statusText = "A deal has been made.\nDeliver and get rewarded!";
        else
          statusText =
              "A deal has been made.\nStay in touch with your influencer!";
        break;
      case ApplicantState.AS_COMPLETE:
        statusText = "This deal has been completed successfully!";
        break;
      case ApplicantState.AS_DISPUTE:
        statusText =
            "A dispute is ongoing. You may be contaced by e-mail by our support staff.\nsupport@infmarketplace.app";
        break;
      case ApplicantState.AS_RESOLVED:
        statusText = "This deal is now closed.";
        break;
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Row(children: [
          new CircleAvatar(
            backgroundImage: otherAccount.summary.avatarThumbnailUrl.isNotEmpty
                ? new NetworkImage(otherAccount.summary.avatarThumbnailUrl)
                : null,
            backgroundColor: Colors
                .primaries[otherAccount.summary.name.hashCode %
                    Colors.primaries.length]
                .shade300,
          ),
          new SizedBox(width: 8.0),
          new Text(otherAccount.summary.name),
        ]),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.account_circle),
            onPressed: () {
              widget.onPressedProfile(otherAccount);
            },
          )
        ],
      ),
      bottomSheet: NetworkStatus.buildOptional(
          context), // TODO: Also show loading progress for chats
      body: new Column(
        children: <Widget>[
          new Material(
            color: Theme.of(context).cardColor,
            elevation: 8.0,
            child: new Column(
              children: <Widget>[
                new OfferCard(businessOffer: widget.offer, inner: true),
                statusText != null
                    ? new Padding(
                        padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                        child: new Text(
                          statusText,
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : null,
              ].where((w) => w != null).toList(),
            ),
          ),
          new Flexible(
            child: new ListView(
              reverse: true,
              padding: new EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              children: _buildChatMessages().reversed.toList(),
            ),
          ),
          new Material(
            color: Theme.of(context).cardColor,
            elevation: 8.0,
            child: new Row(
              children: <Widget>[
                new SizedBox(width: _uploadAttachment ? 16.0 : 8.0),
                new Flexible(
                  child: _uploadAttachment
                      ? new ImageUploader(
                          light: true,
                          uploadKey: _uploadKey,
                          onUploadImage: widget.onUploadImage,
                        )
                      : new Padding(
                          padding: new EdgeInsets.symmetric(horizontal: 8.0),
                          child: new TextField(
                            controller: _lineController,
                            onChanged: (text) {
                              setState(() {});
                            },
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              hintText: "Send a message...",
                            ),
                            onSubmitted: (String msg) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              widget.onSendPlain(_lineController.text);
                              _lineController.text = '';
                            },
                          ),
                        ),
                ),
                // TODO: Animate between these two, like Telegram
                _lineController.text.isEmpty
                    ? new Builder(builder: (context) {
                        return new IconButton(
                          icon: new Icon(
                            _uploadAttachment ? Icons.close : Icons.attach_file,
                            // color: Theme.of(context).primaryColor,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .caption
                                .color,
                          ),
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
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
                    : new IconButton(
                        icon: new Icon(
                          Icons.send,
                          // color: Theme.of(context).primaryColor,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          FocusScope.of(context).requestFocus(new FocusNode());
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
