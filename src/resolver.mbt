///|
/// Resolves a named directory using the supplied environment snapshot and platform.
fn dir_for_env(
  kind : String,
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match kind {
    "home" => home_dir_for_env(platform, envs)
    "cache" => cache_dir_for_env(platform, envs)
    "config" => config_dir_for_env(platform, envs)
    "data" => data_dir_for_env(platform, envs)
    "data_local" => data_local_dir_for_env(platform, envs)
    "download" => download_dir_for_env(platform, envs)
    "tmp" => tmp_dir_for_env(platform, envs)
    _ => None
  }
}

///|
/// Resolves the user's home directory.
fn home_dir_for_env(platform : Platform, envs : Map[String, String]) -> String? {
  match platform {
    Linux | Darwin => env_value(envs, "HOME")
    Windows =>
      match env_value(envs, "USERPROFILE") {
        Some(profile) => Some(profile)
        None => home_drive_path(envs)
      }
    Unknown => None
  }
}

///|
/// Resolves the user's cache directory.
fn cache_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux =>
      match env_value(envs, "XDG_CACHE_HOME") {
        Some(path) => Some(path)
        None =>
          match home_dir_for_env(platform, envs) {
            Some(home) => Some(join_path(platform, home, ".cache"))
            None => None
          }
      }
    Darwin =>
      match home_dir_for_env(platform, envs) {
        Some(home) =>
          Some(
            join_path(platform, join_path(platform, home, "Library"), "Caches"),
          )
        None => None
      }
    Windows => env_value(envs, "LOCALAPPDATA")
    Unknown => None
  }
}

///|
/// Resolves the user's configuration directory.
fn config_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux =>
      match env_value(envs, "XDG_CONFIG_HOME") {
        Some(path) => Some(path)
        None =>
          match home_dir_for_env(platform, envs) {
            Some(home) => Some(join_path(platform, home, ".config"))
            None => None
          }
      }
    Darwin =>
      match home_dir_for_env(platform, envs) {
        Some(home) =>
          Some(
            join_path(
              platform,
              join_path(platform, home, "Library"),
              "Preferences",
            ),
          )
        None => None
      }
    Windows => env_value(envs, "APPDATA")
    Unknown => None
  }
}

///|
/// Resolves the user's shared application data directory.
fn data_dir_for_env(platform : Platform, envs : Map[String, String]) -> String? {
  match platform {
    Linux =>
      match env_value(envs, "XDG_DATA_HOME") {
        Some(path) => Some(path)
        None =>
          match home_dir_for_env(platform, envs) {
            Some(home) =>
              Some(
                join_path(
                  platform,
                  join_path(platform, home, ".local"),
                  "share",
                ),
              )
            None => None
          }
      }
    Darwin =>
      match home_dir_for_env(platform, envs) {
        Some(home) =>
          Some(
            join_path(
              platform,
              join_path(platform, home, "Library"),
              "Application Support",
            ),
          )
        None => None
      }
    Windows => env_value(envs, "APPDATA")
    Unknown => None
  }
}

///|
/// Resolves the user's machine-local application data directory.
fn data_local_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux | Darwin => data_dir_for_env(platform, envs)
    Windows => env_value(envs, "LOCALAPPDATA")
    Unknown => None
  }
}

///|
/// Resolves the user's downloads directory.
fn download_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux =>
      match env_value(envs, "XDG_DOWNLOAD_DIR") {
        Some(path) => Some(path)
        None =>
          match home_dir_for_env(platform, envs) {
            Some(home) => Some(join_path(platform, home, "Downloads"))
            None => None
          }
      }
    Darwin =>
      match home_dir_for_env(platform, envs) {
        Some(home) => Some(join_path(platform, home, "Downloads"))
        None => None
      }
    Windows =>
      match home_dir_for_env(platform, envs) {
        Some(home) => Some(join_path(platform, home, "Downloads"))
        None => None
      }
    Unknown => None
  }
}

///|
/// Resolves the preferred temporary directory.
fn tmp_dir_for_env(platform : Platform, envs : Map[String, String]) -> String? {
  match platform {
    Linux =>
      match env_value(envs, "XDG_RUNTIME_DIR") {
        Some(runtime_dir) => Some(join_path(platform, runtime_dir, "tmp"))
        None =>
          match first_env(envs, ["TMPDIR", "TEMP", "TMP"]) {
            Some(path) => Some(path)
            None => Some("/var/tmp")
          }
      }
    Darwin => env_value(envs, "TMPDIR")
    Windows =>
      match first_env(envs, ["TMP", "TEMP"]) {
        Some(path) => Some(path)
        None => None
      }
    Unknown => None
  }
}

///|
/// Joins HOMEDRIVE and HOMEPATH when USERPROFILE is unavailable.
fn home_drive_path(envs : Map[String, String]) -> String? {
  match (env_value(envs, "HOMEDRIVE"), env_value(envs, "HOMEPATH")) {
    (Some(drive), Some(path)) => Some("\{drive}\{path}")
    _ => None
  }
}
