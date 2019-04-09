package com.jaffaware.flutterstartapp

import com.chartboost.sdk.Chartboost
import com.chartboost.sdk.ChartboostDelegate
import com.chartboost.sdk.Model.CBError
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import com.startapp.android.publish.adsCommon.StartAppAd
import com.startapp.android.publish.adsCommon.StartAppSDK
import com.startapp.android.publish.adsCommon.VideoListener
import com.startapp.android.publish.adsCommon.adListeners.AdDisplayListener
import com.startapp.android.publish.adsCommon.adListeners.AdEventListener


class FlutterStartappPlugin: MethodCallHandler {
  companion object {
    var startAppAd: StartAppAd? = null
    var instanceChannel: MethodChannel? = null
    var registrar: Registrar? = null

    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "flutter_startapp")
      FlutterStartappPlugin.instanceChannel = channel

      channel.setMethodCallHandler(FlutterStartappPlugin())
      Chartboost.setDelegate(object: ChartboostDelegate() {
        override fun didCacheRewardedVideo(location: String?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onChartboostAdDidLoad", mapOf("" to ""))
        }

        override fun didClickRewardedVideo(location: String?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onChartboostAdDidClick", mapOf("" to ""))
        }

        override fun didCompleteRewardedVideo(location: String?, reward: Int) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onChartboostAdDidReward", mapOf("" to ""))
        }

        override fun didFailToLoadRewardedVideo(location: String?, error: CBError.CBImpressionError?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onChartboostAdDidFail", mapOf("Error" to error.toString()))
        }

        override fun didCloseRewardedVideo(location: String?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onChartboostAdDidClose", mapOf("" to ""))
        }

        override fun didDismissRewardedVideo(location: String?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onChartboostAdDidClose", mapOf("" to ""))
        }

        override fun didDisplayRewardedVideo(location: String?) {

        }
      })
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "loadChartboostAd") {
      Chartboost.cacheRewardedVideo(com.chartboost.sdk.CBLocation.LOCATION_MAIN_MENU)
    } else if (call.method == "showChartboostAd") {
      Chartboost.showRewardedVideo(com.chartboost.sdk.CBLocation.LOCATION_MAIN_MENU)
    } else if (call.method == "loadAppStartAd") {
      startAppAd = StartAppAd(FlutterStartappPlugin.registrar?.activity())
      startAppAd?.loadAd(StartAppAd.AdMode.REWARDED_VIDEO, object: AdEventListener {
        override fun onFailedToReceiveAd(p0: com.startapp.android.publish.adsCommon.Ad?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onStartAppAdDidFail", mapOf("Error" to p0?.errorMessage))

        }

        override fun onReceiveAd(p0: com.startapp.android.publish.adsCommon.Ad?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onStartAppAdDidLoad", mapOf("" to ""))
        }
      })
//      StartAppAd. .loadAd(AdMode.REWARDED_VIDEO);
    } else if (call.method == "showAppStartAd") {
      startAppAd?.setVideoListener(object: VideoListener {
        override fun onVideoCompleted() {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onStartAppAdDidReward", mapOf("" to ""))
        }
      })
      startAppAd?.showAd(object: AdDisplayListener {
        override fun adClicked(p0: com.startapp.android.publish.adsCommon.Ad?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onStartAppAdDidClick", mapOf("" to ""))
        }

        override fun adDisplayed(p0: com.startapp.android.publish.adsCommon.Ad?) {

        }

        override fun adNotDisplayed(p0: com.startapp.android.publish.adsCommon.Ad?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onStartAppAdDidFail", mapOf("" to ""))
        }

        override fun adHidden(p0: com.startapp.android.publish.adsCommon.Ad?) {
          FlutterStartappPlugin.instanceChannel?.invokeMethod("onStartAppAdDidClose", mapOf("" to ""))
          startAppAd = null
        }
      })
    } else {
      result.notImplemented()
    }
  }
}
