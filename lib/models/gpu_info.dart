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

import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:winebar/utils/local_storage_paths.dart';

@immutable
class GpuInfo extends Equatable {
  static const _nameKey = 'name';
  static const _deviceTypeKey = 'deviceType';
  static const _deviceUuidKey = 'deviceUuid';
  static const _deviceIdKey = 'deviceId';
  static const _vendorIdKey = 'vendorId';

  final String name;
  final String deviceType;
  final String deviceUuid;
  final String deviceId;
  final String vendorId;

  @override
  List<Object?> get props => [name, deviceType, deviceUuid, deviceId, vendorId];

  const GpuInfo._({
    required this.name,
    required this.deviceType,
    required this.deviceUuid,
    required this.deviceId,
    required this.vendorId,
  });

  factory GpuInfo.fromJson(Map<String, dynamic> json) {
    final name = json[_nameKey] as String;
    final deviceType = json[_deviceTypeKey] as String;
    final deviceUuid = json[_deviceUuidKey] as String;
    final deviceId = json[_deviceIdKey] as String;
    final vendorId = json[_vendorIdKey] as String;

    return GpuInfo._(
      name: name,
      deviceType: deviceType,
      deviceUuid: deviceUuid,
      deviceId: deviceId,
      vendorId: vendorId,
    );
  }

  static Future<List<GpuInfo>> loadListOfAvailableGpus() async {
    try {
      final list = <GpuInfo>[];

      final result = await Process.run(LocalStoragePaths.gpuEnumeratorPath, []);

      if (result.exitCode != 0) {
        GetIt.I.get<Logger>().e(
          'gpu-enumerator failed with status ${result.exitCode}',
          error: result.stderr,
        );

        return [];
      }

      final json = jsonDecode(result.stdout);
      final jsonGpuList = json['gpus'] as List<dynamic>;

      for (final jsonGpu in jsonGpuList) {
        list.add(GpuInfo.fromJson(jsonGpu));
      }

      return list;
    } catch (e, stackTrace) {
      GetIt.I.get<Logger>().e(
        'Failed to parse the output of gpu-enumerator',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }
}
