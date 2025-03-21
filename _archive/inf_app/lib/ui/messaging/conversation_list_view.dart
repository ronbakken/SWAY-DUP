import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inf/backend/backend.dart';
import 'package:inf/ui/filter/bottom_nav.dart';
import 'package:inf/ui/main/empty_tab.dart';
import 'package:inf/ui/messaging/conversation_list_tile.dart';
import 'package:inf/ui/messaging/conversation_screen.dart';
import 'package:inf/ui/widgets/widget_utils.dart';

class ConversationListView extends StatefulWidget {
  const ConversationListView({
    Key key,
  }) : super(key: key);

  @override
  _ConversationListViewState createState() => _ConversationListViewState();
}

class _ConversationListViewState extends State<ConversationListView> with AutomaticKeepAliveClientMixin {
  Stream<List<ConversationHolder>> _conversationStream;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _conversationStream = backend<ConversationManager>().listenForMyConversations();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // AutomaticKeepAlive
    final mediaQuery = MediaQuery.of(context);
    return StreamBuilder<List<ConversationHolder>>(
      stream: _conversationStream,
      builder: (BuildContext context, AsyncSnapshot<List<ConversationHolder>> snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return loadingWidget;
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Sorry!, ${snapshot.error}'),
          );
        } else {
          final offers = snapshot.data;
          if (offers == null || offers.isEmpty) {
            final currentUser = backend<UserManager>().currentUser;
            String otherUserType;
            if(currentUser.userType == UserType.influencer){
              otherUserType = 'businesses';
            }else{
              otherUserType = 'influencers';
            }
            return EmptyTab(
              contentText: 'Your conversations with $otherUserType will appear here.',
            );
          } else {
            final conversations = snapshot.data;
            return Material(
              type: MaterialType.transparency,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 4.0,
                  bottom: mediaQuery.padding.bottom + kBottomNavHeight + 4.0,
                ),
                itemCount: conversations.length,
                itemBuilder: (BuildContext context, int index) {
                  final conversationHolder = conversations[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ConversationListTile(
                      conversationHolder: conversationHolder,
                      onPressed: () => _onShowDetails(conversationHolder),
                    ),
                  );
                },
              ),
            );
          }
        }
      },
    );
  }

  void _onShowDetails(ConversationHolder conversationHolder) {
    Navigator.of(context).push(ConversationScreen.route(conversationHolder));
  }
}
