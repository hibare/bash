setup() {
  PROJECT_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

@test "update_discord: script contains Debian guard" {
  grep -q 'Debian-based' "$PROJECT_ROOT/scripts/update_discord.sh"
}

@test "update_discord: download URL responds with redirect" {
  run bash -c 'curl -sI "https://discord.com/api/download/stable?platform=linux&format=deb" | head -1'
  [ "$status" -eq 0 ]
  # Discord may return 302, 303, or other redirect codes depending on CDN
  [[ "$output" =~ 30[0-9] ]]
}
