///|
test "public helpers agree with dir dispatcher on the live environment" {
  @debug.assert_eq(@dirs.dir("home"), @dirs.home_dir())
  @debug.assert_eq(@dirs.dir("cache"), @dirs.cache_dir())
  @debug.assert_eq(@dirs.dir("config"), @dirs.config_dir())
  @debug.assert_eq(@dirs.dir("executable"), @dirs.executable_dir())
  @debug.assert_eq(@dirs.dir("data"), @dirs.data_dir())
  @debug.assert_eq(@dirs.dir("data_local"), @dirs.data_local_dir())
  @debug.assert_eq(@dirs.dir("audio"), @dirs.audio_dir())
  @debug.assert_eq(@dirs.dir("desktop"), @dirs.desktop_dir())
  @debug.assert_eq(@dirs.dir("document"), @dirs.document_dir())
  @debug.assert_eq(@dirs.dir("download"), @dirs.download_dir())
  @debug.assert_eq(@dirs.dir("font"), @dirs.font_dir())
  @debug.assert_eq(@dirs.dir("picture"), @dirs.picture_dir())
  @debug.assert_eq(@dirs.dir("public"), @dirs.public_dir())
  @debug.assert_eq(@dirs.dir("template"), @dirs.template_dir())
  @debug.assert_eq(@dirs.dir("tmp"), @dirs.tmp_dir())
  @debug.assert_eq(@dirs.dir("video"), @dirs.video_dir())
}

///|
test "unsupported public directory names return none" {
  @debug.assert_eq(@dirs.dir("unsupported"), None)
  @debug.assert_eq(@dirs.dir(""), None)
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
