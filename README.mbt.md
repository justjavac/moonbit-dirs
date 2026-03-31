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
- `data`
- `data_local`
- `download`
- `tmp`

Unsupported names return `None`.

## Resolution summary

| Name | Linux | macOS | Windows |
| ---- | ----- | ----- | ------- |
| `home` | `HOME` | `HOME` | `USERPROFILE`, then `HOMEDRIVE` + `HOMEPATH` |
| `cache` | `XDG_CACHE_HOME`, then `HOME/.cache` | `HOME/Library/Caches` | `LOCALAPPDATA` |
| `config` | `XDG_CONFIG_HOME`, then `HOME/.config` | `HOME/Library/Preferences` | `APPDATA` |
| `data` | `XDG_DATA_HOME`, then `HOME/.local/share` | `HOME/Library/Application Support` | `APPDATA` |
| `data_local` | same as `data` | same as `data` | `LOCALAPPDATA` |
| `download` | `XDG_DOWNLOAD_DIR`, then `HOME/Downloads` | `HOME/Downloads` | `USERPROFILE/Downloads`, then `HOMEDRIVE` + `HOMEPATH` + `Downloads` |
| `tmp` | `XDG_RUNTIME_DIR/tmp`, then `TMPDIR`, `TEMP`, `TMP`, then `/var/tmp` | `TMPDIR` | `TMP`, then `TEMP` |

## Notes

- Source files live under `src/`.
- Platform inference is based on environment variables.
