# BetterTTS

An AutoHotkey v2 application that combines OCR (text capture from screen) with Text-to-Speech functionality. Supports multiple languages with bilingual English/Arabic interface.

## ✨ Key Features

- **Screen OCR**: Capture text from any screen area (`CapsLock + X`)
- **Text-to-Speech**: Adjustable voice, volume, speed, and pitch controls
- **Voice Search**: Easy voice selection with search functionality
- **Multi-language**: Works with any installed Windows OCR language pack
- **Enhanced Voices**: Support for high-quality natural voices (Windows 11 Narrator, Edge)
- **Hotkey Controls**: Complete keyboard shortcuts for all functions
- **Bilingual Interface**: Switch between English and Arabic UI

## 📥 Installation

1. Download the latest binary from the [Releases](../../releases).
2. Run the executable.
3. (Optional) For natural voices, go to Windows Settings → Accessibility → Narrator → "Add natural voices." Alternatively, you can use the [Natural Voice SAPI Adapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter) to download Edge voices.
4. For OCR in different languages, open the application, go to `⚙️ Settings` → `📦 Install OCR Languages`, and install the desired language packs.

**Note 1**: OCR language packs should be installed by default when you install a language pack in Windows.
**Note 2**: While the in-app installer offers a simpler solution, for more reliable installation or troubleshooting, it is recommended to use PowerShell commands as described in the [Microsoft Text Extractor documentation](https://learn.microsoft.com/en-us/windows/powertoys/text-extractor#supported-languages).

## 🔧 Requirements

- **AutoHotkey v2**
- **Windows 10/11**
- **[Descolada's OCR Library](https://github.com/Descolada/OCR/)** (required)
- **Language packs** for desired OCR languages
- **[Natural Voice SAPI Adapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter)** (optional, for better voices, you can also use it download the edge voices)

## 📦 Quick Setup

1. **Install AutoHotkey v2** from [autohotkey.com](https://www.autohotkey.com/)
2. **Download this project** and place `OCR.ahk` from [Descolada's repo](https://github.com/Descolada/OCR/) in the same folder
3. **Add OCR languages**: Windows Settings → Time & Language → Language & region → Add language (with OCR feature)
4. **Get natural voices** (optional): Windows Settings → Accessibility → Narrator → "Add natural voices" -> add them using [Natural Voice SAPI Adapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter)
5. **Run `BetterTTS.ahk`**

## 🎮 Basic Usage

1. Select the text you want to speak then press `CapsLock + C`
2. Press `CapsLock + X` To capture the area (Rectangle) release the button to capture the text (OCR)
3. Press `CapsLock + V` to repeat the text
4. Press `CapsLock + R` to reload the last OCR (Useful in places where text changes in the same place)


## ⌨️ Essential Hotkeys

| Function | Hotkey |
|----------|--------|
| Capture screen text | `CapsLock + X` |
| Speak text | `CapsLock + V` |
| Pause/Resume | `CapsLock + P` |
| Stop speaking | `CapsLock + S` |
| Copy selected text | `CapsLock + C` |
| Reloads the last OCR | `CapsLock + R` |
| Volume up/down | `CapsLock + ↑/↓` |
| Speed up/down | `CapsLock + →/←` |

You can view help to see all the hotkeys

## ⚠️ Important Notes

- **Admin Privileges**: The application requires administrator privileges for installing, uninstalling, or refreshing OCR languages. Once installed and saved, it doesn't need them anymore.
- **Arabic OCR**: Lines may appear in reverse order (known limitation)


## 🔧 Common Issues

**No OCR languages available**
- Ensure the desired OCR language pack is installed. You can do this through the application's `⚙️ Settings` → `📦 Install OCR Languages` menu. Alternatively, for more detailed management or troubleshooting, refer to the [Microsoft Text Extractor documentation](https://learn.microsoft.com/en-us/windows/powertoys/text-extractor#supported-languages) for PowerShell commands.



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
- psss secret You can bypass speed limt by entering the speed manually in the textbox
---

**Made with AutoHotkey v2** | [OCR Library](https://github.com/Descolada/OCR/) | [Natural Voice Adapter](https://github.com/gexgd0419/NaturalVoiceSAPIAdapter)
