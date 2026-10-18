package app.myworldplus.myworld_plus

import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity

// FlutterFragmentActivity is required by local_auth (biometric prompt).
class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Hide app content in the Recents switcher so private documents are not
        // exposed in system previews (screenshots inside the app still work).
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            setRecentsScreenshotEnabled(false)
        }
    }
}
