# justjavac/dirs

Directory helpers for Linux, macOS, and Windows.

## Example

```mbt check
test "dir delegates to named helpers" {
  assert_eq(@dirs.dir("cache"), @dirs.cache_dir())
  assert_eq(@dirs.dir("config"), @dirs.config_dir())
}
```

## Supported names

`dir(kind)` supports:

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

Each public function includes detailed documentation for platform-specific behavior.
