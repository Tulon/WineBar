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

import 'package:async/async.dart';

/// This interface helps us to implement a pattern where we want a new task
/// given to a worker to cause the worker to abandon whatever task it's
/// currently working on.
///
/// The type [T] is the type asynchronously returned by submitted tasks.
abstract interface class OldTaskAbandoningWorker<T> {
  factory OldTaskAbandoningWorker() {
    return _OldTaskAbandoningWorker<T>();
  }

  /// If there is an ongoing task, abandons it, so that the corresponding
  /// Future never completes.
  Future<void> abandonOngoingTask();

  /// Starts a new task, abandoning any ongoing one.
  ///
  /// Returns the future that completes with the task result, but only
  /// if this task won't itself be abandoned before it completes.
  /// In case this task does get abandoned the returned future will
  /// never complete. That won't cause a memory leaks though.
  Future<T> abandonOngoingAndStartNewTask(Future<T> Function() task);
}

class _OldTaskAbandoningWorker<T> implements OldTaskAbandoningWorker<T> {
  CancelableOperation<T>? _ongoingTask;

  @override
  Future<void> abandonOngoingTask() async {
    final lastOngoingTask = _ongoingTask;

    if (lastOngoingTask != null) {
      await lastOngoingTask.cancel();
    }
  }

  @override
  Future<T> abandonOngoingAndStartNewTask(Future<T> Function() task) async {
    await abandonOngoingTask();

    final newOngoingTask = CancelableOperation.fromFuture(task());
    _ongoingTask = newOngoingTask;

    return newOngoingTask.value;
  }
}
