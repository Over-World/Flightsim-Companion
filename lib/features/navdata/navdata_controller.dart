import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../core/settings.dart';
import '../../data/navdata/navdata_importer.dart';
import '../../data/repositories/navdata_repository.dart';

/// Runs the navdata import and keeps its progress alive across screens.
class NavdataController extends ChangeNotifier {
  NavdataController({
    required this.importerFactory,
    required this.repository,
    required this.settings,
  }) {
    refreshCounts();
  }

  final NavdataImporter Function() importerFactory;
  final NavdataRepository repository;
  final SettingsController settings;

  ImportProgress? progress;
  Object? error;
  NavdataCounts? counts;

  bool get isImporting =>
      progress != null && progress!.stage != ImportStage.done;
  bool get hasData => (counts?.airports ?? 0) > 0;

  Future<void> refreshCounts() async {
    counts = await repository.counts();
    notifyListeners();
  }

  Future<void> startImport() async {
    if (isImporting) return;
    error = null;
    progress = const ImportProgress(ImportStage.downloading, 0);
    notifyListeners();
    try {
      await for (final p in importerFactory().run()) {
        progress = p;
        notifyListeners();
      }
      await settings.setNavdataImportedAt(DateTime.now());
      await refreshCounts();
    } catch (e) {
      error = e;
      progress = null;
      notifyListeners();
    }
  }
}
