///|
/// Models the operating system family inferred from environment variables.
priv enum Platform {
  Linux
  Darwin
  Windows
  Unknown
}

///|
/// Reads the current process environment into a map.
fn current_env() -> Map[String, String] {
  @env.get_env_vars()
}

///|
/// Infers the current operating system family from well-known environment variables.
fn detect_platform(envs : Map[String, String]) -> Platform {
  if looks_like_windows(envs) {
    Windows
  } else if looks_like_darwin(envs) {
    Darwin
  } else if looks_like_linux(envs) {
    Linux
  } else {
    Unknown
  }
}

///|
/// Returns whether the environment looks like a Windows process.
fn looks_like_windows(envs : Map[String, String]) -> Bool {
  env_matches(envs, "OS", "windows_nt") ||
  has_any_env(envs, ["USERPROFILE", "LOCALAPPDATA", "APPDATA"]) ||
  (
    env_value(envs, "HOMEDRIVE") is Some(_) &&
    env_value(envs, "HOMEPATH") is Some(_)
  )
}

///|
/// Returns whether the environment looks like a macOS process.
fn looks_like_darwin(envs : Map[String, String]) -> Bool {
  env_contains(envs, "OSTYPE", "darwin") ||
  env_contains(envs, "OSTYPE", "macos") ||
  env_contains(envs, "MACHTYPE", "apple") ||
  env_starts_with(envs, "HOME", "/Users/")
}

///|
/// Returns whether the environment looks like a Linux process.
fn looks_like_linux(envs : Map[String, String]) -> Bool {
  has_any_env(envs, [
    "XDG_CACHE_HOME", "XDG_CONFIG_HOME", "XDG_DATA_HOME", "XDG_RUNTIME_DIR", "XDG_DOWNLOAD_DIR",
  ]) ||
  env_contains(envs, "OSTYPE", "linux") ||
  env_contains(envs, "OSTYPE", "gnu") ||
  env_value(envs, "HOME") is Some(_)
}

///|
/// Returns the first non-blank environment value for the provided keys.
fn first_env(envs : Map[String, String], keys : Array[String]) -> String? {
  for key in keys {
    match env_value(envs, key) {
      Some(value) => break Some(value)
      None => continue
    }
  } nobreak {
    None
  }
}

///|
/// Returns true when any of the keys has a non-blank environment value.
fn has_any_env(envs : Map[String, String], keys : Array[String]) -> Bool {
  first_env(envs, keys) is Some(_)
}

///|
/// Returns a non-blank environment value after trimming whitespace-only entries.
fn env_value(envs : Map[String, String], key : String) -> String? {
  match envs.get(key) {
    Some(value) if !is_blank(value) => Some(value)
    _ => None
  }
}

///|
/// Returns whether an environment value equals the expected string case-insensitively.
fn env_matches(
  envs : Map[String, String],
  key : String,
  expected : String,
) -> Bool {
  match env_value(envs, key) {
    Some(value) => value.to_lower() == expected.to_lower()
    None => false
  }
}

///|
/// Returns whether an environment value contains the expected substring case-insensitively.
fn env_contains(
  envs : Map[String, String],
  key : String,
  needle : String,
) -> Bool {
  match env_value(envs, key) {
    Some(value) => value.to_lower().contains(needle.to_lower())
    None => false
  }
}

///|
/// Returns whether an environment value starts with the expected prefix.
fn env_starts_with(
  envs : Map[String, String],
  key : String,
  prefix : String,
) -> Bool {
  match env_value(envs, key) {
    Some(value) => value[:].has_prefix(prefix)
    None => false
  }
}

///|
/// Returns true when the string contains only whitespace or is empty.
fn is_blank(value : String) -> Bool {
  value.trim().length() == 0
}
