## 💻 Requirements

- **Windows 10/11**
- **AutoHotkey v2** (for source)


An AutoHotkey v2 application combining OCR (screen text capture) with Text-to-Speech functionality. Features bilingual English/Arabic interface and natural voice support.

## ✨ Features

- **Screen OCR**: Capture text from any area (`CapsLock + X`)
- **Natural TTS**: High-quality voices with full control (requires [NaturalVoiceSAPIAdapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter))
- **Voice Search**: Easy voice selection with search
- **Multi-language**: Works with any Windows OCR language pack
- **Hotkey Controls**: Complete keyboard shortcuts
- **Bilingual UI**: English/Arabic interface switching

## 📥 Quick Setup

### Binary Installation (Recommended for People with no coding experience)
1. Download latest `.exe` from [Releases](../../releases)
2. Run executable
3. *(Optional)* For natural voices: add voices from Windows Settings then Install [NaturalVoiceSAPIAdapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter) and follow their steps.

### Source Installation (More recommended but requires coding knowledge)
1. Install [AutoHotkey v2](https://www.autohotkey.com/)
2. Download `OCR.ahk` from [Descolada's repo](https://github.com/Descolada/OCR/)
3. Place in same folder and run `BetterTTS.ahk`

## 🎙️ Enable Natural Voices (Optional)

**Required**: Install [NaturalVoiceSAPIAdapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter) first

**Then add voices**:
1. **Windows 11**: Settings → Accessibility → Narrator → "Add natural voices"
2. **Edge voices**: NaturalVoiceSAPIAdapter can also make Edge TTS voices available
3. **Restart BetterTTS** to see new voices in the dropdown

## 📝 OCR Languages installation

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
**No natural voices**: Install [NaturalVoiceSAPIAdapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter), then add voices from Windows Settings  
**Admin required**: Only needed for language pack management  
**Arabic text reversed**: Known limitation, lines may appear in reverse order

> **Note**: NaturalVoiceSAPIAdapter is required to make Windows natural voices and Edge voices available in the app

## 💻 Requirements

- **Windows 10/11**
- **AutoHotkey v2** (for source)
- **Language packs** for desired OCR languages

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

## 🙏 Credits

- **[Descolada](https://github.com/Descolada/OCR/)** - OCR Library for AutoHotkey v2
- **[gexgd0419](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter)** - NaturalVoiceSAPIAdapter (essential for natural voices)
- **AutoHotkey Community** - For the scripting language

---

**Version:** v1.0 | **License:** MIT | **Made with AutoHotkey v2**
