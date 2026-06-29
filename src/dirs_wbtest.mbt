///|
#cfg(target="native")
test "environment helpers ignore blank values and search in order" {
  let envs : Map[String, String] = {
    "EMPTY": "   ",
    "SECOND": "value",
    "OSTYPE": "Darwin23.0.0",
    "HOME": "/Users/alice",
  }

  fn has_any_env(envs : Map[String, String], keys : Array[String]) -> Bool {
    first_env(envs, keys) is Some(_)
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

  assert_true(env_value(envs, "EMPTY") is None)
  assert_true(env_value(envs, "SECOND") == Some("value"))
  assert_true(env_contains(envs, "OSTYPE", "darwin"))
  assert_true(env_starts_with(envs, "HOME", "/Users/"))
  assert_true(env_matches({ "OS": "WINDOWS_NT" }, "OS", "windows_nt"))
  assert_true(first_env(envs, ["EMPTY", "SECOND", "THIRD"]) == Some("value"))
  assert_true(has_any_env(envs, ["EMPTY", "SECOND"]))
  assert_true(is_blank(" \n\t "))
}

///|
#cfg(all(target="native", platform="windows"))
test "join_path delegates to the windows path implementation" {
  assert_eq(
    normalize_path("C:\\Users\\alice\\AppData\\Roaming\\..\\Local"),
    "C:\\Users\\alice\\AppData\\Local",
  )
  assert_eq(
    join_path("C:\\Users\\alice\\", "Downloads"),
    "C:\\Users\\alice\\Downloads",
  )
  assert_eq(join_path("C:\\", "Temp"), "C:\\Temp")
  assert_eq(join_path("C:\\Users\\alice", "D:\\Data"), "D:\\Data")
}

///|
#cfg(all(target="native", not(platform="windows")))
test "join_path delegates to the posix path implementation" {
  assert_eq(join_path("", "tmp"), "tmp")
  assert_eq(join_path("/home/alice/", ".cache"), "/home/alice/.cache")
  assert_eq(join_path("/", "tmp"), "/tmp")
  assert_eq(
    normalize_path("/home/alice/.local/share/../bin"),
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
  assert_eq(home_dir_for_env(envs), Some("/home/alice"))
  assert_eq(cache_dir_for_env(envs), Some("/cache"))
  assert_eq(config_dir_for_env(envs), Some("/config"))
  assert_eq(executable_dir_for_env(envs), Some("/bin-home"))
  assert_eq(data_dir_for_env(envs), Some("/data"))
  assert_eq(data_local_dir_for_env(envs), Some("/data"))
  assert_eq(audio_dir_for_env(envs), Some("/music"))
  assert_eq(desktop_dir_for_env(envs), Some("/desktop"))
  assert_eq(document_dir_for_env(envs), Some("/documents"))
  assert_eq(download_dir_for_env(envs), Some("/downloads"))
  assert_eq(font_dir_for_env(envs), Some("/data/fonts"))
  assert_eq(picture_dir_for_env(envs), Some("/pictures"))
  assert_eq(public_dir_for_env(envs), Some("/public"))
  assert_eq(template_dir_for_env(envs), Some("/templates"))
  assert_eq(tmp_dir_for_env(envs), Some("/tmp/custom"))
  assert_eq(video_dir_for_env(envs), Some("/videos"))
  assert_eq(dir_for_env("unsupported", envs), None)

  let fallback_envs : Map[String, String] = { "HOME": "/home/alice" }
  assert_eq(cache_dir_for_env(fallback_envs), Some("/home/alice/.cache"))
  assert_eq(config_dir_for_env(fallback_envs), Some("/home/alice/.config"))
  assert_eq(
    executable_dir_for_env(fallback_envs),
    Some("/home/alice/.local/bin"),
  )
  assert_eq(data_dir_for_env(fallback_envs), Some("/home/alice/.local/share"))
  assert_eq(audio_dir_for_env(fallback_envs), Some("/home/alice/Music"))
  assert_eq(desktop_dir_for_env(fallback_envs), Some("/home/alice/Desktop"))
  assert_eq(document_dir_for_env(fallback_envs), Some("/home/alice/Documents"))
  assert_eq(download_dir_for_env(fallback_envs), Some("/home/alice/Downloads"))
  assert_eq(picture_dir_for_env(fallback_envs), Some("/home/alice/Pictures"))
  assert_eq(public_dir_for_env(fallback_envs), Some("/home/alice/Public"))
  assert_eq(template_dir_for_env(fallback_envs), Some("/home/alice/Templates"))
  assert_eq(
    tmp_dir_for_env({ "XDG_RUNTIME_DIR": "/run/user/1000" }),
    Some("/run/user/1000/tmp"),
  )
  assert_eq(tmp_dir_for_env({ "TEMP": "/tmp/temp" }), Some("/tmp/temp"))
  assert_eq(tmp_dir_for_env({ "TMP": "/tmp/tmp" }), Some("/tmp/tmp"))
  assert_eq(tmp_dir_for_env({}), Some("/var/tmp"))
  assert_eq(font_dir_for_env({}), None)
}

///|
#cfg(all(target="native", platform="darwin"))
test "darwin directory resolution covers defined and undefined directories" {
  let envs : Map[String, String] = {
    "HOME": "/Users/alice",
    "TMPDIR": "/var/folders/abc/T/",
  }
  assert_eq(home_dir_for_env(envs), Some("/Users/alice"))
  assert_eq(cache_dir_for_env(envs), Some("/Users/alice/Library/Caches"))
  assert_eq(config_dir_for_env(envs), Some("/Users/alice/Library/Preferences"))
  assert_eq(executable_dir_for_env(envs), None)
  assert_eq(
    data_dir_for_env(envs),
    Some("/Users/alice/Library/Application Support"),
  )
  assert_eq(
    data_local_dir_for_env(envs),
    Some("/Users/alice/Library/Application Support"),
  )
  assert_eq(audio_dir_for_env(envs), Some("/Users/alice/Music"))
  assert_eq(desktop_dir_for_env(envs), Some("/Users/alice/Desktop"))
  assert_eq(document_dir_for_env(envs), Some("/Users/alice/Documents"))
  assert_eq(download_dir_for_env(envs), Some("/Users/alice/Downloads"))
  assert_eq(font_dir_for_env(envs), Some("/Users/alice/Library/Fonts"))
  assert_eq(picture_dir_for_env(envs), Some("/Users/alice/Pictures"))
  assert_eq(public_dir_for_env(envs), Some("/Users/alice/Public"))
  assert_true(template_dir_for_env(envs) is None)
  assert_eq(tmp_dir_for_env(envs), Some("/var/folders/abc/T/"))
  assert_eq(video_dir_for_env(envs), Some("/Users/alice/Movies"))

  assert_eq(cache_dir_for_env({}), None)
  assert_eq(config_dir_for_env({}), None)
  assert_eq(data_dir_for_env({}), None)
  assert_eq(font_dir_for_env({}), None)
  assert_true(tmp_dir_for_env({}) is None)
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
  assert_true(home_dir_for_env(envs) == Some("C:\\Users\\alice"))
  assert_true(
    cache_dir_for_env(envs) == Some("C:\\Users\\alice\\AppData\\Local"),
  )
  assert_true(
    config_dir_for_env(envs) == Some("C:\\Users\\alice\\AppData\\Roaming"),
  )
  assert_true(executable_dir_for_env(envs) is None)
  assert_true(
    data_dir_for_env(envs) == Some("C:\\Users\\alice\\AppData\\Roaming"),
  )
  assert_true(
    data_local_dir_for_env(envs) == Some("C:\\Users\\alice\\AppData\\Local"),
  )
  assert_true(audio_dir_for_env(envs) == Some("C:\\Users\\alice\\Music"))
  assert_true(desktop_dir_for_env(envs) == Some("C:\\Users\\alice\\Desktop"))
  assert_true(document_dir_for_env(envs) == Some("C:\\Users\\alice\\Documents"))
  assert_true(download_dir_for_env(envs) == Some("C:\\Users\\alice\\Downloads"))
  assert_true(font_dir_for_env(envs) is None)
  assert_true(picture_dir_for_env(envs) == Some("C:\\Users\\alice\\Pictures"))
  assert_true(public_dir_for_env(envs) == Some("C:\\Users\\Public"))
  assert_true(
    template_dir_for_env(envs) ==
    Some("C:\\Users\\alice\\AppData\\Roaming\\Microsoft\\Windows\\Templates"),
  )
  assert_true(tmp_dir_for_env(envs) == Some("C:\\Temp"))
  assert_true(video_dir_for_env(envs) == Some("C:\\Users\\alice\\Videos"))

  assert_true(
    home_dir_for_env({ "HOMEDRIVE": "D:", "HOMEPATH": "\\Alice" }) ==
    Some("D:\\Alice"),
  )
  assert_true(
    public_dir_for_env({ "SYSTEMDRIVE": "D:" }) == Some("D:\\Users\\Public"),
  )
  assert_true(template_dir_for_env({}) is None)
  assert_true(
    tmp_dir_for_env({ "TEMP": "C:\\Windows\\Temp" }) ==
    Some("C:\\Windows\\Temp"),
  )
  assert_true(tmp_dir_for_env({}) is None)
}

///|
#cfg(not(target="native"))
test "non native targets resolve no platform specific directories" {
  let envs : Map[String, String] = {
    "HOME": "/home/alice",
    "APPDATA": "C:\\Roaming",
  }
  assert_true(home_dir_for_env(envs) is None)
  assert_true(cache_dir_for_env(envs) is None)
  assert_true(config_dir_for_env(envs) is None)
  assert_true(executable_dir_for_env(envs) is None)
  assert_true(data_dir_for_env(envs) is None)
  assert_true(data_local_dir_for_env(envs) is None)
  assert_true(audio_dir_for_env(envs) is None)
  assert_true(desktop_dir_for_env(envs) is None)
  assert_true(document_dir_for_env(envs) is None)
  assert_true(download_dir_for_env(envs) is None)
  assert_true(font_dir_for_env(envs) is None)
  assert_true(picture_dir_for_env(envs) is None)
  assert_true(public_dir_for_env(envs) is None)
  assert_true(template_dir_for_env(envs) is None)
  assert_true(tmp_dir_for_env(envs) is None)
  assert_true(video_dir_for_env(envs) is None)
}
