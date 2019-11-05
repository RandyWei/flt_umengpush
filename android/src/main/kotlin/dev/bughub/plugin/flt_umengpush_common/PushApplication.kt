package dev.bughub.plugin.flt_umengpush_common

import io.flutter.app.FlutterApplication
import android.content.pm.PackageManager

class PushApplication:FlutterApplication() {
    override fun onCreate() {
        super.onCreate()

        val appSecret = metaValue("UMENG_MESSAGE_SECRET")
        val appKey = metaValue("UMENG_APPKEY")
        val channel = metaValue("UMENG_CHANNEL")

        FltUmengpushCommonPlugin.init(this,appKey,appSecret,channel)
    }

    private fun metaValue(metaKey: String): String {
        try {
            val appInfo = this.packageManager.getApplicationInfo(this.packageName, PackageManager.GET_META_DATA)
            var value: String? = appInfo!!.metaData.get(metaKey)!!.toString()

            if (value == null || value == "") {
                value = ""
            }
            return value
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        }

        return ""
    }
}