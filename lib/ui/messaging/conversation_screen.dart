import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inf/app/assets.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/messaging/message_tile.dart';
import 'package:inf/ui/offer_views/offer_details_page.dart';
import 'package:inf/ui/widgets/inf_asset_image.dart';
import 'package:inf/ui/widgets/inf_business_row.dart';
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
                        child: InfBusinessRow(
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
                                        offer.terms.reward.getTotalValueAsString(),
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
                                  return MessageTile(
                                    key: Key(message.id),
                                    message: message,
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
                  child: NewMessagePanel(
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

class AutoScroller<T> extends StatefulWidget {
  const AutoScroller({
    Key key,
    @required this.data,
    @required this.sliver,
  }) : super(key: key);

  final List<T> data;

  final Widget sliver;

  @override
  _AutoScrollerState<T> createState() => _AutoScrollerState<T>();
}

class _AutoScrollerState<T> extends State<AutoScroller<T>> {
  ScrollPosition _position;
  bool _atBottom = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final _newPosition = Scrollable.of(context)?.position;
    if (_newPosition != _position) {
      _position?.removeListener(_onScrollChanged);
      _position = _newPosition;
      _position?.addListener(_onScrollChanged);
    }
  }

  void _onScrollChanged() {
    _atBottom = (_position != null) && (_position.pixels >= _position.maxScrollExtent - 100.0);
  }

  @override
  void dispose() {
    _position?.removeListener(_onScrollChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(AutoScroller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_position != null) {
      if (oldWidget.data.length < widget.data.length && _atBottom) {
        scrollToBottom();
      }
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _position.animateTo(
        _position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.sliver;
  }
}

class NewMessagePanel extends StatefulWidget {
  const NewMessagePanel({
    Key key,
    @required this.conversationId,
  }) : super(key: key);

  final String conversationId;

  @override
  _NewMessagePanelState createState() => _NewMessagePanelState();
}

class _NewMessagePanelState extends State<NewMessagePanel> {
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
