# Multi-Place Setup Guide

This project is structured for multiple Roblox places within one game/universe.

## 📁 Project Structure

```
SekolahIndonesia/
├── lobby.project.json        # Place 1: Main Lobby
├── quiz.project.json          # Place 2: Quiz Arena
├── drawing.project.json       # Place 3: Drawing Studio (existing)
├── default.project.json       # Backup/Development
└── src/
    ├── lobby/
    │   ├── server/            # Lobby server scripts
    │   └── client/            # Lobby client scripts
    ├── quiz/
    │   ├── server/            # Quiz server scripts
    │   └── client/            # Quiz client scripts
    ├── server/                # Drawing server (existing)
    ├── client/                # Drawing client (existing)
    └── shared/
        ├── PlaceConfig.luau   # Place IDs configuration
        ├── TeleportManager.luau  # Teleport system
        ├── Types.luau
        └── RemoteEvents.luau
```

## 🚀 Setup Steps

### Step 1: Publish Lobby Place

1. Start Rojo for lobby:
   ```bash
   rojo serve lobby.project.json
   ```

2. In Roblox Studio:
   - File → Publish to Roblox
   - Choose "Create New Game" or select existing game
   - Name it: "Sekolah Indonesia"
   - Save the **Place ID** (you'll see it in URL)

3. Update `src/shared/PlaceConfig.luau`:
   ```lua
   Lobby = YOUR_LOBBY_PLACE_ID,
   ```

### Step 2: Publish Quiz Place

1. In Roblox Studio (with Lobby place open):
   - View → Asset Manager
   - Click on your game
   - Right-click → "Add New Place"
   - Name it: "Quiz Arena"

2. Start Rojo for quiz:
   ```bash
   rojo serve quiz.project.json
   ```

3. Connect Rojo to the NEW Quiz place

4. Update `src/shared/PlaceConfig.luau`:
   ```lua
   Quiz = YOUR_QUIZ_PLACE_ID,
   ```

### Step 3: Publish Drawing Place

1. In Asset Manager:
   - Right-click game → "Add New Place"
   - Name it: "Drawing Studio"

2. Start Rojo for drawing:
   ```bash
   rojo serve drawing.project.json
   ```

3. Connect Rojo to Drawing place

4. Update `src/shared/PlaceConfig.luau`:
   ```lua
   Drawing = YOUR_DRAWING_PLACE_ID,
   ```

### Step 4: Test Teleportation

1. Publish all places with updated PlaceConfig
2. Join the Lobby place in Roblox app (NOT Studio)
3. Click portal buttons to teleport between places

**⚠️ Important:** Teleportation only works in published games, NOT in Studio "Play" mode!

## 🎮 Development Workflow

### Working on Lobby:
```bash
rojo serve lobby.project.json
```

### Working on Quiz:
```bash
rojo serve quiz.project.json
```

### Working on Drawing:
```bash
rojo serve drawing.project.json
```

### Update All Places:
Commit changes to git, then:
1. Pull latest on different machine/Studio instance
2. Serve each project file
3. Publish each place

## 📝 Adding New Features

### To Lobby:
- Edit files in `src/lobby/`
- Serve `lobby.project.json`
- Publish Lobby place

### To Quiz:
- Edit files in `src/quiz/`
- Serve `quiz.project.json`
- Publish Quiz place

### To Drawing:
- Edit files in `src/client/` and `src/server/`
- Serve `drawing.project.json`
- Publish Drawing place

### Shared Code:
- Edit files in `src/shared/`
- Publish ALL places (shared code affects all)

## 🔧 Troubleshooting

**"Teleport failed" error:**
- Check PlaceConfig has correct Place IDs
- Make sure all places are published
- Verify places are under same game/universe

**"Place ID is 0":**
- You forgot to update PlaceConfig.luau
- Get Place ID from Asset Manager or URL

**Changes not appearing:**
- Republish the place
- Wait ~30 seconds for Roblox servers to update
- Hard refresh in Roblox app

## 📊 Place Overview

| Place | Purpose | Load | Max Players |
|-------|---------|------|-------------|
| Lobby | Hub, portals | Light | 50-100 |
| Quiz | Quiz system | Light | 20-30 |
| Drawing | Canvas, animation | Medium | 20-30 |
| WinBox | 3D network sim | Heavy | 10-20 |

## 🎯 Next Steps

1. ✅ Setup multi-place structure
2. ✅ Create lobby with portals
3. ✅ Setup teleportation system
4. 🔄 Implement quiz system
5. 🔄 Add animation to drawing
6. 🔄 Create WinBox 3D place
7. 🔄 Add DataStore persistence
8. 🔄 Implement leaderboards

---

Made with ❤️ for Sekolah Indonesia
