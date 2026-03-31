///|
test "public helpers agree with dir dispatcher on the live environment" {
  assert_eq(@moonbit_dirs.dir("home"), @moonbit_dirs.home_dir())
  assert_eq(@moonbit_dirs.dir("cache"), @moonbit_dirs.cache_dir())
  assert_eq(@moonbit_dirs.dir("config"), @moonbit_dirs.config_dir())
  assert_eq(@moonbit_dirs.dir("data"), @moonbit_dirs.data_dir())
  assert_eq(@moonbit_dirs.dir("data_local"), @moonbit_dirs.data_local_dir())
  assert_eq(@moonbit_dirs.dir("download"), @moonbit_dirs.download_dir())
  assert_eq(@moonbit_dirs.dir("tmp"), @moonbit_dirs.tmp_dir())
}

///|
test "unsupported public directory names return none" {
  assert_eq(@moonbit_dirs.dir("desktop"), None)
  assert_eq(@moonbit_dirs.dir(""), None)
}

///|
test "public helpers return non blank strings when available" {
  let values = [
    @moonbit_dirs.home_dir(),
    @moonbit_dirs.cache_dir(),
    @moonbit_dirs.config_dir(),
    @moonbit_dirs.data_dir(),
    @moonbit_dirs.data_local_dir(),
    @moonbit_dirs.download_dir(),
    @moonbit_dirs.tmp_dir(),
  ]
  for value in values {
    match value {
      Some(path) => assert_true(path.trim().length() > 0)
      None => continue
    }
  }
}
