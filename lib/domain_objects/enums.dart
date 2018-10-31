enum UserType {
  influcencer,
  business,
  support,
  manager,
}

enum AccountState
{
  newAccount, // User is a new account
  banned, // User is disallowed from the service
  createdDenied, // User account creation request was denied. Contact support
  approved, // User account was approved
  demoapproved, // User account was automatically approved for demonstration purpose
  pending, // User account approval is pending
  requiresInfo, // More information is required from the user to approve their account
}

enum ProposalState {
  haggling,
  
  deal,
  rejected,
  
  complete,
  dispute,
  resolved
}


enum BusinessOfferState {
  draft,
  open, // Open and awaiting new applicants
  active, // Active but no longer accepting applicants // (Will be renamed to CLOSED)
  closed // (Will be renamed to ARCHIVED)
}

enum BusinessOfferStateReason {
  newOffer,
  userClosed, // You have closed this offer.
  tosViolation, // This offer violates the Terms of Service
  violation // This offer has been completed by all applicants
}


enum ChatEntryType {
  plain,
  haggle, // url-encoded haggle message (deliverable=...&reward=...&remarks=...)
  image,
  marker // system marker (id=...)
}