///|
test "public helpers agree with dir dispatcher on the live environment" {
  assert_eq(@dirs.dir("home"), @dirs.home_dir())
  assert_eq(@dirs.dir("cache"), @dirs.cache_dir())
  assert_eq(@dirs.dir("config"), @dirs.config_dir())
  assert_eq(@dirs.dir("data"), @dirs.data_dir())
  assert_eq(@dirs.dir("data_local"), @dirs.data_local_dir())
  assert_eq(@dirs.dir("download"), @dirs.download_dir())
  assert_eq(@dirs.dir("tmp"), @dirs.tmp_dir())
}

///|
test "unsupported public directory names return none" {
  assert_eq(@dirs.dir("desktop"), None)
  assert_eq(@dirs.dir(""), None)
}

///|
test "public helpers return non blank strings when available" {
  let values = [
    @dirs.home_dir(),
    @dirs.cache_dir(),
    @dirs.config_dir(),
    @dirs.data_dir(),
    @dirs.data_local_dir(),
    @dirs.download_dir(),
    @dirs.tmp_dir(),
  ]
  for value in values {
    match value {
      Some(path) => assert_true(path.trim().length() > 0)
      None => continue
    }
  }
}
