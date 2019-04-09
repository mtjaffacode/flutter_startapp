#import "FlutterStartappPlugin.h"
#import <StartApp/StartApp.h>
#import <Chartboost/Chartboost.h>

@implementation FlutterChartboostDelegate
FlutterMethodChannel *thechannel;

- (void)initWithPlugin:(FlutterMethodChannel*) channel {
    thechannel = channel;
}

- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward {
    [thechannel invokeMethod:@"onStartAppAdDidReward" arguments:@{@"": @""}];
}

- (void)didClickRewardedVideo:(CBLocation)location {
    [thechannel invokeMethod:@"onStartAppAdDidClick" arguments:@{@"": @""}];
}

- (void)didCloseRewardedVideo:(CBLocation)location {
    [thechannel invokeMethod:@"onChartboostAdDidClose" arguments:@{@"": @""}];
}

- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error {
    [thechannel invokeMethod:@"onChartboostAdDidFail" arguments:@{@"Error": [NSString stringWithFormat:@"%lu", (unsigned long)error]}];
}

- (void)didCacheRewardedVideo:(CBLocation)location {
    [thechannel invokeMethod:@"onChartboostAdDidLoad" arguments:@{@"": @""}];
}

@end

@implementation FlutterStartappPluginAdDelegate
FlutterMethodChannel *thechannel;

- (void)initWithPlugin:(FlutterMethodChannel*) channel {
    thechannel = channel;
}

- (void) didLoadAd:(STAAbstractAd*)ad {
     [thechannel invokeMethod:@"onStartAppAdDidLoad" arguments:@{@"": @""}];
}

- (void) failedLoadAd:(STAAbstractAd*)ad withError:(NSError *)error {
    [thechannel invokeMethod:@"onStartAppAdDidFail" arguments:@{@"Error": error.localizedDescription}];
}

- (void) didShowAd:(STAAbstractAd*)ad {
    
}

- (void) failedShowAd:(STAAbstractAd*)ad withError:(NSError *)error {
    [thechannel invokeMethod:@"onStartAppAdDidFail" arguments:@{@"Error": error.localizedDescription}];
}

- (void) didCloseAd:(STAAbstractAd*)ad {
     [thechannel invokeMethod:@"onStartAppAdDidClose" arguments:@{@"": @""}];
}

- (void) didClickAd:(STAAbstractAd*)ad {
    [thechannel invokeMethod:@"onStartAppAdDidClick" arguments:@{@"": @""}];
}

- (void) didCloseInAppStore:(STAAbstractAd*)ad {
    
}

- (void) didCompleteVideo:(STAAbstractAd*)ad {
    [thechannel invokeMethod:@"onStartAppAdDidReward" arguments:@{@"": @""}];
}


@end

@implementation FlutterStartappPlugin
STAStartAppAd* startAppRewardedVideoAd;

FlutterStartappPluginAdDelegate *adDelegate;
FlutterChartboostDelegate *chartboostdelegate;
FlutterMethodChannel *thechannel;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_startapp"
            binaryMessenger:[registrar messenger]];
    thechannel = channel;
  FlutterStartappPlugin* instance = [[FlutterStartappPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
    adDelegate = [[FlutterStartappPluginAdDelegate alloc] init];
    chartboostdelegate = [[FlutterChartboostDelegate alloc] init];
    [chartboostdelegate initWithPlugin:thechannel];
    [Chartboost setDelegate:chartboostdelegate];
    [adDelegate initWithPlugin:thechannel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"loadChartboostAd" isEqualToString:call.method]) {
      [Chartboost cacheRewardedVideo:CBLocationMainMenu];
  } else if ([@"showChartboostAd" isEqualToString:call.method]) {
      [Chartboost showRewardedVideo:CBLocationMainMenu];
  } else if ([@"loadStartAppAd" isEqualToString:call.method]) {
      startAppRewardedVideoAd = [[STAStartAppAd alloc] init];
      [startAppRewardedVideoAd loadRewardedVideoAdWithDelegate:adDelegate];
      result(@true);
  } else if ([@"showStartAppAd" isEqualToString:call.method]) {
      [startAppRewardedVideoAd showAd];
      result(@true);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
