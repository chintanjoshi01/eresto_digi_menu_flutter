package `in`.eresto.digimenu

import android.content.ClipData
import android.content.ComponentName
import android.content.Intent
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val channelName = "in.eresto.digimenu/social_share"
    private val instagramPackage = "com.instagram.android"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result ->
                if (call.method == "shareToInstagram") {
                    val filePath = call.argument<String>("filePath")
                    val target = call.argument<String>("target") ?: "story"
                    val caption = call.argument<String>("caption") ?: ""
                    val contentUrl = call.argument<String>("url") ?: ""

                    if (filePath.isNullOrBlank()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }

                    val shared = shareImageToInstagram(
                        filePath = filePath,
                        target = target,
                        caption = caption,
                        contentUrl = contentUrl
                    )
                    result.success(shared)
                } else {
                    result.notImplemented()
                }
            }
    }

    private fun shareImageToInstagram(
        filePath: String,
        target: String,
        caption: String,
        contentUrl: String
    ): Boolean {
        return try {
            val sourceFile = File(filePath)
            if (!sourceFile.exists()) return false

            // Copy to cacheDir/share_plus so ShareFileProvider always serves it cleanly
            val shareDir = File(cacheDir, "share_plus")
            if (!shareDir.exists()) {
                shareDir.mkdirs()
            }
            val sharedFile = File(shareDir, "eresto_menu_qr.png")
            sourceFile.copyTo(sharedFile, overwrite = true)

            val authority = "$packageName.flutter.share_provider"
            val contentUri = FileProvider.getUriForFile(this, authority, sharedFile)

            grantUriPermission(
                instagramPackage,
                contentUri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION
            )

            val baseSendIntent = Intent(Intent.ACTION_SEND).apply {
                type = "image/png"
                putExtra(Intent.EXTRA_STREAM, contentUri)
                if (caption.isNotEmpty()) {
                    putExtra(Intent.EXTRA_TEXT, caption)
                }
                setPackage(instagramPackage)
                clipData = ClipData.newRawUri("", contentUri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }

            if (target.equals("story", ignoreCase = true)) {
                // 1. Direct launch of Instagram's StoryShareHandlerActivity via ACTION_SEND
                try {
                    val directStoryIntent = Intent(baseSendIntent).apply {
                        component = ComponentName(
                            instagramPackage,
                            "com.instagram.share.handleractivity.StoryShareHandlerActivity"
                        )
                    }
                    startActivity(directStoryIntent)
                    return true
                } catch (_: Exception) {
                    // Fallback to dynamic lookup below
                }

                // 2. Dynamic lookup of any Story share handler in com.instagram.android
                val matchingActivities = packageManager.queryIntentActivities(baseSendIntent, 0)
                val storyActivity = matchingActivities.firstOrNull { info ->
                    info.activityInfo.name.contains("StoryShareHandlerActivity", ignoreCase = true) ||
                        info.activityInfo.name.contains("Story", ignoreCase = true)
                }
                if (storyActivity != null) {
                    val resolvedStoryIntent = Intent(baseSendIntent).apply {
                        setClassName(instagramPackage, storyActivity.activityInfo.name)
                    }
                    startActivity(resolvedStoryIntent)
                    return true
                }

                // 3. Fallback to ADD_TO_STORY intent
                try {
                    val addToStoryIntent = Intent("com.instagram.share.ADD_TO_STORY").apply {
                        setDataAndType(contentUri, "image/png")
                        putExtra("interactive_asset_uri", contentUri)
                        putExtra("source_application", packageName)
                        if (contentUrl.isNotEmpty()) {
                            putExtra("content_url", contentUrl)
                        }
                        putExtra("top_background_color", "#FFFFFF")
                        putExtra("bottom_background_color", "#F3F4F6")
                        setPackage(instagramPackage)
                        clipData = ClipData.newRawUri("", contentUri)
                        addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                    }
                    startActivity(addToStoryIntent)
                    return true
                } catch (_: Exception) {
                    // Fallback below
                }
            } else if (target.equals("post", ignoreCase = true)) {
                // 1. Direct launch of Instagram's Feed/Post ShareHandlerActivity via ACTION_SEND
                try {
                    val directFeedIntent = Intent(baseSendIntent).apply {
                        component = ComponentName(
                            instagramPackage,
                            "com.instagram.share.handleractivity.ShareHandlerActivity"
                        )
                    }
                    startActivity(directFeedIntent)
                    return true
                } catch (_: Exception) {
                    // Fallback to dynamic lookup below
                }

                // 2. Dynamic lookup of Feed ShareHandlerActivity in com.instagram.android
                val matchingActivities = packageManager.queryIntentActivities(baseSendIntent, 0)
                val feedActivity = matchingActivities.firstOrNull { info ->
                    val name = info.activityInfo.name
                    name.contains("ShareHandlerActivity", ignoreCase = true) &&
                        !name.contains("Story", ignoreCase = true) &&
                        !name.contains("Clips", ignoreCase = true) &&
                        !name.contains("Reel", ignoreCase = true)
                }
                if (feedActivity != null) {
                    val resolvedFeedIntent = Intent(baseSendIntent).apply {
                        setClassName(instagramPackage, feedActivity.activityInfo.name)
                    }
                    startActivity(resolvedFeedIntent)
                    return true
                }
            }

            // General Instagram package share fallback
            startActivity(baseSendIntent)
            true
        } catch (e: Exception) {
            false
        }
    }
}
