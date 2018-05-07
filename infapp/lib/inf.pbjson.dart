///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library inf_pbjson;

const ConfigSubCategories$json = const {
  '1': 'ConfigSubCategories',
  '2': const [
    const {'1': 'labels', '3': 1, '4': 3, '5': 9, '10': 'labels'},
  ],
};

const ConfigCategories$json = const {
  '1': 'ConfigCategories',
  '2': const [
    const {'1': 'sub', '3': 1, '4': 3, '5': 11, '6': '.ConfigSubCategories', '10': 'sub'},
  ],
};

const Config$json = const {
  '1': 'Config',
  '2': const [
    const {'1': 'categories', '3': 1, '4': 1, '5': 11, '6': '.ConfigCategories', '10': 'categories'},
  ],
};

const CategoryId$json = const {
  '1': 'CategoryId',
  '2': const [
    const {'1': 'main', '3': 1, '4': 1, '5': 5, '10': 'main'},
    const {'1': 'sub', '3': 2, '4': 1, '5': 5, '10': 'sub'},
  ],
};

const CategoryIdSet$json = const {
  '1': 'CategoryIdSet',
  '2': const [
    const {'1': 'ids', '3': 1, '4': 3, '5': 11, '6': '.CategoryId', '10': 'ids'},
  ],
};

