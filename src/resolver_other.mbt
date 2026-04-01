///|
/// Resolves the current target's home directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn home_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's cache directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn cache_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's configuration directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn config_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's executable directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn executable_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's shared application data directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn data_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's machine-local application data directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn data_local_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's audio directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn audio_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's desktop directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn desktop_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's document directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn document_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's downloads directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn download_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's font directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn font_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's picture directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn picture_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's public directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn public_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's template directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn template_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's temporary directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn tmp_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}

///|
/// Resolves the current target's video directory on unsupported targets.
#cfg(any(not(target="native"), all(target="native", not(any(platform="linux", platform="darwin", platform="windows")))))
fn video_dir_for_env(_envs : Map[String, String]) -> String? {
  None
}
