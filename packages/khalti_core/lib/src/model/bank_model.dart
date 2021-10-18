import 'package:khalti_core/src/helper/model_helpers.dart';

class BankModel {
  BankModel({
    required this.idx,
    required this.logo,
    required this.name,
    required this.shortName,
  });

  final String idx;
  final String logo;
  final String name;
  final String shortName;

  factory BankModel.fromMap(Map<String, Object?> map) {
    return BankModel(
      idx: map.getString('idx'),
      logo: map.getString('logo'),
      name: map.getString('name'),
      shortName: map.getString('short_name'),
    );
  }

  @override
  String toString() {
    return 'BankModel{idx: $idx, logo: $logo, name: $name, shortName: $shortName}';
  }
}

class BankListModel {
  final List<BankModel> banks;
  final int currentPage;
  final List<int> recordRange;
  final int totalPages;
  final int totalRecords;
  final String? next;
  final String? previous;

  BankListModel({
    required this.banks,
    required this.currentPage,
    required this.recordRange,
    required this.totalPages,
    required this.totalRecords,
    this.next,
    this.previous,
  });

  factory BankListModel.fromMap(Map<String, Object?> map) {
    final rawBanks = map['records'] ?? [];
    return BankListModel(
      banks: rawBanks is Iterable
          ? rawBanks
              .map((bank) => BankModel.fromMap(bank))
              .toList(growable: false)
          : [],
      currentPage: map.getInt('current_page', defaultValue: 1),
      recordRange: map.getList('record_range'),
      totalPages: map.getInt('total_pages', defaultValue: 1),
      totalRecords: map.getInt('total_records', defaultValue: 0),
      next: map.getString('next'),
      previous: map.getString('previous'),
    );
  }

  @override
  String toString() {
    return 'BankListModel{banks: $banks, currentPage: $currentPage, recordRange: $recordRange, totalPages: $totalPages, totalRecords: $totalRecords, next: $next, previous: $previous}';
  }
}
