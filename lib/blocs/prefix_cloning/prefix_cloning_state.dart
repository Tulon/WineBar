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

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:winebar/models/process_log.dart';

enum PrefixCloningStatus { notStarted, inProgress, failed, succeeded }

@immutable
class PrefixCloningState extends Equatable {
  final String targetPrefixName;
  final String? targetPrefixNameErrorMessage;
  final PrefixCloningStatus prefixCloningStatus;
  final String? prefixCloningFailureMessage;
  final List<ProcessLog> prefixCloningFailedProcessLogs;

  bool get readyToClone =>
      targetPrefixName.isNotEmpty &&
      targetPrefixNameErrorMessage == null &&
      prefixCloningStatus != PrefixCloningStatus.inProgress;

  const PrefixCloningState({
    required this.targetPrefixName,
    required this.targetPrefixNameErrorMessage,
    required this.prefixCloningStatus,
    required this.prefixCloningFailureMessage,
    required this.prefixCloningFailedProcessLogs,
  });

  const PrefixCloningState.defaultState()
    : this(
        targetPrefixName: '',
        targetPrefixNameErrorMessage: null,
        prefixCloningStatus: PrefixCloningStatus.notStarted,
        prefixCloningFailureMessage: null,
        prefixCloningFailedProcessLogs: const [],
      );

  @override
  List<Object?> get props => [
    targetPrefixName,
    targetPrefixNameErrorMessage,
    prefixCloningStatus,
    prefixCloningFailureMessage,
    prefixCloningFailedProcessLogs,
  ];

  PrefixCloningState copyWith({
    String? targetPrefixName,
    ValueGetter<String?>? targetPrefixNameErrorMessageGetter,
    PrefixCloningStatus? prefixCloningStatus,
    ValueGetter<String?>? prefixCloningFailureMessageGetter,
    List<ProcessLog>? prefixCloningFailedProcessLogs,
  }) {
    return PrefixCloningState(
      targetPrefixName: targetPrefixName ?? this.targetPrefixName,
      targetPrefixNameErrorMessage: targetPrefixNameErrorMessageGetter != null
          ? targetPrefixNameErrorMessageGetter()
          : targetPrefixNameErrorMessage,
      prefixCloningStatus: prefixCloningStatus ?? this.prefixCloningStatus,
      prefixCloningFailureMessage: prefixCloningFailureMessageGetter != null
          ? prefixCloningFailureMessageGetter()
          : prefixCloningFailureMessage,
      prefixCloningFailedProcessLogs:
          prefixCloningFailedProcessLogs ?? this.prefixCloningFailedProcessLogs,
    );
  }
}
