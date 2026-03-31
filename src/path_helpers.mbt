///|
/// Joins two path segments with the separator expected by the platform.
fn join_path(platform : Platform, base : String, child : String) -> String {
  let normalized = strip_trailing_separators(base, platform)
  if normalized == "" {
    child
  } else if ends_with_separator(normalized) {
    "\{normalized}\{child}"
  } else {
    "\{normalized}\{path_separator(platform)}\{child}"
  }
}

///|
/// Removes trailing separators while preserving filesystem roots.
fn strip_trailing_separators(path : String, platform : Platform) -> String {
  if path == "" || is_root_path(path, platform) || !ends_with_separator(path) {
    path
  } else if path[:].has_suffix("\\") {
    strip_trailing_separators(
      path.strip_suffix("\\").unwrap().to_string(),
      platform,
    )
  } else {
    strip_trailing_separators(
      path.strip_suffix("/").unwrap().to_string(),
      platform,
    )
  }
}

///|
/// Returns the preferred path separator for the platform.
fn path_separator(platform : Platform) -> String {
  match platform {
    Windows => "\\"
    _ => "/"
  }
}

///|
/// Returns true when the path already ends with either slash style.
fn ends_with_separator(path : String) -> Bool {
  path[:].has_suffix("/") || path[:].has_suffix("\\")
}

///|
/// Returns true when the path is a filesystem root that must keep its separator.
fn is_root_path(path : String, platform : Platform) -> Bool {
  match platform {
    Windows => is_windows_root(path)
    _ => path == "/"
  }
}

///|
/// Returns true when the path is a Windows root such as `C:\` or `\`.
fn is_windows_root(path : String) -> Bool {
  if path == "\\" || path == "/" {
    true
  } else if path.length() == 3 {
    let second = path.get_char(1)
    let third = path.get_char(2)
    second == Some(':') && (third == Some('\\') || third == Some('/'))
  } else {
    false
  }
}
