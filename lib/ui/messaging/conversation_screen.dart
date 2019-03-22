import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/app/theme.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/widgets/inf_business_row.dart';

class ConversationScreen extends StatefulWidget {
  static Route<dynamic> routeExisting() {
    return PageRouteBuilder(
      pageBuilder: (BuildContext context, Animation animation, Animation secondaryAnimation) {
        return const ConversationScreen(
          conversationId: '123',
        );
      },
    );
  }

  const ConversationScreen({
    Key key,
    this.conversationId,
  }) : super(key: key);

  final String conversationId;

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Stream<List<Message>> _messageStream;

  @override
  void initState() {
    super.initState();
    _messageStream = backend<InfMessagingService>().listenForMessages(widget.conversationId);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.listViewAndMenuBackground,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: constraints.biggest.width / (16.0 / 12.0),
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: const Text('Conversation'),
                  background: Image.network(
                    "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: InfBusinessRow(
                  leading: Image.network(
                    "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                    fit: BoxFit.cover,
                  ),
                  title: 'businessName',
                  subtitle: 'businessDescription',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text('\$1,300'),
                      SizedBox(width: 12.0),
                      Icon(Icons.image),
                    ],
                  ),
                ),
              ),
              StreamBuilder<List<Message>>(
                stream: _messageStream,
                builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
                  if (snapshot.hasData) {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                        return ListTile(
                          title: Text('Item #$index'),
                        );
                      }, childCount: 50),
                    );
                  } else if (snapshot.hasError) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Text(snapshot.error),
                      ),
                    );
                  } else {
                    return const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class CollapsingHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return OverflowBox(
      minHeight: 200.0,
      maxHeight: 200.0,
      child: Container(
        height: 200.0,
        child: const Placeholder(),
      ),
    );
  }

  @override
  double get maxExtent => 200.0;

  @override
  double get minExtent => 0.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
