/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

enum ChangeAction {
  /// Newly added (for example, chat message arrives)
  add,

  /// Updated or inserted (for example, chat messages being loaded)
  upsert,

  /// Deleted (for example, chat message was removed)
  remove,

  /// Changed, but data is incomplete (for example, object failed to fetch previously due to network error)
  retry,

  /// Refresh all data (all data was invalidated)
  refreshAll,
}

class Change<T> {
  final T data;
  final ChangeAction action;
  const Change(this.data, this.action);
}

/* end of file */
