import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

enum StartAppRewardedVideoAdEvent {
  loaded,
  failedToLoad,
  clicked,
  closed,
  completed,
}

enum ChartboostRewardedVideoAdEvent {
  loaded,
  failedToLoad,
  clicked,
  closed,
  completed,
}


typedef void StartAppRewardedVideoAdListener(StartAppRewardedVideoAdEvent event);
typedef void ChartboostRewardedVideoAdListener(ChartboostRewardedVideoAdEvent event);


class StartAppRewardedVideoAd {
  StartAppRewardedVideoAd._();

  static final StartAppRewardedVideoAd _instance = StartAppRewardedVideoAd._();

  /// The one and only instance of this class.
  static StartAppRewardedVideoAd get instance => _instance;

  /// Callback invoked for events in the rewarded video ad lifecycle.
  StartAppRewardedVideoAdListener listener;

  /// Shows a rewarded video ad if one has been loaded.
  Future<bool> show() {
    return _invokeBooleanMethod("showStartAppAd");
  }

  /// Loads a rewarded video ad using the provided ad unit ID.
  Future<bool> load(
      {@required String placementId}) {
    return _invokeBooleanMethod("loadStartAppAd");
  }
}


class ChartboostRewardedVideoAd {
  ChartboostRewardedVideoAd._();

  static final ChartboostRewardedVideoAd _instance = ChartboostRewardedVideoAd._();

  /// The one and only instance of this class.
  static ChartboostRewardedVideoAd get instance => _instance;

  /// Callback invoked for events in the rewarded video ad lifecycle.
  ChartboostRewardedVideoAdListener listener;

  /// Shows a rewarded video ad if one has been loaded.
  Future<bool> show() {
    return _invokeBooleanMethod("showChartboostAd");
  }

  /// Loads a rewarded video ad using the provided ad unit ID.
  Future<bool> load(
      {@required String placementId}) {
    return _invokeBooleanMethod("loadChartboostAd");
  }
}


class StartAppAds {
  @visibleForTesting
  StartAppAds.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_handleMethod);
  }

//
//  // A placeholder AdMob App ID for testing. AdMob App IDs and ad unit IDs are
//  // specific to a single operating system, so apps building for both Android and
//  // iOS will need a set for each platform.
//  static final String testAppId = Platform.isAndroid
//      ? 'ca-app-pub-3940256099942544~3347511713'
//      : 'ca-app-pub-3940256099942544~1458002511';

  static final StartAppAds _instance = StartAppAds.private(
    const MethodChannel('flutter_startapp'),
  );

  /// The single shared instance of this plugin.
  static StartAppAds get instance => _instance;

  final MethodChannel _channel;

  Future<String> get platformVersion =>
      _invokeStringMethod("getPlatformVersion");

  static const Map<String,
      StartAppRewardedVideoAdEvent> _methodToStartAppRewardedAdEvent =
  <String, StartAppRewardedVideoAdEvent>{
    'onStartAppAdDidClick': StartAppRewardedVideoAdEvent.clicked,
    'onStartAppAdDidClose': StartAppRewardedVideoAdEvent.closed,
    'onStartAppAdDidFail': StartAppRewardedVideoAdEvent.failedToLoad,
    'onStartAppAdDidLoad': StartAppRewardedVideoAdEvent.loaded,
    'onStartAppAdDidReward': StartAppRewardedVideoAdEvent.completed,
  };

  static const Map<String,
      ChartboostRewardedVideoAdEvent> _methodToChartboostRewardedAdEvent =
  <String, ChartboostRewardedVideoAdEvent>{
    'onChartboostAdDidClick': ChartboostRewardedVideoAdEvent.clicked,
    'onChartboostAdDidClose': ChartboostRewardedVideoAdEvent.closed,
    'onChartboostAdDidFail': ChartboostRewardedVideoAdEvent.failedToLoad,
    'onChartboostAdDidLoad': ChartboostRewardedVideoAdEvent.loaded,
    'onChartboostAdDidReward': ChartboostRewardedVideoAdEvent.completed,
  };


  Future<dynamic> _handleMethod(MethodCall call) {
    assert(call.arguments is Map);
    final Map<dynamic, dynamic> argumentsMap = call.arguments;
    final StartAppRewardedVideoAdEvent startAppEvent =
    _methodToStartAppRewardedAdEvent[call.method];

    final ChartboostRewardedVideoAdEvent chartBoostEvent =
    _methodToChartboostRewardedAdEvent[call.method];

    if (startAppEvent != null) {
      if (StartAppRewardedVideoAd.instance.listener != null) {
        StartAppRewardedVideoAd.instance.listener(startAppEvent);
      }
    } else if (chartBoostEvent != null) {
      if (ChartboostRewardedVideoAd.instance.listener != null) {
        ChartboostRewardedVideoAd.instance.listener(chartBoostEvent);
      }
    }


    return Future<dynamic>.value(null);
  }
}

Future<bool> _invokeBooleanMethod(String method, [dynamic arguments]) async {
  final bool result = await StartAppAds.instance._channel.invokeMethod(
    method,
    arguments,
  );
  return result;
}

Future<String> _invokeStringMethod(String method, [dynamic arguments]) async {
  final String result = await StartAppAds.instance._channel.invokeMethod(
    method,
    arguments,
  );
  return result;
}
