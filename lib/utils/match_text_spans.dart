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

import 'package:flutter/material.dart';

/// Converts a string with placeholders into a list of [TextSpan] instances.
///
/// Example:
/// ```dart
/// List<TextSpan> spans = matchTextSpans(
///   'first middle last',
///   matchedBuilders: {
///     'first': (match) => TextSpan(text: match, style: TextStyle(color: Colors.red)),
///     'last': (match) => TextSpan(text: match, style: TextStyle(color: Colors.blue)),
///   },
///
///   // The `text` variable here will be ' middle '.
///   unmatchedBuilder: (text) => TextSpan(text: text)),
/// );
/// ```
List<TextSpan> matchTextSpans(
  String text, {
  required Map<String, TextSpan Function(String)> matchedBuilders,
  required TextSpan Function(String) unmatchedBuilder,
}) {
  if (matchedBuilders.isEmpty) {
    return [unmatchedBuilder(text)];
  }

  final regexPattern = matchedBuilders.keys
      .map((key) => RegExp.escape(key))
      .join('|');

  final textSpanList = <TextSpan>[];

  int lastMatchEnd = 0;

  for (final match in RegExp(regexPattern).allMatches(text)) {
    if (match.start > lastMatchEnd) {
      textSpanList.add(
        unmatchedBuilder(text.substring(lastMatchEnd, match.start)),
      );
    }

    final matchedString = text.substring(match.start, match.end);
    final matchedBuilder = matchedBuilders[matchedString]!;
    textSpanList.add(matchedBuilder(matchedString));

    lastMatchEnd = match.end;
  }

  if (text.length > lastMatchEnd) {
    textSpanList.add(
      unmatchedBuilder(text.substring(lastMatchEnd, text.length)),
    );
  }

  return textSpanList;
}
