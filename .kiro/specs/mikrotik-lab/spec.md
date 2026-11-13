# Simulation Mikrotik - 3D Network Builder Spec

## Project Overview

**Goal:** Build an interactive 3D network simulation system in Roblox where players can freely place networking devices (PC, Switch, Router, etc.), configure them with IP addresses, and monitor connectivity - similar to a physical WinBox interface.

**Gameplay Model:** Inventory hotbar system with unlimited item placement, click-to-interact context menu, and WinBox-style configuration panels.

**Target:** Educational/training platform for networking concepts with hands-on device placement and configuration.

---

## Core Gameplay Loop

1. **Hotbar System** - Bottom-screen UI showing available devices (PC, Switch, Router, Firewall, AP, Server)
2. **Placement** - Click device → ghost model follows mouse → click to place (unlimited placement)
3. **Interaction** - Click placed device → Context menu (Remove/Configure/Info)
4. **Configuration** - Click Configure → WinBox-style panel for IP address, DHCP settings
5. **Monitoring** - See real-time connectivity, ping between devices

---

## Architecture Design

### System Components

```
SimulationMikrotik (Place)
│
├─ Server Systems
│  ├─ DeviceManager - Create/delete/track placed devices
│  ├─ ConfigurationManager - Store device IP/configs
│  ├─ SimulationEngine - Check connectivity
│  ├─ PersistenceManager - Save/load networks
│  └─ NetworkRemotes - Remote event handlers
│
├─ Client Systems
│  ├─ HotbarUI - Bottom inventory bar (PC, Switch, Router, etc)
│  ├─ PlacementSystem - Ghost model + placement mode
│  ├─ InteractionUI - Click menu (Remove/Configure/Info)
│  ├─ ConfigPanel - WinBox-style IP/settings panel
│  ├─ DeviceRaycast - Click detection for placed devices
│  ├─ CameraController - Free look around
│  └─ MonitoringUI - Network stats display
│
└─ Shared Systems
   ├─ DeviceTypes - Device definitions
   ├─ NetworkRemotes - Remote events list
   └─ Constants - Shared configs
```

### Data Flow

```
Player clicks hotbar item "Switch"
    ↓
PlacementSystem: Enter placement mode, show ghost
    ↓
Player moves mouse + sees ghost follow
    ↓
Player clicks to place
    ↓
Client sends PlaceDevice RemoteEvent
    ↓
Server: Create switch model, store data
    ↓
Server: Broadcast to all clients
    ↓
All clients: Show new switch in world
    ↓
Player clicks switch model
    ↓
Client: Show context menu (Remove / Configure)
    ↓
Player clicks Configure
    ↓
Client: Show WinBox IP panel
    ↓
Player enters IP, saves
    ↓
Server: Store config, broadcast update
```

---

## Implementation Phases

### Phase 1: Hotbar + Basic Placement (MVP)
- Hotbar UI with device items
- Ghost model placement system
- Device spawning (default Parts with naming)
- Basic interaction (placeholder)
- Server tracking of devices

### Phase 2: Interaction + Configuration
- Click detection on placed devices
- Context menu (Remove/Configure/Info)
- WinBox-style IP configuration panel
- Device configuration storage
- Config replication to players

### Phase 3: Connectivity & Monitoring
- Network connectivity checking algorithm
- Ping/test between devices
- Real-time monitoring UI
- Device status indicators

### Phase 4: Persistence & Polish
- Save/load networks (DataStore)
- Performance optimization
- UI polish
- Multiplayer testing

---

## File Structure

```
src/simulation-mikrotik/
├── server/
│   ├── DeviceManager.luau
│   ├── ConfigurationManager.luau
│   ├── SimulationEngine.luau
│   ├── PersistenceManager.luau
│   └── init.server.luau
├── client/
│   ├── HotbarUI.luau
│   ├── PlacementSystem.luau
│   ├── InteractionUI.luau
│   ├── ConfigPanel.luau
│   ├── DeviceRaycast.luau
│   ├── CameraController.luau
│   ├── MonitoringUI.luau
│   └── init.client.luau
└── shared/
    ├── DeviceTypes.luau
    ├── NetworkRemotes.luau
    └── Constants.luau
```

---

## Device Specifications

### PC
- **Model:** Gray rectangular shape (10x2x8 studs)
- **Color:** Gray
- **Config:** IP address, hostname, gateway
- **Role:** End device / workstation

### Switch  
- **Model:** Gray horizontal box (12x2x6 studs)
- **Color:** Gray (lighter shade)
- **Config:** IP address (management), VLAN
- **Role:** Network switch

### Router
- **Model:** Blue box (10x4x6 studs)
- **Color:** Blue
- **Config:** IP address, gateway, routes
- **Role:** Gateway/routing device

### Firewall
- **Model:** Red box (8x3x6 studs)
- **Color:** Red
- **Config:** IP address, filtering rules
- **Role:** Security/filtering device

### Access Point
- **Model:** Yellow box with antenna (6x6x8 studs)
- **Color:** Yellow
- **Config:** IP address, SSID, channel
- **Role:** Wireless access point

### Server
- **Model:** Green tower (6x6x10 studs)
- **Color:** Green
- **Config:** IP address, service type
- **Role:** Network service provider

---

## UI/UX Design

### Hotbar (Bottom Screen)
```
┌─────────────────────────────────────────────┐
│ [PC] [Switch] [Router] [Firewall] [AP] [Server] │
└─────────────────────────────────────────────┘
```

### Context Menu (on device click)
```
┌──────────────────┐
│  🔧 Configure    │
│  ❌ Remove       │
│  ⓘ View Info    │
└──────────────────┘
```

### Configuration Panel (WinBox-style)
```
╔════════════════ PC Configuration ════════════════╗
║                                                   ║
║  Device Name: [PC-1________________]             ║
║                                                   ║
║  IP Address:    [192.168.1.100____]             ║
║  Subnet Mask:   [255.255.255.0_____]            ║
║  Gateway:       [192.168.1.1_______]            ║
║                                                   ║
║  [ DHCP ]  [ ✓ Save ]  [ ✗ Cancel ]            ║
║                                                   ║
╚═══════════════════════════════════════════════════╝
```

### Monitoring Panel
```
┌──────────────────────────────┐
│  Network Status              │
├──────────────────────────────┤
│  Active Devices: 5           │
│  Network Range: 192.168.1.0/24
│  Gateway: 192.168.1.1       │
│  Avg Latency: 2.5ms         │
└──────────────────────────────┘
```

---

## Interaction Flow

### Placing a Device
1. Player clicks device button in hotbar
2. PlacementSystem enters placement mode
3. Ghost model appears, follows mouse
4. Player clicks in world → device placed
5. Server confirms placement
6. All players see new device

### Configuring a Device
1. Player clicks placed device in world
2. Context menu appears (Remove/Configure/Info)
3. Player clicks Configure
4. ConfigPanel opens with WinBox-style interface
5. Player enters IP address, gateway, etc
6. Player clicks Save
7. Panel closes, config stored server-side
8. All players see updated device

### Removing a Device
1. Player clicks placed device
2. Context menu appears
3. Player clicks Remove
4. Device removed from world
5. Server confirms deletion
6. All players see device disappear

---

## Multiplayer Considerations

### Device Ownership
- All devices visible to all players
- Any player can interact with any device (for now)
- Future: Per-player device ownership option

### Performance
- Unlimited device placement (but reasonable limits ~50 per player for now)
- Simple Models (just Parts)
- Efficient raycasting for click detection
- Periodic save to avoid data loss

### Sync
- Real-time sync of device placement
- Configuration changes replicate to all players
- No cables/connections initially (future feature)

---

## Success Criteria

✅ Hotbar displays 6 device types  
✅ Can place unlimited devices (within reason)  
✅ Devices are named correctly  
✅ Can remove placed devices  
✅ Can configure IP addresses (WinBox-style UI)  
✅ Configs saved and displayed  
✅ Multi-player sync working  
✅ Free camera movement  
✅ Smooth 60 FPS  
✅ Network saves on logout/rejoins  

---

## Future Enhancements

- [ ] Cable connections between devices
- [ ] Visual network topology diagram
- [ ] Traffic flow visualization
- [ ] Advanced device configurations (DHCP, DNS, routes)
- [ ] Ping/connectivity testing UI
- [ ] Device grouping/organization
- [ ] Device templates/presets
- [ ] Collaborative networks
- [ ] Troubleshooting challenges
- [ ] Leaderboards/achievements
