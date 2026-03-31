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
    "executable" => executable_dir_for_env(platform, envs)
    "data" => data_dir_for_env(platform, envs)
    "data_local" => data_local_dir_for_env(platform, envs)
    "audio" => audio_dir_for_env(platform, envs)
    "desktop" => desktop_dir_for_env(platform, envs)
    "document" => document_dir_for_env(platform, envs)
    "download" => download_dir_for_env(platform, envs)
    "font" => font_dir_for_env(platform, envs)
    "picture" => picture_dir_for_env(platform, envs)
    "public" => public_dir_for_env(platform, envs)
    "template" => template_dir_for_env(platform, envs)
    "tmp" => tmp_dir_for_env(platform, envs)
    "video" => video_dir_for_env(platform, envs)
    _ => None
  }
}

///|
/// Joins two path segments with the official platform-specific path implementation.
fn join_path(platform : Platform, base : String, child : String) -> String {
  match platform {
    Windows => @win32.Path::join(base, child).to_string()
    _ => @posix.Path::join(base, child).to_string()
  }
}

///|
/// Normalizes a path using the official platform-specific path implementation.
fn normalize_path(platform : Platform, path : String) -> String {
  match platform {
    Windows => @win32.Path::normalize(path).to_string()
    _ => @posix.Path::normalize(path).to_string()
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
/// Resolves the user's executable directory.
fn executable_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux =>
      match env_value(envs, "XDG_BIN_HOME") {
        Some(path) => Some(path)
        None =>
          match env_value(envs, "XDG_DATA_HOME") {
            Some(data_home) =>
              Some(
                normalize_path(
                  platform,
                  join_path(platform, data_home, "../bin"),
                ),
              )
            None =>
              match home_dir_for_env(platform, envs) {
                Some(home) =>
                  Some(
                    join_path(
                      platform,
                      join_path(platform, home, ".local"),
                      "bin",
                    ),
                  )
                None => None
              }
          }
      }
    Darwin | Windows | Unknown => None
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
/// Resolves the user's audio directory.
fn audio_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux => user_dir_for_env(platform, envs, "XDG_MUSIC_DIR", "Music")
    Darwin => home_named_dir_for_env(platform, envs, "Music")
    Windows => home_named_dir_for_env(platform, envs, "Music")
    Unknown => None
  }
}

///|
/// Resolves the user's desktop directory.
fn desktop_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux => user_dir_for_env(platform, envs, "XDG_DESKTOP_DIR", "Desktop")
    Darwin => home_named_dir_for_env(platform, envs, "Desktop")
    Windows => home_named_dir_for_env(platform, envs, "Desktop")
    Unknown => None
  }
}

///|
/// Resolves the user's document directory.
fn document_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux => user_dir_for_env(platform, envs, "XDG_DOCUMENTS_DIR", "Documents")
    Darwin => home_named_dir_for_env(platform, envs, "Documents")
    Windows => home_named_dir_for_env(platform, envs, "Documents")
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
/// Resolves the user's font directory.
fn font_dir_for_env(platform : Platform, envs : Map[String, String]) -> String? {
  match platform {
    Linux =>
      match data_dir_for_env(platform, envs) {
        Some(data_dir) => Some(join_path(platform, data_dir, "fonts"))
        None => None
      }
    Darwin =>
      match home_dir_for_env(platform, envs) {
        Some(home) =>
          Some(
            join_path(platform, join_path(platform, home, "Library"), "Fonts"),
          )
        None => None
      }
    Windows | Unknown => None
  }
}

///|
/// Resolves the user's picture directory.
fn picture_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux => user_dir_for_env(platform, envs, "XDG_PICTURES_DIR", "Pictures")
    Darwin => home_named_dir_for_env(platform, envs, "Pictures")
    Windows => home_named_dir_for_env(platform, envs, "Pictures")
    Unknown => None
  }
}

///|
/// Resolves the public shared directory.
fn public_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux => user_dir_for_env(platform, envs, "XDG_PUBLICSHARE_DIR", "Public")
    Darwin => home_named_dir_for_env(platform, envs, "Public")
    Windows =>
      match env_value(envs, "PUBLIC") {
        Some(path) => Some(path)
        None =>
          match env_value(envs, "SYSTEMDRIVE") {
            Some(system_drive) =>
              Some(join_path(platform, "\{system_drive}\\Users", "Public"))
            None => None
          }
      }
    Unknown => None
  }
}

///|
/// Resolves the user's template directory.
fn template_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux => user_dir_for_env(platform, envs, "XDG_TEMPLATES_DIR", "Templates")
    Darwin => None
    Windows =>
      match env_value(envs, "APPDATA") {
        Some(appdata) =>
          Some(
            join_path(
              platform,
              join_path(platform, appdata, "Microsoft\\Windows"),
              "Templates",
            ),
          )
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
/// Resolves the user's video directory.
fn video_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
) -> String? {
  match platform {
    Linux => user_dir_for_env(platform, envs, "XDG_VIDEOS_DIR", "Videos")
    Darwin => home_named_dir_for_env(platform, envs, "Movies")
    Windows => home_named_dir_for_env(platform, envs, "Videos")
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

///|
/// Resolves a home-relative directory by name.
fn home_named_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
  name : String,
) -> String? {
  match home_dir_for_env(platform, envs) {
    Some(home) => Some(join_path(platform, home, name))
    None => None
  }
}

///|
/// Resolves an XDG-style user directory with a conventional home fallback.
fn user_dir_for_env(
  platform : Platform,
  envs : Map[String, String],
  env_key : String,
  fallback_name : String,
) -> String? {
  match env_value(envs, env_key) {
    Some(path) => Some(path)
    None => home_named_dir_for_env(platform, envs, fallback_name)
  }
}
