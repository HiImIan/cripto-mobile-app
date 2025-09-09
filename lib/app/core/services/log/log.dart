// ignore_for_file: public_member_api_docs

import 'dart:developer' as dev;
import 'dart:io';

import 'package:logging/logging.dart';

class Log {
  static final Logger _logger = Logger('Crypto');

  static void initialize() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      var coloredInit = '';
      var coloredEnd = '';

      if (Platform.isAndroid) {
        if (record.level.value >= Level.SEVERE.value) {
          coloredInit = '\x1B[31m';
        } else if (record.level.value >= Level.WARNING.value) {
          coloredInit = '\x1B[33m';
        } else if (record.level.value >= Level.INFO.value) {
          coloredInit = '\x1B[34m';
        } else if (record.level.value >= Level.CONFIG.value) {
          coloredInit = '\x1B[36m';
        } else if (record.level.value >= Level.FINEST.value) {
          coloredInit = '\x1B[37m';
        }

        coloredEnd = '\x1B[0m';
      }

      dev.log(
        '$coloredInit${record.message}$coloredEnd',
        name: '$coloredInit${record.level.name}$coloredEnd',
        level: record.level.value,
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }

  static void log(String message) {
    _logger.log(Level.INFO, message);
  }

  static void fine(String message) {
    _logger.log(Level.FINE, message);
  }

  static void config(String message) {
    _logger.log(Level.CONFIG, message);
  }

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _logger.log(Level.SEVERE, message, error, stackTrace);
  }

  static void warning(String message) {
    _logger.log(Level.WARNING, message);
  }
}
