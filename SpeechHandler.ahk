#Requires AutoHotkey v2

SetOutputVoiceFormat(AudioOutputStreamFormatType) {
    oVoice := ComObject("SAPI.SpVoice")
    oVoice.AllowAudioOutputFormatChangesOnNextSet := 0
    oVoice.AudioOutputStream.Format.Type := AudioOutputStreamFormatType
    oVoice.AudioOutputStream := oVoice.AudioOutputStream
    oVoice.AllowAudioOutputFormatChangesOnNextSet := 1
    return oVoice
}

class SpeechHandler {
    static speaker := SetOutputVoiceFormat(39)
    static voices := SpeechHandler.speaker.GetVoices
    

     
    

    static SpeakText(text, voiceIndex, volume, speed, pitch) {
        this.speaker.Voice := this.voices.Item(voiceIndex)
        
        
        ; Set volume (0-100)
        this.speaker.Volume := volume
        
        ; Set speed (20-80 mapped to 2-8, then to -4 to 4 for SAPI)
        this.speaker.Rate := (speed/10 - 5)  ; Convert 2-8 to -3 to 3
        
        ; Apply pitch using SSML (pitch range is -10 to 10, we map 1-10 to -5 to 5)
        pitchValue := pitch - 5
        textWithPitch := '<pitch middle="' pitchValue '">' text '</pitch>'
        
        ; Use SVSFlagsAsync (1) | SVSFIsXML (8) = 9 for non-blocking XML speech
        this.speaker.Speak(textWithPitch, 9)
    }

    static StopSpeaking() {
        this.speaker.Speak("", 3)
    }

    static PauseSpeech() {
        static isPaused := false
        if (!isPaused) {
            this.speaker.Pause()
            isPaused := true
        } else {
            this.speaker.Resume()
            isPaused := false
        }
    }

    static GetVoiceList() {
        voiceList := []
        Loop this.voices.Count {
            try {
                current_voice := this.voices.Item(A_Index-1)
                lang := current_voice.GetAttribute("Language")
                description := current_voice.GetDescription()
                ; Add voice with language indicator
                voiceList.Push(description . " [" . lang . "]")
            } catch {
                ; If we can't get the language attribute, just use the description
                voiceList.Push(current_voice.GetDescription())
            }
        }
        return voiceList
    }
} 