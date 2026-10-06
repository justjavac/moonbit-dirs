///|
/// Prints common user directory paths resolved by this platform.
fn main {
  println("home:   \{@dirs.home_dir()}")
  println("cache:  \{@dirs.cache_dir()}")
  println("config: \{@dirs.config_dir()}")
  println("data:   \{@dirs.data_dir()}")
  println("download: \{@dirs.download_dir()}")
}