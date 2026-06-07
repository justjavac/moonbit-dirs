///|
/// Resolves the current target's home directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn home_dir_for_env(envs : Map[String, String]) -> String? {
  env_value(envs, "HOME")
}

///|
/// Resolves the current target's cache directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn cache_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "XDG_CACHE_HOME") {
    Some(path) => Some(path)
    None =>
      match home_dir_for_env(envs) {
        Some(home) => Some(join_path(home, ".cache"))
        None => None
      }
  }
}

///|
/// Resolves the current target's configuration directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn config_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "XDG_CONFIG_HOME") {
    Some(path) => Some(path)
    None =>
      match home_dir_for_env(envs) {
        Some(home) => Some(join_path(home, ".config"))
        None => None
      }
  }
}

///|
/// Resolves the current target's executable directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn executable_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "XDG_BIN_HOME") {
    Some(path) => Some(path)
    None =>
      match env_value(envs, "XDG_DATA_HOME") {
        Some(data_home) => Some(_normalize_path(join_path(data_home, "../bin")))
        None =>
          match home_dir_for_env(envs) {
            Some(home) => Some(join_path(join_path(home, ".local"), "bin"))
            None => None
          }
      }
  }
}

///|
/// Resolves the current target's shared application data directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn data_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "XDG_DATA_HOME") {
    Some(path) => Some(path)
    None =>
      match home_dir_for_env(envs) {
        Some(home) => Some(join_path(join_path(home, ".local"), "share"))
        None => None
      }
  }
}

///|
/// Resolves the current target's machine-local application data directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn data_local_dir_for_env(envs : Map[String, String]) -> String? {
  data_dir_for_env(envs)
}

///|
/// Resolves the current target's audio directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn audio_dir_for_env(envs : Map[String, String]) -> String? {
  _user_dir_for_env(envs, "XDG_MUSIC_DIR", "Music")
}

///|
/// Resolves the current target's desktop directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn desktop_dir_for_env(envs : Map[String, String]) -> String? {
  _user_dir_for_env(envs, "XDG_DESKTOP_DIR", "Desktop")
}

///|
/// Resolves the current target's document directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn document_dir_for_env(envs : Map[String, String]) -> String? {
  _user_dir_for_env(envs, "XDG_DOCUMENTS_DIR", "Documents")
}

///|
/// Resolves the current target's downloads directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn download_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "XDG_DOWNLOAD_DIR") {
    Some(path) => Some(path)
    None =>
      match home_dir_for_env(envs) {
        Some(home) => Some(join_path(home, "Downloads"))
        None => None
      }
  }
}

///|
/// Resolves the current target's font directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn font_dir_for_env(envs : Map[String, String]) -> String? {
  match data_dir_for_env(envs) {
    Some(data_dir) => Some(join_path(data_dir, "fonts"))
    None => None
  }
}

///|
/// Resolves the current target's picture directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn picture_dir_for_env(envs : Map[String, String]) -> String? {
  _user_dir_for_env(envs, "XDG_PICTURES_DIR", "Pictures")
}

///|
/// Resolves the current target's public directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn public_dir_for_env(envs : Map[String, String]) -> String? {
  _user_dir_for_env(envs, "XDG_PUBLICSHARE_DIR", "Public")
}

///|
/// Resolves the current target's template directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn template_dir_for_env(envs : Map[String, String]) -> String? {
  _user_dir_for_env(envs, "XDG_TEMPLATES_DIR", "Templates")
}

///|
/// Resolves the current target's temporary directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn tmp_dir_for_env(envs : Map[String, String]) -> String? {
  match env_value(envs, "XDG_RUNTIME_DIR") {
    Some(runtime_dir) => Some(join_path(runtime_dir, "tmp"))
    None =>
      match _first_env(envs, ["TMPDIR", "TEMP", "TMP"]) {
        Some(path) => Some(path)
        None => Some("/var/tmp")
      }
  }
}

///|
/// Resolves the current target's video directory on Linux native builds.
#cfg(all(target="native", platform="linux"))
fn video_dir_for_env(envs : Map[String, String]) -> String? {
  _user_dir_for_env(envs, "XDG_VIDEOS_DIR", "Videos")
}
