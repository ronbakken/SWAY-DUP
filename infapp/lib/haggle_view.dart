import 'dart:async';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';

import 'network/inf.pb.dart';
import 'cards/offer_card.dart';
import 'widgets/image_uploader.dart';

class HaggleView extends StatefulWidget {
  const HaggleView({
    Key key,
    @required this.account,
    @required this.businessAccount,
    @required this.influencerAccount,
    @required this.offer,
    @required this.applicant,
  }) : super(key: key);

  final DataAccount account;
  final DataAccount businessAccount;
  final DataAccount influencerAccount;

  final DataBusinessOffer offer;
  final DataApplicant applicant;

  @override
  _HaggleViewState createState() => new _HaggleViewState();
}

class _HaggleViewState extends State<HaggleView> {
  TextEditingController _lineController = new TextEditingController();
  TextEditingController _uploadKey = new TextEditingController();

  void _sendText(String text) {}

  List<DataApplicantChat> _testingData = new List<DataApplicantChat>();

  int get influencerAccountId {
    return widget.influencerAccount.state.accountId;
  }

  int get businessAccountId {
    return widget.businessAccount.state.accountId;
  }

  int get accountId {
    return widget.account.state.accountId;
  }

  DataAccount getAccount(int accountId) {
    if (accountId == this.accountId) return widget.account;
    if (accountId == influencerAccountId) return widget.influencerAccount;
    if (accountId == businessAccountId) return widget.businessAccount;
    return new DataAccount(); // Blank
  }

  @override
  void initState() {
    super.initState();

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
  }

  Widget _buildChatMessage(DataApplicantChat current,
      DataApplicantChat previous, DataApplicantChat next) {
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
        if (true || current.chatId == widget.applicant.haggleChatId) {
          content = new Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Not localized?
            children: <Widget>[
              info,
              new SizedBox(height: 12.0),
              new Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
          content = info;
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
    for (int i = 0; i < _testingData.length; ++i) {
      result.add(_buildChatMessage(
          _testingData[i],
          i > 0 ? _testingData[i - 1] : null,
          i + 1 < _testingData.length ? _testingData[i + 1] : null));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    DataAccount otherAccount =
        widget.account.state.accountId == widget.businessAccount.state.accountId
            ? widget.influencerAccount
            : widget.businessAccount;
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
            onPressed: () {},
          )
        ],
      ),
      body: new Column(
        children: <Widget>[
          new Material(
              color: Theme.of(context).cardColor,
              elevation: 8.0,
              child: new Column(
                children: <Widget>[
                  new OfferCard(businessOffer: widget.offer, inner: true),
                  new Padding(
                    padding: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
                    child: new Text(
                      "${getAccount(businessAccountId).summary.name} wants to make a deal.\nHaggle or make a deal?",
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
          new Flexible(
            child: new ListView(
              reverse: true,
              padding: new EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
              children: _buildChatMessages().reversed.toList(), //<Widget>[
              // _buildChatMessage()
              /*
                new Card(
                  margin:
                      new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: new Padding(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: new Text("ESD 4.5"),
                  ),
                ),
                new Card(
                  margin:
                      new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: new Padding(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: new Text("ESE 3.0"),
                  ),
                ),
                new Card(
                  margin:
                      new EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: new Padding(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: new Text("BT8XXEMU: BT815"),
                  ),
                ),
                new Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: new Text("Tralalala"),
                ),
                new Dismissible(
                  key: new Key("dfsanddna"),
                  child: new Padding(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: new Text("Tralalala!!!"),
                  ),
                  background: new Padding(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: new Text("Done"),
                  ),
                  secondaryBackground: new Padding(
                    padding: new EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 4.0),
                    child: new Text("waaah"),
                  ),
                  direction: DismissDirection.startToEnd,
                ),
                new Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: new Text("Tralalala"),
                ),
                new Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: new Text("Tralalala"),
                ),
                new Padding(
                  padding:
                      new EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: new Text("Tralalalaaa"),
                ),
                */
              //],
            ),
          ),
          /*new Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).primaryTextTheme,
              iconTheme: Theme.of(context).primaryIconTheme,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child:*/
          new Material(
            color: Theme.of(context).cardColor,
            elevation: 8.0,
            child: new Row(
              children: <Widget>[
                new SizedBox(width: 8.0),
                new Flexible(
                  child: new Padding(
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
                        FocusScope.of(context).requestFocus(new FocusNode());
                        _sendText(_lineController.text);
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
                            Icons.attach_file,
                            // color: Theme.of(context).primaryColor,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .caption
                                .color,
                          ),
                          onPressed: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            // TODO: Maybe use pop up instead
                            Scaffold.of(context).showBottomSheet((context) {
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
                            });
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
                          _sendText(_lineController.text);
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
