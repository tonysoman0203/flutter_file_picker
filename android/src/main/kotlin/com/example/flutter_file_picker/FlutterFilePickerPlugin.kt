package com.example.flutter_file_picker

import android.app.Activity
import androidx.annotation.NonNull
import com.example.flutter_file_picker.dataModel.FilePickerMethodChannelHandler
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel

/** PriceFilePickerPlugin */
class FlutterFilePickerPlugin: FlutterPlugin, ActivityAware {
  private var channel: MethodChannel? = null
  private var activity: Activity? = null
  private var pluginBinding: FlutterPluginBinding? = null
  private var activityBinding: ActivityPluginBinding? = null
  private val TAG = "FilePicker"
  private val CHANNEL = "flutter_file_picker"

  private var filePickerMethodChannelHandler: FilePickerMethodChannelHandler? = null

  companion object {
    const val GET_CONTENT_REQUEST_CODE = 0x100001
    const val GET_CONTENTS_REQUEST_CODE = 0x100002
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = flutterPluginBinding
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    tearUp(binding)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    tearDown()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.onAttachedToActivity(binding);
  }

  override fun onDetachedFromActivity() {
    tearDown()
  }

  private fun tearUp(binding: ActivityPluginBinding) {
    activityBinding = binding
    activity = binding.activity
    if (filePickerMethodChannelHandler == null) {
      channel = pluginBinding?.binaryMessenger?.let { MethodChannel(it, CHANNEL) }
      filePickerMethodChannelHandler = FilePickerMethodChannelHandler(activity = activity!!)
      channel?.setMethodCallHandler(filePickerMethodChannelHandler)
    }
  }

  private fun tearDown() {
    channel?.setMethodCallHandler(null)
    channel = null
    pluginBinding = null
    activityBinding = null
    activity = null
  }
}
