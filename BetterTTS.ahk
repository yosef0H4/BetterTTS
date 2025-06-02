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
    static installedOCRLanguages := Map()  ; Store dynamically loaded OCR languages
    static ocrLanguageNames := Map()  ; Store friendly names for OCR languages
    
    ; Translations for GUI text
    static translations := Map(
        "eng", Map(
            "capturedText", "📝 Captured Text",
            "voiceSettings", "🎙️ Voice Settings",
            "language", "🌐 Interface:",
            "ocrLanguage", "🔍 OCR:",
            "english", "🇺🇸 English",
            "arabic", "🇸🇦 Arabic",
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
            "refreshOCRLanguages", "🔄 Refresh OCR Languages",
            "ocrLanguagesRefreshed", "✅ OCR languages refreshed",
            "refreshingOCRLanguages", "🔄 Refreshing OCR languages...",
            "noOCRLanguagesFound", "⚠️ No OCR languages found",
            "adminRequired", "⚠️ Administrator privileges required",
            "adminRequiredText", "Refreshing OCR languages requires administrator privileges.`n`nPlease run as administrator to use this feature.",
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
            "aboutText", "✨ Better TTS`nVersion v0.3`n`nCreated with AutoHotkey v2",
            "hotkeyColumn", "⌨️ Hotkey",
            "descriptionColumn", "📝 Description",
            "ok", "✅ OK",
            "pitch", "🎵 Pitch:",
            "pitchSet", "🎵 Pitch: {1}",
            "resetDefaults", "🔄 Reset to Defaults",
            "settingsReset", "✨ Settings reset to defaults",
            "languagePackInfo", "🔍 Language Pack Requirements",
            "languagePackInfoTitle", "OCR Language Pack Requirements",
            "languagePackInfoText", "To use OCR with different languages, you need to install the appropriate language packs on your Windows system.`n`n"
                . "1. Go to Windows Settings > Time & Language > Language & region`n"
                . "2. Click 'Add a language' and select your desired language`n"
                . "3. During installation, make sure to select the OCR feature`n`n"
                . "After installation, click the 'Refresh OCR Languages' button to update the list.",
            "installOCRLanguages", "📦 Install OCR Languages",
            "removeOCRLanguages", "🗑️ Remove OCR Languages",
            "close", "❌ Close",
            "availableOCRLanguagePacks", "Available OCR Language Packs (double-click to install):",
            "languageCode", "Language Code",
            "status", "Status",
            "refreshList", "🔄 Refresh List",
            "install", "📦 Install",
            "remove", "🗑️ Remove",
            "loadingLanguages", "Loading languages... Please wait...",
            "installed", "Installed",
            "notInstalled", "Not Installed",
            "foundOCRLanguagePacks", "Found {1} OCR language packs. Double-click or select and click Install.",
            "errorRetrievingLanguageList", "Error: Could not retrieve language list.",
            "errorLoadingLanguages", "Error: Failed to load languages. ",
            "pleaseSelectLanguageToInstall", "Please select a language to install.",
            "alreadyInstalled", " is already installed.",
            "installing", "Installing ",
            "installationCompleted", "Installation completed for {1}! Click Refresh to update list.",
            "errorInstalling", "Error: Failed to install ",
            "pleaseSelectLanguageToRemove", "Please select a language to remove.",
            "notInstalledOrCannotBeRemoved", " is not installed or cannot be removed.",
            "removing", "Removing ",
            "removalCompleted", "Removal completed for {1}! Click Refresh to update list.",
            "errorRemoving", "Error: Failed to remove "
        ),
        "ara", Map(
            "capturedText", "📝 النص الملتقط",
            "voiceSettings", "🎙️ إعدادات الصوت",
            "language", "🌐 الواجهة:",
            "ocrLanguage", "🔍 النصوص:",
            "english", "🇺🇸 الإنجليزية",
            "arabic", "🇸🇦 العربية",
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
            "refreshOCRLanguages", "🔄 تحديث لغات التعرف على النصوص",
            "ocrLanguagesRefreshed", "✅ تم تحديث لغات التعرف على النصوص",
            "refreshingOCRLanguages", "🔄 جاري تحديث لغات التعرف على النصوص...",
            "noOCRLanguagesFound", "⚠️ لم يتم العثور على لغات للتعرف على النصوص",
            "adminRequired", "⚠️ مطلوب صلاحيات المدير",
            "adminRequiredText", "تحديث لغات التعرف على النصوص يتطلب صلاحيات المدير.`n`nالرجاء تشغيل البرنامج كمدير لاستخدام هذه الميزة.",
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
            "aboutText", "✨ قارئ النصوص`nالإصدار v0.3`n`nتم إنشاؤه باستخدام AutoHotkey v2",
            "hotkeyColumn", "⌨️ مفتاح الاختصار",
            "descriptionColumn", "📝 الوصف",
            "ok", "✅ موافق",
            "pitch", "🎵 درجة الصوت:",
            "pitchSet", "🎵 درجة الصوت: {1}",
            "resetDefaults", "🔄 إعادة الضبط للإعدادات الافتراضية",
            "settingsReset", "✨ تم إعادة ضبط الإعدادات للوضع الافتراضي",
            "languagePackInfo", "🔍 متطلبات حزمة اللغة",
            "languagePackInfoTitle", "متطلبات حزم لغات التعرف على النصوص",
            "languagePackInfoText", "لاستخدام التعرف على النصوص بلغات مختلفة، تحتاج إلى تثبيت حزم اللغة المناسبة في نظام Windows الخاص بك.`n`n"
                . "1. انتقل إلى إعدادات Windows > الوقت واللغة > اللغة والمنطقة`n"
                . "2. انقر على 'إضافة لغة' واختر اللغة المطلوبة`n"
                . "3. أثناء التثبيت، تأكد من تحديد ميزة التعرف على النصوص`n`n"
                . "بعد التثبيت، انقر على زر 'تحديث لغات التعرف على النصوص' لتحديث القائمة.",
            "installOCRLanguages", "📦 تثبيت لغات التعرف على النصوص",
            "removeOCRLanguages", "🗑️ إزالة لغات التعرف على النصوص",
            "close", "❌ إغلاق",
            "availableOCRLanguagePacks", "حزم لغات التعرف الضوئي (OCR) المتوفرة (انقر نقرًا مزدوجًا للتثبيت):",
            "languageCode", "رمز اللغة",
            "status", "الحالة",
            "refreshList", "🔄 القائمة",
            "install", "📦 تثبيت",
            "remove", "🗑️ إزالة",
            "loadingLanguages", "جاري تحميل اللغات... الرجاء الانتظار...",
            "installed", "مثبت",
            "notInstalled", "غير مثبت",
            "foundOCRLanguagePacks", "تم العثور على {1} حزمة لغة OCR. انقر نقرًا مزدوجًا أو حدد ثم انقر على تثبيت.",
            "errorRetrievingLanguageList", "خطأ: تعذر استرداد قائمة اللغات.",
            "errorLoadingLanguages", "خطأ: فشل في تحميل اللغات. ",
            "pleaseSelectLanguageToInstall", "الرجاء تحديد لغة للتثبيت.",
            "alreadyInstalled", " مثبتة بالفعل.",
            "installing", "جاري تثبيت ",
            "installationCompleted", "اكتمل التثبيت لـ {1}! انقر على تحديث لتحديث القائمة.",
            "errorInstalling", "خطأ: فشل في تثبيت ",
            "pleaseSelectLanguageToRemove", "الرجاء تحديد لغة للإزالة.",
            "notInstalledOrCannotBeRemoved", " ليست مثبتة أو لا يمكن إزالتها.",
            "removing", "جاري إزالة ",
            "removalCompleted", "اكتملت الإزالة لـ {1}! انقر على تحديث لتحديث القائمة.",
            "errorRemoving", "خطأ: فشل في إزالة "
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
    
    ; New method to load installed OCR languages dynamically
    static LoadInstalledOCRLanguages() {
        this.installedOCRLanguages.Clear()
        this.ocrLanguageNames.Clear()
        
        ; Default fallback - always include English if no languages found
        this.installedOCRLanguages["en-US"] := "🇺🇸 English (en-US)"
        this.ocrLanguageNames["en-US"] := "English"
        
        try {
            ; PowerShell command to get installed OCR capabilities
            PSCommand := "pwsh -Command `"Get-WindowsCapability -Online | Where-Object { $_.Name -Like 'Language.OCR*' -and $_.State -eq 'Installed' } | ForEach-Object { $_.Name }`""
            
            ; Create temporary file for output
            TempFile := A_Temp . "\InstalledOCRLanguages.txt"
            
            ; Run PowerShell and capture output
            RunWait(PSCommand . " > `"" . TempFile . "`"", , "Hide")
            
            ; Read the output file
            if (FileExist(TempFile)) {
                FileContent := FileRead(TempFile)
                FileDelete(TempFile)
                
                ; Parse each line
                Lines := StrSplit(FileContent, "`n")
                
                for Line in Lines {
                    Line := Trim(Line)
                    if (Line = "")
                        continue
                    
                    ; Extract language code from capability name
                    ; Format: Language.OCR~~~en-US~0.0.1.0
                    if (RegExMatch(Line, "Language\.OCR~~~(.+?)~", &Match)) {
                        LanguageCode := Match[1]
                        FriendlyName := this.GetFriendlyLanguageName(LanguageCode)
                        
                        this.installedOCRLanguages[LanguageCode] := FriendlyName
                        this.ocrLanguageNames[LanguageCode] := FriendlyName
                    }
                }
            }
        } catch Error as err {
            ; If error, keep default English only
        }
    }
    
    ; Helper method to get friendly language names
    static GetFriendlyLanguageName(languageCode) {
        
            return "🌐 " . languageCode
        
    }
    
    ; Method to refresh OCR languages (requires admin)
    static RefreshOCRLanguages(gui) {
        if (!A_IsAdmin) {
            MsgBox(this.GetTranslation("adminRequiredText"), 
                   this.GetTranslation("adminRequired"), 
                   "48")  ; Warning icon
            return
        }
        
        gui.DisplayText(this.GetTranslation("refreshingOCRLanguages"))
        
        ; Load languages
        this.LoadInstalledOCRLanguages()
        
        ; Update the dropdown
        this.UpdateOCRLanguageDropdown(gui)
        
        gui.DisplayText(this.GetTranslation("ocrLanguagesRefreshed"))
    }
    
    ; Method to update OCR language dropdown with installed languages
    static UpdateOCRLanguageDropdown(gui) {
        ; Store current selection
        currentIndex := gui.ocrLanguageDropDown.Value
        currentLanguage := ""
        
        ; Get current language code if valid index
        if (currentIndex > 0 && currentIndex <= this.installedOCRLanguages.Count) {
            ; Find the language code for current selection
            counter := 1
            for code, name in this.installedOCRLanguages {
                if (counter = currentIndex) {
                    currentLanguage := code
                    break
                }
                counter++
            }
        }
        
        ; Clear and repopulate dropdown
        gui.ocrLanguageDropDown.Delete()
        
        options := []
        newIndex := 1
        selectedIndex := 1
        
        for code, name in this.installedOCRLanguages {
            options.Push(name)
            if (code = currentLanguage || (currentLanguage = "" && code = this.ocrLanguage)) {
                selectedIndex := newIndex
            }
            newIndex++
        }
        
        if (options.Length = 0) {
            ; No languages found, add default
            options.Push("🇺🇸 English (en-US)")
            this.installedOCRLanguages["en-US"] := "🇺🇸 English (en-US)"
        }
        
        gui.ocrLanguageDropDown.Add(options)
        gui.ocrLanguageDropDown.Value := selectedIndex
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
            
            ; Save installed OCR languages
            languageCodes := []
            for code, name in this.installedOCRLanguages {
                languageCodes.Push(code)
            }
            ; Manually join the language codes as AHK v2 Maps (arrays) do not have a .Join method
            persistedLanguagesString := ""
            for index, code in languageCodes {
                persistedLanguagesString .= code
                if (index < languageCodes.Length)
                    persistedLanguagesString .= ","
            }
            IniWrite(persistedLanguagesString, this.settingsFile, "Settings", "PersistedOCRLanguages")
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
            gui.overlayCheckbox.Value := this.showOverlays
            
            ; Load persisted OCR languages from settings
            persistedLanguages := IniRead(this.settingsFile, "Settings", "PersistedOCRLanguages", "en-US")
            this.installedOCRLanguages.Clear()
            this.ocrLanguageNames.Clear()
            
            ; Always include English as a fallback
            this.installedOCRLanguages["en-US"] := "🇺🇸 English (en-US)"
            this.ocrLanguageNames["en-US"] := "English"

            for each, code in StrSplit(persistedLanguages, ",") {
                code := Trim(code)
                if (code = "")
                    continue
                FriendlyName := this.GetFriendlyLanguageName(code)
                this.installedOCRLanguages[code] := FriendlyName
                this.ocrLanguageNames[code] := FriendlyName
            }
            
            ; Load installed OCR languages and update dropdown
            this.UpdateOCRLanguageDropdown(gui)
            
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
            gui.overlayCheckbox.Value := 0
            
            ; Load persisted OCR languages from settings
            persistedLanguages := IniRead(this.settingsFile, "Settings", "PersistedOCRLanguages", "en-US")
            this.installedOCRLanguages.Clear()
            this.ocrLanguageNames.Clear()

            ; Always include English as a fallback
            this.installedOCRLanguages["en-US"] := "🇺🇸 English (en-US)"
            this.ocrLanguageNames["en-US"] := "English"

            for each, code in StrSplit(persistedLanguages, ",") {
                code := Trim(code)
                if (code = "")
                    continue
                FriendlyName := this.GetFriendlyLanguageName(code)
                this.installedOCRLanguages[code] := FriendlyName
                this.ocrLanguageNames[code] := FriendlyName
            }

            ; Update dropdown even on error
            this.UpdateOCRLanguageDropdown(gui)
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
        ; Get the selected language code from the dropdown
        selectedIndex := gui.ocrLanguageDropDown.Value
        counter := 1
        
        for code, name in this.installedOCRLanguages {
            if (counter = selectedIndex) {
                this.ocrLanguage := code
                gui.DisplayText(this.GetTranslation("ocrLanguageSet") . name)
                break
            }
            counter++
        }
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
        
        this.cleanTextEnabled := true
        this.showOverlays := true
        this.guiLanguage := "eng"
        this.ocrLanguage := "en-US"
        
        ; Reset OCR language dropdown to first available language
        if (this.installedOCRLanguages.Count > 0) {
            gui.ocrLanguageDropDown.Value := 1
            ; Set the OCR language to the first available
            counter := 1
            for code, name in this.installedOCRLanguages {
                if (counter = 1) {
                    this.ocrLanguage := code
                    break
                }
                counter++
            }
        }
        
        gui.UpdateTranslations()
        gui.DisplayText(this.GetTranslation("settingsReset"))
    }

    ; Check admin privileges (for refresh button)
    static CheckAdminAndRestart() {
        if (!A_IsAdmin) {
            ; Show admin required message
            result := MsgBox(this.GetTranslation("adminRequiredText"), 
                           this.GetTranslation("adminRequired"), 
                           52)  ; Yes/No + Warning icon (4 + 48)
            
            if (result = "Yes") {
                try {
                    ; Restart with admin privileges
                    if A_IsCompiled
                        Run '*RunAs "' A_ScriptFullPath '"'
                    else
                        Run '*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"'
                    ExitApp()
                } catch as err {
                    MsgBox("Failed to restart with admin privileges: " err.Message, "Error", "0x10")
                    return false
                }
            }
            return false
        }
        return true
    }
}

; OCR Language Installer integrated class - Modified to work with dynamic languages
class OCRLanguageInstaller {
    ; Properties for GUI controls
    MyGui := ""
    LanguageList := ""
    RefreshBtn := ""
    InstallBtn := ""
    RemoveBtn := ""
    CloseBtn := ""
    StatusText := ""
    ParentGUI := ""
    OCRClass := ""
    
    ; Constructor
    __New(parentGUI, ocrClass) {
        this.ParentGUI := parentGUI
        this.OCRClass := ocrClass
        this.CreateGUI()
        this.LoadLanguages()
    }
    
    ; Create the GUI interface
    CreateGUI() {
        ; Create the main GUI
        this.MyGui := Gui("+Resize +Owner" this.ParentGUI.Hwnd, this.OCRClass.GetTranslation("installOCRLanguages"))
        this.MyGui.SetFont("s10", "Segoe UI")
        this.MyGui.BackColor := "FFFFFF"
        
        ; Add instruction text
        this.MyGui.Add("Text", "xm y+15 w500", this.OCRClass.GetTranslation("availableOCRLanguagePacks"))
        
        ; Add ListView for languages
        this.LanguageList := this.MyGui.Add("ListView", "xm y+10 w500 h200 vLanguageList", 
            [this.OCRClass.GetTranslation("languageCode"), this.OCRClass.GetTranslation("status")])
        this.LanguageList.OnEvent("DoubleClick", this.InstallSelected.Bind(this))
        
        ; Add buttons
        this.RefreshBtn := this.MyGui.Add("Button", "xm y+15 w100", this.OCRClass.GetTranslation("refreshList"))
        this.RefreshBtn.OnEvent("Click", this.LoadLanguages.Bind(this))
        
        this.InstallBtn := this.MyGui.Add("Button", "x+10 yp w120", this.OCRClass.GetTranslation("install"))
        this.InstallBtn.OnEvent("Click", this.InstallSelected.Bind(this))
        
        this.RemoveBtn := this.MyGui.Add("Button", "x+10 yp w120", this.OCRClass.GetTranslation("remove"))
        this.RemoveBtn.OnEvent("Click", this.RemoveSelected.Bind(this))
        
        this.CloseBtn := this.MyGui.Add("Button", "x+10 yp w100", this.OCRClass.GetTranslation("close"))
        this.CloseBtn.OnEvent("Click", this.Close.Bind(this))
        
        ; Add status text
        this.StatusText := this.MyGui.Add("Text", "xm y+15 w500 h30 +Border", this.OCRClass.GetTranslation("loadingLanguages"))
        
        ; Set up event handlers
        this.MyGui.OnEvent("Escape", this.Close.Bind(this))
        this.MyGui.OnEvent("Close", this.Close.Bind(this))
    }
    
    ; Show the GUI
    Show() {
        this.MyGui.Show("w530 h350")
    }
    
    ; Load available OCR languages
    LoadLanguages(*) {
        this.StatusText.Text := this.OCRClass.GetTranslation("loadingLanguages")
        this.RefreshBtn.Enabled := false
        this.InstallBtn.Enabled := false
        this.RemoveBtn.Enabled := false
        this.LanguageList.Delete() ; Clear existing items
        
        ; PowerShell command to get OCR capabilities
        PSCommand := "pwsh -Command `"Get-WindowsCapability -Online | Where-Object { $_.Name -Like 'Language.OCR*' } | ForEach-Object { $_.Name + '||' + $_.State }`""
        
        try {
            ; Create temporary file for output
            TempFile := A_Temp . "\OCRLanguages.txt"
            
            ; Run PowerShell and capture output
            RunWait(PSCommand . " > `"" . TempFile . "`"", , "Hide")
            
            ; Read the output file
            if (FileExist(TempFile)) {
                FileContent := FileRead(TempFile)
                FileDelete(TempFile)
                
                ; Parse each line
                Lines := StrSplit(FileContent, "`n")
                Count := 0
                
                for Line in Lines {
                    Line := Trim(Line)
                    if (Line = "")
                        continue
                        
                    ; Split by double pipe character
                    Parts := StrSplit(Line, "||")
                    if (Parts.Length >= 2) {
                        ; Extract language code from name (e.g., "Language.OCR~~~en-US~0.0.1.0" -> "en-US")
                        FullName := Parts[1]
                        State := Parts[2]
                        
                        ; Extract language code
                        if (RegExMatch(FullName, "Language\.OCR~~~(.+?)~", &Match)) {
                            LanguageCode := Match[1]
                            
                            ; Translate status
                            TranslatedStatus := (InStr(State , "Installed")) ? this.OCRClass.GetTranslation("installed") : this.OCRClass.GetTranslation("notInstalled")
                            
                            ; Add to ListView
                            this.LanguageList.Add(, LanguageCode, TranslatedStatus)
                            Count++
                        }
                    }
                }
                
                ; Auto-size columns
                this.LanguageList.ModifyCol(1, "AutoHdr")
                this.LanguageList.ModifyCol(2, "AutoHdr")
                
                this.StatusText.Text := Format(this.OCRClass.GetTranslation("foundOCRLanguagePacks"), Count)
            }
            else {
                this.StatusText.Text := this.OCRClass.GetTranslation("errorRetrievingLanguageList")
            }
        }
        catch Error as err {
            this.StatusText.Text := this.OCRClass.GetTranslation("errorLoadingLanguages") . err.Message
        }
        
        this.RefreshBtn.Enabled := true
        this.InstallBtn.Enabled := true
        this.RemoveBtn.Enabled := true
    }
    
    ; Install selected language
    InstallSelected(*) {
        ; Get selected row
        SelectedRow := this.LanguageList.GetNext()
        
        if (SelectedRow = 0) {
            this.StatusText.Text := this.OCRClass.GetTranslation("pleaseSelectLanguageToInstall")
            return
        }
        
        ; Get language code from selected row
        LanguageCode := this.LanguageList.GetText(SelectedRow, 1)
        CurrentStatus := this.LanguageList.GetText(SelectedRow, 2)
        
        if (CurrentStatus = this.OCRClass.GetTranslation("installed")) {
            this.StatusText.Text := LanguageCode . this.OCRClass.GetTranslation("alreadyInstalled")
            return
        }
        
        ; Update status
        this.StatusText.Text := this.OCRClass.GetTranslation("installing") . LanguageCode . "..."
        this.InstallBtn.Enabled := false
        this.RefreshBtn.Enabled := false
        this.RemoveBtn.Enabled := false
        
        ; Create PowerShell command to install specific OCR language pack
        PSCommand := "pwsh -Command `"$Capability = Get-WindowsCapability -Online | Where-Object { $_.Name -Like 'Language.OCR*" . LanguageCode . "*' }; if ($Capability) { $Capability | Add-WindowsCapability -Online; Write-Host 'Success: " . LanguageCode . " installed' } else { Write-Host 'Error: " . LanguageCode . " not found' }`""
        
        try {
            ; Run the PowerShell command (already running as admin)
            RunWait(PSCommand, , "")
            this.StatusText.Text := Format(this.OCRClass.GetTranslation("installationCompleted"), LanguageCode)
            
            ; Update the status in the ListView
            this.LoadLanguages()
        }
        catch Error as err {
            this.StatusText.Text := this.OCRClass.GetTranslation("errorInstalling") . LanguageCode . ". " . err.Message
        }
        
        ; Re-enable buttons
        this.InstallBtn.Enabled := true
        this.RefreshBtn.Enabled := true
        this.RemoveBtn.Enabled := true
    }
    
    ; Remove selected language
    RemoveSelected(*) {
        ; Get selected row
        SelectedRow := this.LanguageList.GetNext()
        
        if (SelectedRow = 0) {
            this.StatusText.Text := this.OCRClass.GetTranslation("pleaseSelectLanguageToRemove")
            return
        }
        
        ; Get language code from selected row
        LanguageCode := this.LanguageList.GetText(SelectedRow, 1)
        CurrentStatus := this.LanguageList.GetText(SelectedRow, 2)
        
        if (CurrentStatus != this.OCRClass.GetTranslation("installed")) {
            this.StatusText.Text := LanguageCode . this.OCRClass.GetTranslation("notInstalledOrCannotBeRemoved")
            return
        }
        
        ; Update status
        this.StatusText.Text := this.OCRClass.GetTranslation("removing") . LanguageCode . "..."
        this.InstallBtn.Enabled := false
        this.RefreshBtn.Enabled := false
        this.RemoveBtn.Enabled := false
        
        ; Create PowerShell command to remove specific OCR language pack
        PSCommand := "pwsh -Command `"$Capability = Get-WindowsCapability -Online | Where-Object { $_.Name -Like 'Language.OCR*" . LanguageCode . "*' }; if ($Capability) { $Capability | Remove-WindowsCapability -Online; Write-Host 'Success: " . LanguageCode . " removed' } else { Write-Host 'Error: " . LanguageCode . " not found' }`""
        
        try {
            ; Run the PowerShell command (already running as admin)
            RunWait(PSCommand, , "")
            this.StatusText.Text := Format(this.OCRClass.GetTranslation("removalCompleted"), LanguageCode)
            
            ; Update the status in the ListView
            this.LoadLanguages()
        }
        catch Error as err {
            this.StatusText.Text := this.OCRClass.GetTranslation("errorRemoving") . LanguageCode . ". " . err.Message
        }
        
        ; Re-enable buttons
        this.InstallBtn.Enabled := true
        this.RefreshBtn.Enabled := true
        this.RemoveBtn.Enabled := true
    }
    
    ; Close the installer
    Close(*) {
        this.MyGui.Destroy()
    }
}

; Create and initialize the application
app := OCRReaderGUI(BetterTTS)