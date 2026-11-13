# Simulation Mikrotik - 3D Network Builder Spec

## Project Overview

**Goal:** Build an interactive 3D network simulation system in Roblox where players can design, configure, and monitor MikroTik networks.

**Target:** Educational/training platform for networking concepts with real-time visualization.

---

## Architecture Design

### System Components

```
SimulationMikrotik (Place)
│
├─ Server Systems
│  ├─ DeviceManager - Create/delete/track devices
│  ├─ ConnectionManager - Handle cable connections
│  ├─ ConfigurationManager - Store device configs
│  ├─ SimulationEngine - Run network simulation
│  └─ PersistenceManager - Save to DataStore
│
├─ Client Systems
│  ├─ DeviceUI - Placement and interaction
│  ├─ ConfigPanel - SurfaceGui configuration
│  ├─ NetworkVisualization - Traffic rendering
│  ├─ InputHandler - Mouse/selection logic
│  └─ CameraController - Free look camera
│
└─ Shared Systems
   ├─ DeviceTypes - Type definitions
   ├─ NetworkRemotes - Remote events
   └─ Constants - Shared configs
```

### Data Flow

```
Player Action
    ↓
Client InputHandler
    ↓
RemoteEvent to Server
    ↓
Server DeviceManager/ConnectionManager
    ↓
Update DataStore
    ↓
Broadcast to all players (RemoteEvent)
    ↓
Client updates visualization
```

---

## Implementation Phases

### Phase 1: Core Device System (Foundation)
- Device models (geometric shapes)
- Device placement grid system
- Device ownership/permissions
- Basic UI menu

### Phase 2: Connection System
- Cable connections between ports
- Visual cable rendering (beam or line)
- Connection validation
- Delete connections

### Phase 3: Configuration System
- SurfaceGui panels on devices
- Device-specific configuration UIs
- Save/load configurations
- Config replication to players

### Phase 4: Visualization & Simulation
- Traffic flow particles
- Bandwidth monitoring display
- Network statistics dashboard
- Ping/connectivity testing

### Phase 5: Persistence
- DataStore integration
- Network save/load
- Auto-save on changes
- Export/import configs

### Phase 6: Polish & Multiplayer
- Multi-player device isolation
- Smooth interactions
- Performance optimization
- UI improvements

---

## File Structure

```
src/simulation-mikrotik/
├── server/
│   ├── DeviceManager.luau
│   ├── ConnectionManager.luau
│   ├── ConfigurationManager.luau
│   ├── SimulationEngine.luau
│   ├── PersistenceManager.luau
│   └── init.server.luau
├── client/
│   ├── DeviceUI.luau
│   ├── ConfigPanel.luau
│   ├── NetworkVisualization.luau
│   ├── InputHandler.luau
│   ├── CameraController.luau
│   └── init.client.luau
└── shared/
    ├── DeviceTypes.luau
    ├── NetworkRemotes.luau
    ├── Constants.luau
    └── Utilities.luau
```

---

## Device Specifications

### Router
- **Visual:** Blue cube with 4 labeled ports
- **Ports:** 4 Ethernet
- **Config:** IP address, gateway, static routes
- **Logic:** Route packets between networks

### Switch
- **Visual:** Gray rectangular prism with 8+ ports
- **Ports:** 8 or 16 Ethernet (configurable)
- **Config:** Port VLAN, port mirroring, STP
- **Logic:** Bridge frames between ports

### Server
- **Visual:** Green tower shape with 1 port
- **Ports:** 1 Ethernet
- **Config:** Service type, IP, open ports
- **Logic:** End device/service provider

### Firewall
- **Visual:** Red box with 2 ports (IN/OUT)
- **Ports:** 2 (WAN in, LAN out)
- **Config:** Firewall rules, logging, policy
- **Logic:** Filter and block traffic

### Access Point
- **Visual:** Yellow box with antenna representation
- **Ports:** 1 Ethernet + wireless
- **Config:** SSID, channel, power, security
- **Logic:** Wireless bridge

---

## UI/UX Design

### Main Menu (Floating Panel)
```
┌─ Simulation Mikrotik ─────┐
├─ Device Tools            │
│  [+ Router] [+ Switch]    │
│  [+ Server] [+ Firewall]  │
│  [+ AP]     [🗑 Delete]   │
├─ Tools                   │
│  [🔧 Config] [📊 Stats]   │
│  [🧪 Test] [💾 Save]     │
└───────────────────────────┘
```

### Device Configuration Panel (SurfaceGui on Device)
```
┌─ Router Configuration ─┐
├─ IP Address: [____] │
├─ Gateway: [____]    │
├─ Routes:           │
│  [+ Add Route]      │
├─ NAT Rules:        │
│  [+ Add Rule]       │
└─────────────────────┘
```

### Network Stats Dashboard
```
┌─ Network Stats ────────┐
├─ Active Devices: 5    │
├─ Connections: 7       │
├─ Total Bandwidth: 1Gbps│
├─ Avg Latency: 2.5ms   │
├─ Packet Loss: 0%      │
└────────────────────────┘
```

---

## Interaction Flow

### Placing a Device
1. Player clicks "+ Router" button
2. Grid placement mode activated
3. Player moves mouse → sees ghost router following
4. Click to place → router appears
5. Confirmation message

### Connecting Devices
1. Player clicks port A (highlights)
2. Player clicks port B (highlights)
3. Cable draws between ports
4. Connection stored server-side
5. Visual connection confirmed

### Configuring Device
1. Player clicks on device (highlights + outline)
2. Configuration panel appears on device surface
3. Player edits settings
4. Click "Save" → updates server
5. Changes replicate to all players

### Testing Network
1. Player clicks "Test" tool
2. Select source device
3. Select destination device
4. Ping test runs
5. Results show latency, packet loss, path

---

## Multiplayer Considerations

### Isolation
- Each player gets own "workspace" area
- Devices are per-player owned
- Can't modify other player devices
- Can view but not edit others' networks

### Sharing (Future)
- Optional collaborative mode
- Multiple players edit same network
- Conflict resolution
- Admin controls

### Performance
- Limit devices per player (20-50)
- Limit connections per player (100)
- LOD for distant networks
- Cable pooling for efficiency

---

## Success Metrics

✅ Can place 5 device types  
✅ Can connect devices with visual cables  
✅ Can configure each device type  
✅ Network persists after logout  
✅ Multi-player isolation works  
✅ Real-time updates visible  
✅ Smooth 60 FPS interaction  
✅ UI intuitive and responsive  

---

## Future Enhancements

- [ ] Animation for packet movement
- [ ] Advanced simulation (BGP, OSPF)
- [ ] Network templates/presets
- [ ] Collaborative networks
- [ ] Troubleshooting challenges
- [ ] Quiz integration
- [ ] Leaderboards
- [ ] Custom device creation
