/*
INF Marketplace
Copyright (C) 2018  INF Marketplace LLC
Author: Jan Boon <kaetemi@no-break.space>
*/

enum ChangeAction {
  New,
  Upsert,
  Delete,
  RefreshAll,
}

class Change<T> {
  final T data;
  final ChangeAction action;
  const Change(this.data, this.action);
}

/* end of file */
