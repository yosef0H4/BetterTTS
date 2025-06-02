# BetterTTS

An AutoHotkey v2 application combining OCR (screen text capture) with Text-to-Speech functionality. Features bilingual English/Arabic interface and natural voice support.

## ✨ Features

- **Screen OCR**: Capture text from any area (`CapsLock + X`)
- **Standard TTS**: Built-in Windows voices (reliable and officially supported)
- **Enhanced TTS**: Optional high-quality natural voices (see warnings below)
- **Voice Search**: Easy voice selection with search
- **Multi-language**: Works with any Windows OCR language pack
- **Hotkey Controls**: Complete keyboard shortcuts
- **Bilingual UI**: English/Arabic interface switching
- **Runs locally**: No internet connection required (except for OCR pack installation)

## 💻 Requirements

- **Windows 10/11**
- **AutoHotkey v2** (for source)
- **Language packs** for desired OCR languages

## 📥 Quick Setup

### Binary Installation (Recommended for People with no coding experience)
1. Download latest `.exe` from [Releases](../../releases)
2. Run executable
3. The app works perfectly with standard Windows voices

### Source Installation (More recommended but requires coding knowledge)
1. Install [AutoHotkey v2](https://www.autohotkey.com/)
2. Download `OCR.ahk` from [Descolada's repo](https://github.com/Descolada/OCR/)
3. Place in same folder and run `BetterTTS.ahk`
4. Double click BetterTTS.ahk or build it with Ahk2Exe

## ⚠️ Enhanced Natural Voices (Optional - Use at Your Own Risk)

**IMPORTANT WARNINGS**:

> ⚠️ **Legal Gray Area**: NaturalVoiceSAPIAdapter operates by extracting encryption keys from system files and accessing voices not officially made available to third-party applications. Microsoft has not authorized this usage.

>  **Technical Risks**: 
> - May stop working after Windows updates
> - Uses unofficial methods that could be patched by Microsoft
> - Described by its own author as "more like a hack than a proper solution"

>  **Stability**: No guarantee of continued functionality. Microsoft could block this at any time.

**If you choose to proceed despite these risks**:

1. **First**: Install [NaturalVoiceSAPIAdapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter) at your own discretion
2. **Then add voices**:
   - **Windows 11**: Settings → Accessibility → Narrator → "Add natural voices"
   - **Edge voices**: NaturalVoiceSAPIAdapter can also make Edge TTS voices available
3. **Restart BetterTTS** to see new voices in the dropdown

**Safer alternatives**:
- Use built-in Windows SAPI voices (included with Windows)
- Purchase commercial TTS solutions
- Use cloud-based TTS APIs for applications requiring high-quality voices

## 📝 OCR Languages Installation

- **In-app**: Settings → Install OCR Languages (requires admin)
- **PowerShell**: See [Microsoft docs](https://learn.microsoft.com/en-us/windows/powertoys/text-extractor#supported-languages) (Recommended)

## ⌨️ Essential Hotkeys

| Function | Hotkey | Description |
|----------|--------|-------------|
| **Capture text** | `CapsLock + X` | Click-drag to OCR area |
| **Copy selection** | `CapsLock + C` | OCR selected text |
| **Speak text** | `CapsLock + V` | Start speech |
| **Pause/Resume** | `CapsLock + P` | Toggle playback |
| **Stop** | `CapsLock + S` | Stop speech |
| **Refresh OCR** | `CapsLock + R` | Re-OCR same area |
| **Volume** | `CapsLock + ↑/↓` | Adjust volume |
| **Speed** | `CapsLock + →/←` | Adjust speed |

> View all hotkeys in Help menu

## 🎮 Quick Start

1. Press `CapsLock + X` and drag to select text area
2. Text appears in the interface
3. Press `CapsLock + V` to hear it spoken
4. Use `CapsLock + C` for already selected text

## 🔧 Troubleshooting

**OCR not working**: Install language packs via Settings → Install OCR Languages  
**No enhanced voices**: This is normal - BetterTTS works great with standard Windows voices. Enhanced voices require the optional (and risky) NaturalVoiceSAPIAdapter  
**Admin required**: Only needed for language pack management  
**Arabic text reversed**: Known limitation, lines may appear in reverse order  

## 📁 Project Structure

```
BetterTTS/
├── BetterTTS.ahk          # Main application
├── OCRReaderGUI.ahk       # User interface
├── SpeechHandler.ahk      # Text-to-speech engine
├── VoiceSearchGUI.ahk     # Voice selection dialog
├── RectangleCreator.ahk   # Screen selection tool
├── Highlighter.ahk        # Visual feedback
├── OCR.ahk               # OCR library (download separately)
└── settings.ini          # Auto-generated settings
```

## 🛡️ Legal & Safety Notice

**BetterTTS Core**: Fully safe and legal for personal and commercial use under MIT license.

**Recommendation**: Start with the core application using standard Windows voices. Only consider enhanced voices if you understand and accept the associated risks.

## 🙏 Credits

- **[Descolada](https://github.com/Descolada/OCR/)** - OCR Library for AutoHotkey v2
- **[gexgd0419](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter)** - NaturalVoiceSAPIAdapter (optional third-party enhancement)
- **AutoHotkey Community** - For the scripting language

---

**Version:** v1.0 | **License:** MIT | **Made with AutoHotkey v2**

> **Disclaimer**: BetterTTS core functionality is safe and reliable. Optional enhancements using NaturalVoiceSAPIAdapter are provided as-is and users assume all associated risks.
