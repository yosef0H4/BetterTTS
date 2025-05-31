#Requires AutoHotkey v2

class VoiceSearchGUI {
    ; Instance variables
    gui := unset
    searchEdit := unset
    voiceListView := unset
    resultsList := []
    allVoices := []
    parentGui := unset
    parentControl := unset
    ocr := unset
    
    __New(parentGui, parentControl, voiceList, currentVoiceIndex, ocrClass) {
        ; Store references
        this.parentGui := parentGui
        this.parentControl := parentControl
        this.allVoices := voiceList
        this.ocr := ocrClass
        
        ; Create search GUI
        this.Create(currentVoiceIndex)
    }
    
    Create(currentVoiceIndex) {
        ; Create popup GUI with search features
        this.gui := Gui("+AlwaysOnTop +ToolWindow +Owner" this.parentGui.gui.Hwnd)
        this.gui.Title := this.ocr.GetTranslation("voiceSearch")
        this.gui.SetFont("s10", "Segoe UI")
        this.gui.BackColor := "FFFFFF"  ; White background
        
        ; Add search box
        this.gui.AddText("x10 y10 w400", this.ocr.GetTranslation("searchForVoices"))
        this.searchEdit := this.gui.AddEdit("x10 y30 w400 h25")
        this.searchEdit.OnEvent("Change", this.UpdateSearch.Bind(this))
        
        ; Add listview for voice display
        this.voiceListView := this.gui.AddListView("x10 y65 w400 h300 -Multi", [this.ocr.GetTranslation("voiceColumn")])
        this.voiceListView.OnEvent("DoubleClick", this.SelectVoice.Bind(this))
        
        ; Add column for voice names
        this.voiceListView.ModifyCol(1, 380)
        
        ; Populate the listview with all voices
        for voice in this.allVoices
            this.voiceListView.Add("", voice)
        
        ; Try to select the current voice
        if (currentVoiceIndex > 0 && currentVoiceIndex <= this.voiceListView.GetCount())
            this.voiceListView.Modify(currentVoiceIndex, "Select Focus")
        
        ; Add Select and Cancel buttons
        selectBtn := this.gui.AddButton("x200 y375 w100 h30 Default", this.ocr.GetTranslation("select"))
        selectBtn.OnEvent("Click", this.SelectVoice.Bind(this))
        
        cancelBtn := this.gui.AddButton("x310 y375 w100 h30", this.ocr.GetTranslation("cancel"))
        cancelBtn.OnEvent("Click", (*) => this.gui.Destroy())
        
        ; Set up events
        this.gui.OnEvent("Escape", (*) => this.gui.Destroy())
        this.gui.OnEvent("Close", (*) => this.gui.Destroy())
        
        ; Show the GUI - get parent window position to place this near it
        WinGetPos(&parentX, &parentY, &parentW, &parentH, "ahk_id " this.parentGui.gui.Hwnd)
        guiX := parentX + (parentW / 2) - 210  ; Center horizontally
        guiY := parentY + (parentH / 2) - 200  ; Center vertically
        this.gui.Show("x" guiX " y" guiY " w420 h415")
        
        ; Set focus to search box
        this.searchEdit.Focus()
    }
    
    UpdateSearch(*) {
        ; Filter voices based on search term
        searchTerm := this.searchEdit.Value
        this.voiceListView.Delete()
        
        if (searchTerm = "") {
            ; If search is empty, show all voices
            for voice in this.allVoices
                this.voiceListView.Add("", voice)
        } else {
            ; Otherwise, filter voices containing the search term
            for voice in this.allVoices {
                if (InStr(voice, searchTerm, false))
                    this.voiceListView.Add("", voice)
            }
        }
        
        ; Select first item if any results
        if (this.voiceListView.GetCount() > 0)
            this.voiceListView.Modify(1, "Select Focus")
    }
    
    SelectVoice(*) {
        ; Get the selected voice row
        if (row := this.voiceListView.GetNext(0, "Focused")) {
            selectedVoice := this.voiceListView.GetText(row, 1)
            
            ; Find the index of the selected voice in the original voice list
            for index, voice in this.allVoices {
                if (voice = selectedVoice) {
                    ; Update parent dropdown with selected voice
                    this.parentControl.Value := index
                    break
                }
            }
            
            ; Close the search dialog
            this.gui.Destroy()
        }
    }
}