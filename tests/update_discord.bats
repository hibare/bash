setup() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "update_discord: script contains Debian guard" {
  grep -q 'Debian-based' "$PROJECT_ROOT/scripts/update_discord.sh"
}

@test "update_discord: downloads Discord deb package with curl" {
  run bash -c 'curl -sI "https://discord.com/api/download/stable?platform=linux&format=deb" | head -1'
  [ "$status" -eq 0 ]
  [[ "$output" =~ 302 ]] || [[ "$output" =~ 200 ]]
}
