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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:winebar/exceptions/error_with_more_details_url.dart';
import 'package:winebar/l10n/app_localizations.dart';
import 'package:winebar/services/locale_persistence_service.dart';
import 'package:winebar/utils/app_info.dart';
import 'package:winebar/utils/cast_or_null.dart';
import 'package:winebar/utils/l10n.dart';
import 'package:winebar/utils/open_url.dart';
import 'package:winebar/utils/tappable_link.dart';

import '../utils/startup_data.dart';
import 'error_message_widget.dart';
import 'wine_prefixes_page.dart';

class TopLevelWidget extends StatefulWidget {
  const TopLevelWidget({super.key});

  @override
  State<TopLevelWidget> createState() => _TopLevelWidgetState();
}

class _TopLevelWidgetState extends State<TopLevelWidget> {
  late final Future<Locale> initialLocaleGetter;
  Locale? currentLocale;

  @override
  void initState() {
    super.initState();
    initialLocaleGetter = LocalePersistenceService.getLocale();
  }

  @override
  Widget build(BuildContext context) {
    final locale = currentLocale;
    if (locale != null) {
      return _buildMainScreen(context: context, locale: locale);
    } else {
      return FutureBuilder<Locale>(
        future: initialLocaleGetter,
        builder: (context, snapshot) {
          // LocalePersistenceService.getLocale() never throws.
          assert(!snapshot.hasError);

          final locale = snapshot.data;
          if (locale != null) {
            return _buildMainScreen(context: context, locale: locale);
          } else {
            // While the initial locale is loading, show a blank screen.
            // Alternatively, we could have built a MaterialApp without
            // passing a locale and stick a _buildSplashScreen() underneeth,
            // but that's not worth it, as reading the stored locale is
            // really fast.
            return SizedBox.shrink();
          }
        },
      );
    }
  }

  Widget _buildMainScreen({
    required BuildContext context,
    required Locale locale,
  }) {
    return MaterialApp(
      builder: (context, child) {
        L10n.current = AppLocalizations.of(context)!;
        return child!;
      },
      title: AppInfo.appName,
      locale: locale,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: FutureBuilder<StartupData>(
        future: StartupData.asyncInstance,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While LocalDataRepo is loading, show the splash screen
            return _buildSplashScreen(context);
          } else if (snapshot.hasError) {
            // Handle the error case. It's a critical error and the only
            // thing the user can do at this point is to close the app.
            return _buildCriticalErrorWidget(
              context: context,
              errorMessage:
                  snapshot.error?.toString() ??
                  L10n.current.unknownErrorMessage,
              moreDetailsUrl: castOrNull<ErrorWithMoreDetailsUrl>(
                snapshot.error,
              )?.moreDetailsUrl,
            );
          } else {
            // StartupData has finished loading, so we display
            // the home screen.
            return WinePrefixesPage(
              onLocaleChanged: (locale) {
                setState(() {
                  currentLocale = locale;
                  unawaited(LocalePersistenceService.setLocale(locale));
                });
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildSplashScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 100.0,
          height: 100.0,
          child: CircularProgressIndicator(strokeWidth: 7.0),
        ),
      ),
    );
  }

  Widget _buildCriticalErrorWidget({
    required BuildContext context,
    required String errorMessage,
    String? moreDetailsUrl,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Center(
        child: Card(
          elevation: 3,
          margin: EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 16.0,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  spacing: 8.0,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: colorScheme.error,
                      size: 24.0,
                    ),
                    Text(
                      L10n.current.criticalErrorCaption,
                      style: TextStyle(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ErrorMessageWidget(
                  text: errorMessage,
                  trailingLink: moreDetailsUrl == null
                      ? null
                      : TappableLink(
                          linkText: L10n.current.moreDetailsLink,
                          onTapped: () => openUrlAndLogErrors(moreDetailsUrl),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
