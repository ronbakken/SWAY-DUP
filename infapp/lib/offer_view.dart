import 'dart:async';

import 'package:flutter/material.dart';

import 'network/inf.pb.dart';
import 'widgets/carousel_app_bar.dart';
import 'widgets/dark_container.dart';

import 'utility/ensure_visible_when_focused.dart';

class OfferView extends StatefulWidget {
  const OfferView({
    Key key,
    this.onApply,
    @required this.businessOffer,
    @required this.businessAccount,
    @required this.account,
    this.onSharePressed,
    this.onEndPressed,
    this.onEditPressed,
    this.onApplicantsPressed,
  }) : super(key: key);

  final Future<DataApplicant> Function(String remarks) onApply;

  final DataBusinessOffer businessOffer;
  final DataAccount businessAccount;
  final DataAccount account;

  final VoidCallback onSharePressed;

  final VoidCallback onEndPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onApplicantsPressed;

  @override
  _OfferViewState createState() => new _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  bool _waiting = false;
  final _formKey = new GlobalKey<FormState>();
  final TextEditingController _remarksController = new TextEditingController();
  final FocusNode _remarksNode = new FocusNode();

  void _submitPressed(BuildContext context) async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _waiting = true;
      });
      try {
        await widget.onApply(_remarksController.text);
      } finally {
        setState(() {
          _waiting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new CustomScrollView(
        slivers: <Widget>[
          new CarouselAppBar(
            context: context,
            title: new Text(widget.businessOffer.title),
            imageUrls: widget.businessOffer.coverUrls,
            actions: [
              widget.onSharePressed == null
                  ? null
                  : new IconButton(
                      icon: new Icon(Icons.share),
                      onPressed: () {},
                    )
            ]..removeWhere((Widget w) => w == null),
          ),
          new SliverList(
            delegate: new SliverChildListDelegate([
              new DarkContainer(
                child: new ListTile(
                  //isThreeLine: true, //-------------------
                  //enabled: true,
                  leading: new CircleAvatar(
                      backgroundImage: widget.businessAccount.summary
                              .avatarThumbnailUrl.isNotEmpty
                          ? new NetworkImage(
                              widget.businessAccount.summary.avatarThumbnailUrl)
                          : null,
                      backgroundColor: Colors
                          .primaries[
                              widget.businessAccount.summary.name.hashCode %
                                  Colors.primaries.length]
                          .shade300),
                  title: new Text(
                      widget.businessOffer.locationName.isNotEmpty
                          ? widget.businessOffer.locationName
                          : widget.businessAccount.summary.name,
                      maxLines: 1,
                      overflow: TextOverflow.fade),
                  subtitle: new Text(
                      widget.businessAccount.summary.description.isNotEmpty
                          ? widget.businessAccount.summary.description
                          : widget.businessAccount.summary.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ),
              widget.onEndPressed == null &&
                      widget.onEditPressed == null &&
                      widget.onApplicantsPressed == null
                  ? null
                  : new Container(
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            widget.onEndPressed == null
                                ? null
                                : new IconButton(
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: new Column(
                                      children: [
                                        new Container(
                                          padding: new EdgeInsets.all(8.0),
                                          child: new Icon(Icons.remove_circle,
                                              size: 24.0),
                                        ),
                                        new Text("End".toUpperCase(),
                                            maxLines: 1),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return new AlertDialog(
                                            title: new Text('End Your Offer'),
                                            content: new SingleChildScrollView(
                                              child: new ListBody(
                                                children: [
                                                  new Text(
                                                      "Are you sure you would like to end this offer?\n\n"
                                                      "This will remove the offer from influencer search results."
                                                      "The offer will remain standing for current applicants."),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              new FlatButton(
                                                child: new Text("End This Offer"
                                                    .toUpperCase()),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  widget.onEndPressed();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                            widget.onEditPressed == null
                                ? null
                                : new IconButton(
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: new Column(
                                      children: [
                                        new Container(
                                          padding: new EdgeInsets.all(8.0),
                                          child:
                                              new Icon(Icons.edit, size: 24.0),
                                        ),
                                        new Text("Edit".toUpperCase(),
                                            maxLines: 1),
                                      ],
                                    ),
                                    onPressed: widget.onEditPressed,
                                  ),
                            widget.onApplicantsPressed == null
                                ? null
                                : new IconButton(
                                    // TODO: Refactor to not use IconButton
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: new Column(
                                      children: [
                                        new Container(
                                          padding: new EdgeInsets.all(8.0),
                                          child:
                                              new Icon(Icons.inbox, size: 24.0),
                                        ),
                                        new Text("Applicants".toUpperCase(),
                                            maxLines: 1,
                                            overflow: TextOverflow
                                                .ellipsis), // FIXME: IconButton width is insufficient
                                      ],
                                    ),
                                    onPressed: widget.onApplicantsPressed,
                                  ),
                          ]..removeWhere((Widget w) => w == null)),
                    ),
              widget.onEndPressed == null &&
                      widget.onEditPressed == null &&
                      widget.onApplicantsPressed == null
                  ? null
                  : new Divider(),
              new ListTile(
                title: new Text(widget.businessOffer.description,
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.work),
                title: new Text(widget.businessOffer.deliverables,
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.redeem),
                title: new Text(widget.businessOffer.reward,
                    style: Theme.of(context).textTheme.body1),
              ),
              new ListTile(
                leading: new Icon(Icons.pin_drop),
                title: new Text(widget.businessOffer.location,
                    style: Theme.of(context).textTheme.body1),
              ),
              new Divider(),
              widget.account.state.accountType == AccountType.AT_INFLUENCER
                  ? new Container(
                    margin: new EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                      child: new Column(
                      children: <Widget>[
                        new Form(
                          key: _formKey,
                          child: new Column(children: [
                            new EnsureVisibleWhenFocused(
                              focusNode: _remarksNode,
                              child: new TextFormField(
                                focusNode: _remarksNode,
                                controller: _remarksController,
                                maxLines: 4,
                                decoration: new InputDecoration(
                                    labelText:
                                        'Tell us what you can offer more'),
                                validator: (val) => val.trim().length < 20
                                    ? 'Message must be longer'
                                    : null,
                              ),
                            ),
                          ]),
                        ),
                        new SizedBox(
                          height: 16.0,
                        ),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            new RaisedButton(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  new Text("Apply".toUpperCase()),
                                ],
                              ),
                              onPressed: (widget.onApply != null && !_waiting)
                                  ? () {
                                      _submitPressed(context);
                                    }
                                  : null,
                            )
                          ],
                        )
                      ],
                    ))
                  : null,
            ]..removeWhere((Widget w) => w == null)),
          ),
        ],
      ),
    );
  }
}
