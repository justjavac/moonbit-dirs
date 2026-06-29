///|
test "public helpers agree with dir dispatcher on the live environment" {
  assert_true(@dirs.dir("home") == @dirs.home_dir())
  assert_true(@dirs.dir("cache") == @dirs.cache_dir())
  assert_true(@dirs.dir("config") == @dirs.config_dir())
  assert_true(@dirs.dir("executable") == @dirs.executable_dir())
  assert_true(@dirs.dir("data") == @dirs.data_dir())
  assert_true(@dirs.dir("data_local") == @dirs.data_local_dir())
  assert_true(@dirs.dir("audio") == @dirs.audio_dir())
  assert_true(@dirs.dir("desktop") == @dirs.desktop_dir())
  assert_true(@dirs.dir("document") == @dirs.document_dir())
  assert_true(@dirs.dir("download") == @dirs.download_dir())
  assert_true(@dirs.dir("font") == @dirs.font_dir())
  assert_true(@dirs.dir("picture") == @dirs.picture_dir())
  assert_true(@dirs.dir("public") == @dirs.public_dir())
  assert_true(@dirs.dir("template") == @dirs.template_dir())
  assert_true(@dirs.dir("tmp") == @dirs.tmp_dir())
  assert_true(@dirs.dir("video") == @dirs.video_dir())
}

///|
test "unsupported public directory names return none" {
  assert_true(@dirs.dir("unsupported") is None)
  assert_true(@dirs.dir("") is None)
}

///|
test "public helpers return non blank strings when available" {
  let values = [
    @dirs.home_dir(),
    @dirs.cache_dir(),
    @dirs.config_dir(),
    @dirs.executable_dir(),
    @dirs.data_dir(),
    @dirs.data_local_dir(),
    @dirs.audio_dir(),
    @dirs.desktop_dir(),
    @dirs.document_dir(),
    @dirs.download_dir(),
    @dirs.font_dir(),
    @dirs.picture_dir(),
    @dirs.public_dir(),
    @dirs.template_dir(),
    @dirs.tmp_dir(),
    @dirs.video_dir(),
  ]
  for value in values {
    match value {
      Some(path) => assert_true(path.trim().length() > 0)
      None => continue
    }
  }
}
