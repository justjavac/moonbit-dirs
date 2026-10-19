///|
/// Renders an optional directory path, falling back to a placeholder when the
/// platform cannot resolve it.
fn render(path : String?) -> String {
  match path {
    Some(value) => value
    None => "(unavailable)"
  }
}

///|
/// Prints common user directory paths resolved by this platform.
fn main {
  println("home:   \{render(@dirs.home_dir())}")
  println("cache:  \{render(@dirs.cache_dir())}")
  println("config: \{render(@dirs.config_dir())}")
  println("data:   \{render(@dirs.data_dir())}")
  println("download: \{render(@dirs.download_dir())}")
}
