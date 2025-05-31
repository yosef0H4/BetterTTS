# BetterTTS

An AutoHotkey v2 application that combines OCR (text capture from screen) with Text-to-Speech functionality. Supports multiple languages with bilingual English/Arabic interface.

## ✨ Key Features

- **Screen OCR**: Capture text from any screen area (`CapsLock + X`)
- **Text-to-Speech**: Adjustable voice, volume, speed, and pitch controls
- **Voice Search**: Easy voice selection with search functionality
- **Multi-language**: Works with any installed Windows OCR language pack
- **Enhanced Voices**: Support for high-quality natural voices (Windows 11 Narrator, Edge, Azure)
- **Hotkey Controls**: Complete keyboard shortcuts for all functions
- **Bilingual Interface**: Switch between English and Arabic UI

## 🔧 Requirements

- **AutoHotkey v2**
- **Windows 10/11**
- **[Descolada's OCR Library](https://github.com/Descolada/OCR/)** (required)
- **Language packs** for desired OCR languages
- **[Natural Voice SAPI Adapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter)** (optional, for better voices)

## 📦 Quick Setup

1. **Install AutoHotkey v2** from [autohotkey.com](https://www.autohotkey.com/)
2. **Download this project** and place `OCR.ahk` from [Descolada's repo](https://github.com/Descolada/OCR/) in the same folder
3. **Add OCR languages**: Windows Settings → Time & Language → Language & region → Add language (with OCR feature)
4. **Get natural voices** (optional): Windows Settings → Accessibility → Narrator → "Add natural voices" -> add them using [Natural Voice SAPI Adapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter)
5. **Run `BetterTTS.ahk`**

## 🎮 Basic Usage

1. **Capture text**: `CapsLock + X`, then drag to select screen area
2. **Adjust voice settings** in the GUI (voice, volume, speed, pitch)
3. **Speak text**: `CapsLock + V` or click "Speak" button

### Alternative Text Input
- `CapsLock + A` - OCR from clipboard image
- `CapsLock + C` - Copy selected text from any app
- Type directly in the text area

## ⌨️ Essential Hotkeys

| Function | Hotkey |
|----------|--------|
| Capture screen text | `CapsLock + X` |
| Speak text | `CapsLock + V` |
| Pause/Resume | `CapsLock + P` |
| Stop speaking | `CapsLock + S` |
| Copy selected text | `CapsLock + C` |
| OCR from clipboard | `CapsLock + A` |
| Volume up/down | `CapsLock + ↑/↓` |
| Speed up/down | `CapsLock + →/←` |

## ⚠️ Important Notes

- **Clean Text Limitation**: The clean text feature (enabled by default) only preserves Arabic and English characters. **For other languages, disable "Clean Text" in Settings** to prevent text corruption.
- **Arabic OCR**: Lines may appear in reverse order (known limitation)


## 🔧 Common Issues

**No OCR languages available**
- Install language packs via Windows Settings → Language & region

**Text appears corrupted**
- For non-English/Arabic languages: disable "Clean Text" in Settings menu

**Poor voice quality**
- Install natural voices or Natural Voice SAPI Adapter

**OCR not working**
- Ensure clear text selection and correct language pack installed

## 📁 Project Files

```
BetterTTS/
├── BetterTTS.ahk          # Main application
├── OCRReaderGUI.ahk       # User interface
├── SpeechHandler.ahk      # Text-to-speech
├── VoiceSearchGUI.ahk     # Voice selection
├── RectangleCreator.ahk   # Screen selection
├── Highlighter.ahk        # Visual highlighting
├── OCR.ahk               # OCR library (download separately)
└── settings.ini          # Auto-generated settings
```

---

**Made with AutoHotkey v2** | [OCR Library](https://github.com/Descolada/OCR/) | [Natural Voice Adapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter)