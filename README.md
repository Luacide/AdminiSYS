# 🛡️ Roblox Anticheat API

A lightweight, modular server-side anticheat system for Roblox games. Host the API on GitHub and load it via `loadstring` — no manual installation required.

---

## ✨ Features

- ✅ PlaceId verification — blocks unauthorized game copies
- ✅ Speed hack detection — flags players exceeding a configurable stud/sec limit
- ✅ Flight / noclip detection — raycasts below players to detect mid-air exploiting
- ✅ Persistent bans via DataStore — bans survive server restarts
- ✅ Escalating punishment — flags → kick → ban
- ✅ Fully modular API — call any function from any server script

---

## 🚀 Quick Start

### 1. Enable HTTP Requests
In Roblox Studio go to **Game Settings → Security → Allow HTTP Requests** and turn it on.

### 2. Load the API in a Server Script
Place a `Script` inside `ServerScriptService` with the following:

```lua
local AnticheatAPI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/YOURNAME/YOURREPO/main/AnticheatAPI.lua"
))()

AnticheatAPI.Init({
    ALLOWED_PLACE_ID = 987654,   -- Replace with your PlaceId
    MAX_SPEED = 60,
    LOG_TO_CONSOLE = true,
})
```

> ⚠️ Replace the URL with your own raw GitHub URL after uploading `AnticheatAPI.lua`.

---

## ⚙️ Configuration

Pass any of these options into `AnticheatAPI.Init({})` to override the defaults:

| Option | Default | Description |
|--------|---------|-------------|
| `ALLOWED_PLACE_ID` | `123456` | Your game's PlaceId |
| `MAX_SPEED` | `50` | Max studs/sec before speed flag |
| `MAX_FLAGS_BEFORE_KICK` | `3` | Flags before player is kicked |
| `MAX_FLAGS_BEFORE_BAN` | `6` | Flags before player is banned |
| `BAN_DATASTORE` | `"BannedPlayers"` | DataStore key for ban persistence |
| `LOG_TO_CONSOLE` | `true` | Print anticheat logs to output |

---

## 📖 API Reference

### `AnticheatAPI.Init(config?)`
Initializes the anticheat. Must be called once at startup.
```lua
AnticheatAPI.Init({ ALLOWED_PLACE_ID = 12345 })
```

### `AnticheatAPI.Flag(player, reason)`
Manually flag a player. Automatically kicks or bans once thresholds are hit.
```lua
AnticheatAPI.Flag(player, "Suspicious teleport")
```

### `AnticheatAPI.Kick(player, reason)`
Immediately kicks a player with a reason.
```lua
AnticheatAPI.Kick(player, "Cheating detected")
```

### `AnticheatAPI.Ban(player, reason)`
Permanently bans a player and saves to DataStore.
```lua
AnticheatAPI.Ban(player, "Speed hacking")
```

### `AnticheatAPI.Unban(userId)`
Removes a ban by UserId.
```lua
AnticheatAPI.Unban(12345678)
```

### `AnticheatAPI.IsBanned(player)`
Returns `true, reason` if the player is banned, otherwise `false, nil`.
```lua
local banned, reason = AnticheatAPI.IsBanned(player)
```

### `AnticheatAPI.GetFlags(player)`
Returns the current flag count for a player.
```lua
print(AnticheatAPI.GetFlags(player)) -- 2
```

### `AnticheatAPI.ClearFlags(player)`
Resets a player's flag count to 0.
```lua
AnticheatAPI.ClearFlags(player)
```

---

## 📁 File Structure

```
your-repo/
├── AnticheatAPI.lua   ← The API (host this on GitHub)
└── README.md          ← This file
```

---

## 🔒 Security Notes

- All anticheat logic runs **server-side** — exploiters cannot bypass or modify it
- Never run anticheat in a `LocalScript` — client-side checks can be bypassed trivially
- `LocalPlayer:Kick()` from a LocalScript can be blocked; this API always kicks from the server
- DataStore bans persist across all servers and restarts

---

## 📝 License

MIT — free to use, modify, and distribute.
