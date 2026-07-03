setup() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "debian-packages: exits 1 when not on Debian or not as root" {
  run bash "$PROJECT_ROOT/installers/debian/packages.sh"
  [ "$status" -eq 1 ]
}
