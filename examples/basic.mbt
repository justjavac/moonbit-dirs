fn main {
  println("home: \{to_repr(@dirs.home_dir())}")
  println("cache: \{to_repr(@dirs.cache_dir())}")
}
