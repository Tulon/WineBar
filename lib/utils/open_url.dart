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

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> openUrlAndLogErrors(String url) {
  return launchUrlString(url)
      .then<void>((_) {})
      .catchError(
        (e) => GetIt.I.get<Logger>().w('Failed opening URL $url', error: e),
      );
}
