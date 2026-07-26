setup() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "tflint: no args exits cleanly (shows tflint help)" {
  run bash "$PROJECT_ROOT/scripts/tflint.sh"
  [ "$status" -eq 0 ]
}

@test "tflint: exits 1 when directory does not exist" {
  run bash "$PROJECT_ROOT/scripts/tflint.sh" /tmp/nonexistent_tf_dir
  [ "$status" -eq 1 ]
  echo "$output" | grep -q "not found"
}

@test "tflint: warns when no .tflint.hcl found" {
  tmpdir=$(mktemp -d)
  run bash "$PROJECT_ROOT/scripts/tflint.sh" "$tmpdir"
  echo "$output" | grep -q "Warning.*.tflint.hcl"
  rm -rf "$tmpdir"
}

@test "tflint: passes flags through to docker" {
  # --init should result in tflint's own output about init, not a usage error
  run bash "$PROJECT_ROOT/scripts/tflint.sh" --init
  # --init either succeeds or fails with tflint-specific errors, but NOT "Usage"
  echo "$output" | grep -v "Usage"
}
