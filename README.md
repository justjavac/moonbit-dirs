# moonbit-dirs

[![codecov](https://codecov.io/github/justjavac/moonbit-dirs/graph/badge.svg?branch=main)](https://app.codecov.io/github/justjavac/moonbit-dirs?branch=main)

Returns user-specific, platform-specific directory paths in pure MoonBit.

This project follows the implemented surface of [`justjavac/deno_dirs`](https://github.com/justjavac/deno_dirs), but exposes a MoonBit API and keeps the implementation free of C stubs or native glue code.

## Usage

```moonbit
let home_directory = @moonbit_dirs.dir("home")

let cache_directory = @moonbit_dirs.cache_dir()
let config_directory = @moonbit_dirs.config_dir()
let download_directory = @moonbit_dirs.download_dir()
```

The public API returns `String?`.

- `Some(path)` means the directory could be resolved.
- `None` means the current platform could not be inferred or the required environment variables were not available.

## Supported names

`dir(kind)` currently accepts:

- `"home"`
- `"cache"`
- `"config"`
- `"data"`
- `"data_local"`
- `"download"`
- `"tmp"`

Not yet implemented:

- `"executable"`
- `"audio"`
- `"desktop"`
- `"document"`
- `"font"`
- `"picture"`
- `"public"`
- `"template"`
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

### `data_local`

| Platform | Resolution |
| -------- | ---------- |
| Linux | Same as `data` |
| macOS | Same as `data` |
| Windows | `LOCALAPPDATA` |

### `download`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_DOWNLOAD_DIR`, then `HOME/Downloads` |
| macOS | `HOME/Downloads` |
| Windows | `USERPROFILE/Downloads`, then `HOMEDRIVE` + `HOMEPATH` + `Downloads` |

### `tmp`

| Platform | Resolution |
| -------- | ---------- |
| Linux | `XDG_RUNTIME_DIR/tmp`, then `TMPDIR`, `TEMP`, `TMP`, then `/var/tmp` |
| macOS | `TMPDIR` |
| Windows | `TMP`, then `TEMP` |

## Design notes

- Source files live under `src/`.
- The implementation is pure MoonBit.
- Platform detection is environment-driven instead of using native APIs.
- Tests cover the public API plus all internal resolution branches.

## Development

```powershell
moon fmt
moon check
moon test --enable-coverage
moon coverage report -f summary -p justjavac/moonbit_dirs
moon info
```

## License

MIT. See [LICENSE](./LICENSE).
