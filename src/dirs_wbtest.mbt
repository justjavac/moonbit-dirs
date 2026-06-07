///|
test "environment helpers ignore blank values and search in order" {
  let envs : Map[String, String] = {
    "EMPTY": "   ",
    "SECOND": "value",
    "OSTYPE": "Darwin23.0.0",
    "HOME": "/Users/alice",
  }

  fn has_any_env(envs : Map[String, String], keys : Array[String]) -> Bool {
    _first_env(envs, keys) is Some(_)
  }

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

  @debug.assert_eq(env_value(envs, "EMPTY"), None)
  @debug.assert_eq(env_value(envs, "SECOND"), Some("value"))
  assert_true(env_contains(envs, "OSTYPE", "darwin"))
  assert_true(env_starts_with(envs, "HOME", "/Users/"))
  assert_true(env_matches({ "OS": "WINDOWS_NT" }, "OS", "windows_nt"))
  @debug.assert_eq(
    _first_env(envs, ["EMPTY", "SECOND", "THIRD"]),
    Some("value"),
  )
  assert_true(has_any_env(envs, ["EMPTY", "SECOND"]))
  assert_true(is_blank(" \n\t "))
}

///|
#cfg(all(target="native", platform="windows"))
test "join_path delegates to the windows path implementation" {
  @debug.assert_eq(
    _normalize_path("C:\\Users\\alice\\AppData\\Roaming\\..\\Local"),
    "C:\\Users\\alice\\AppData\\Local",
  )
  @debug.assert_eq(
    join_path("C:\\Users\\alice\\", "Downloads"),
    "C:\\Users\\alice\\Downloads",
  )
  @debug.assert_eq(join_path("C:\\", "Temp"), "C:\\Temp")
  @debug.assert_eq(join_path("C:\\Users\\alice", "D:\\Data"), "D:\\Data")
}

///|
#cfg(not(all(target="native", platform="windows")))
test "join_path delegates to the posix path implementation" {
  @debug.assert_eq(join_path("", "tmp"), "tmp")
  @debug.assert_eq(join_path("/home/alice/", ".cache"), "/home/alice/.cache")
  @debug.assert_eq(join_path("/", "tmp"), "/tmp")
  @debug.assert_eq(
    _normalize_path("/home/alice/.local/share/../bin"),
    "/home/alice/.local/bin",
  )
}

///|
#cfg(all(target="native", platform="linux"))
test "linux directory resolution covers xdg and fallback branches" {
  let envs : Map[String, String] = {
    "HOME": "/home/alice",
    "XDG_CACHE_HOME": "/cache",
    "XDG_CONFIG_HOME": "/config",
    "XDG_BIN_HOME": "/bin-home",
    "XDG_DATA_HOME": "/data",
    "XDG_MUSIC_DIR": "/music",
    "XDG_DESKTOP_DIR": "/desktop",
    "XDG_DOCUMENTS_DIR": "/documents",
    "XDG_DOWNLOAD_DIR": "/downloads",
    "XDG_PICTURES_DIR": "/pictures",
    "XDG_PUBLICSHARE_DIR": "/public",
    "XDG_TEMPLATES_DIR": "/templates",
    "TMPDIR": "/tmp/custom",
    "XDG_VIDEOS_DIR": "/videos",
  }
  @debug.assert_eq(home_dir_for_env(envs), Some("/home/alice"))
  @debug.assert_eq(cache_dir_for_env(envs), Some("/cache"))
  @debug.assert_eq(config_dir_for_env(envs), Some("/config"))
  @debug.assert_eq(executable_dir_for_env(envs), Some("/bin-home"))
  @debug.assert_eq(data_dir_for_env(envs), Some("/data"))
  @debug.assert_eq(data_local_dir_for_env(envs), Some("/data"))
  @debug.assert_eq(audio_dir_for_env(envs), Some("/music"))
  @debug.assert_eq(desktop_dir_for_env(envs), Some("/desktop"))
  @debug.assert_eq(document_dir_for_env(envs), Some("/documents"))
  @debug.assert_eq(download_dir_for_env(envs), Some("/downloads"))
  @debug.assert_eq(font_dir_for_env(envs), Some("/data/fonts"))
  @debug.assert_eq(picture_dir_for_env(envs), Some("/pictures"))
  @debug.assert_eq(public_dir_for_env(envs), Some("/public"))
  @debug.assert_eq(template_dir_for_env(envs), Some("/templates"))
  @debug.assert_eq(tmp_dir_for_env(envs), Some("/tmp/custom"))
  @debug.assert_eq(video_dir_for_env(envs), Some("/videos"))
  @debug.assert_eq(dir_for_env("unsupported", envs), None)

  let fallback_envs : Map[String, String] = { "HOME": "/home/alice" }
  @debug.assert_eq(cache_dir_for_env(fallback_envs), Some("/home/alice/.cache"))
  @debug.assert_eq(
    config_dir_for_env(fallback_envs),
    Some("/home/alice/.config"),
  )
  @debug.assert_eq(
    executable_dir_for_env(fallback_envs),
    Some("/home/alice/.local/bin"),
  )
  @debug.assert_eq(
    data_dir_for_env(fallback_envs),
    Some("/home/alice/.local/share"),
  )
  @debug.assert_eq(audio_dir_for_env(fallback_envs), Some("/home/alice/Music"))
  @debug.assert_eq(
    desktop_dir_for_env(fallback_envs),
    Some("/home/alice/Desktop"),
  )
  @debug.assert_eq(
    document_dir_for_env(fallback_envs),
    Some("/home/alice/Documents"),
  )
  @debug.assert_eq(
    download_dir_for_env(fallback_envs),
    Some("/home/alice/Downloads"),
  )
  @debug.assert_eq(
    picture_dir_for_env(fallback_envs),
    Some("/home/alice/Pictures"),
  )
  @debug.assert_eq(
    public_dir_for_env(fallback_envs),
    Some("/home/alice/Public"),
  )
  @debug.assert_eq(
    template_dir_for_env(fallback_envs),
    Some("/home/alice/Templates"),
  )
  @debug.assert_eq(
    tmp_dir_for_env({ "XDG_RUNTIME_DIR": "/run/user/1000" }),
    Some("/run/user/1000/tmp"),
  )
  @debug.assert_eq(tmp_dir_for_env({ "TEMP": "/tmp/temp" }), Some("/tmp/temp"))
  @debug.assert_eq(tmp_dir_for_env({ "TMP": "/tmp/tmp" }), Some("/tmp/tmp"))
  @debug.assert_eq(tmp_dir_for_env({}), Some("/var/tmp"))
  @debug.assert_eq(font_dir_for_env({}), None)
}

///|
#cfg(all(target="native", platform="darwin"))
test "darwin directory resolution covers defined and undefined directories" {
  let envs : Map[String, String] = {
    "HOME": "/Users/alice",
    "TMPDIR": "/var/folders/abc/T/",
  }
  @debug.assert_eq(home_dir_for_env(envs), Some("/Users/alice"))
  @debug.assert_eq(cache_dir_for_env(envs), Some("/Users/alice/Library/Caches"))
  @debug.assert_eq(
    config_dir_for_env(envs),
    Some("/Users/alice/Library/Preferences"),
  )
  @debug.assert_eq(executable_dir_for_env(envs), None)
  @debug.assert_eq(
    data_dir_for_env(envs),
    Some("/Users/alice/Library/Application Support"),
  )
  @debug.assert_eq(
    data_local_dir_for_env(envs),
    Some("/Users/alice/Library/Application Support"),
  )
  @debug.assert_eq(audio_dir_for_env(envs), Some("/Users/alice/Music"))
  @debug.assert_eq(desktop_dir_for_env(envs), Some("/Users/alice/Desktop"))
  @debug.assert_eq(document_dir_for_env(envs), Some("/Users/alice/Documents"))
  @debug.assert_eq(download_dir_for_env(envs), Some("/Users/alice/Downloads"))
  @debug.assert_eq(font_dir_for_env(envs), Some("/Users/alice/Library/Fonts"))
  @debug.assert_eq(picture_dir_for_env(envs), Some("/Users/alice/Pictures"))
  @debug.assert_eq(public_dir_for_env(envs), Some("/Users/alice/Public"))
  @debug.assert_eq(template_dir_for_env(envs), None)
  @debug.assert_eq(tmp_dir_for_env(envs), Some("/var/folders/abc/T/"))
  @debug.assert_eq(video_dir_for_env(envs), Some("/Users/alice/Movies"))

  @debug.assert_eq(cache_dir_for_env({}), None)
  @debug.assert_eq(config_dir_for_env({}), None)
  @debug.assert_eq(data_dir_for_env({}), None)
  @debug.assert_eq(font_dir_for_env({}), None)
  @debug.assert_eq(tmp_dir_for_env({}), None)
}

///|
#cfg(all(target="native", platform="windows"))
test "windows directory resolution covers profile appdata and fallbacks" {
  let envs : Map[String, String] = {
    "USERPROFILE": "C:\\Users\\alice",
    "LOCALAPPDATA": "C:\\Users\\alice\\AppData\\Local",
    "APPDATA": "C:\\Users\\alice\\AppData\\Roaming",
    "PUBLIC": "C:\\Users\\Public",
    "TMP": "C:\\Temp",
  }
  @debug.assert_eq(home_dir_for_env(envs), Some("C:\\Users\\alice"))
  @debug.assert_eq(
    cache_dir_for_env(envs),
    Some("C:\\Users\\alice\\AppData\\Local"),
  )
  @debug.assert_eq(
    config_dir_for_env(envs),
    Some("C:\\Users\\alice\\AppData\\Roaming"),
  )
  @debug.assert_eq(executable_dir_for_env(envs), None)
  @debug.assert_eq(
    data_dir_for_env(envs),
    Some("C:\\Users\\alice\\AppData\\Roaming"),
  )
  @debug.assert_eq(
    data_local_dir_for_env(envs),
    Some("C:\\Users\\alice\\AppData\\Local"),
  )
  @debug.assert_eq(audio_dir_for_env(envs), Some("C:\\Users\\alice\\Music"))
  @debug.assert_eq(desktop_dir_for_env(envs), Some("C:\\Users\\alice\\Desktop"))
  @debug.assert_eq(
    document_dir_for_env(envs),
    Some("C:\\Users\\alice\\Documents"),
  )
  @debug.assert_eq(
    download_dir_for_env(envs),
    Some("C:\\Users\\alice\\Downloads"),
  )
  @debug.assert_eq(font_dir_for_env(envs), None)
  @debug.assert_eq(
    picture_dir_for_env(envs),
    Some("C:\\Users\\alice\\Pictures"),
  )
  @debug.assert_eq(public_dir_for_env(envs), Some("C:\\Users\\Public"))
  @debug.assert_eq(
    template_dir_for_env(envs),
    Some("C:\\Users\\alice\\AppData\\Roaming\\Microsoft\\Windows\\Templates"),
  )
  @debug.assert_eq(tmp_dir_for_env(envs), Some("C:\\Temp"))
  @debug.assert_eq(video_dir_for_env(envs), Some("C:\\Users\\alice\\Videos"))

  @debug.assert_eq(
    home_dir_for_env({ "HOMEDRIVE": "D:", "HOMEPATH": "\\Alice" }),
    Some("D:\\Alice"),
  )
  @debug.assert_eq(
    public_dir_for_env({ "SYSTEMDRIVE": "D:" }),
    Some("D:\\Users\\Public"),
  )
  @debug.assert_eq(template_dir_for_env({}), None)
  @debug.assert_eq(
    tmp_dir_for_env({ "TEMP": "C:\\Windows\\Temp" }),
    Some("C:\\Windows\\Temp"),
  )
  @debug.assert_eq(tmp_dir_for_env({}), None)
}

///|
#cfg(not(target="native"))
test "non native targets resolve no platform specific directories" {
  let envs : Map[String, String] = {
    "HOME": "/home/alice",
    "APPDATA": "C:\\Roaming",
  }
  @debug.assert_eq(home_dir_for_env(envs), None)
  @debug.assert_eq(cache_dir_for_env(envs), None)
  @debug.assert_eq(config_dir_for_env(envs), None)
  @debug.assert_eq(executable_dir_for_env(envs), None)
  @debug.assert_eq(data_dir_for_env(envs), None)
  @debug.assert_eq(data_local_dir_for_env(envs), None)
  @debug.assert_eq(audio_dir_for_env(envs), None)
  @debug.assert_eq(desktop_dir_for_env(envs), None)
  @debug.assert_eq(document_dir_for_env(envs), None)
  @debug.assert_eq(download_dir_for_env(envs), None)
  @debug.assert_eq(font_dir_for_env(envs), None)
  @debug.assert_eq(picture_dir_for_env(envs), None)
  @debug.assert_eq(public_dir_for_env(envs), None)
  @debug.assert_eq(template_dir_for_env(envs), None)
  @debug.assert_eq(tmp_dir_for_env(envs), None)
  @debug.assert_eq(video_dir_for_env(envs), None)
}
