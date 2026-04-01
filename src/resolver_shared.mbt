///|
/// Resolves a named directory using the supplied environment snapshot.
fn dir_for_env(kind : String, envs : Map[String, String]) -> String? {
  match kind {
    "home" => home_dir_for_env(envs)
    "cache" => cache_dir_for_env(envs)
    "config" => config_dir_for_env(envs)
    "executable" => executable_dir_for_env(envs)
    "data" => data_dir_for_env(envs)
    "data_local" => data_local_dir_for_env(envs)
    "audio" => audio_dir_for_env(envs)
    "desktop" => desktop_dir_for_env(envs)
    "document" => document_dir_for_env(envs)
    "download" => download_dir_for_env(envs)
    "font" => font_dir_for_env(envs)
    "picture" => picture_dir_for_env(envs)
    "public" => public_dir_for_env(envs)
    "template" => template_dir_for_env(envs)
    "tmp" => tmp_dir_for_env(envs)
    "video" => video_dir_for_env(envs)
    _ => None
  }
}

///|
/// Joins two path segments with the official platform-specific path implementation.
#cfg(all(target="native", platform="windows"))
fn join_path(base : String, child : String) -> String {
  @win32.Path::join(base, child).to_string()
}

///|
/// Joins two path segments with the official platform-specific path implementation.
#cfg(not(all(target="native", platform="windows")))
fn join_path(base : String, child : String) -> String {
  @posix.Path::join(base, child).to_string()
}

///|
/// Normalizes a path using the official platform-specific path implementation.
#cfg(all(target="native", platform="windows"))
fn normalize_path(path : String) -> String {
  @win32.Path::normalize(path).to_string()
}

///|
/// Normalizes a path using the official platform-specific path implementation.
#cfg(not(all(target="native", platform="windows")))
fn normalize_path(path : String) -> String {
  @posix.Path::normalize(path).to_string()
}

///|
/// Joins HOMEDRIVE and HOMEPATH when USERPROFILE is unavailable.
fn home_drive_path(envs : Map[String, String]) -> String? {
  match (env_value(envs, "HOMEDRIVE"), env_value(envs, "HOMEPATH")) {
    (Some(drive), Some(path)) => Some("\{drive}\{path}")
    _ => None
  }
}

///|
/// Resolves a home-relative directory by name.
fn home_named_dir_for_env(envs : Map[String, String], name : String) -> String? {
  match home_dir_for_env(envs) {
    Some(home) => Some(join_path(home, name))
    None => None
  }
}

///|
/// Resolves an XDG-style user directory with a conventional home fallback.
fn user_dir_for_env(
  envs : Map[String, String],
  env_key : String,
  fallback_name : String,
) -> String? {
  match env_value(envs, env_key) {
    Some(path) => Some(path)
    None => home_named_dir_for_env(envs, fallback_name)
  }
}
