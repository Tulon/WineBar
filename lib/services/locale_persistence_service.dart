/*
 * Wine Bar - A Wine prefix manager.
 * Copyright (C) 2025-2026 Josif Arcimovic
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'dart:ui';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:winebar/l10n/app_localizations.dart';

class LocalePersistenceService {
  static final String _keyName = 'localeName';

  static Future<Locale> getLocale() async {
    final localeName = await GetIt.I
        .get<SharedPreferencesAsync>()
        .getString(_keyName)
        .catchError((e, stackTrace) {
          GetIt.I.get<Logger>().e(
            'Failed to read the preferred locale',
            error: e,
            stackTrace: stackTrace,
          );
          return 'en';
        });

    final locale = AppLocalizations.supportedLocales.firstWhere(
      (loc) => loc.toString() == localeName,
      orElse: () => Locale('en'),
    );

    return locale;
  }

  static Future<void> setLocale(Locale loc) async {
    await GetIt.I
        .get<SharedPreferencesAsync>()
        .setString(_keyName, loc.toString())
        .catchError((e, stackTrace) {
          GetIt.I.get<Logger>().e(
            'Failed to save the preferred locale',
            error: e,
            stackTrace: stackTrace,
          );
        });
  }
}
