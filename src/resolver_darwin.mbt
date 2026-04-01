///|
/// Resolves the current target's home directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn home_dir_for_env(envs : Map[String, String]) -> String? {
  env_value(envs, "HOME")
}

///|
/// Resolves the current target's cache directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn cache_dir_for_env(envs : Map[String, String]) -> String? {
  match home_dir_for_env(envs) {
    Some(home) => Some(join_path(join_path(home, "Library"), "Caches"))
    None => None
  }
}

///|
/// Resolves the current target's configuration directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn config_dir_for_env(envs : Map[String, String]) -> String? {
  match home_dir_for_env(envs) {
    Some(home) => Some(join_path(join_path(home, "Library"), "Preferences"))
    None => None
  }
}

///|
/// Resolves the current target's executable directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn executable_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's shared application data directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn data_dir_for_env(envs : Map[String, String]) -> String? {
  match home_dir_for_env(envs) {
    Some(home) =>
      Some(join_path(join_path(home, "Library"), "Application Support"))
    None => None
  }
}

///|
/// Resolves the current target's machine-local application data directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn data_local_dir_for_env(envs : Map[String, String]) -> String? {
  data_dir_for_env(envs)
}

///|
/// Resolves the current target's audio directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn audio_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Music")
}

///|
/// Resolves the current target's desktop directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn desktop_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Desktop")
}

///|
/// Resolves the current target's document directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn document_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Documents")
}

///|
/// Resolves the current target's downloads directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn download_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Downloads")
}

///|
/// Resolves the current target's font directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn font_dir_for_env(envs : Map[String, String]) -> String? {
  match home_dir_for_env(envs) {
    Some(home) => Some(join_path(join_path(home, "Library"), "Fonts"))
    None => None
  }
}

///|
/// Resolves the current target's picture directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn picture_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Pictures")
}

///|
/// Resolves the current target's public directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn public_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Public")
}

///|
/// Resolves the current target's template directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn template_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's temporary directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn tmp_dir_for_env(envs : Map[String, String]) -> String? {
  env_value(envs, "TMPDIR")
}

///|
/// Resolves the current target's video directory on macOS native builds.
#cfg(all(target="native", platform="darwin"))
fn video_dir_for_env(envs : Map[String, String]) -> String? {
  home_named_dir_for_env(envs, "Movies")
}
