///|
/// Returns a user-specific directory path for one of the supported directory names.
///
/// This function is the MoonBit equivalent of `dir("name")` from
/// [`justjavac/deno_dirs`](https://github.com/justjavac/deno_dirs). It accepts
/// the following names:
///
/// | Name | Meaning |
/// | ---- | ------- |
/// | `"home"` | The current user's home directory |
/// | `"cache"` | A directory for cached, disposable data |
/// | `"config"` | A directory for user-specific configuration files |
/// | `"executable"` | A directory for user-specific executables |
/// | `"data"` | A directory for user-specific shared application data |
/// | `"data_local"` | A directory for user-specific machine-local application data |
/// | `"audio"` | The user's music directory |
/// | `"desktop"` | The user's desktop directory |
/// | `"document"` | The user's documents directory |
/// | `"download"` | The user's downloads directory |
/// | `"font"` | The user's font directory |
/// | `"picture"` | The user's pictures directory |
/// | `"public"` | A public shared directory |
/// | `"template"` | The user's templates directory |
/// | `"tmp"` | The preferred temporary directory |
/// | `"video"` | The user's videos directory |
///
/// When the required variables are missing, or when the current compilation
/// target does not define the requested directory, the function returns `None`.
///
/// # Example
///
/// ```mbt check
/// test "dir agrees with dedicated helpers" {
///   assert_true(@dirs.dir("cache") == @dirs.cache_dir())
///   assert_true(@dirs.dir("tmp") == @dirs.tmp_dir())
///   assert_true(@dirs.dir("unsupported") is None)
/// }
/// ```
pub fn dir(kind : String) -> String? {
  dir_for_env(kind, current_env())
}

///|
/// Returns the current user's home directory.
///
/// Resolution follows the same platform rules as `deno_dirs`:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `HOME` |
/// | macOS | `HOME` |
/// | Windows | `USERPROFILE`, then `HOMEDRIVE` + `HOMEPATH` |
///
/// If none of the relevant environment variables are available, this function
/// returns `None`.
pub fn home_dir() -> String? {
  home_dir_for_env(current_env())
}

///|
/// Returns the current user's cache directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_CACHE_HOME`, then `HOME/.cache` |
/// | macOS | `HOME/Library/Caches` |
/// | Windows | `LOCALAPPDATA` |
///
/// The function returns `None` when no applicable location can be constructed.
pub fn cache_dir() -> String? {
  cache_dir_for_env(current_env())
}

///|
/// Returns the current user's configuration directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_CONFIG_HOME`, then `HOME/.config` |
/// | macOS | `HOME/Library/Preferences` |
/// | Windows | `APPDATA` |
///
/// The function returns `None` when the required environment variables are not
/// available.
pub fn config_dir() -> String? {
  config_dir_for_env(current_env())
}

///|
/// Returns the current user's executable directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_BIN_HOME`, then `XDG_DATA_HOME/../bin`, then `HOME/.local/bin` |
/// | macOS | Not defined |
/// | Windows | Not defined |
///
/// The function returns `None` on platforms where no standard user executable
/// directory is defined.
pub fn executable_dir() -> String? {
  executable_dir_for_env(current_env())
}

///|
/// Returns the current user's shared application data directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_DATA_HOME`, then `HOME/.local/share` |
/// | macOS | `HOME/Library/Application Support` |
/// | Windows | `APPDATA` |
///
/// Use this location for data that should roam with the user profile when the
/// platform supports it.
pub fn data_dir() -> String? {
  data_dir_for_env(current_env())
}

///|
/// Returns the current user's machine-local application data directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | Same as `data_dir()` |
/// | macOS | Same as `data_dir()` |
/// | Windows | `LOCALAPPDATA` |
///
/// This is the recommended location for data that should stay on the current
/// machine instead of roaming with the profile.
pub fn data_local_dir() -> String? {
  data_local_dir_for_env(current_env())
}

///|
/// Returns the current user's music directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_MUSIC_DIR`, then `HOME/Music` |
/// | macOS | `HOME/Music` |
/// | Windows | `USERPROFILE/Music`, then `HOMEDRIVE` + `HOMEPATH` + `Music` |
pub fn audio_dir() -> String? {
  audio_dir_for_env(current_env())
}

///|
/// Returns the current user's desktop directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_DESKTOP_DIR`, then `HOME/Desktop` |
/// | macOS | `HOME/Desktop` |
/// | Windows | `USERPROFILE/Desktop`, then `HOMEDRIVE` + `HOMEPATH` + `Desktop` |
pub fn desktop_dir() -> String? {
  desktop_dir_for_env(current_env())
}

///|
/// Returns the current user's documents directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_DOCUMENTS_DIR`, then `HOME/Documents` |
/// | macOS | `HOME/Documents` |
/// | Windows | `USERPROFILE/Documents`, then `HOMEDRIVE` + `HOMEPATH` + `Documents` |
pub fn document_dir() -> String? {
  document_dir_for_env(current_env())
}

///|
/// Returns the current user's downloads directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_DOWNLOAD_DIR`, then `HOME/Downloads` |
/// | macOS | `HOME/Downloads` |
/// | Windows | `USERPROFILE/Downloads`, then `HOMEDRIVE` + `HOMEPATH` + `Downloads` |
///
/// The function returns `None` when no home directory can be derived.
pub fn download_dir() -> String? {
  download_dir_for_env(current_env())
}

///|
/// Returns the current user's font directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_DATA_HOME/fonts`, then `HOME/.local/share/fonts` |
/// | macOS | `HOME/Library/Fonts` |
/// | Windows | Not defined |
pub fn font_dir() -> String? {
  font_dir_for_env(current_env())
}

///|
/// Returns the current user's pictures directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_PICTURES_DIR`, then `HOME/Pictures` |
/// | macOS | `HOME/Pictures` |
/// | Windows | `USERPROFILE/Pictures`, then `HOMEDRIVE` + `HOMEPATH` + `Pictures` |
pub fn picture_dir() -> String? {
  picture_dir_for_env(current_env())
}

///|
/// Returns the public shared directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_PUBLICSHARE_DIR`, then `HOME/Public` |
/// | macOS | `HOME/Public` |
/// | Windows | `PUBLIC`, then `SYSTEMDRIVE\\Users\\Public` |
pub fn public_dir() -> String? {
  public_dir_for_env(current_env())
}

///|
/// Returns the current user's templates directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_TEMPLATES_DIR`, then `HOME/Templates` |
/// | macOS | Not defined |
/// | Windows | `APPDATA/Microsoft/Windows/Templates` |
pub fn template_dir() -> String? {
  template_dir_for_env(current_env())
}

///|
/// Returns the preferred temporary directory for the current user session.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_RUNTIME_DIR/tmp`, then `TMPDIR`, `TEMP`, `TMP`, then `/var/tmp` |
/// | macOS | `TMPDIR` |
/// | Windows | `TMP`, then `TEMP` |
///
/// This function returns `None` only when the current compilation target does
/// not define a temporary-directory location, or when the active platform
/// exposes no usable temporary-directory environment variable.
pub fn tmp_dir() -> String? {
  tmp_dir_for_env(current_env())
}

///|
/// Returns the current user's videos directory.
///
/// Platform-specific resolution:
///
/// | Platform | Resolution order |
/// | -------- | ---------------- |
/// | Linux | `XDG_VIDEOS_DIR`, then `HOME/Videos` |
/// | macOS | `HOME/Movies` |
/// | Windows | `USERPROFILE/Videos`, then `HOMEDRIVE` + `HOMEPATH` + `Videos` |
pub fn video_dir() -> String? {
  video_dir_for_env(current_env())
}
