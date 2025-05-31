#Requires AutoHotkey v2
#include "OCR.ahk"
#include "RectangleCreator.ahk"
#include "SpeechHandler.ahk"
#include "Highlighter.ahk"
#include "OCRReaderGUI.ahk"

; Global settings
CoordMode "Mouse", "Screen"
CoordMode "ToolTip", "Screen"
DllCall("SetThreadDpiAwarenessContext", "ptr", -3)
SetCapsLockState("AlwaysOff")
CapsLock::SetCapsLockState("AlwaysOff")


class BetterTTS {
    static showOverlays := true
    static cleanTextEnabled := true
    static settingsFile := A_ScriptDir "\settings.ini"
    static box := Rectangle_creator()
    static guiLanguage := "eng"  ; Default GUI language is English
    static ocrLanguage := "en-US"  ; Default OCR language is English (Windows language code)
    static isPaused := false
    ; Translations for GUI text
    static translations := Map(
        "eng", Map(
            "capturedText", "📝 Captured Text",
            "voiceSettings", "🎙️ Voice Settings",
            "language", "🌐 Interface:",
            "ocrLanguage", "🔍 OCR:",
            "english", "🇺🇸 English",
            "arabic", "🇸🇦 Arabic",
            "ocrEnglish", "🇺🇸 English (en-US)",
            "ocrArabic", "🇸🇦 Arabic (ar-SA)",
            "voice", "🗣️ Voice:",
            "volume", "🔊 Volume:",
            "speed", "⚡ Speed:",
            "speak", "🔊 Speak",
            "pause", "⏸️ Pause",
            "resume", "⏯️ Resume",
            "stop", "⏹️ Stop",
            "ready", "✅ Ready",
            "textCaptured", "📸 Text captured",
            "captureRefreshed", "🔄 Capture refreshed",
            "highlightCleared", "🧹 Highlight cleared",
            "speaking", "🗣️ Speaking...",
            "speechPaused", "⏸️ Speech paused",
            "speechStopped", "⏹️ Speech stopped",
            "overlaysDisabled", "🚫 Overlays disabled",
            "overlaysEnabled", "✅ Overlays enabled",
            "cleanTextOn", "✨ Clean text: On",
            "cleanTextOff", "❌ Clean text: Off",
            "languageSet", "🌐 Interface language set to: ",
            "ocrLanguageSet", "🔍 OCR language set to: ",
            "volumeSet", "🔊 Volume: {1}%",
            "speedSet", "⚡ Speed: {1}",
            "textCopied", "📋 Text copied from selection",
            "noTextSelected", "⚠️ No text was selected",
            "showOverlays", "🎯 Show Overlays",
            ; Menu translations
            "fileMenu", "📁 File",
            "settingsMenu", "⚙️ Settings",
            "helpMenu", "❓ Help",
            "voiceSearch", "🔍 Voice Search",
            "searchForVoices", "🔍 Search for voices:",
            "voiceColumn", "Voice",
            "select", "✅ Select",
            "cancel", "❌ Cancel",
            "saveText", "💾 Save Text",
            "loadText", "📂 Load Text",
            "exit", "🚪 Exit",
            "alwaysOnTop", "📌 Always on Top",
            "cleanText", "✨ Clean Text",
            "hotkeys", "⌨️ Hotkeys",
            "about", "ℹ️ About",
            "textSaved", "✅ Text saved successfully",
            "textLoaded", "✅ Text loaded successfully",
            "alwaysOnTopOn", "📌 Always on top: On",
            "alwaysOnTopOff", "❌ Always on top: Off",
            "saveFileDialog", "💾 Save Captured Text",
            "loadFileDialog", "📂 Load Text File",
            "textFiles", "📄 Text Files (*.txt)",
            "errorSaving", "❌ Error saving file: ",
            "errorLoading", "❌ Error loading file: ",
            "error", "⚠️ Error",
            "hotkeyTitle", "⌨️ Available Hotkeys",
            "hotkeyDesc", "⌨️ Keyboard Shortcuts",
            "captureDesc", "📸 Capture new text",
            "refreshDesc", "🔄 Refresh captured text",
            "copyDesc", "📋 Copy selected text",
            "clearDesc", "🧹 Clear highlight",
            "speakDesc", "🔊 Start speaking",
            "pauseDesc", "⏯️ Pause/Resume speech",
            "stopDesc", "⏹️ Stop speaking",
            "topDesc", "📌 Toggle always on top",
            "overlayDesc", "🎯 Toggle overlays",
            "volumeUpDesc", "🔊 Increase volume",
            "volumeDownDesc", "🔈 Decrease volume",
            "speedUpDesc", "⚡ Increase speed",
            "speedDownDesc", "🐌 Decrease speed",
            "aboutTitle", "ℹ️ About Better TTS",
            "aboutText", "✨ Better TTS`nVersion v0.2`n`nCreated with AutoHotkey v2",
            "hotkeyColumn", "⌨️ Hotkey",
            "descriptionColumn", "📝 Description",
            "ok", "✅ OK",
            "pitch", "🎵 Pitch:",
            "pitchSet", "🎵 Pitch: {1}",
            "resetDefaults", "🔄 Reset to Defaults",
            "settingsReset", "✨ Settings reset to defaults",
            "languagePackInfo", "🔍 Language Pack Requirements",
            "languagePackInfoTitle", "Arabic OCR Requirements",
            "languagePackInfoText", "For Arabic OCR to work properly, you need to install the Arabic language pack and OCR features on your Windows system.`n`n"
                . "1. Go to Windows Settings > Time & Language > Language & region`n"
                . "2. Click 'Add a language' and select Arabic`n"
                . "3. During installation, make sure to select the OCR feature`n`n"
                . "If you're an advanced user, you can also install it using PowerShell:`n"
                . "Add-WindowsCapability -Online -Name 'Language.OCR~~~ar-SA~0.0.1.0'"
        ),
        "ara", Map(
            "capturedText", "📝 النص الملتقط",
            "voiceSettings", "🎙️ إعدادات الصوت",
            "language", "🌐 الواجهة:",
            "ocrLanguage", "🔍 النصوص:",
            "english", "🇺🇸 الإنجليزية",
            "arabic", "🇸🇦 العربية",
            "ocrEnglish", "🇺🇸 الإنجليزية (en-US)",
            "ocrArabic", "🇸🇦 العربية (ar-SA)",
            "voice", "🗣️ الصوت:",
            "volume", "🔊 مستوى الصوت:",
            "speed", "⚡ السرعة:",
            "speak", "🔊 تحدث",
            "pause", "⏸️ إيقاف مؤقت",
            "resume", "⏯️ استئناف",
            "stop", "⏹️ توقف",
            "ready", "✅ جاهز",
            "textCaptured", "📸 تم التقاط النص",
            "captureRefreshed", "🔄 تم تحديث النص",
            "highlightCleared", "🧹 تم مسح التحديد",
            "speaking", "🗣️ جاري التحدث...",
            "speechPaused", "⏸️ تم إيقاف التحدث مؤقتاً",
            "speechStopped", "⏹️ تم إيقاف التحدث",
            "overlaysDisabled", "🚫 تم تعطيل التراكبات",
            "overlaysEnabled", "✅ تم تمكين التراكبات",
            "cleanTextOn", "✨ تنظيف النص: مفعل",
            "cleanTextOff", "❌ تنظيف النص: معطل",
            "languageSet", "🌐 تم تعيين لغة الواجهة إلى: ",
            "ocrLanguageSet", "🔍 تم تعيين لغة التعرف على النصوص إلى: ",
            "volumeSet", "🔊 مستوى الصوت: {1}%",
            "speedSet", "⚡ السرعة: {1}",
            "textCopied", "📋 تم نسخ النص من التحديد",
            "noTextSelected", "⚠️ لم يتم تحديد نص",
            "showOverlays", "🎯 إظهار التراكبات",
            ; Menu translations
            "fileMenu", "📁 ملف",
            "settingsMenu", "⚙️ إعدادات",
            "helpMenu", "❓ مساعدة",
            "voiceSearch", "🔍 البحث عن الأصوات",
            "searchForVoices", "🔍 البحث عن الأصوات:",
            "voiceColumn", "الصوت",
            "select", "✅ اختيار",
            "cancel", "❌ إلغاء",
            "saveText", "💾 حفظ النص",
            "loadText", "📂 تحميل النص",
            "exit", "🚪 خروج",
            "alwaysOnTop", "📌 دائماً في المقدمة",
            "cleanText", "✨ تنظيف النص",
            "hotkeys", "⌨️ اختصارات",
            "about", "ℹ️ حول",
            "textSaved", "✅ تم حفظ النص بنجاح",
            "textLoaded", "✅ تم تحميل النص بنجاح",
            "alwaysOnTopOn", "📌 دائماً في المقدمة: مفعل",
            "alwaysOnTopOff", "❌ دائماً في المقدمة: معطل",
            "saveFileDialog", "💾 حفظ النص الملتقط",
            "loadFileDialog", "📂 تحميل ملف نصي",
            "textFiles", "📄 ملفات نصية (*.txt)",
            "errorSaving", "❌ خطأ في حفظ الملف: ",
            "errorLoading", "❌ خطأ في تحميل الملف: ",
            "error", "⚠️ خطأ",
            "hotkeyTitle", "⌨️ اختصارات لوحة المفاتيح المتاحة",
            "hotkeyDesc", "⌨️ اختصارات لوحة المفاتيح",
            "captureDesc", "📸 التقاط نص جديد",
            "refreshDesc", "🔄 تحديث النص الملتقط",
            "copyDesc", "📋 نسخ النص المحدد",
            "clearDesc", "🧹 مسح التحديد",
            "speakDesc", "🔊 بدء القراءة",
            "pauseDesc", "⏯️ إيقاف مؤقت/استئناف",
            "stopDesc", "⏹️ إيقاف القراءة",
            "topDesc", "📌 تثبيت النافذة في المقدمة",
            "overlayDesc", "🎯 تفعيل/تعطيل التراكبات",
            "volumeUpDesc", "🔊 رفع مستوى الصوت",
            "volumeDownDesc", "🔈 خفض مستوى الصوت",
            "speedUpDesc", "⚡ زيادة سرعة القراءة",
            "speedDownDesc", "🐌 تقليل سرعة القراءة",
            "aboutTitle", "ℹ️ حول قارئ النصوص",
            "aboutText", "✨ قارئ النصوص`nالإصدار v0.2`n`nتم إنشاؤه باستخدام AutoHotkey v2",
            "hotkeyColumn", "⌨️ مفتاح الاختصار",
            "descriptionColumn", "📝 الوصف",
            "ok", "✅ موافق",
            "pitch", "🎵 درجة الصوت:",
            "pitchSet", "🎵 درجة الصوت: {1}",
            "resetDefaults", "🔄 إعادة الضبط للإعدادات الافتراضية",
            "settingsReset", "✨ تم إعادة ضبط الإعدادات للوضع الافتراضي",
            "languagePackInfo", "🔍 متطلبات حزمة اللغة",
            "languagePackInfoTitle", "متطلبات التعرف على النصوص العربية",
            "languagePackInfoText", "لكي يعمل التعرف على النصوص العربية بشكل صحيح، تحتاج إلى تثبيت حزمة اللغة العربية وميزات التعرف على النصوص في نظام Windows الخاص بك.`n`n"
                . "1. انتقل إلى إعدادات Windows > الوقت واللغة > اللغة والمنطقة`n"
                . "2. انقر على 'إضافة لغة' واختر العربية`n"
                . "3. أثناء التثبيت، تأكد من تحديد ميزة التعرف على النصوص`n`n"
                . "إذا كنت مستخدماً متقدماً، يمكنك أيضاً تثبيتها باستخدام PowerShell:`n"
                . "Add-WindowsCapability -Online -Name 'Language.OCR~~~ar-SA~0.0.1.0'"
        )
    )
    
    static GetTranslation(key) {
        return this.translations[this.guiLanguage][key]
    }
    
    static ReverseArabicWords(text) {
        if (this.ocrLanguage != "ar-SA")
            return text
        
        ; Split text into words and reverse their order
        words := StrSplit(text, " ")
        reversed := ""
        Loop words.Length {
            reversed .= words[words.Length - A_Index + 1] . (A_Index < words.Length ? " " : "")
        }
        return reversed
    }
    
    static CaptureText(gui) {
        this.box.set_first_coord()
        while (GetKeyState("x", "P")) {
            this.box.set_second_coord()
            this.box.set_rectangle()
            this.HighlightArea("Red")
            capturedText := OCR.FromRect(this.box.rectangle[1], this.box.rectangle[2],
                                      this.box.rectangle[3], this.box.rectangle[4], this.ocrLanguage, 2).Text
            gui.textEdit.Value := this.ReverseArabicWords(capturedText)
            Sleep(50)
        }
        gui.DisplayText(this.GetTranslation("textCaptured"))
        SetTimer(() => this.SpeakText(gui), -1)
    }
    
    static RefreshCapture(gui) {
        gui.textEdit.Value := OCR.FromRect(this.box.rectangle[1], this.box.rectangle[2],
                                      this.box.rectangle[3], this.box.rectangle[4], this.ocrLanguage, 2).Text
        this.HighlightArea("Blue")
        Sleep(100)
        this.HighlightArea("Red")
        gui.DisplayText(this.GetTranslation("captureRefreshed"))
        SetTimer(() => this.SpeakText(gui), -1)
    }
    
    static ClearHighlight(gui) {
        Highlighter.Highlight()
        ToolTip()
        this.box.isFirstCoord := true
        this.box.isBoxActive := false
        gui.DisplayText(this.GetTranslation("highlightCleared"))
    }
    
    static SpeakText(gui) {
        if (this.isPaused) {
            SpeechHandler.PauseSpeech()
            this.isPaused := false
            gui.pauseButton.Text := this.GetTranslation("pause")
        }
        SpeechHandler.StopSpeaking()
        gui.playButton.Enabled := false
        gui.DisplayText(this.GetTranslation("speaking"))
        
        ; Get text to speak
        textToSpeak := this.cleanTextEnabled ? this.CleanText(gui.textEdit.Value) : gui.textEdit.Value
        
        SpeechHandler.SpeakText(textToSpeak, gui.voiceDropDown.Value - 1,
                           gui.volumeSlider.Value, gui.speedSlider.Value,
                           gui.pitchSlider.Value)
        gui.playButton.Enabled := true
        Highlighter.Highlight()
    }
    
    static PauseSpeech(gui) {
        SpeechHandler.PauseSpeech()
        this.isPaused := !this.isPaused
        gui.pauseButton.Text := this.GetTranslation(this.isPaused ? "resume" : "pause")
        gui.DisplayText(this.GetTranslation(this.isPaused ? "resume" : "pause"))
    }
    
    static StopSpeaking(gui) {
        if (this.isPaused) {
            SpeechHandler.PauseSpeech()
            this.isPaused := false
            gui.pauseButton.Text := this.GetTranslation("pause")
        }
        SpeechHandler.StopSpeaking()
        gui.DisplayText(this.GetTranslation("speechStopped"))
    }
    
    static SaveSettings(gui) {
        try {
            IniWrite(gui.voiceDropDown.Value, this.settingsFile, "Settings", "VoiceIndex")
            IniWrite(gui.volumeSlider.Value, this.settingsFile, "Settings", "Volume")
            IniWrite(gui.speedSlider.Value, this.settingsFile, "Settings", "Speed")
            IniWrite(gui.pitchSlider.Value, this.settingsFile, "Settings", "Pitch")
            IniWrite(this.cleanTextEnabled, this.settingsFile, "Settings", "CleanText")
            IniWrite(this.guiLanguage, this.settingsFile, "Settings", "GUILanguage")
            IniWrite(this.ocrLanguage, this.settingsFile, "Settings", "OCRLanguage")
            IniWrite(this.showOverlays, this.settingsFile, "Settings", "ShowOverlays")
        } catch as err {
            MsgBox("Error saving settings: " err.Message, "Error", "0x10")
        }
    }
    
    static LoadSettings(gui) {
        try {
            gui.voiceDropDown.Value := IniRead(this.settingsFile, "Settings", "VoiceIndex", "1")
            gui.volumeSlider.Value := IniRead(this.settingsFile, "Settings", "Volume", "100")
            gui.speedSlider.Value := IniRead(this.settingsFile, "Settings", "Speed", "5")
            gui.pitchSlider.Value := IniRead(this.settingsFile, "Settings", "Pitch", "5")
            this.cleanTextEnabled := IniRead(this.settingsFile, "Settings", "CleanText", "0")
            this.guiLanguage := IniRead(this.settingsFile, "Settings", "GUILanguage", "eng")
            this.ocrLanguage := IniRead(this.settingsFile, "Settings", "OCRLanguage", "en-US")
            this.showOverlays := IniRead(this.settingsFile, "Settings", "ShowOverlays", "0")
            gui.guiLanguageDropDown.Value := (this.guiLanguage = "eng") ? 1 : 2
            gui.ocrLanguageDropDown.Value := (this.ocrLanguage = "en-US") ? 1 : 2
            gui.overlayCheckbox.Value := this.showOverlays
        } catch as err {
            MsgBox("Error loading settings: " err.Message "`nDefault settings will be used.",
                   "Warning", "0x30")
            gui.voiceDropDown.Value := 1
            gui.volumeSlider.Value := 100
            gui.speedSlider.Value := 5
            gui.pitchSlider.Value := 5
            this.cleanTextEnabled := false
            this.guiLanguage := "eng"
            this.ocrLanguage := "en-US"
            this.showOverlays := false
            gui.guiLanguageDropDown.Value := 1
            gui.ocrLanguageDropDown.Value := 1
            gui.overlayCheckbox.Value := 0
        }
    }
    
    static HighlightArea(color) {
        if (this.showOverlays) {
            Highlighter.Highlight(this.box.rectangle[1], this.box.rectangle[2], 
                            this.box.rectangle[3], this.box.rectangle[4], 0, color, 1)
        }
    }
    
    static CleanText(text) {
        ; Replace all non-alphanumeric characters (except spaces) with spaces
        ; Include both English (a-zA-Z0-9) and Arabic characters (ء-ي)
        cleaned := RegExReplace(text, "[^a-zA-Z0-9ء-ي\s]", " ")
        ; Replace multiple spaces with a single space and trim
        return Trim(RegExReplace(cleaned, "\s+", " "))
    }
    
    static ToggleOverlays(gui) {
        this.showOverlays := !this.showOverlays
        gui.overlayCheckbox.Value := this.showOverlays ? 1 : 0
        if (!this.showOverlays) {
            Highlighter.Highlight()
            ToolTip()
            gui.DisplayText(this.GetTranslation("overlaysDisabled"))
        } else {
            gui.DisplayText(this.GetTranslation("overlaysEnabled"))
        }
    }
    
    static ToggleCleanText(gui) {
        this.cleanTextEnabled := !this.cleanTextEnabled
        gui.DisplayText(this.GetTranslation(this.cleanTextEnabled ? "cleanTextOn" : "cleanTextOff"))
    }
    
    static SetGUILanguage(gui) {
        this.guiLanguage := gui.guiLanguageDropDown.Value = 1 ? "eng" : "ara"
        gui.UpdateTranslations()
        gui.DisplayText(this.GetTranslation("languageSet") . (this.guiLanguage = "eng" ? this.GetTranslation("english") : this.GetTranslation("arabic")))
    }
    
    static SetOCRLanguage(gui) {
        this.ocrLanguage := gui.ocrLanguageDropDown.Value = 1 ? "en-US" : "ar-SA"
        gui.DisplayText(this.GetTranslation("ocrLanguageSet") . (this.ocrLanguage = "en-US" ? this.GetTranslation("ocrEnglish") : this.GetTranslation("ocrArabic")))
    }
    
    static OCRFromClipboard() {
        try {
            ; Get clipboard bitmap handle
            if DllCall("IsClipboardFormatAvailable", "uint", 2) { ; CF_BITMAP = 2
                if DllCall("OpenClipboard", "ptr", A_ScriptHwnd) {
                    if (hBitmap := DllCall("GetClipboardData", "uint", 2, "ptr")) {
                        ; Perform OCR on the bitmap with the selected language
                        result := OCR.FromBitmap(hBitmap, this.ocrLanguage)
                        if result && result.Text {
                            ; Update the GUI text
                            return result.Text
                        }
                        else {
                            return ""
                        }
                    }
                }
            }
        } catch Error as e {
            return ""
        }
        DllCall("CloseClipboard")
    }
    
    static ShowLanguagePackInfo() {
        MsgBox(this.GetTranslation("languagePackInfoText"),
               this.GetTranslation("languagePackInfoTitle"),
               "64")
    }
    
    static ResetToDefaults(gui) {
        gui.voiceDropDown.Value := 1
        gui.volumeSlider.Value := 100
        gui.speedSlider.Value := 50
        gui.pitchSlider.Value := 5
        gui.overlayCheckbox.Value := 1
        gui.guiLanguageDropDown.Value := 1
        gui.ocrLanguageDropDown.Value := 1
        
        this.cleanTextEnabled := true
        this.showOverlays := true
        this.guiLanguage := "eng"
        this.ocrLanguage := "en-US"
        
        gui.UpdateTranslations()
        gui.DisplayText(this.GetTranslation("settingsReset"))
    }
}

; Create and initialize the application
app := OCRReaderGUI(BetterTTS)