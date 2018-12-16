/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

import 'dart:async';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:inf/widgets/profile_avatar.dart';

import 'package:inf_common/inf_common.dart';
import 'package:inf/widgets/carousel_app_bar.dart';
import 'package:inf/widgets/dark_container.dart';

import 'package:inf/utility/ensure_visible_when_focused.dart';

class OfferView extends StatefulWidget {
  const OfferView({
    Key key,
    this.onApply,
    @required this.offer,
    @required this.senderAccount,
    @required this.account,
    this.onSenderAccountPressed,
    this.onSharePressed,
    this.onEndPressed,
    this.onEditPressed,
    this.onProposalsPressed,
    this.onProposalPressed,
  }) : super(key: key);

  final Future<DataProposal> Function(String remarks) onApply;

  final DataOffer offer;
  final DataAccount senderAccount;
  final DataAccount account;

  final Function() onSenderAccountPressed;

  final Function() onSharePressed;

  final Function() onEndPressed;
  final Function() onEditPressed;
  final Function() onProposalsPressed;

  final Function(Int64 proposalId) onProposalPressed;

  @override
  _OfferViewState createState() => _OfferViewState();
}

class _OfferViewState extends State<OfferView> {
  bool _waiting = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _remarksController = TextEditingController();
  final FocusNode _remarksNode = FocusNode();

  Future<void> _submitPressed(BuildContext context) async {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _waiting = true;
      });
      try {
        await widget.onApply(_remarksController.text);
        _remarksController.text = ''; // Clear text on success
      } finally {
        setState(() {
          _waiting = false;
        });
      }
    }
  }

  Widget _buildInfluencerApply(BuildContext context) {
    if (widget.account.accountType == AccountType.influencer) {
      if (widget.offer.proposalId == 0) {
        return Container(
            margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(children: [
                    EnsureVisibleWhenFocused(
                      focusNode: _remarksNode,
                      child: TextFormField(
                        focusNode: _remarksNode,
                        controller: _remarksController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                            labelText: 'Tell us what you can offer more'),
                        validator: (val) => val.trim().length < 20
                            ? 'Message must be longer'
                            : null,
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RaisedButton(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Apply".toUpperCase()),
                        ],
                      ),
                      onPressed: (widget.onApply != null && !_waiting)
                          ? () {
                              _submitPressed(context);
                            }
                          : null,
                    )
                  ],
                ),
              ],
            ));
      } else {
        return Container(
          margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("See your application".toUpperCase()),
                      ],
                    ),
                    onPressed: widget.onProposalPressed != null
                        ? () {
                            widget.onProposalPressed(
                                widget.offer.proposalId);
                          }
                        : null,
                  )
                ],
              ),
            ],
          ),
        );
      }
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool withProposal =
        (widget.account.accountType == AccountType.influencer) &&
            (widget.offer.proposalId != 0);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          CarouselAppBar(
            context: context,
            title: Text(widget.offer.title),
            imageUrls: widget.offer.coverUrls,
            imagesBlurred: widget.offer.coversBlurred
                .map<Uint8List>(
                    (coverBlurred) => Uint8List.fromList(coverBlurred))
                .toList(),
            fallbackBlurred:
                Uint8List.fromList(widget.offer.thumbnailBlurred),
            actions: [
              widget.onSharePressed == null
                  ? null
                  : IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    )
            ]..removeWhere((Widget w) => w == null),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              DarkContainer(
                child: ListTile(
                  //isThreeLine: true, //-------------------
                  //enabled: true,
                  leading: ProfileAvatar(
                      size: 40.0, account: widget.senderAccount),
                  title: Text(
                      widget.offer.senderName.isNotEmpty
                          ? widget.offer.senderName
                          : widget.senderAccount.name,
                      maxLines: 1,
                      overflow: TextOverflow.fade),
                  subtitle: Text(
                      widget.senderAccount.description.isNotEmpty
                          ? widget.senderAccount.description
                          : widget.senderAccount.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  onTap: widget.onSenderAccountPressed,
                ),
              ),
              widget.onEndPressed == null &&
                      widget.onEditPressed == null &&
                      widget.onProposalsPressed == null
                  ? null
                  : Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            widget.onEndPressed == null
                                ? null
                                : IconButton(
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: const Icon(Icons.remove_circle,
                                              size: 24.0),
                                        ),
                                        Text("End".toUpperCase(), maxLines: 1),
                                      ],
                                    ),
                                    onPressed: () async {
                                      await showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('End Your Offer'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: const <Widget>[
                                                  Text(
                                                      "Are you sure you would like to end this offer?\n\n"
                                                      "This will remove the offer from influencer search results."
                                                      "The offer will remain standing for current proposals."),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text("End This Offer"
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
                                : IconButton(
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: const Icon(Icons.edit,
                                              size: 24.0),
                                        ),
                                        Text("Edit".toUpperCase(), maxLines: 1),
                                      ],
                                    ),
                                    onPressed: widget.onEditPressed,
                                  ),
                            widget.onProposalsPressed == null
                                ? null
                                : IconButton(
                                    // TODO: Refactor to not use IconButton
                                    iconSize: 56.0,
                                    highlightColor: Colors.transparent,
                                    icon: Column(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8.0),
                                          child: const Icon(Icons.inbox,
                                              size: 24.0),
                                        ),
                                        Text("Proposals".toUpperCase(),
                                            maxLines: 1,
                                            overflow: TextOverflow
                                                .ellipsis), // FIXME: IconButton width is insufficient
                                      ],
                                    ),
                                    onPressed: widget.onProposalsPressed,
                                  ),
                          ]..removeWhere((Widget w) => w == null)),
                    ),
              widget.onEndPressed == null &&
                      widget.onEditPressed == null &&
                      widget.onProposalsPressed == null
                  ? null
                  : const Divider(),
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Description",
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.start,
                    ),
                    Text(widget.offer.description,
                        style: Theme.of(context).textTheme.body1),
                  ],
                ),
              ),
              // Proposal, so hide the original deliverables, etc, as it's specified in haggle chat
              withProposal
                  ? null
                  : ListTile(
                      leading: const Icon(Icons.work),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Deliverables",
                            style: Theme.of(context).textTheme.caption,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                              widget
                                  .offer.terms.deliverablesDescription,
                              style: Theme.of(context).textTheme.body1),
                        ],
                      ),
                    ),
              // Proposal, so hide the original rewards, etc, etc, as it's specified in haggle chat
              withProposal
                  ? null
                  : ListTile(
                      leading: const Icon(Icons.redeem),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Reward",
                            style: Theme.of(context).textTheme.caption,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                              widget.offer.terms
                                  .rewardItemOrServiceDescription,
                              style: Theme.of(context).textTheme.body1),
                        ],
                      ),
                    ),
              ListTile(
                leading: const Icon(Icons.pin_drop),
                title: Text(widget.offer.locationAddress,
                    style: Theme.of(context).textTheme.body1),
              ),
              const Divider(),
              _buildInfluencerApply(context),
            ]..removeWhere((Widget w) => w == null)),
          ),
        ],
      ),
    );
  }
}

/* end of file */
