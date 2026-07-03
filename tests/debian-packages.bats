setup() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "debian-packages: exits 1 when not run as root" {
  run bash "$PROJECT_ROOT/installers/debian/packages.sh"
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "root"
}
