-- Legacy business payloads still carry a token; the local store ignores it.
require("internal/timers")
_G.GAME_GLOBAL_KEY = "local-archive"
