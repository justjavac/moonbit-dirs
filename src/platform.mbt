///|
/// Reads the current process environment into a map.
fn current_env() -> Map[String, String] {
  @env.get_env_vars()
}

///|
/// Returns the first non-blank environment value for the provided keys.
#cfg(target="native")
fn first_env(envs : Map[String, String], keys : Array[String]) -> String? {
  for key in keys {
    match env_value(envs, key) {
      Some(value) => break Some(value)
      None => continue
    }
  } nobreak {
    None
  }
}

///|
/// Returns a non-blank environment value after trimming whitespace-only entries.
#cfg(target="native")
fn env_value(envs : Map[String, String], key : String) -> String? {
  match envs.get(key) {
    Some(value) if !is_blank(value) => Some(value)
    _ => None
  }
}

///|
/// Returns true when the string contains only whitespace or is empty.
#cfg(target="native")
fn is_blank(value : String) -> Bool {
  value.trim().length() == 0
}
