package com.example.flutter_file_picker.dataModel

import android.app.Activity
import android.content.Intent
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import com.example.flutter_file_picker.FilePickerActivity
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class FilePickerMethodChannelHandler(val activity: Activity) : MethodChannel.MethodCallHandler {

    companion object {
        val TAG = "FilePickerHandler"
    }
    init {
        Log.d(TAG, "init")
    }

    private var handlerResult: MethodChannel.Result? = null

    private var startActivityResultLauncher: ActivityResultLauncher<Intent> =
        (activity as ComponentActivity).registerForActivityResult(
            ActivityResultContracts.StartActivityForResult()) { result: ActivityResult ->
            if (result.resultCode == Activity.RESULT_OK) {
                val intent = result.data
                // Handle the Intent
                if (intent?.extras?.getSerializable("uriList") != null) {
                    val uriList = intent.extras?.getSerializable("uriList");
                    handlerResult?.success(uriList)
                    handlerResult = null
                } else {
                    val map = mutableMapOf<String, String>()
                    map["uri"] = intent?.extras?.getString("uri") ?: ""
                    map["fileName"] = intent?.extras?.getString("fileName") ?: ""
                    handlerResult?.success(map)
                    handlerResult = null
                }
            } else {
                 // handle activity - user not select any files / photos
                 handlerResult?.success(null)
                 handlerResult = null
            }
        }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        if (handlerResult != null) {
            handlerResult?.error(
                "already_running",
                "Cannot launch another File Picker at the same time",
                null
            )
            return
        }
        this.handlerResult = result

        Log.d(TAG, call.arguments.toString())

        when (call.method) {
            "pickPhoto" -> {
                val mimeType = call.argument<String>("mimeType")
                startActivityResultLauncher.launch(Intent(activity, FilePickerActivity::class.java).apply {
                    putExtra("mimeType", mimeType)
                })
            }
            "pickPhotos" -> {
                val mimeType = call.argument<String>("mimeType")
                startActivityResultLauncher.launch(Intent(activity, FilePickerActivity::class.java).apply {
                    putExtra("mimeType", mimeType)
                    putExtra("allowMultiple", true)
                })
            }
            else -> {
                handlerResult?.notImplemented()
                handlerResult = null
            }
        }

    }
}