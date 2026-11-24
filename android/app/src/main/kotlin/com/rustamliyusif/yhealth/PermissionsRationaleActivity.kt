package com.rustamliyusif.yhealth

import android.app.Activity
import android.graphics.Color
import android.os.Bundle
import android.widget.ScrollView
import android.widget.TextView

class PermissionsRationaleActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val az = FlutterPrefs.isAzerbaijani(this)
        val text = if (az) {
            "YHealth və Health Connect\n\n" +
                "• Yuxu: Health Connect-dəki yuxu qeydləri YHealth-in Yuxu bölməsinə əlavə olunur.\n" +
                "• Çəki: çəki ölçmələri Coach Leo-nun çəki tarixçəsinə əlavə olunur.\n" +
                "• Addımlar: YHealth-in saydığı gündəlik addımlar Health Connect-ə yazılır.\n" +
                "• Su: YHealth-də qeyd etdiyin su Health Connect-ə yazılır.\n\n" +
                "Bu məlumatlar yalnız telefonunda saxlanılır, heç bir serverə göndərilmir və reklam üçün istifadə olunmur. " +
                "İcazələri istənilən vaxt Health Connect ayarlarından ləğv edə bilərsən."
        } else {
            "YHealth and Health Connect\n\n" +
                "• Sleep: sleep sessions from Health Connect are added to YHealth's Sleep section.\n" +
                "• Weight: weight measurements are added to Coach Leo's weight history.\n" +
                "• Steps: daily steps counted by YHealth are written to Health Connect.\n" +
                "• Water: water you log in YHealth is written to Health Connect.\n\n" +
                "This data stays on your phone. It is never sent to a server or used for ads. " +
                "You can revoke access at any time in Health Connect settings."
        }
        val view = TextView(this).apply {
            this.text = text
            textSize = 16f
            setTextColor(Color.WHITE)
            setPadding(56, 96, 56, 56)
            setLineSpacing(0f, 1.25f)
        }
        setContentView(ScrollView(this).apply {
            setBackgroundColor(Color.parseColor("#04100B"))
            addView(view)
        })
    }
}
