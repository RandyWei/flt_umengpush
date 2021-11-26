package dev.bughub.plugin.flt_umengpush_core

import android.app.Activity
import android.content.Context
import android.util.Log
import com.umeng.message.IUmengRegisterCallback
import com.umeng.message.PushAgent
import com.umeng.message.UTrack
import com.umeng.message.common.inter.ITagManager
import com.umeng.message.tag.TagManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FltUmengpushCorePlugin : MethodCallHandler, FlutterPlugin, ActivityAware {

    private val eventSink = QueuingEventSink()

    private var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    var pushAgent: PushAgent? = null
    var deviceToken: String? = null
    var error: String? = null
    var activity: Activity? = null


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "configure" -> {

                if (pushAgent == null || deviceToken == null) {
                    eventSink.error("error", "配置可能有错，请检查.($error)", "")
                }

                deviceToken?.let {
                    val eventResult = HashMap<String, Any>()
                    eventResult["event"] = "configure"
                    eventResult["deviceToken"] = it

                    eventSink.success(eventResult)
                }
                result.success(null)
            }
            //添加标签 示例：将“标签1”、“标签2”绑定至该设备
            "addTags" -> {

                val tags = call.argument<List<String>>("tags") ?: arrayListOf()
                pushAgent?.tagManager?.addTags(TagManager.TCallBack { isSuccess, result ->

                }, *tags.toTypedArray())

                result.success(null)
            }
            //删除标签,将之前添加的标签中的一个或多个删除
            "deleteTags" -> {

                val tags = call.argument<List<String>>("tags") ?: arrayListOf()

                pushAgent?.tagManager?.deleteTags(TagManager.TCallBack { isSuccess, result ->

                }, *tags.toTypedArray())

                result.success(null)
            }
            //别名增加，将某一类型的别名ID绑定至某设备，老的绑定设备信息还在，别名ID和device_token是一对多的映射关系
            "addAlias" -> {

                val alias = call.argument<String>("alias")
                val type = call.argument<String>("type")

                pushAgent?.addAlias(alias, type) { isSuccess, message ->
                    try {
                        val eventResult = HashMap<String, Any>()
                        eventResult["isSuccess"] = isSuccess
                        eventResult["message"] = message
                        activity?.runOnUiThread {
                            MethodChannel(
                                flutterPluginBinding?.binaryMessenger,
                                "plugin.bughub.dev/flt_umengpush_core/UTrack.ICallBack_addAlias"
                            ).invokeMethod("callback", eventResult)
                        }
                    } catch (e: Exception) {
                    }
                }

                result.success(null)
            }
            //别名绑定，将某一类型的别名ID绑定至某设备，老的绑定设备信息被覆盖，别名ID和deviceToken是一对一的映射关系
            "setAlias" -> {

                val alias = call.argument<String>("alias")
                val type = call.argument<String>("type")

                pushAgent?.setAlias(alias, type) { isSuccess, message ->
                    try {
                        val eventResult = HashMap<String, Any>()
                        eventResult["isSuccess"] = isSuccess
                        eventResult["message"] = message
                        activity?.runOnUiThread {
                            MethodChannel(
                                flutterPluginBinding?.binaryMessenger,
                                "plugin.bughub.dev/flt_umengpush_core/UTrack.ICallBack_setAlias"
                            ).invokeMethod("callback", eventResult)
                        }
                    } catch (e: Exception) {
                        Log.i("----", e.message)
                    }
                }
                result.success(null)
            }
            //移除别名ID
            "deleteAlias" -> {

                val alias = call.argument<String>("alias")
                val type = call.argument<String>("type")

                pushAgent?.deleteAlias(alias, type) { isSuccess, message ->
                    try {
                        val eventResult = HashMap<String, Any>()
                        eventResult["isSuccess"] = isSuccess
                        eventResult["message"] = message
                        activity?.runOnUiThread {
                            MethodChannel(
                                flutterPluginBinding?.binaryMessenger,
                                "plugin.bughub.dev/flt_umengpush_core/UTrack.ICallBack_deleteAlias"
                            ).invokeMethod("callback", eventResult)
                        }
                    } catch (e: Exception) {
                        Log.i("----", e.message)
                    }
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        flutterPluginBinding = binding

        //获取消息推送代理
        pushAgent = PushAgent.getInstance(flutterPluginBinding?.applicationContext)
        Log.i("==========", "pushAgent:$pushAgent")

        pushAgent?.register(object : IUmengRegisterCallback {
            override fun onSuccess(token: String?) {
                deviceToken = token
                Log.i("==========", "deviceToken:$deviceToken")
            }

            override fun onFailure(p0: String?, p1: String?) {
                error = p0 + p1
                Log.i("==========", "error:$error")
            }

        })

        //自定义通知栏打开动作
        pushAgent?.setNotificationClickHandler { _, uMessage ->

            val eventResult = HashMap<String, Any>()
            eventResult["event"] = "notificationHandler"
            eventResult["data"] = uMessage.custom

            eventSink.success(eventResult)
        }

        val channel = MethodChannel(binding.binaryMessenger, "plugin.bughub.dev/flt_umengpush_core")
        channel.setMethodCallHandler(this)
        val eventChannel =
            EventChannel(binding.binaryMessenger, "plugin.bughub.dev/flt_umengpush_core/event")
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(p0: Any?, sink: EventChannel.EventSink?) {
                // 把eventSink存起来
                eventSink.setDelegate(sink)
            }

            override fun onCancel(p0: Any?) {
                eventSink.setDelegate(null)
            }

        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pushAgent = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onDetachedFromActivity() {

    }
}
