# Simulation Mikrotik - 3D Network Builder

## 📋 Overview
Players dapat membangun dan mengkonfigurasi jaringan MikroTik mereka sendiri secara interaktif di ruang 3D. System ini memungkinkan player menempatkan devices (router, switch, server), menghubungkannya dengan cable, dan memonitor traffic real-time.

## 🎯 Core Features

### 1. Device Placement System
- **Types of Devices:**
  - Router (pusat kontrol, bisa 4 port)
  - Switch (8-24 port)
  - Server (end device)
  - Firewall (security device)
  - Access Point (wireless)

- **Placement Mechanics:**
  - Player click button → Grid selector appears
  - Dapat preview device sebelum place
  - Place device di grid (snap to grid)
  - Dapat move/delete device setelah placed
  - Device ownership → hanya owner bisa modify

### 2. Cable Connection System
- **Cable Types:**
  - Ethernet cable (physical connection visual)
  - Wireless link (beam effect)
  
- **Connection Flow:**
  - Click port device A
  - Click port device B
  - Cable auto-draw between them
  - Cable bisa di-delete
  - Visual feedback untuk active connections

### 3. Device Configuration Panel
- **Access:** Click device → SurfaceGui panel appears on device
- **Configurable per device type:**
  - **Router:** IP address, gateway, routing rules
  - **Switch:** VLAN settings, port configuration
  - **Server:** IP, service type, status
  - **Firewall:** Rules, port blocking
  - **Access Point:** SSID, channel, power

### 4. Network Visualization
- **Real-time Monitoring:**
  - Traffic flow visualization (particles along cables)
  - Bandwidth usage per device
  - Active connections highlight
  - Device status indicators (online/offline)
  - Network map/minimap

### 5. Network Simulation
- **Basic Simulation:**
  - Ping connectivity test
  - Packet loss visualization
  - Latency display
  - Bandwidth allocation
  - DHCP pool assignment

### 6. Multiplayer Features
- **Per-Player Networks:**
  - Each player builds own network in their area
  - Can't modify other player's devices
  - Can view other networks (spectate)
  - Optional: Shared network (collaborative)

### 7. Persistence
- **Save/Load:**
  - Network configuration saved to DataStore
  - On rejoin: network rebuilds automatically
  - Share network configs via codes

## 📊 Device Specs

### Router
```
- Ports: 4 Ethernet ports
- Size: 10x4x6 studs
- Color: Blue
- Config: IP, Gateway, Routes, NAT
- Logic: Central hub, routes packets
```

### Switch
```
- Ports: 8 or 16 ports
- Size: 10x2x6 studs
- Color: Gray
- Config: VLAN, Port mirroring
- Logic: Layer 2 switching
```

### Server
```
- Ports: 1 Ethernet port
- Size: 4x4x8 studs
- Color: Green
- Config: IP, Service (DNS/HTTP/etc)
- Logic: Data endpoint
```

### Firewall
```
- Ports: 2 ports (In/Out)
- Size: 8x3x6 studs
- Color: Red
- Config: Rules, blocking, logging
- Logic: Traffic filtering
```

### Access Point
```
- Ports: 1 Ethernet + Wireless
- Size: 4x4x4 studs
- Color: Yellow
- Config: SSID, Channel, Power
- Logic: Wireless bridge
```

## 🎮 User Experience Flow

1. **Enter Simulation Mikrotik place**
2. **See empty grid-based arena**
3. **UI Menu appears:**
   - Device selection buttons
   - Delete/Move tools
   - Configuration viewer
   - Network stats dashboard
4. **Place devices:**
   - Click "Add Router" → Grid selector
   - Place router in area
   - Router appears 3D model
5. **Connect devices:**
   - Click port A (highlight)
   - Click port B
   - Cable drawn, connection established
6. **Configure devices:**
   - Click device → Panel appears
   - Set IP, settings, etc
7. **Monitor network:**
   - See traffic flow
   - Check bandwidth
   - Test connectivity
8. **Save/Export:**
   - Auto-save to DataStore
   - Can export config as code

## 🛠️ Technical Requirements

- **3D Models:** Simple geometric shapes (Part-based)
- **UI Panels:** SurfaceGui on devices
- **Networking:** RemoteEvents for multi-player sync
- **Persistence:** DataStore for saving configs
- **Performance:** Efficient cable rendering, particle optimization

## ✅ Success Criteria

- [ ] Can place 4+ device types
- [ ] Can connect devices with cables
- [ ] Can configure each device
- [ ] Network persists after logout
- [ ] Multi-player isolation working
- [ ] Real-time traffic visualization
- [ ] Smooth 3D interaction
- [ ] UI responsive and intuitive
