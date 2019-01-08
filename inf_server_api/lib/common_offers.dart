/*

Future<DataOffer> getOffer(Int64 offerId) async {
  dynamic doc = await elasticsearch.getDocument("offers", offerId.toString());
  return ElasticsearchOffer.fromJson(config, doc,
      state: true,
      summary: true,
      detail: true,
      offerId: offerId,
      receiver: accountId,
      private: true);
}

*/