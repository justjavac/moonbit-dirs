///|
/// Resolves the current target's home directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn home_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "USERPROFILE") {
    Some(profile) => Some(profile)
    None => _home_drive_path(envs)
  }
}

///|
/// Resolves the current target's cache directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn cache_dir_for_env(envs : Map[String, String]) -> String? {
  env_value(envs, "LOCALAPPDATA")
}

///|
/// Resolves the current target's configuration directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn config_dir_for_env(envs : Map[String, String]) -> String? {
  env_value(envs, "APPDATA")
}

///|
/// Resolves the current target's executable directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn executable_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's shared application data directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn data_dir_for_env(envs : Map[String, String]) -> String? {
  env_value(envs, "APPDATA")
}

///|
/// Resolves the current target's machine-local application data directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn data_local_dir_for_env(envs : Map[String, String]) -> String? {
  env_value(envs, "LOCALAPPDATA")
}

///|
/// Resolves the current target's audio directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn audio_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Music")
}

///|
/// Resolves the current target's desktop directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn desktop_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Desktop")
}

///|
/// Resolves the current target's document directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn document_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Documents")
}

///|
/// Resolves the current target's downloads directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn download_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Downloads")
}

///|
/// Resolves the current target's font directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn font_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's picture directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn picture_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Pictures")
}

///|
/// Resolves the current target's public directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn public_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "PUBLIC") {
    Some(path) => Some(path)
    None =>
      match env_value(envs, "SYSTEMDRIVE") {
        Some(system_drive) =>
          Some(join_path("\{system_drive}\\Users", "Public"))
        None => None
      }
  }
}

///|
/// Resolves the current target's template directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn template_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "APPDATA") {
    Some(appdata) =>
      Some(join_path(join_path(appdata, "Microsoft\\Windows"), "Templates"))
    None => None
  }
}

///|
/// Resolves the current target's temporary directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn tmp_dir_for_env(envs : Map[String, String]) -> String? {
  _first_env(envs, ["TMP", "TEMP"])
}

///|
/// Resolves the current target's video directory on Windows native builds.
#cfg(all(target="native", platform="windows"))
fn video_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Videos")
}
