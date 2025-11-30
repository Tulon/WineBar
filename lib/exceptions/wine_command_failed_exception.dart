/*
 * Wine Bar - A Wine prefix manager.
 * Copyright (C) 2025 Josif Arcimovic
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

import 'package:winebar/services/wine_process_runner_service.dart';

/// This exception is used to report errors caused by a wine command failing
/// during prefix creation and modification. This exception carries the
/// [processResult], allowing us to show the logs to the user.
class WineCommandFailedException implements Exception {
  final String errorMessage;
  final WineProcessResult processResult;

  WineCommandFailedException(this.errorMessage, {required this.processResult});

  @override
  String toString() => errorMessage;
}
