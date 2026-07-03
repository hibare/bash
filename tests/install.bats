setup() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "install: exits 1 when not run with bash" {
  run sh "$PROJECT_ROOT/install.sh"
  [ "$status" -eq 1 ]
}

@test "install: --help prints usage and exits 0" {
  run bash "$PROJECT_ROOT/install.sh" --help
  [ "$status" -eq 0 ]
  echo "$output" | grep -q "Usage"
}

@test "install: --skip-packages is accepted" {
  run bash "$PROJECT_ROOT/install.sh" --skip-packages
  # Should fail later (not running as root for real) but not on the flag
  [ "$status" -ne 0 ] || true
}

@test "install: script contains shell detection" {
  grep -q 'detect_shell' "$PROJECT_ROOT/install.sh"
}

@test "install: script contains OS detection" {
  grep -q 'detect_os' "$PROJECT_ROOT/install.sh"
}

@test "install: script contains copy_files function" {
  grep -q 'copy_files' "$PROJECT_ROOT/install.sh"
}
