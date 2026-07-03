setup() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "hadolint: exits 1 when no arguments given" {
  run bash "$PROJECT_ROOT/scripts/hadolint.sh"
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "Usage"
}

@test "hadolint: exits 1 when Dockerfile does not exist" {
  run bash "$PROJECT_ROOT/scripts/hadolint.sh" /tmp/nonexistent_Dockerfile
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "not found"
}
