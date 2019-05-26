import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/messaging/auto_scroller.dart';
import 'package:inf/ui/messaging/bottom_sheets/job_completed_sheet.dart';
import 'package:inf/ui/messaging/job_completed_header.dart';
import 'package:inf/ui/messaging/message_tile.dart';
import 'package:inf/ui/messaging/negotiation_action_buttons.dart';
import 'package:inf/ui/messaging/offer_profile_header.dart';
import 'package:inf/ui/widgets/inf_divider.dart';
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
  Stream<List<Message>> _messageStream;

  @override
  void initState() {
    super.initState();
    _messageStream = widget.conversationHolder.messages;
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
                            OfferProfileHeader(offer: offer),
                            const InfDivider(),
                            JobCompletedHeader(onTap: onTapJobCompleted)
                          ],
                        ),
                      ),
                      StreamBuilder<List<Message>>(
                        stream: _messageStream,
                        builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
                          if (snapshot.hasData) {
                            final messages = MessageGroup.collapseMessages(snapshot.data);
                            return AutoScroller<MessageTextProvider>(
                              data: snapshot.data,
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                                  final message = messages[index];
                                  final isLastMessage = index == messages.length - 1;
                                  final shouldDisplayActionButtons =
                                      isLastMessage && false; // TODO: Define condition to check if offer has been made.

                                  return Column(
                                    children: <Widget>[
                                      MessageTile(
                                        key: Key(message.id),
                                        message: message,
                                      ),
                                      if (shouldDisplayActionButtons)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: NegotiationActionButtons(
                                            onAccept: onOfferAccept,
                                            onCounter: onOfferCounter,
                                            onReject: onOfferReject,
                                          ),
                                        ),
                                    ],
                                  );
                                }, childCount: messages.length),
                              ),
                            );
                          } else if (snapshot.hasError != null) {
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
                        },
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

  void onTapJobCompleted() async {
    final completionConfirmed = await Navigator.of(context).push<bool>(JobCompletedSheet.route()) ?? false;

    // TODO: Implement callback.
  }

  void onOfferAccept() {}
  void onOfferCounter() {}
  void onOfferReject() {}
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
