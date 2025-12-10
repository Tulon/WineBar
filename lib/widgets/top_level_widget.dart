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

import 'package:flutter/material.dart';
import 'package:winebar/utils/app_info.dart';

import '../utils/startup_data.dart';
import 'error_message_widget.dart';
import 'wine_prefixes_page.dart';

class TopLevelWidget extends StatelessWidget {
  final _startupDataFuture = StartupData.load();

  TopLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppInfo.appName,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: FutureBuilder<StartupData>(
        future: _startupDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While LocalDataRepo is loading, show the splash screen
            return _buildSplashScreen(context);
          } else if (snapshot.hasError) {
            // Handle the error case. It's a critical error and the only
            // thing the user can do at this point is to close the app.
            return _buildCriticalErrorWidget(
              context,
              snapshot.error?.toString() ?? 'Unknown error',
            );
          } else {
            // StartupData has finished loading, so we display
            // the home screen.
            return WinePrefixesPage(startupData: snapshot.data!);
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

  Widget _buildCriticalErrorWidget(BuildContext context, String errorMessage) {
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
                      'Critical Error',
                      style: TextStyle(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ErrorMessageWidget(text: errorMessage),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
