# Simulation Mikrotik - Implementation Tasks (Hotbar-based System)

## Phase 1: Hotbar + Basic Placement (MVP)

### Task 1: Create DeviceTypes module with device definitions
**Description:** Define all 6 device types with their properties (size, color, default config).

**Sub-tasks:**
- [ ] Create device type enum (PC, Switch, Router, Firewall, AP, Server)
- [ ] Define device properties (size, color, display name, default IP)
- [ ] Create device instance structure (ID, owner, position, rotation, config)
- [ ] Create helper functions for type checking and creation

**Output:** `src/simulation-mikrotik/shared/DeviceTypes.luau`

---

### Task 2: Create server DeviceManager for tracking placed devices
**Description:** Manage device creation, deletion, and server-side state.

**Sub-tasks:**
- [ ] Create DeviceManager class with methods (PlaceDevice, RemoveDevice, UpdateConfig, GetDevices)
- [ ] Implement device instance creation (store in table, assign IDs)
- [ ] Implement device deletion/cleanup
- [ ] Track device positions and configurations
- [ ] Setup RemoteEvent listeners

**Output:** `src/simulation-mikrotik/server/DeviceManager.luau`

---

### Task 3: Create default Part-based 3D models for devices
**Description:** Build simple Part-based models for each device type (don't make fancy, just simple boxes with correct colors/sizes).

**Sub-tasks:**
- [ ] PC model (gray box, 10x2x8, with label "PC")
- [ ] Switch model (light gray box, 12x2x6, with label "Switch")
- [ ] Router model (blue box, 10x4x6, with label "Router")
- [ ] Firewall model (red box, 8x3x6, with label "Firewall")
- [ ] AP model (yellow box, 6x6x8, with antenna decal/indicator)
- [ ] Server model (green tower, 6x6x10, with label "Server")
- [ ] Create factory function to clone models

**Output:** Function in DeviceManager or separate ModelFactory.luau

---

### Task 4: Create client PlacementSystem for placing devices
**Description:** Handle hotbar click → placement mode → ghost model → place device.

**Sub-tasks:**
- [ ] Implement placement mode activation
- [ ] Show ghost model following mouse
- [ ] Validate placement (not inside things, within bounds)
- [ ] Detect click to place
- [ ] Send PlaceDevice RemoteEvent to server
- [ ] Exit placement mode after successful placement

**Output:** `src/simulation-mikrotik/client/PlacementSystem.luau`

---

### Task 5: Create client HotbarUI
**Description:** Bottom-screen UI showing 6 device types as clickable buttons.

**Sub-tasks:**
- [ ] Create ScreenGui at bottom of screen
- [ ] Add 6 device buttons (PC, Switch, Router, Firewall, AP, Server)
- [ ] Add hover effects (highlight on mouse over)
- [ ] Connect buttons to PlacementSystem
- [ ] Show current placement status
- [ ] Position and style appropriately

**Output:** `src/simulation-mikrotik/client/HotbarUI.luau`

---

### Task 6: Create NetworkRemotes module
**Description:** All RemoteEvents needed for device placement and interaction.

**Sub-tasks:**
- [ ] RemoteEvent: PlaceDevice(deviceType, position, rotation)
- [ ] RemoteEvent: RemoveDevice(deviceID)
- [ ] RemoteEvent: UpdateDeviceConfig(deviceID, config)
- [ ] RemoteEvent: DevicePlaced (broadcast to all clients)
- [ ] RemoteEvent: DeviceRemoved (broadcast to all clients)
- [ ] RemoteEvent: DeviceConfigUpdated (broadcast)

**Output:** `src/simulation-mikrotik/shared/NetworkRemotes.luau`

---

### Task 7: Create server init and setup
**Description:** Initialize all server systems and setup remotes.

**Sub-tasks:**
- [ ] Create `init.server.luau` entry point
- [ ] Initialize DeviceManager
- [ ] Setup all remote listeners
- [ ] Create arena boundaries (optional)
- [ ] Setup player tracking
- [ ] Load persisted networks on server start

**Output:** `src/simulation-mikrotik/server/init.server.luau`

---

### Task 8: Create client init
**Description:** Initialize all client systems.

**Sub-tasks:**
- [ ] Create `init.client.luau` entry point
- [ ] Initialize HotbarUI
- [ ] Initialize PlacementSystem
- [ ] Initialize DeviceRaycast (for clicking devices)
- [ ] Initialize CameraController
- [ ] Listen for device sync events

**Output:** `src/simulation-mikrotik/client/init.client.luau`

---

## Phase 2: Connection System (Cables & Networking)

### Task 9: Create ConnectionManager on server
**Description:** Manage cable connections between device ports.

**Sub-tasks:**
- [ ] Create connection data structure (ID, device A, port A, device B, port B, status)
- [ ] Implement connection creation (validation, storage)
- [ ] Implement connection deletion
- [ ] Add connection retrieval functions
- [ ] Validate port compatibility
- [ ] Handle orphaned connections on device deletion

**Input:**
- DeviceTypes, DeviceManager
- RemoteEvents

**Output:**
- `src/simulation-mikrotik/server/ConnectionManager.luau`

---

### Task 10: Create cable visual rendering on client
**Description:** Render cables between connected ports.

**Sub-tasks:**
- [ ] Create cable rendering system (Beams or Line parts)
- [ ] Implement cable draw between two 3D points
- [ ] Add cable update on device movement
- [ ] Add cable deletion visual
- [ ] Style cables (colors for different types)
- [ ] Optimize for many cables

**Input:**
- Connection data
- Device positions

**Output:**
- `src/simulation-mikrotik/client/NetworkVisualization.luau` (or part of it)

---

### Task 11: Create client connection UI
**Description:** Allow player to create connections by clicking ports.

**Sub-tasks:**
- [ ] Add port selection mode to InputHandler
- [ ] Implement port highlighting on hover/click
- [ ] Implement connection creation UI flow
- [ ] Send connection request to server
- [ ] Show visual confirmation
- [ ] Handle invalid connections

**Input:**
- InputHandler, DeviceUI, ConnectionManager
- RemoteEvents

**Output:**
- Enhancement to `InputHandler.luau`

---

## Phase 3: Configuration System (Device Settings)

### Task 12: Create ConfigurationManager on server
**Description:** Store and manage device configurations.

**Sub-tasks:**
- [ ] Create configuration data structure per device type
- [ ] Implement config save per device
- [ ] Implement config retrieval
- [ ] Add config validation rules
- [ ] Handle default configs
- [ ] Replicate configs to all players

**Input:**
- DeviceTypes, device specifications
- RemoteEvents

**Output:**
- `src/simulation-mikrotik/server/ConfigurationManager.luau`

---

### Task 13: Create device configuration panels
**Description:** Create SurfaceGui panels on devices for configuration.

**Sub-tasks:**
- [ ] Create generic ConfigPanel class
- [ ] Create Router-specific config panel (IP, gateway, routes)
- [ ] Create Switch-specific config panel (VLAN, ports)
- [ ] Create Server-specific config panel (service, IP)
- [ ] Create Firewall-specific config panel (rules, policy)
- [ ] Create AP-specific config panel (SSID, channel)
- [ ] Add save/cancel functionality

**Input:**
- Device types, configurations
- UI design from spec.md

**Output:**
- `src/simulation-mikrotik/client/ConfigPanel.luau`

---

### Task 14: Create client configuration UI handler
**Description:** Handle device selection and config panel display.

**Sub-tasks:**
- [ ] Add device click detection to InputHandler
- [ ] Implement device selection highlight
- [ ] Implement config panel creation/display
- [ ] Connect panel save button to server update
- [ ] Handle panel closing
- [ ] Replicate configurations to other players

**Input:**
- InputHandler, ConfigPanel, ConfigurationManager
- RemoteEvents

**Output:**
- Enhancement to `InputHandler.luau` and `ConfigPanel.luau`

---

## Phase 4: Visualization & Simulation (Real-time Monitoring)

### Task 15: Create network statistics display
**Description:** Show real-time network stats dashboard.

**Sub-tasks:**
- [ ] Create stats GUI panel (ScreenGui)
- [ ] Display active devices count
- [ ] Display active connections count
- [ ] Display total bandwidth
- [ ] Display average latency
- [ ] Display packet loss percentage
- [ ] Auto-update stats every second

**Input:**
- Network state, device/connection data
- UI design from spec.md

**Output:**
- `src/simulation-mikrotik/client/NetworkVisualization.luau`

---

### Task 16: Create traffic flow visualization
**Description:** Visualize network traffic with particles/beams along cables.

**Sub-tasks:**
- [ ] Create particle system for traffic visualization
- [ ] Implement traffic particles moving along cables
- [ ] Add color coding (normal/warning/critical)
- [ ] Implement bandwidth-based particle speed
- [ ] Add packet loss drop effects
- [ ] Optimize for performance

**Input:**
- Connection data, simulation data
- Cable rendering system

**Output:**
- Enhancement to `NetworkVisualization.luau`

---

### Task 17: Implement basic network simulation engine
**Description:** Simple simulation to calculate connectivity and latency.

**Sub-tasks:**
- [ ] Create SimulationEngine class
- [ ] Implement connection tracking (which devices can reach which)
- [ ] Implement latency calculation (distance + config-based)
- [ ] Implement packet loss based on configuration
- [ ] Implement bandwidth tracking
- [ ] Run simulation loop every 0.5 seconds

**Input:**
- Device/connection data
- Configuration data

**Output:**
- `src/simulation-mikrotik/server/SimulationEngine.luau`

---

### Task 18: Create ping/test connectivity feature
**Description:** Allow players to test connectivity between devices.

**Sub-tasks:**
- [ ] Create test mode in UI
- [ ] Allow source device selection
- [ ] Allow destination device selection
- [ ] Run simulation test (calculate path, latency, loss)
- [ ] Display test results (path taken, latency, loss, status)
- [ ] Add visual indication of test result

**Input:**
- SimulationEngine, ConfigPanel
- UI design

**Output:**
- Enhancement to `DeviceUI.luau` and visualization

---

## Phase 5: Persistence (Save/Load)

### Task 19: Create PersistenceManager
**Description:** Save and load network configurations to DataStore.

**Sub-tasks:**
- [ ] Create DataStore structure for networks
- [ ] Implement network save (serialize all devices + connections + configs)
- [ ] Implement network load (deserialize and rebuild)
- [ ] Add auto-save on changes (debounced)
- [ ] Add manual save button
- [ ] Handle save/load errors gracefully

**Input:**
- All network data structures
- RemoteEvents

**Output:**
- `src/simulation-mikrotik/server/PersistenceManager.luau`

---

### Task 20: Integrate persistence into workflow
**Description:** Connect persistence to device management operations.

**Sub-tasks:**
- [ ] Auto-save on device placement
- [ ] Auto-save on device deletion
- [ ] Auto-save on connection creation/deletion
- [ ] Auto-save on configuration changes
- [ ] Load network on player join
- [ ] Display save status to player

**Input:**
- PersistenceManager
- DeviceManager, ConnectionManager, ConfigurationManager

**Output:**
- Enhancement to server init and managers

---

## Phase 6: Polish & Optimization

### Task 21: Implement camera controller
**Description:** Smooth free-look camera for exploring network.

**Sub-tasks:**
- [ ] Create CameraController class
- [ ] Implement WASD movement
- [ ] Implement mouse look (right-click drag)
- [ ] Add camera height/speed settings
- [ ] Implement collision detection with world
- [ ] Add smooth acceleration/deceleration

**Input:**
- Camera mechanics
- Input handling

**Output:**
- `src/simulation-mikrotik/client/CameraController.luau`

---

### Task 22: Optimize performance
**Description:** Ensure smooth 60 FPS with multiple devices/connections.

**Sub-tasks:**
- [ ] Profile and identify bottlenecks
- [ ] Optimize cable rendering (pooling, LOD)
- [ ] Optimize particle effects
- [ ] Optimize simulation engine calculations
- [ ] Add LOD for distant devices
- [ ] Limit max devices per player (50)
- [ ] Implement connection pooling

**Input:**
- All systems
- Performance metrics

**Output:**
- Optimizations across modules

---

### Task 23: Polish UI/UX
**Description:** Improve user interface and experience.

**Sub-tasks:**
- [ ] Add tooltips to all buttons
- [ ] Improve visual feedback (hover, click, active states)
- [ ] Add loading indicators
- [ ] Add error messages
- [ ] Improve panel designs
- [ ] Add sound effects (optional)
- [ ] Add keyboard shortcuts

**Input:**
- UI design, user feedback
- All UI components

**Output:**
- Enhancements to all UI components

---

### Task 24: Test multiplayer functionality
**Description:** Ensure multi-player isolation and sync work correctly.

**Sub-tasks:**
- [ ] Test device placement isolation
- [ ] Test configuration privacy
- [ ] Test real-time sync (add device, see in all players)
- [ ] Test permission system
- [ ] Test with 2+ players simultaneously
- [ ] Fix any sync issues

**Input:**
- Multiplayer system
- RemoteEvents

**Output:**
- Bugfixes and refinements

---

## Dependencies

```
Phase 1 (Foundation) - Required for all
├─ Task 1: DeviceTypes
├─ Task 2: DeviceManager (depends on 1)
├─ Task 3: Device Models (depends on 1)
├─ Task 4: InputHandler (depends on 1, 2)
├─ Task 5: DeviceUI
├─ Task 6: NetworkRemotes
├─ Task 7: Server Init (depends on 1, 2, 6)
└─ Task 8: Client Init (depends on 4, 5, 6)

Phase 2 (Connections) - Depends on Phase 1
├─ Task 9: ConnectionManager
├─ Task 10: Cable Rendering
└─ Task 11: Connection UI

Phase 3 (Config) - Depends on Phase 1
├─ Task 12: ConfigurationManager
├─ Task 13: Config Panels
└─ Task 14: Config UI Handler

Phase 4 (Visualization) - Depends on Phase 2, 3
├─ Task 15: Stats Display
├─ Task 16: Traffic Visualization
├─ Task 17: Simulation Engine
└─ Task 18: Ping/Test Feature

Phase 5 (Persistence) - Can start after Phase 3
├─ Task 19: PersistenceManager
└─ Task 20: Integration

Phase 6 (Polish) - Final phase
├─ Task 21: Camera Controller
├─ Task 22: Performance
├─ Task 23: UI Polish
└─ Task 24: Multiplayer Testing
```

---

## Success Criteria Per Phase

**Phase 1:** Can place devices, see 3D models, select/delete devices  
**Phase 2:** Can create connections between ports, see cables  
**Phase 3:** Can configure devices, configs persist  
**Phase 4:** Can see real-time stats, traffic visualization, test connectivity  
**Phase 5:** Network saves/loads on logout/login  
**Phase 6:** Smooth 60 FPS, polished UI, multiplayer working  
