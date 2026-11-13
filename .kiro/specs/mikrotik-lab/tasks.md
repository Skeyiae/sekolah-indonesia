# Simulation Mikrotik - Implementation Tasks

## Phase 1: Core Device System (Foundation)

### Task 1: Create DeviceTypes module and data structures
**Description:** Define all device types, their properties, ports, and base configurations.

**Sub-tasks:**
- [ ] Create DeviceTypes enum (Router, Switch, Server, Firewall, AP)
- [ ] Define device properties (size, color, port count, defaults)
- [ ] Create device instance structure (ID, owner, position, rotation, config)
- [ ] Create port structure (port ID, port type, connection ID)
- [ ] Add helper functions for device validation

**Input:**
- Device specifications from spec.md

**Output:**
- `src/simulation-mikrotik/shared/DeviceTypes.luau`

---

### Task 2: Create server DeviceManager
**Description:** Manage device creation, deletion, placement, and ownership validation.

**Sub-tasks:**
- [ ] Create DeviceManager class with methods for CRUD operations
- [ ] Implement device creation (spawn model, setup properties)
- [ ] Implement device deletion (remove model, cleanup connections)
- [ ] Implement device movement/rotation
- [ ] Add ownership validation (only owner can modify)
- [ ] Setup RemoteEvent listeners for device actions

**Input:**
- DeviceTypes module
- Device specifications

**Output:**
- `src/simulation-mikrotik/server/DeviceManager.luau`

---

### Task 3: Create 3D device models
**Description:** Build geometric 3D models for each device type using Roblox parts.

**Sub-tasks:**
- [ ] Create Router model (blue box with 4 port indicators)
- [ ] Create Switch model (gray box with 8+ port indicators)
- [ ] Create Server model (green tower with 1 port)
- [ ] Create Firewall model (red box with 2 ports)
- [ ] Create AP model (yellow box with antenna)
- [ ] Add model factory function that returns cloneable model

**Input:**
- Device visual specs from spec.md

**Output:**
- `src/simulation-mikrotik/server/DeviceModels.luau` (or inline in DeviceManager)
- Actual 3D models in workspace template

---

### Task 4: Create client InputHandler for device placement
**Description:** Handle mouse input for selecting and placing devices on grid.

**Sub-tasks:**
- [ ] Create grid snapping system (0.5 stud grid)
- [ ] Implement device preview on mouse movement
- [ ] Implement placement validation (no overlap, within bounds)
- [ ] Connect placement buttons to placement mode
- [ ] Add visual feedback (ghost model, grid highlight)
- [ ] Send placement request to server

**Input:**
- DeviceTypes
- UI button structure

**Output:**
- `src/simulation-mikrotik/client/InputHandler.luau`

---

### Task 5: Create client DeviceUI menu
**Description:** Create main menu for device selection and tools.

**Sub-tasks:**
- [ ] Create floating ScreenGui panel
- [ ] Add device type buttons (Router, Switch, Server, Firewall, AP)
- [ ] Add tool buttons (Config, Stats, Test, Delete, Save)
- [ ] Connect buttons to appropriate handlers
- [ ] Add visual feedback (hover effects, active states)
- [ ] Position panel appropriately on screen

**Input:**
- UI design from spec.md
- RemoteEvent system

**Output:**
- `src/simulation-mikrotik/client/DeviceUI.luau`

---

### Task 6: Create NetworkRemotes module
**Description:** Setup all RemoteEvents and RemoteFunctions for Simulation Mikrotik communication.

**Sub-tasks:**
- [ ] Create RemoteEvent for device placement
- [ ] Create RemoteEvent for device deletion
- [ ] Create RemoteEvent for device configuration updates
- [ ] Create RemoteEvent for connection creation/deletion
- [ ] Create RemoteEvent for network state sync
- [ ] Create RemoteFunction for permission validation

**Input:**
- Feature requirements
- Multi-player scenarios

**Output:**
- `src/simulation-mikrotik/shared/NetworkRemotes.luau`

---

### Task 7: Create server init and setup workspace
**Description:** Initialize server systems and setup simulation place structure.

**Sub-tasks:**
- [ ] Create `init.server.luau` entry point
- [ ] Initialize DeviceManager
- [ ] Setup RemoteEvent handlers
- [ ] Create arena/workspace boundaries
- [ ] Setup player management (track player networks)
- [ ] Initialize PersistenceManager (load saved networks)

**Input:**
- All server modules
- Place structure

**Output:**
- `src/simulation-mikrotik/server/init.server.luau`

---

### Task 8: Create client init
**Description:** Initialize client systems and setup UI.

**Sub-tasks:**
- [ ] Create `init.client.luau` entry point
- [ ] Initialize DeviceUI
- [ ] Initialize InputHandler
- [ ] Initialize CameraController
- [ ] Setup network sync listeners
- [ ] Connect button events to handlers

**Input:**
- All client modules

**Output:**
- `src/simulation-mikrotik/client/init.client.luau`

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
