///|
test "detect_platform recognizes windows environments" {
  let envs : Map[String, String] = {
    "OS": "Windows_NT",
    "USERPROFILE": "C:\\Users\\alice",
  }
  assert_true(detect_platform(envs) is Windows)

  let fallback_envs : Map[String, String] = {
    "APPDATA": "C:\\Users\\alice\\AppData\\Roaming",
  }
  assert_true(detect_platform(fallback_envs) is Windows)

  let drive_envs : Map[String, String] = {
    "HOMEDRIVE": "C:",
    "HOMEPATH": "\\Alice",
  }
  assert_true(detect_platform(drive_envs) is Windows)
}

///|
test "detect_platform recognizes darwin linux and unknown environments" {
  let darwin_envs : Map[String, String] = { "HOME": "/Users/alice" }
  assert_true(detect_platform(darwin_envs) is Darwin)

  let linux_envs : Map[String, String] = {
    "XDG_CONFIG_HOME": "/home/alice/.config",
  }
  assert_true(detect_platform(linux_envs) is Linux)

  let unknown_envs : Map[String, String] = {}
  assert_true(detect_platform(unknown_envs) is Unknown)
}

///|
test "environment helpers ignore blank values and search in order" {
  let envs : Map[String, String] = {
    "EMPTY": "   ",
    "SECOND": "value",
    "OSTYPE": "Darwin23.0.0",
    "HOME": "/Users/alice",
  }

  assert_eq(env_value(envs, "EMPTY"), None)
  assert_eq(env_value(envs, "SECOND"), Some("value"))
  assert_true(env_contains(envs, "OSTYPE", "darwin"))
  assert_true(env_starts_with(envs, "HOME", "/Users/"))
  assert_true(env_matches({ "OS": "WINDOWS_NT" }, "OS", "windows_nt"))
  assert_eq(first_env(envs, ["EMPTY", "SECOND", "THIRD"]), Some("value"))
  assert_true(has_any_env(envs, ["EMPTY", "SECOND"]))
  assert_true(is_blank(" \n\t "))
}

///|
test "join_path delegates to official path implementations" {
  assert_eq(join_path(Linux, "", "tmp"), "tmp")
  assert_eq(join_path(Linux, "/home/alice/", ".cache"), "/home/alice/.cache")
  assert_eq(join_path(Linux, "/", "tmp"), "/tmp")
  assert_eq(
    normalize_path(Linux, "/home/alice/.local/share/../bin"),
    "/home/alice/.local/bin",
  )
  assert_eq(
    normalize_path(Windows, "C:\\Users\\alice\\AppData\\Roaming\\..\\Local"),
    "C:\\Users\\alice\\AppData\\Local",
  )
  assert_eq(
    join_path(Windows, "C:\\Users\\alice\\", "Downloads"),
    "C:\\Users\\alice\\Downloads",
  )
  assert_eq(join_path(Windows, "C:\\", "Temp"), "C:\\Temp")
  assert_eq(join_path(Windows, "C:\\Users\\alice", "D:\\Data"), "D:\\Data")
}

///|
test "home directory resolution covers every platform branch" {
  assert_eq(
    home_dir_for_env(Linux, { "HOME": "/home/alice" }),
    Some("/home/alice"),
  )
  assert_eq(
    home_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice"),
  )
  assert_eq(
    home_dir_for_env(Windows, { "USERPROFILE": "C:\\Users\\alice" }),
    Some("C:\\Users\\alice"),
  )
  assert_eq(
    home_dir_for_env(Windows, { "HOMEDRIVE": "D:", "HOMEPATH": "\\Alice" }),
    Some("D:\\Alice"),
  )
  assert_eq(home_dir_for_env(Windows, {}), None)
  assert_eq(home_dir_for_env(Unknown, { "HOME": "/home/alice" }), None)
}

///|
test "cache directory resolution covers xdg home windows and unknown fallbacks" {
  assert_eq(
    cache_dir_for_env(Linux, { "XDG_CACHE_HOME": "/cache" }),
    Some("/cache"),
  )
  assert_eq(
    cache_dir_for_env(Linux, { "HOME": "/home/alice" }),
    Some("/home/alice/.cache"),
  )
  assert_eq(cache_dir_for_env(Linux, {}), None)
  assert_eq(
    cache_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Library/Caches"),
  )
  assert_eq(cache_dir_for_env(Darwin, {}), None)
  assert_eq(
    cache_dir_for_env(Windows, {
      "LOCALAPPDATA": "C:\\Users\\alice\\AppData\\Local",
    }),
    Some("C:\\Users\\alice\\AppData\\Local"),
  )
  assert_eq(cache_dir_for_env(Unknown, {}), None)
}

///|
test "config directory resolution covers all branches" {
  assert_eq(
    config_dir_for_env(Linux, { "XDG_CONFIG_HOME": "/config" }),
    Some("/config"),
  )
  assert_eq(
    config_dir_for_env(Linux, { "HOME": "/home/alice" }),
    Some("/home/alice/.config"),
  )
  assert_eq(config_dir_for_env(Linux, {}), None)
  assert_eq(
    config_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Library/Preferences"),
  )
  assert_eq(config_dir_for_env(Darwin, {}), None)
  assert_eq(
    config_dir_for_env(Windows, {
      "APPDATA": "C:\\Users\\alice\\AppData\\Roaming",
    }),
    Some("C:\\Users\\alice\\AppData\\Roaming"),
  )
  assert_eq(config_dir_for_env(Unknown, {}), None)
}

///|
test "executable directory resolution covers all branches" {
  assert_eq(
    executable_dir_for_env(Linux, { "XDG_BIN_HOME": "/bin-home" }),
    Some("/bin-home"),
  )
  assert_eq(
    executable_dir_for_env(Linux, {
      "XDG_DATA_HOME": "/home/alice/.local/share",
    }),
    Some("/home/alice/.local/bin"),
  )
  assert_eq(
    executable_dir_for_env(Linux, { "HOME": "/home/alice" }),
    Some("/home/alice/.local/bin"),
  )
  assert_eq(executable_dir_for_env(Linux, {}), None)
  assert_eq(executable_dir_for_env(Darwin, { "HOME": "/Users/alice" }), None)
  assert_eq(
    executable_dir_for_env(Windows, { "USERPROFILE": "C:\\Users\\alice" }),
    None,
  )
  assert_eq(executable_dir_for_env(Unknown, {}), None)
}

///|
test "data directory resolution covers all branches" {
  assert_eq(
    data_dir_for_env(Linux, { "XDG_DATA_HOME": "/data" }),
    Some("/data"),
  )
  assert_eq(
    data_dir_for_env(Linux, { "HOME": "/home/alice" }),
    Some("/home/alice/.local/share"),
  )
  assert_eq(data_dir_for_env(Linux, {}), None)
  assert_eq(
    data_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Library/Application Support"),
  )
  assert_eq(data_dir_for_env(Darwin, {}), None)
  assert_eq(
    data_dir_for_env(Windows, {
      "APPDATA": "C:\\Users\\alice\\AppData\\Roaming",
    }),
    Some("C:\\Users\\alice\\AppData\\Roaming"),
  )
  assert_eq(data_dir_for_env(Unknown, {}), None)
}

///|
test "data local directory resolution covers all branches" {
  assert_eq(
    data_local_dir_for_env(Linux, { "XDG_DATA_HOME": "/data" }),
    Some("/data"),
  )
  assert_eq(
    data_local_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Library/Application Support"),
  )
  assert_eq(
    data_local_dir_for_env(Windows, {
      "LOCALAPPDATA": "C:\\Users\\alice\\AppData\\Local",
    }),
    Some("C:\\Users\\alice\\AppData\\Local"),
  )
  assert_eq(data_local_dir_for_env(Unknown, {}), None)
}

///|
test "media and user folder resolution covers all branches" {
  let linux_envs : Map[String, String] = {
    "HOME": "/home/alice",
    "XDG_MUSIC_DIR": "/music",
    "XDG_DESKTOP_DIR": "/desktop",
    "XDG_DOCUMENTS_DIR": "/documents",
    "XDG_PICTURES_DIR": "/pictures",
    "XDG_PUBLICSHARE_DIR": "/public",
    "XDG_TEMPLATES_DIR": "/templates",
    "XDG_VIDEOS_DIR": "/videos",
  }
  assert_eq(audio_dir_for_env(Linux, linux_envs), Some("/music"))
  assert_eq(desktop_dir_for_env(Linux, linux_envs), Some("/desktop"))
  assert_eq(document_dir_for_env(Linux, linux_envs), Some("/documents"))
  assert_eq(picture_dir_for_env(Linux, linux_envs), Some("/pictures"))
  assert_eq(public_dir_for_env(Linux, linux_envs), Some("/public"))
  assert_eq(template_dir_for_env(Linux, linux_envs), Some("/templates"))
  assert_eq(video_dir_for_env(Linux, linux_envs), Some("/videos"))

  let linux_fallback_envs : Map[String, String] = { "HOME": "/home/alice" }
  assert_eq(
    audio_dir_for_env(Linux, linux_fallback_envs),
    Some("/home/alice/Music"),
  )
  assert_eq(
    desktop_dir_for_env(Linux, linux_fallback_envs),
    Some("/home/alice/Desktop"),
  )
  assert_eq(
    document_dir_for_env(Linux, linux_fallback_envs),
    Some("/home/alice/Documents"),
  )
  assert_eq(
    picture_dir_for_env(Linux, linux_fallback_envs),
    Some("/home/alice/Pictures"),
  )
  assert_eq(
    public_dir_for_env(Linux, linux_fallback_envs),
    Some("/home/alice/Public"),
  )
  assert_eq(
    template_dir_for_env(Linux, linux_fallback_envs),
    Some("/home/alice/Templates"),
  )
  assert_eq(
    video_dir_for_env(Linux, linux_fallback_envs),
    Some("/home/alice/Videos"),
  )

  assert_eq(
    audio_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Music"),
  )
  assert_eq(
    desktop_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Desktop"),
  )
  assert_eq(
    document_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Documents"),
  )
  assert_eq(
    font_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Library/Fonts"),
  )
  assert_eq(
    picture_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Pictures"),
  )
  assert_eq(
    public_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Public"),
  )
  assert_eq(template_dir_for_env(Darwin, { "HOME": "/Users/alice" }), None)
  assert_eq(
    video_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Movies"),
  )
  assert_eq(font_dir_for_env(Darwin, {}), None)

  let windows_envs : Map[String, String] = {
    "USERPROFILE": "C:\\Users\\alice",
    "APPDATA": "C:\\Users\\alice\\AppData\\Roaming",
    "PUBLIC": "C:\\Users\\Public",
  }
  assert_eq(
    audio_dir_for_env(Windows, windows_envs),
    Some("C:\\Users\\alice\\Music"),
  )
  assert_eq(
    desktop_dir_for_env(Windows, windows_envs),
    Some("C:\\Users\\alice\\Desktop"),
  )
  assert_eq(
    document_dir_for_env(Windows, windows_envs),
    Some("C:\\Users\\alice\\Documents"),
  )
  assert_eq(
    picture_dir_for_env(Windows, windows_envs),
    Some("C:\\Users\\alice\\Pictures"),
  )
  assert_eq(
    public_dir_for_env(Windows, windows_envs),
    Some("C:\\Users\\Public"),
  )
  assert_eq(
    template_dir_for_env(Windows, windows_envs),
    Some("C:\\Users\\alice\\AppData\\Roaming\\Microsoft\\Windows\\Templates"),
  )
  assert_eq(
    video_dir_for_env(Windows, windows_envs),
    Some("C:\\Users\\alice\\Videos"),
  )

  let windows_fallback_envs : Map[String, String] = { "SYSTEMDRIVE": "D:" }
  assert_eq(
    public_dir_for_env(Windows, windows_fallback_envs),
    Some("D:\\Users\\Public"),
  )
  assert_eq(public_dir_for_env(Windows, {}), None)
  assert_eq(template_dir_for_env(Windows, {}), None)
  assert_eq(audio_dir_for_env(Unknown, {}), None)
  assert_eq(desktop_dir_for_env(Unknown, {}), None)
  assert_eq(document_dir_for_env(Unknown, {}), None)
  assert_eq(font_dir_for_env(Linux, {}), None)
  assert_eq(font_dir_for_env(Unknown, {}), None)
  assert_eq(picture_dir_for_env(Unknown, {}), None)
  assert_eq(public_dir_for_env(Unknown, {}), None)
  assert_eq(template_dir_for_env(Unknown, {}), None)
  assert_eq(video_dir_for_env(Unknown, {}), None)
  assert_eq(home_named_dir_for_env(Linux, {}, "Desktop"), None)
}

///|
test "download directory resolution covers all branches" {
  assert_eq(
    download_dir_for_env(Linux, { "XDG_DOWNLOAD_DIR": "/downloads" }),
    Some("/downloads"),
  )
  assert_eq(
    download_dir_for_env(Linux, { "HOME": "/home/alice" }),
    Some("/home/alice/Downloads"),
  )
  assert_eq(download_dir_for_env(Linux, {}), None)
  assert_eq(
    download_dir_for_env(Darwin, { "HOME": "/Users/alice" }),
    Some("/Users/alice/Downloads"),
  )
  assert_eq(download_dir_for_env(Darwin, {}), None)
  assert_eq(
    download_dir_for_env(Windows, { "USERPROFILE": "C:\\Users\\alice" }),
    Some("C:\\Users\\alice\\Downloads"),
  )
  assert_eq(download_dir_for_env(Windows, {}), None)
  assert_eq(download_dir_for_env(Unknown, {}), None)
}

///|
test "temporary directory resolution covers all branches" {
  assert_eq(
    tmp_dir_for_env(Linux, { "XDG_RUNTIME_DIR": "/run/user/1000" }),
    Some("/run/user/1000/tmp"),
  )
  assert_eq(
    tmp_dir_for_env(Linux, { "TMPDIR": "/tmp/custom" }),
    Some("/tmp/custom"),
  )
  assert_eq(tmp_dir_for_env(Linux, { "TEMP": "/tmp/temp" }), Some("/tmp/temp"))
  assert_eq(tmp_dir_for_env(Linux, { "TMP": "/tmp/tmp" }), Some("/tmp/tmp"))
  assert_eq(tmp_dir_for_env(Linux, {}), Some("/var/tmp"))
  assert_eq(
    tmp_dir_for_env(Darwin, { "TMPDIR": "/var/folders/abc/T/" }),
    Some("/var/folders/abc/T/"),
  )
  assert_eq(tmp_dir_for_env(Darwin, {}), None)
  assert_eq(tmp_dir_for_env(Windows, { "TMP": "C:\\Temp" }), Some("C:\\Temp"))
  assert_eq(
    tmp_dir_for_env(Windows, { "TEMP": "C:\\Windows\\Temp" }),
    Some("C:\\Windows\\Temp"),
  )
  assert_eq(tmp_dir_for_env(Windows, {}), None)
  assert_eq(tmp_dir_for_env(Unknown, {}), None)
}

///|
test "dispatcher covers every supported directory name" {
  let linux_envs : Map[String, String] = {
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
  assert_eq(dir_for_env("home", Linux, linux_envs), Some("/home/alice"))
  assert_eq(dir_for_env("cache", Linux, linux_envs), Some("/cache"))
  assert_eq(dir_for_env("config", Linux, linux_envs), Some("/config"))
  assert_eq(dir_for_env("executable", Linux, linux_envs), Some("/bin-home"))
  assert_eq(dir_for_env("data", Linux, linux_envs), Some("/data"))
  assert_eq(dir_for_env("data_local", Linux, linux_envs), Some("/data"))
  assert_eq(dir_for_env("audio", Linux, linux_envs), Some("/music"))
  assert_eq(dir_for_env("desktop", Linux, linux_envs), Some("/desktop"))
  assert_eq(dir_for_env("document", Linux, linux_envs), Some("/documents"))
  assert_eq(dir_for_env("download", Linux, linux_envs), Some("/downloads"))
  assert_eq(dir_for_env("font", Linux, linux_envs), Some("/data/fonts"))
  assert_eq(dir_for_env("picture", Linux, linux_envs), Some("/pictures"))
  assert_eq(dir_for_env("public", Linux, linux_envs), Some("/public"))
  assert_eq(dir_for_env("template", Linux, linux_envs), Some("/templates"))
  assert_eq(dir_for_env("tmp", Linux, linux_envs), Some("/tmp/custom"))
  assert_eq(dir_for_env("video", Linux, linux_envs), Some("/videos"))
  assert_eq(dir_for_env("unsupported", Linux, linux_envs), None)
}
