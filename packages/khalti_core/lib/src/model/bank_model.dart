// Copyright (c) 2021 The Khalti Authors. All rights reserved.

import 'package:khalti_core/src/helper/model_helpers.dart';

/// The class representing a Bank.
class BankModel {
  /// Default constructor for [BankModel].
  BankModel({
    required this.idx,
    required this.logo,
    required this.name,
    required this.shortName,
  });

  /// A unique bank identification string.
  final String idx;

  /// URL of Bank's logo.
  final String logo;

  /// Name of the Bank.
  ///
  /// e.g. NIC ASIA Bank Limited
  final String name;

  /// Short name of the Bank.
  ///
  /// e.g. NICA
  final String shortName;

  /// Factory to create [BankModel] instance from [map].
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BankModel &&
          runtimeType == other.runtimeType &&
          idx == other.idx &&
          logo == other.logo &&
          name == other.name &&
          shortName == other.shortName;

  @override
  int get hashCode =>
      idx.hashCode ^ logo.hashCode ^ name.hashCode ^ shortName.hashCode;
}

/// Paginated class for [BankModel].
class BankListModel {
  /// Default constructor for [BankListModel].
  BankListModel({
    required this.banks,
    required this.currentPage,
    required this.recordRange,
    required this.totalPages,
    required this.totalRecords,
    this.next,
    this.previous,
  });

  /// The list of Bank.
  final List<BankModel> banks;

  /// The Current page.
  final int currentPage;

  /// The record range.
  final List<int> recordRange;

  /// The total pages available.
  final int totalPages;

  /// The total records available.
  final int totalRecords;

  /// The next page url.
  final String? next;

  /// The previous page url.
  final String? previous;

  /// Factory to create [BankListModel] instance from [map].
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
