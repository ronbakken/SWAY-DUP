# INF Server

This contains the services that make up the INF server.

Currently there is one majestic monolith service. Preconfigured to connect stand-alone with development databases. Just run it.

## Service Ports

| Service | Port |
| --- | --- |
| API gRPC | 8900 |
| API WS | 8901 |
| Elasticsearch API | 9200 |
| Elasticsearch Mesh | 9300 |
| MariaDB | 3306 |
| phpMyAdmin | 8098 |
| Kibana | 5601 |
| Envoy Proxy HTTP | 80 |
| Envoy Proxy HTTPS | 443 |

## Todo

- Use gRPC.
- Separate social media fetching.
- Put profile information into Elasticsearch instead of SQL. (That is, user profile details, not account data.)
- Separate where necessary.
- Hash slot sharding approach for chat routing (sharded redis pubsub or custom).
- Map cache (custom or any cache that supports sorted queries).

## API

| | Request | | Response | |
| --- | --- | --- | --- | --- |
| | Session | | | |
|client | open session | internal | / | / |
|client/server | close session | internal | / | / |
|client | SESSIONC | NetSessionCreate | R_SESSIO | NetSession |
|server | SESREMOV | NetSessionRemove | / | / |
|client | PING | / | PONG | / |
| | Signing | | | |
|client | A_SETTYP | NetSetAccountType | / | / |
|client | A_CREATE | NetAccountCreate | A_R_CREA | NetAccount |
| | OAuth | | | |
|client | OA_URLRE | NetOAuthGetUrl | OA_R_URL | NetOAuthUrl |
|client | OA_SECRE | NetOAuthGetSecrets | OA_R_SEC | NetOAuthSecrets |
|client | OA_CONNE | NetOAuthConnect | OA_R_CON | NetOAuthConnection |
|client | disconnect oauth | todo | todo | NetOAuthConnection |
| | Account | | | |
|server | ACCOUNTU | NetAccount | / | / |
|client | SFIREBAT | NetSetFirebaseToken | ? | ? |
| | SONESIGI | NetSetOneSignalId | ? | ? |
|client | edit account | todo | todo | NetAccountUpdate |
|client | edit social | todo | todo | NetAccountUpdate |
| | Profile | | | |
|client | GETPROFL | NetGetProfile | R_PROFIL | NetProfile |
| | UP_IMAGE | NetUploadImage | R_UP_IMG | NetUploadSigned |
| | (My) Offers | | | |
|client | CREOFFER | NetCreateOffer | R_CREOFR | NetOffer |
|client | LISTOFRS | NetListOffers | R_LSTOFR | NetOffer |
|client | GETOFFER | NetGetOffer | R_GETOFR | NetOffer |
|client | REPOFFER | NetReportOffer | R_REPOFR | NetReport |
|client | EDITOFFR | NetEditOffer | R_EDTOFR | NetOffer |
|server | LU_OFFER | NetOffer | / | / |
| | Explore (Offers) | | | |
|client | DEMOAOFF | NetDemoAllOffers | R_DEMAOF | NetOffer |
|client | EXPLOMAP | NetExploreMap | R_EXPMAP | NetMapEntry |
|client | EXPLORLS | NetExploreList | R_EXPLST | NetListEntry |
|client | EXFEATUR | NetExploreFeatured | R_EXFEAT | NetFeaturedEntry |
| | Proposals | | | |
|client | APLYPROP | NetApplyProposal | R_APLPRP | NetProposal |
|client | DIREPROP | NetDirectProposal | R_DIRPRP | NetProposal |
|client | LISTPROP | NetListProposals | R_LSTPRP | NetProposal |
|client | GETPRPSL | NetGetProposal | R_GETPRP | NetProposal |
|client | LISTCHAT | NetListChats | R_LSTCHA | NetProposalChat |
|client | PR_WADEA | NetProposalWantDeal | PR_R_WAD | NetProposal |
|client | PR_NGOTI | NetProposalNegotiate | PR_R_NGT | NetProposal |
|client | PR_REJEC | NetProposalReject | PR_R_REJ | NetProposal |
|client | PR_RPORT | NetProposalReport | PR_R_RPT | NetProposal |
|client | PR_DISPU | NetProposalDispute | PR_R_DSP | NetProposal |
|client | PR_COMPT | NetProposalCompletion | PR_R_COM | NetProposal |
|client | PR_ARCHV | NetProposalArchive | PR_R_ARC | NetProposal |
|client | CH_PLAIN | NetChatPlain | / | / |
|client | CH_HAGGL | NetChatNegotiate | / | / |
|client | CH_IMAGE | NetChatImageKey | / | / |
|server | LN_PRPSL | NetProposal | / | / |
|server | LU_PRPSL | NetProposal | / | / |
|server | LN_P_CHA | NetProposalChat | / | / |
|server | LU_P_CHA | NetProposalChat | / | / |
