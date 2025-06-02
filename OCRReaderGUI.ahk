#Requires AutoHotkey v2
#include "SpeechHandler.ahk"
#include "VoiceSearchGUI.ahk"

class OCRReaderGUI {
    ; Instance variables
    gui := unset
    textEdit := unset
    voiceDropDown := unset
    volumeSlider := unset
    speedSlider := unset
    pitchSlider := unset
    playButton := unset
    pauseButton := unset
    stopButton := unset
    statusBar := unset
    guiLanguageDropDown := unset
    ocrLanguageDropDown := unset
    overlayCheckbox := unset
    ocr := unset
    voiceSearchButton := unset
    refreshOcrLanguagesButton := unset

    ; GUI controls that need translation updates
    textGroupBox := unset
    voiceGroupBox := unset
    languageLabel := unset
    ocrLanguageLabel := unset
    voiceLabel := unset
    volumeLabel := unset
    speedLabel := unset
    pitchLabel := unset

    __New(ocrClass) {
        this.ocr := ocrClass

        ; Create main GUI with better styling
        this.gui := Gui("+Resize")
        this.gui.Title := "Better TTS"
        this.gui.BackColor := "FFFFFF"  ; White background for better contrast
        this.gui.SetFont("s10", "Segoe UI")  ; Modern font

        ; Create menu bar
        this.CreateMenuBar()

        ; Create main layout
        this.CreateControls()

        ; Load saved settings
        this.ocr.LoadSettings(this)

        ; Update translations based on loaded language
        this.UpdateTranslations()

        ; Setup event handlers
        this.SetupEvents()

        ; Show GUI
        this.Show()
    }

    CreateMenuBar() {
        local mb := MenuBar()

        ; File menu
        local fileMenu := Menu()
        fileMenu.Add("&" this.ocr.GetTranslation("saveText"), this.SaveText.Bind(this))
        fileMenu.Add("&" this.ocr.GetTranslation("loadText"), this.LoadText.Bind(this))
        fileMenu.Add()
        fileMenu.Add("&" this.ocr.GetTranslation("exit"), (*) => this.gui.Destroy())

        ; Settings menu
        local settingsMenu := Menu()
        settingsMenu.Add("&" this.ocr.GetTranslation("alwaysOnTop"), this.ToggleAlwaysOnTop.Bind(this))
        settingsMenu.Add("&" this.ocr.GetTranslation("cleanText"), this.ToggleCleanText.Bind(this))
        settingsMenu.Add()  ; Add a separator
        settingsMenu.Add("&" this.ocr.GetTranslation("installOCRLanguages"), this.OpenLanguageInstaller.Bind(this))
        settingsMenu.Add()  ; Add another separator
        settingsMenu.Add("&" this.ocr.GetTranslation("resetDefaults"), this.ResetToDefaults.Bind(this))

        ; Help menu
        local helpMenu := Menu()
        helpMenu.Add("&" this.ocr.GetTranslation("hotkeys"), this.ShowHotkeys.Bind(this))
        helpMenu.Add("&" this.ocr.GetTranslation("languagePackInfo"), (*) => this.ocr.ShowLanguagePackInfo())
        helpMenu.Add()
        helpMenu.Add("&" this.ocr.GetTranslation("about"), this.ShowAbout.Bind(this))

        mb.Add("&" this.ocr.GetTranslation("fileMenu"), fileMenu)
        mb.Add("&" this.ocr.GetTranslation("settingsMenu"), settingsMenu)
        mb.Add("&" this.ocr.GetTranslation("helpMenu"), helpMenu)

        this.gui.MenuBar := mb
    }

    CreateControls() {
        ; Text capture section
        this.textGroupBox := this.gui.AddGroupBox("x10 y10 w480 h300", this.ocr.GetTranslation("capturedText"))
        this.textEdit := this.gui.Add("Edit", "vOCRText x20 y30 w460 h270 Multi")

        ; Voice settings section
        this.voiceGroupBox := this.gui.AddGroupBox("x10 y320 w480 h250", this.ocr.GetTranslation("voiceSettings"))

        ; GUI Language selection with label
        this.languageLabel := this.gui.AddText("x20 y340 w100", this.ocr.GetTranslation("language"))
        this.guiLanguageDropDown := this.gui.AddDropDownList("x120 y338 w150 vSelectedGUILanguage",
            [this.ocr.GetTranslation("english"), this.ocr.GetTranslation("arabic")])
        this.guiLanguageDropDown.OnEvent("Change", (*) => this.ocr.SetGUILanguage(this))

        ; OCR Language selection with label
        this.ocrLanguageLabel := this.gui.AddText("x280 y340", this.ocr.GetTranslation("ocrLanguage"))
        
        this.ocrLanguageDropDown := this.gui.AddDropDownList("x+5 y338 w90 vSelectedOCRLanguage")
        ; Add the refresh OCR languages button
        this.refreshOcrLanguagesButton := this.gui.Add("Button", "x+2 y338 w25 h25", "🔄")
        this.refreshOcrLanguagesButton.OnEvent("Click", this.HandleRefreshOCRLanguages.Bind(this))
        ; Populate OCR language dropdown dynamically
        this.ocr.UpdateOCRLanguageDropdown(this)
        this.ocrLanguageDropDown.OnEvent("Change", (*) => this.ocr.SetOCRLanguage(this))

        ; Voice selection with label
        this.voiceLabel := this.gui.AddText("x20 y370 w100", this.ocr.GetTranslation("voice"))
        this.voiceSearchButton := this.gui.Add("Button", "x+0 y368 w25 h25", "🔍")
        this.voiceSearchButton.OnEvent("Click", this.OpenVoiceSearch.Bind(this))
        this.voiceDropDown := this.gui.AddDropDownList("x+2 y368 w332 vSelectedVoice", SpeechHandler.GetVoiceList())
        
        ; Volume control with label
        this.volumeLabel := this.gui.AddText("x20 y400 w100", this.ocr.GetTranslation("volume"))
        this.volumeSlider := this.gui.AddSlider("x120 y398 w300 vVolume Range0-100")
        this.volumeValueLabel := this.gui.AddEdit("x425 y398 w35 h21", "100")  ; Changed to Edit control
        this.volumeSlider.OnEvent("Change", this.UpdateVolumeLabel.Bind(this))
        this.volumeValueLabel.OnEvent("Change", this.OnVolumeValueChange.Bind(this))

        ; Speed control with label and value display
        this.speedLabel := this.gui.AddText("x20 y430 w100", this.ocr.GetTranslation("speed"))
        this.speedSlider := this.gui.AddSlider("x120 y428 w300 vSpeed Range20-80", 50)
        this.speedValueLabel := this.gui.AddEdit("x425 y428 w35 h21", "5.0")  ; Changed to Edit control
        this.speedSlider.OnEvent("Change", this.UpdateSpeedLabel.Bind(this))
        this.speedValueLabel.OnEvent("Change", this.OnSpeedValueChange.Bind(this))

        ; Pitch control with label and value display
        this.pitchLabel := this.gui.AddText("x20 y460 w100", this.ocr.GetTranslation("pitch"))
        this.pitchSlider := this.gui.AddSlider("x120 y458 w300 vPitch Range1-10")
        this.pitchValueLabel := this.gui.AddEdit("x425 y458 w35 h21", "5")  ; Changed to Edit control
        this.pitchSlider.OnEvent("Change", this.UpdatePitchLabel.Bind(this))
        this.pitchValueLabel.OnEvent("Change", this.OnPitchValueChange.Bind(this))

        ; Control buttons with icons
        this.playButton := this.gui.AddButton("x20 y490 w150 h25", this.ocr.GetTranslation("speak"))
        this.pauseButton := this.gui.AddButton("x180 y490 w150 h25", this.ocr.GetTranslation("pause"))
        this.stopButton := this.gui.AddButton("x340 y490 w150 h25", this.ocr.GetTranslation("stop"))

        ; Overlay toggle checkbox
        this.overlayCheckbox := this.gui.AddCheckbox("x20 y525 w460 h25", this.ocr.GetTranslation("showOverlays"))
        this.overlayCheckbox.Value := 1  ; Set initial state to checked
        this.overlayCheckbox.OnEvent("Click", (*) => this.ocr.ToggleOverlays(this))

        ; Status bar
        this.statusBar := this.gui.AddStatusBar(, this.ocr.GetTranslation("ready"))
    }

    UpdateTranslations() {
        ; Update menu bar
        this.CreateMenuBar()

        ; Update group boxes
        this.textGroupBox.Text := this.ocr.GetTranslation("capturedText")
        this.voiceGroupBox.Text := this.ocr.GetTranslation("voiceSettings")

        ; Update labels
        this.languageLabel.Text := this.ocr.GetTranslation("language")
        this.ocrLanguageLabel.Text := this.ocr.GetTranslation("ocrLanguage")
        this.voiceLabel.Text := this.ocr.GetTranslation("voice")
        this.volumeLabel.Text := this.ocr.GetTranslation("volume")
        this.speedLabel.Text := this.ocr.GetTranslation("speed")
        this.pitchLabel.Text := this.ocr.GetTranslation("pitch")

        ; Update dropdown items
        this.guiLanguageDropDown.Delete()
        this.guiLanguageDropDown.Add([this.ocr.GetTranslation("english"), this.ocr.GetTranslation("arabic")])
        this.guiLanguageDropDown.Value := (this.ocr.guiLanguage = "eng") ? 1 : 2

        ; Update OCR language dropdown dynamically
        this.ocr.UpdateOCRLanguageDropdown(this)

        ; Update buttons
        this.playButton.Text := this.ocr.GetTranslation("speak")
        this.pauseButton.Text := this.ocr.GetTranslation("pause")
        this.stopButton.Text := this.ocr.GetTranslation("stop")

        ; Update refresh OCR languages button
        this.refreshOcrLanguagesButton.Text := "🔄" ; Icon-based, so text remains the same

        ; Update overlay checkbox
        this.overlayCheckbox.Text := this.ocr.GetTranslation("showOverlays")

        ; Update status bar
        this.statusBar.SetText(this.ocr.GetTranslation("ready"))

        ; Update window title based on language
        this.gui.Title := this.ocr.guiLanguage = "eng" ? "Better TTS" : "قارئ النصوص"
    }

    SetupEvents() {
        ; Button events
        this.playButton.OnEvent("Click", (*) => this.ocr.SpeakText(this))
        this.pauseButton.OnEvent("Click", (*) => this.ocr.PauseSpeech(this))
        this.stopButton.OnEvent("Click", (*) => this.ocr.StopSpeaking(this))

        ; Add CapsLock+A hotkey for OCR from clipboard
        Hotkey "CapsLock & a", (*) => this.clipboardToText()

        ; Add CapsLock+C hotkey for copying selected text
        Hotkey "CapsLock & c", (*) => this.CopySelectedText()

        ; Window events
        this.gui.OnEvent("Close", this.GuiClose.Bind(this))
        this.gui.OnEvent("Size", this.GuiSize.Bind(this))

        ; Hotkeys
        Hotkey "CapsLock & x", (*) => this.ocr.CaptureText(this)
        Hotkey "CapsLock & r", (*) => this.ocr.RefreshCapture(this)
        Hotkey "CapsLock & z", (*) => this.ocr.ClearHighlight(this)
        Hotkey "CapsLock & v", (*) => this.ocr.SpeakText(this)
        Hotkey "CapsLock & p", (*) => this.ocr.PauseSpeech(this)
        Hotkey "CapsLock & s", (*) => this.ocr.StopSpeaking(this)
        Hotkey "CapsLock & t", this.ToggleAlwaysOnTop.Bind(this)
        Hotkey "CapsLock & h", (*) => this.ocr.ToggleOverlays(this)

        ; Volume and Speed control hotkeys
        Hotkey "CapsLock & Up", this.IncreaseVolume.Bind(this)
        Hotkey "CapsLock & Down", this.DecreaseVolume.Bind(this)
        Hotkey "CapsLock & Right", this.IncreaseSpeed.Bind(this)
        Hotkey "CapsLock & Left", this.DecreaseSpeed.Bind(this)
        ; Pitch control hotkeys
        Hotkey "CapsLock & PgUp", this.IncreasePitch.Bind(this)
        Hotkey "CapsLock & PgDn", this.DecreasePitch.Bind(this)
    }

    Show() {
        this.gui.Show("w500 h590")  ; Increased height to accommodate all controls
    }

    ; Event handlers
    GuiClose(*) {
        this.ocr.SaveSettings(this)
        ExitApp
    }

    GuiSize(thisGui, MinMax, Width, Height) {
        if MinMax = -1  ; Window is minimized
            return

        ; Calculate new control widths
        sliderWidth := Width - 200  ; Leave space for label and value

        ; Adjust control sizes and positions
        this.textEdit.Move(, , Width - 40)
        ; this.voiceDropDown.Move(, , Width - 140)
        this.volumeSlider.Move(, , sliderWidth)
        this.volumeValueLabel.Move(120 + sliderWidth + 5)  ; Position after slider with small gap
        this.speedSlider.Move(, , sliderWidth)
        this.speedValueLabel.Move(120 + sliderWidth + 5)  ; Position after slider with small gap
        this.pitchSlider.Move(, , sliderWidth)
        this.pitchValueLabel.Move(120 + sliderWidth + 5)  ; Position after slider with small gap
    }

    ; Menu handlers
    SaveText(*) {
        if (fileName := FileSelect("S16", , this.ocr.GetTranslation("saveFileDialog"), this.ocr.GetTranslation(
            "textFiles"))) {
            try {
                FileAppend(this.textEdit.Value, fileName)
                this.DisplayText(this.ocr.GetTranslation("textSaved"))
            } catch as err {
                MsgBox(this.ocr.GetTranslation("errorSaving") err.Message, this.ocr.GetTranslation("error"), "Icon!")
            }
        }
    }

    LoadText(*) {
        if (fileName := FileSelect(3, , this.ocr.GetTranslation("loadFileDialog"), this.ocr.GetTranslation("textFiles"))) {
            try {
                this.textEdit.Value := FileRead(fileName)
                this.DisplayText(this.ocr.GetTranslation("textLoaded"))
            } catch as err {
                MsgBox(this.ocr.GetTranslation("errorLoading") err.Message, this.ocr.GetTranslation("error"), "Icon!")
            }
        }
    }

    ToggleAlwaysOnTop(*) {
        static isOnTop := false
        isOnTop := !isOnTop
        this.gui.Opt(isOnTop ? "+AlwaysOnTop" : "-AlwaysOnTop")
        this.DisplayText(this.ocr.GetTranslation(isOnTop ? "alwaysOnTopOn" : "alwaysOnTopOff"))
    }

    ToggleCleanText(*) {
        this.ocr.ToggleCleanText(this)
    }

    ; New method to open the language installer
    OpenLanguageInstaller(*) {
        ; Check if running as admin, restart if needed
        if (this.ocr.CheckAdminAndRestart()) {
            ; Create and show the language installer
            installer := OCRLanguageInstaller(this.gui, this.ocr)
            installer.Show()
        }
    }

    ; New method to handle OCR language refresh with admin check
    HandleRefreshOCRLanguages(*) {
        if (this.ocr.CheckAdminAndRestart()) {
            this.ocr.RefreshOCRLanguages(this)
        }
    }

    ShowHotkeys(*) {
        ; Create a new GUI for hotkeys
        hotkeyGui := Gui("+AlwaysOnTop +Owner" this.gui.Hwnd " +Resize")  ; Added Resize option
        hotkeyGui.Title := this.ocr.GetTranslation("hotkeyTitle")
        hotkeyGui.SetFont("s9", "Segoe UI")
        hotkeyGui.BackColor := "FFFFFF"

        ; Add a ListView to display hotkeys in a more organized way
        LV := hotkeyGui.Add("ListView", "w170 h250 Grid", [this.ocr.GetTranslation("hotkeyColumn"), this.ocr.GetTranslation(
            "descriptionColumn")])
        LV.Opt("+LV0x10000")  ; Enable double buffering

        ; Add hotkeys to the ListView
        LV.Add(, "CapsLock + X", this.ocr.GetTranslation("captureDesc"))
        LV.Add(, "CapsLock + R", this.ocr.GetTranslation("refreshDesc"))
        LV.Add(, "CapsLock + C", this.ocr.GetTranslation("copyDesc"))
        LV.Add(, "CapsLock + Z", this.ocr.GetTranslation("clearDesc"))
        LV.Add(, "CapsLock + V", this.ocr.GetTranslation("speakDesc"))
        LV.Add(, "CapsLock + P", this.ocr.GetTranslation("pauseDesc"))
        LV.Add(, "CapsLock + S", this.ocr.GetTranslation("stopDesc"))
        LV.Add(, "CapsLock + T", this.ocr.GetTranslation("topDesc"))
        LV.Add(, "CapsLock + H", this.ocr.GetTranslation("overlayDesc"))
        LV.Add(, "CapsLock + ↑", this.ocr.GetTranslation("volumeUpDesc"))
        LV.Add(, "CapsLock + ↓", this.ocr.GetTranslation("volumeDownDesc"))
        LV.Add(, "CapsLock + →", this.ocr.GetTranslation("speedUpDesc"))
        LV.Add(, "CapsLock + ←", this.ocr.GetTranslation("speedDownDesc"))

        ; Set initial column widths
        LV.ModifyCol(1, 90)
        LV.ModifyCol(2, 190)

        ; Add a close button
        closeButton := hotkeyGui.Add("Button", "w80 h25 Default", this.ocr.GetTranslation("ok"))
        closeButton.OnEvent("Click", (*) => hotkeyGui.Destroy())

        ; Handle window resize
        HotkeyGuiSize(thisGui, MinMax, Width, Height) {
            if (MinMax = -1)  ; Window is minimized
                return

            ; Resize ListView to fill the window with padding
            LV.Move(, , Width - 16, Height - 35)

            ; Move close button to bottom of window
            closeButton.Move((Width - 80) // 2, Height - 30)

            ; Adjust column widths proportionally
            LV.ModifyCol(1, 90)  ; Keep hotkey column fixed
            LV.ModifyCol(2, Width - 106)  ; Adjust description column to fill remaining space
        }

        hotkeyGui.OnEvent("Size", HotkeyGuiSize)

        ; Show the GUI
        hotkeyGui.Show("w280 h330")  ; Initial size
    }

    ShowAbout(*) {
        MsgBox(this.ocr.GetTranslation("aboutText"), this.ocr.GetTranslation("aboutTitle"), "0x40")
    }

    ; Volume control methods
    IncreaseVolume(*) {
        newVolume := Min(this.volumeSlider.Value + 10, 100)
        this.volumeSlider.Value := newVolume
        this.UpdateVolumeLabel()  ; Update the value label
        this.DisplayText(StrReplace(this.ocr.GetTranslation("volumeSet"), "{1}", newVolume))
    }

    DecreaseVolume(*) {
        newVolume := Max(this.volumeSlider.Value - 10, 0)
        this.volumeSlider.Value := newVolume
        this.UpdateVolumeLabel()  ; Update the value label
        this.DisplayText(StrReplace(this.ocr.GetTranslation("volumeSet"), "{1}", newVolume))
    }

    ; Speed control methods
    IncreaseSpeed(*) {
        newSpeed := Min(this.speedSlider.Value + 10, 80)  ; Changed max to 80 (maps to 8)
        this.speedSlider.Value := newSpeed
        this.UpdateSpeedLabel()
        this.DisplayText(StrReplace(this.ocr.GetTranslation("speedSet"), "{1}", newSpeed / 10))
    }

    DecreaseSpeed(*) {
        newSpeed := Max(this.speedSlider.Value - 10, 20)  ; Changed min to 20 (maps to 2)
        this.speedSlider.Value := newSpeed
        this.UpdateSpeedLabel()
        this.DisplayText(StrReplace(this.ocr.GetTranslation("speedSet"), "{1}", newSpeed / 10))
    }

    ; Pitch control methods
    IncreasePitch(*) {
        newPitch := Min(this.pitchSlider.Value + 1, 10)
        this.pitchSlider.Value := newPitch
        this.UpdatePitchLabel()  ; Update the value label
        this.DisplayText(StrReplace(this.ocr.GetTranslation("pitchSet"), "{1}", newPitch))
    }

    DecreasePitch(*) {
        newPitch := Max(this.pitchSlider.Value - 1, 1)
        this.pitchSlider.Value := newPitch
        this.UpdatePitchLabel()  ; Update the value label
        this.DisplayText(StrReplace(this.ocr.GetTranslation("pitchSet"), "{1}", newPitch))
    }
    clipboardToText(*) {
        text := this.ocr.OCRFromClipboard()
        if text = "" {
            text := A_Clipboard
        }
        this.textEdit.Value := text
        this.DisplayText(this.ocr.GetTranslation("textCopied"))
        SetTimer(() => this.ocr.SpeakText(this), -1)
    }
    ; Text selection method
    CopySelectedText(*) {
        ; Store current clipboard content
        prevClip := A_Clipboard

        ; Clear clipboard and send copy command
        A_Clipboard := ""
        Send "^c"

        ; Wait for the clipboard to contain text (timeout after 0.5 seconds)
        if ClipWait(0.5) {
            ; Update the edit control with the selected text
            this.textEdit.Value := A_Clipboard
            this.DisplayText(this.ocr.GetTranslation("textCopied"))

            ; Start speaking the text
            SetTimer(() => this.ocr.SpeakText(this), -1)
            A_Clipboard := prevClip
        } else {
            this.DisplayText(this.ocr.GetTranslation("noTextSelected"))
            ; Restore previous clipboard content
            A_Clipboard := prevClip
        }
    }

    ; Helper method to display text in status bar and tooltip
    DisplayText(text) {
        ; Update status bar
        this.statusBar.SetText(text)

        ; Show tooltip near mouse cursor only if overlays are enabled
        if (this.ocr.showOverlays) {
            MouseGetPos(&mouseX, &mouseY)
            ToolTip(text, mouseX + 10, mouseY + 20)  ; Position tooltip below and slightly to the right of cursor
            ; Auto-hide tooltip after 1.5 seconds
            SetTimer () => ToolTip(), -1500
        }
    }

    ; Add these new methods for updating the value labels
    UpdateSpeedLabel(*) {
        this.speedValueLabel.Value := Format("{:.1f}", this.speedSlider.Value / 10)
    }

    OnSpeedValueChange(*) {
        ; Get the text value and ensure it's a valid number
        value := this.speedValueLabel.Value
        if (value ~= "^[0-9]*\.?[0-9]*$" && value!="") {  ; Check if it's a valid number format
            speed := Float(value)
            if (speed >= 2 && speed <= 10) {
                ; Convert the speed value (2-10) to slider value (20-80)
                sliderValue := Round(speed * 10)
                this.speedSlider.Value := Min(Max(sliderValue, 20), 80)
            }
        }
    }

    UpdatePitchLabel(*) {
        this.pitchValueLabel.Value := this.pitchSlider.Value
    }

    OnPitchValueChange(*) {
        ; Get the text value and ensure it's a valid number
        value := this.pitchValueLabel.Value
        if (value ~= "^[0-9]+$") {  ; Check if it's a valid integer
            pitch := Integer(value)
            if (pitch >= 1 && pitch <= 10) {
                this.pitchSlider.Value := pitch
            } else if (pitch > 10) {
                this.pitchValueLabel.Value := "10"
                this.pitchSlider.Value := 10
            } else if (pitch < 1) {
                this.pitchValueLabel.Value := "1"
                this.pitchSlider.Value := 1
            }
        } else {
            ; If invalid input, reset to current slider value
            this.UpdatePitchLabel()
        }
    }

    ; Add volume label update method with the other label update methods
    UpdateVolumeLabel(*) {
        this.volumeValueLabel.Value := this.volumeSlider.Value
    }

    OnVolumeValueChange(*) {
        ; Get the text value and ensure it's a valid number
        value := this.volumeValueLabel.Value
        if (value ~= "^[0-9]+$") {  ; Check if it's a valid integer
            volume := Integer(value)
            if (volume >= 0 && volume <= 100) {
                this.volumeSlider.Value := volume
            } else if (volume > 100) {
                this.volumeValueLabel.Value := "100"
                this.volumeSlider.Value := 100
            } else if (volume < 0) {
                this.volumeValueLabel.Value := "0"
                this.volumeSlider.Value := 0
            }
        } else {
            ; If invalid input, reset to current slider value
            this.UpdateVolumeLabel()
        }
    }

    ; Add the reset to defaults method
    ResetToDefaults(*) {
        ; Reset all controls to default values
        this.voiceDropDown.Value := 1
        this.volumeSlider.Value := 100
        this.speedSlider.Value := 50  ; Middle value for speed (5.0)
        this.pitchSlider.Value := 5   ; Middle value for pitch
        this.overlayCheckbox.Value := 1  ; Overlays enabled by default
        this.guiLanguageDropDown.Value := 1  ; English
        this.ocrLanguageDropDown.Value := 1  ; English OCR

        ; Update all value labels
        this.UpdateVolumeLabel()
        this.UpdateSpeedLabel()
        this.UpdatePitchLabel()

        ; Reset OCR class settings
        this.ocr.cleanTextEnabled := true  ; Clean text enabled by default
        this.ocr.showOverlays := true  ; Overlays enabled by default
        this.ocr.guiLanguage := "eng"
        this.ocr.ocrLanguage := "en-US"

        ; Update translations for new language
        this.UpdateTranslations()

        ; Show confirmation message
        this.DisplayText(this.ocr.GetTranslation("settingsReset"))
    }

    ; Open voice search dialog
    OpenVoiceSearch(*) {
        ; Get the current voice list and selected index
        voiceList := SpeechHandler.GetVoiceList()
        ; Create and show the voice search GUI
        voiceSearch := VoiceSearchGUI(this, this.voiceDropDown, voiceList, this.voiceDropDown.Value, this.ocr)
    }
}