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
/// | `"data"` | A directory for user-specific shared application data |
/// | `"data_local"` | A directory for user-specific machine-local application data |
/// | `"download"` | The user's downloads directory |
/// | `"tmp"` | The preferred temporary directory |
///
/// When the required variables are missing or the platform cannot be inferred,
/// the function returns `None`.
///
/// # Example
///
/// ```mbt check
/// test "dir agrees with dedicated helpers" {
///   assert_eq(@dirs.dir("cache"), @dirs.cache_dir())
///   assert_eq(@dirs.dir("tmp"), @dirs.tmp_dir())
///   assert_eq(@dirs.dir("unsupported"), None)
/// }
/// ```
pub fn dir(kind : String) -> String? {
  let envs = current_env()
  dir_for_env(kind, detect_platform(envs), envs)
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
  let envs = current_env()
  home_dir_for_env(detect_platform(envs), envs)
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
  let envs = current_env()
  cache_dir_for_env(detect_platform(envs), envs)
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
  let envs = current_env()
  config_dir_for_env(detect_platform(envs), envs)
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
  let envs = current_env()
  data_dir_for_env(detect_platform(envs), envs)
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
  let envs = current_env()
  data_local_dir_for_env(detect_platform(envs), envs)
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
  let envs = current_env()
  download_dir_for_env(detect_platform(envs), envs)
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
/// This function returns `None` only when the platform cannot be inferred or
/// the active platform exposes no usable temporary-directory environment
/// variable.
pub fn tmp_dir() -> String? {
  let envs = current_env()
  tmp_dir_for_env(detect_platform(envs), envs)
}
