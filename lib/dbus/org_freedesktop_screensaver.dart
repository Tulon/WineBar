// This file was generated using the following command and may be overwritten.
// dart-dbus generate-remote-object dbus/interfaces/org.freedesktop.ScreenSaver.xml

import 'dart:io';
import 'package:dbus/dbus.dart';

/// Signal data for org.freedesktop.ScreenSaver.ActiveChanged.
class OrgFreedesktopScreenSaverActiveChanged extends DBusSignal {
  bool get arg_0 => values[0].asBoolean();

  OrgFreedesktopScreenSaverActiveChanged(DBusSignal signal) : super(sender: signal.sender, path: signal.path, interface: signal.interface, name: signal.name, values: signal.values);
}

class OrgFreedesktopScreenSaver extends DBusRemoteObject {
  /// Stream of org.freedesktop.ScreenSaver.ActiveChanged signals.
  late final Stream<OrgFreedesktopScreenSaverActiveChanged> activeChanged;

  OrgFreedesktopScreenSaver(DBusClient client, String destination, DBusObjectPath path) : super(client, name: destination, path: path) {
    activeChanged = DBusRemoteObjectSignalStream(object: this, interface: 'org.freedesktop.ScreenSaver', name: 'ActiveChanged', signature: DBusSignature('b')).asBroadcastStream().map((signal) => OrgFreedesktopScreenSaverActiveChanged(signal));
  }

  /// Invokes org.freedesktop.ScreenSaver.Lock()
  Future<void> callLock({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    await callMethod('org.freedesktop.ScreenSaver', 'Lock', [], replySignature: DBusSignature(''), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes org.freedesktop.ScreenSaver.SimulateUserActivity()
  Future<void> callSimulateUserActivity({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    await callMethod('org.freedesktop.ScreenSaver', 'SimulateUserActivity', [], replySignature: DBusSignature(''), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes org.freedesktop.ScreenSaver.GetActive()
  Future<bool> callGetActive({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.freedesktop.ScreenSaver', 'GetActive', [], replySignature: DBusSignature('b'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.freedesktop.ScreenSaver.GetActiveTime()
  Future<int> callGetActiveTime({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.freedesktop.ScreenSaver', 'GetActiveTime', [], replySignature: DBusSignature('u'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asUint32();
  }

  /// Invokes org.freedesktop.ScreenSaver.GetSessionIdleTime()
  Future<int> callGetSessionIdleTime({bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.freedesktop.ScreenSaver', 'GetSessionIdleTime', [], replySignature: DBusSignature('u'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asUint32();
  }

  /// Invokes org.freedesktop.ScreenSaver.SetActive()
  Future<bool> callSetActive(bool e, {bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.freedesktop.ScreenSaver', 'SetActive', [DBusBoolean(e)], replySignature: DBusSignature('b'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.freedesktop.ScreenSaver.Inhibit()
  Future<int> callInhibit(String application_name, String reason_for_inhibit, {bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.freedesktop.ScreenSaver', 'Inhibit', [DBusString(application_name), DBusString(reason_for_inhibit)], replySignature: DBusSignature('u'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asUint32();
  }

  /// Invokes org.freedesktop.ScreenSaver.UnInhibit()
  Future<void> callUnInhibit(int cookie, {bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    await callMethod('org.freedesktop.ScreenSaver', 'UnInhibit', [DBusUint32(cookie)], replySignature: DBusSignature(''), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes org.freedesktop.ScreenSaver.Throttle()
  Future<int> callThrottle(String application_name, String reason_for_inhibit, {bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.freedesktop.ScreenSaver', 'Throttle', [DBusString(application_name), DBusString(reason_for_inhibit)], replySignature: DBusSignature('u'), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asUint32();
  }

  /// Invokes org.freedesktop.ScreenSaver.UnThrottle()
  Future<void> callUnThrottle(int cookie, {bool noAutoStart = false, bool allowInteractiveAuthorization = false}) async {
    await callMethod('org.freedesktop.ScreenSaver', 'UnThrottle', [DBusUint32(cookie)], replySignature: DBusSignature(''), noAutoStart: noAutoStart, allowInteractiveAuthorization: allowInteractiveAuthorization);
  }
}
