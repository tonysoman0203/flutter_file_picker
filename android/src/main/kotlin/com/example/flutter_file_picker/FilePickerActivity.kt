package com.example.flutter_file_picker

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.os.Bundle
import android.util.Log
import android.webkit.MimeTypeMap
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import java.util.*
import kotlin.collections.ArrayList

class FilePickerActivity : ComponentActivity() {

    companion object {
        val TAG = "FilePickerActivity"
    }

    private var getContent: ActivityResultLauncher<String> =
        registerForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
            uri?.let { uriString ->
                Log.d(TAG, "uriString = $uriString")
                getMimeType(this, uriString)?.let {
                    setResult(RESULT_OK, intent.apply {
                        putExtra("uri", uriString.toString())
                        putExtra("fileName", uri.pathSegments.toString())
                    })
                    finish()
                }

            } ?: run {
                setResult(RESULT_CANCELED, intent)
                finish()
            }
        }

    private var getMultipleContents: ActivityResultLauncher<String> =
        registerForActivityResult(ActivityResultContracts.GetMultipleContents()) { lists: List<Uri>? ->
            lists?.let {
                val arrayList = lists.let { it -> ArrayList(it.map { it.toString() }) }
                setResult(RESULT_OK, intent.apply {
                    putExtra("uriList", arrayList)
                })
                finish()
            } ?: kotlin.run {
                setResult(RESULT_CANCELED, intent)
                finish()
            }
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_file_picker)
        val allowMultiple = intent.extras?.getBoolean("allowMultiple") ?: false
        val mimeType = intent.extras?.getString("mimeType") ?: throw Exception("MimeType is missing!")
        if (!allowMultiple) {
            getContent.launch(mimeType)
        } else {
            getMultipleContents.launch((mimeType))
        }
    }

    private fun getMimeType(context: Context, uri: Uri): String? {
        val mimeType: String? = if (ContentResolver.SCHEME_CONTENT.equals(uri.scheme)) {
            val cr: ContentResolver = context.getContentResolver()
            cr.getType(uri)
        } else {
            val fileExtension: String = MimeTypeMap.getFileExtensionFromUrl(uri.toString())
            MimeTypeMap.getSingleton().getMimeTypeFromExtension(
                fileExtension.lowercase(Locale.getDefault())
            )
        }
        return mimeType
    }
}