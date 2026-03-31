# moonbit-dirs

[![codecov](https://codecov.io/github/justjavac/moonbit-dirs/graph/badge.svg?branch=main)](https://app.codecov.io/github/justjavac/moonbit-dirs?branch=main)

Returns user-specific, platform-specific directory paths.

This project follows the implemented surface of [`justjavac/deno_dirs`](https://github.com/justjavac/deno_dirs) and exposes a MoonBit API.

## Usage

```moonbit
let home_directory = @dirs.dir("home")

let cache_directory = @dirs.cache_dir()
let config_directory = @dirs.config_dir()
let download_directory = @dirs.download_dir()
```

The public API returns `String?`.

- `Some(path)` means the directory could be resolved.
- `None` means the current platform could not be inferred or the required environment variables were not available.

## Supported names

`dir(kind)` currently accepts:

- `"home"`
- `"cache"`
- `"config"`
- `"executable"`
- `"data"`
- `"data_local"`
- `"audio"`
- `"desktop"`
- `"document"`
- `"download"`
- `"font"`
- `"picture"`
- `"public"`
- `"template"`
- `"tmp"`
- `"video"`

## Directory rules

### `home`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `HOME` |
| macOS | `HOME` |
| Windows | `USERPROFILE`, then `HOMEDRIVE` + `HOMEPATH` |

### `cache`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_CACHE_HOME`, then `HOME/.cache` |
| macOS | `HOME/Library/Caches` |
| Windows | `LOCALAPPDATA` |

### `config`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_CONFIG_HOME`, then `HOME/.config` |
| macOS | `HOME/Library/Preferences` |
| Windows | `APPDATA` |

### `data`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_DATA_HOME`, then `HOME/.local/share` |
| macOS | `HOME/Library/Application Support` |
| Windows | `APPDATA` |

### `executable`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_BIN_HOME`, then `XDG_DATA_HOME/../bin`, then `HOME/.local/bin` |
| macOS | Not defined |
| Windows | Not defined |

### `data_local`

| Platform | Resolution |
| -------- | ---------- |
| Linux | Same as `data` |
| macOS | Same as `data` |
| Windows | `LOCALAPPDATA` |

### `audio`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_MUSIC_DIR`, then `HOME/Music` |
| macOS | `HOME/Music` |
| Windows | `USERPROFILE/Music`, then `HOMEDRIVE` + `HOMEPATH` + `Music` |

### `desktop`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_DESKTOP_DIR`, then `HOME/Desktop` |
| macOS | `HOME/Desktop` |
| Windows | `USERPROFILE/Desktop`, then `HOMEDRIVE` + `HOMEPATH` + `Desktop` |

### `document`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_DOCUMENTS_DIR`, then `HOME/Documents` |
| macOS | `HOME/Documents` |
| Windows | `USERPROFILE/Documents`, then `HOMEDRIVE` + `HOMEPATH` + `Documents` |

### `download`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_DOWNLOAD_DIR`, then `HOME/Downloads` |
| macOS | `HOME/Downloads` |
| Windows | `USERPROFILE/Downloads`, then `HOMEDRIVE` + `HOMEPATH` + `Downloads` |

### `font`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_DATA_HOME/fonts`, then `HOME/.local/share/fonts` |
| macOS | `HOME/Library/Fonts` |
| Windows | Not defined |

### `picture`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_PICTURES_DIR`, then `HOME/Pictures` |
| macOS | `HOME/Pictures` |
| Windows | `USERPROFILE/Pictures`, then `HOMEDRIVE` + `HOMEPATH` + `Pictures` |

### `public`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_PUBLICSHARE_DIR`, then `HOME/Public` |
| macOS | `HOME/Public` |
| Windows | `PUBLIC`, then `SYSTEMDRIVE\\Users\\Public` |

### `template`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_TEMPLATES_DIR`, then `HOME/Templates` |
| macOS | Not defined |
| Windows | `APPDATA/Microsoft/Windows/Templates` |

### `tmp`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_RUNTIME_DIR/tmp`, then `TMPDIR`, `TEMP`, `TMP`, then `/var/tmp` |
| macOS | `TMPDIR` |
| Windows | `TMP`, then `TEMP` |

### `video`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_VIDEOS_DIR`, then `HOME/Videos` |
| macOS | `HOME/Movies` |
| Windows | `USERPROFILE/Videos`, then `HOMEDRIVE` + `HOMEPATH` + `Videos` |

## Design notes

- Source files live under `src/`.
- Tests cover the public API plus all internal resolution branches.

## Development

```powershell
moon fmt
moon check
moon test --enable-coverage
moon coverage report -f summary
moon info
```

## License

MIT. See [LICENSE](./LICENSE).
