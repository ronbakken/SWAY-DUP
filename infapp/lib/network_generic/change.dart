/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

enum ChangeAction {
  /// Newly added (for example, chat message arrives)
  New,

  /// Updated or inserted (for example, chat messages being loaded)
  Upsert,

  /// Deleted (for example, chat message was removed)
  Delete,

  /// Changed, but data is incomplete (for example, object failed to fetch previously due to network error)
  Retry,

  /// Refresh all data (all data was invalidated)
  RefreshAll,
}

class Change<T> {
  final T data;
  final ChangeAction action;
  const Change(this.data, this.action);
}

/* end of file */
