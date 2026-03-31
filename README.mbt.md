# justjavac/dirs

[![codecov](https://codecov.io/github/justjavac/moonbit-dirs/graph/badge.svg?branch=main)](https://app.codecov.io/github/justjavac/moonbit-dirs?branch=main)

MoonBit helpers for resolving user-specific directory paths on Linux, macOS, and Windows.

## Example

```mbt check
test "public API stays consistent" {
  assert_eq(@dirs.dir("cache"), @dirs.cache_dir())
  assert_eq(@dirs.dir("download"), @dirs.download_dir())
  assert_eq(@dirs.dir("tmp"), @dirs.tmp_dir())
}
```

## Supported names

- `home`
- `cache`
- `config`
- `executable`
- `data`
- `data_local`
- `audio`
- `desktop`
- `document`
- `download`
- `font`
- `picture`
- `public`
- `template`
- `tmp`
- `video`

Unsupported names return `None`.

## Resolution summary

| Name | Linux | macOS | Windows |
| ---- | ----- | ----- | ------- |
| `home` | `HOME` | `HOME` | `USERPROFILE`, then `HOMEDRIVE` + `HOMEPATH` |
| `cache` | `XDG_CACHE_HOME`, then `HOME/.cache` | `HOME/Library/Caches` | `LOCALAPPDATA` |
| `config` | `XDG_CONFIG_HOME`, then `HOME/.config` | `HOME/Library/Preferences` | `APPDATA` |
| `executable` | `XDG_BIN_HOME`, then `XDG_DATA_HOME/../bin`, then `HOME/.local/bin` | not defined | not defined |
| `data` | `XDG_DATA_HOME`, then `HOME/.local/share` | `HOME/Library/Application Support` | `APPDATA` |
| `data_local` | same as `data` | same as `data` | `LOCALAPPDATA` |
| `audio` | `XDG_MUSIC_DIR`, then `HOME/Music` | `HOME/Music` | `USERPROFILE/Music`, then `HOMEDRIVE` + `HOMEPATH` + `Music` |
| `desktop` | `XDG_DESKTOP_DIR`, then `HOME/Desktop` | `HOME/Desktop` | `USERPROFILE/Desktop`, then `HOMEDRIVE` + `HOMEPATH` + `Desktop` |
| `document` | `XDG_DOCUMENTS_DIR`, then `HOME/Documents` | `HOME/Documents` | `USERPROFILE/Documents`, then `HOMEDRIVE` + `HOMEPATH` + `Documents` |
| `download` | `XDG_DOWNLOAD_DIR`, then `HOME/Downloads` | `HOME/Downloads` | `USERPROFILE/Downloads`, then `HOMEDRIVE` + `HOMEPATH` + `Downloads` |
| `font` | `XDG_DATA_HOME/fonts`, then `HOME/.local/share/fonts` | `HOME/Library/Fonts` | not defined |
| `picture` | `XDG_PICTURES_DIR`, then `HOME/Pictures` | `HOME/Pictures` | `USERPROFILE/Pictures`, then `HOMEDRIVE` + `HOMEPATH` + `Pictures` |
| `public` | `XDG_PUBLICSHARE_DIR`, then `HOME/Public` | `HOME/Public` | `PUBLIC`, then `SYSTEMDRIVE\\Users\\Public` |
| `template` | `XDG_TEMPLATES_DIR`, then `HOME/Templates` | not defined | `APPDATA/Microsoft/Windows/Templates` |
| `tmp` | `XDG_RUNTIME_DIR/tmp`, then `TMPDIR`, `TEMP`, `TMP`, then `/var/tmp` | `TMPDIR` | `TMP`, then `TEMP` |
| `video` | `XDG_VIDEOS_DIR`, then `HOME/Videos` | `HOME/Movies` | `USERPROFILE/Videos`, then `HOMEDRIVE` + `HOMEPATH` + `Videos` |

## Notes

- Source files live under `src/`.
- Platform inference is based on environment variables.
