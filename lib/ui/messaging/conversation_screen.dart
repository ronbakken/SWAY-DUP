import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/messaging/auto_scroller.dart';
import 'package:inf/ui/messaging/bottom_sheets/job_completed_sheet.dart';
import 'package:inf/ui/messaging/bottom_sheets/negotiation_sheet.dart';
import 'package:inf/ui/messaging/conversation_negotiation_buttons.dart';
import 'package:inf/ui/messaging/message_tile.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_business_row.dart';
import 'package:inf/ui/widgets/inf_divider.dart';
import 'package:inf/ui/widgets/inf_icon.dart';
import 'package:inf/ui/widgets/inf_image.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class ConversationScreen extends StatefulWidget {
  static Route<dynamic> route(ConversationHolder conversationHolder) {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
        return ConversationScreen(
          conversationHolder: conversationHolder,
        );
      },
    );
  }

  const ConversationScreen({
    Key key,
    this.conversationHolder,
  }) : super(key: key);

  final ConversationHolder conversationHolder;

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _scrollController = ScrollController();
  Message _latestMessageWithAction;
  Stream<List<Message>> _messageStream;
  StreamSubscription<Conversation> _conversationStream;
  Proposal _proposal;

  @override
  void initState() {
    super.initState();
    _latestMessageWithAction = widget.conversationHolder.latestMessageWithAction;
    _messageStream = widget.conversationHolder.messages;
    _conversationStream = widget.conversationHolder.stream.listen((conversation) {
      setState(() {
        _latestMessageWithAction = conversation.latestMessageWithAction;
        _proposal = Message.findProposalAttachment(_latestMessageWithAction.attachments);
      });
    });
  }

  @override
  void dispose() {
    _conversationStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final offer = widget.conversationHolder.offer;
    return Material(
      color: AppTheme.listViewAndMenuBackground,
      child: Padding(
        padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: kToolbarHeight + mediaQuery.padding.bottom),
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: _ScrimCollapsingHeader(
                          topPadding: mediaQuery.padding.top,
                          expandedHeight: constraints.biggest.width / (16.0 / 6.0),
                          title: Text(offer.title),
                          background: InfImage.fromProvider(
                            offer.images[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _OfferProfileHeader(offer: offer),
                            const InfDivider(),
                            _JobCompletedHeader(
                              onTap: _onTapJobCompleted,
                            )
                          ],
                        ),
                      ),
                      StreamBuilder<List<Message>>(
                        stream: _messageStream,
                        builder: _buildMessageList,
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: _MessageEntryPanel(
                    conversationId: widget.conversationHolder.conversation.id,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
    if (snapshot.hasData) {
      final messages = MessageGroup.collapseMessages(snapshot.data);
      return AutoScroller<MessageTextProvider>(
        data: snapshot.data,
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _buildMessageListItem(messages[index], index == messages.length - 1);
            },
            childCount: messages.length,
          ),
        ),
      );
    } else if (snapshot.hasError) {
      return SliverFillRemaining(
        child: Center(
          child: Text(snapshot.error.toString()),
        ),
      );
    } else {
      return const SliverFillRemaining(
        child: loadingWidget,
      );
    }
  }

  Widget _buildMessageListItem(final MessageTextProvider message, final bool isLastMessage) {
    final currentUser = backend<UserManager>().currentUser;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        MessageTile(
          key: Key(message.id),
          message: message,
          isLastMessage: isLastMessage,
        ),
        if (message.id == (_latestMessageWithAction?.id ?? '_NONE_') && message.user.id != currentUser.id)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ConversationNegotiationButtons(
              onAccept: _onOfferAccept,
              onCounter: _onOfferCounter,
              onReject: _onOfferReject,
            ),
          ),
      ],
    );
  }

  void _onTapJobCompleted() async {
    final success = await Navigator.of(context).push<bool>(JobCompletedSheet.route()) ?? false;
    if (success) {
      _sendProposalAction(MessageAction.completed, _proposal);
    }
  }

  void _onOfferAccept() {
    _sendProposalAction(MessageAction.accept, _proposal);
  }

  void _onOfferCounter() async {
    final newProposal = await Navigator.of(context).push<Proposal>(NegotiationSheet.route(
      existingProposal: _proposal,
      confirmButtonTitle: 'COUNTER',
    ));
    _sendProposalAction(MessageAction.accept, newProposal);
  }

  void _onOfferReject() {
    _sendProposalAction(MessageAction.reject, _proposal);
  }

  void _sendProposalAction(MessageAction action, Proposal proposal) {
    final currentUser = backend<UserManager>().currentUser;
    backend<ConversationManager>().sendMessage(
      widget.conversationHolder.conversation.id,
      Message(currentUser, action: action, attachments: [
        MessageAttachment.forObject(proposal),
      ]),
    );
  }
}

class _ScrimCollapsingHeader extends SliverPersistentHeaderDelegate {
  _ScrimCollapsingHeader({
    @required this.title,
    @required this.topPadding,
    @required this.expandedHeight,
    @required this.background,
  });

  final Widget title;
  final double topPadding;
  final double expandedHeight;
  final Widget background;

  @override
  double get minExtent => kToolbarHeight + topPadding;

  @override
  double get maxExtent => kToolbarHeight + topPadding + expandedHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final value = 1.0 - (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: Material(
            color: AppTheme.blue,
            elevation: overlapsContent || (shrinkOffset > maxExtent - minExtent) ? 4.0 : 0.0,
            child: Stack(
              children: <Widget>[
                ClipRect(
                  child: OverflowBox(
                    minWidth: constraints.maxWidth,
                    maxWidth: constraints.maxWidth,
                    minHeight: maxExtent,
                    maxHeight: maxExtent,
                    child: Opacity(
                      opacity: value,
                      child: background,
                    ),
                  ),
                ),
                Opacity(
                  opacity: value,
                  child: Container(
                    height: kToolbarHeight * 2,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.black87,
                          Colors.black54,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: AppBar(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        title,
                      ],
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(_ScrimCollapsingHeader old) {
    return old.title != title ||
        old.topPadding != topPadding ||
        old.expandedHeight != expandedHeight ||
        old.background != background;
  }
}

class _MessageEntryPanel extends StatefulWidget {
  const _MessageEntryPanel({
    Key key,
    @required this.conversationId,
  }) : super(key: key);

  final String conversationId;

  @override
  _MessageEntryPanelState createState() => _MessageEntryPanelState();
}

class _MessageEntryPanelState extends State<_MessageEntryPanel> {
  final _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Material(
      color: AppTheme.blackTwo,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, mediaQuery.padding.bottom + 4.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Send a message…',
                ),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            IconButton(
              onPressed: _sendMessage,
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    _messageController.clear();
    if (text.isNotEmpty) {
      final currentUser = backend<UserManager>().currentUser;
      backend<ConversationManager>().sendMessage(
        widget.conversationId,
        Message(currentUser, text: text),
      );
    }
  }
}

class _JobCompletedHeader extends StatelessWidget {
  const _JobCompletedHeader({
    @required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      color: AppTheme.blackTwo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const Text('Deal Completed?'),
          Text.rich(
            TextSpan(
              text: 'MARK AS COMPLETE',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: AppTheme.white50,
              ),
              recognizer: TapGestureRecognizer()..onTap = onTap,
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferProfileHeader extends StatelessWidget {
  const _OfferProfileHeader({
    Key key,
    @required this.offer,
  }) : super(key: key);

  final BusinessOffer offer;

  @override
  Widget build(BuildContext context) {
    return InfBusinessRow(
      onPressed: () {
        return Navigator.of(context).push(
          OfferDetailsPage.route(
            Stream.fromFuture(backend.get<OfferManager>().getFullOffer(offer.id)),
            initialOffer: offer,
          ),
        );
      },
      leading: Image.network(
        offer.businessAvatarThumbnailUrl,
        fit: BoxFit.cover,
      ),
      title: offer.businessName,
      subtitle: offer.businessDescription,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: const ShapeDecoration(
              color: AppTheme.darkGrey,
              shape: StadiumBorder(),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const InfIcon(AppIcons.value, size: 16.0),
                horizontalMargin8,
                Padding(
                  padding: const EdgeInsets.only(bottom: 1.0),
                  child: Text(
                    offer.terms.getTotalValueAsString(),
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 2.0),
          for (final channel in offer.terms.deliverable.channels)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              alignment: Alignment.center,
              decoration: const ShapeDecoration(
                color: AppTheme.darkGrey,
                shape: CircleBorder(),
              ),
              width: 28.0,
              height: 28.0,
              child: SizedBox(
                width: 16.0,
                height: 16.0,
                child: InfAssetImage(
                  channel.logoRawAsset,
                  width: 16.0,
                  height: 16.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
