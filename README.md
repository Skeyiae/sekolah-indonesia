# Drawing Canvas System - SekolahIndonesia

Sistem drawing canvas dengan ownership untuk Roblox. Player bisa claim canvas dan menggambar dengan smooth!

## 🎨 Fitur

✅ **Canvas Claiming System** - Player harus claim canvas sebelum bisa menggambar  
✅ **Smooth Drawing** - Drawing yang smooth dengan mouse  
✅ **Ownership Protection** - Hanya owner yang bisa menggambar di canvas miliknya  
✅ **Realtime Replication** - Player lain bisa lihat gambar yang dibuat  
✅ **Drawing Tools UI** - Pilih warna dan ukuran brush  
✅ **Clear Canvas** - Hapus semua gambar di canvas  
✅ **Multi-Canvas Support** - Bisa ada banyak canvas di map

## 📦 Setup

### 1. Install Rojo
```bash
aftman add rojo-rbx/rojo@7.7.0-rc.1
```

### 2. Start Rojo Server
```bash
rojo serve
```

### 3. Setup di Roblox Studio

1. Buka Roblox Studio
2. Install Rojo Plugin dari Marketplace
3. Klik "Connect" di Rojo plugin
4. Masukkan address: `localhost:34872` (atau port yang muncul di terminal)

### 4. Buat Canvas di Workspace

1. Buat Folder di Workspace dengan nama **"Canvases"**
2. Buat Part di dalam folder tersebut (ukuran bebas, misal 10x10x0.5)
3. Beri nama Part sesuai ID canvas (misal: "Canvas1", "Canvas2", etc.)
4. Play test!

## 🎮 Cara Pakai

1. **Claim Canvas**: Dekat ke canvas dan tekan tombol proximity prompt
2. **Drawing UI**: UI tools akan muncul di kanan atas
3. **Pilih Warna**: Klik warna yang diinginkan
4. **Gambar**: Click dan drag mouse di canvas untuk menggambar
5. **Clear**: Tekan tombol "Clear Canvas" untuk hapus semua gambar

## 📁 Struktur Project

```
src/
├── server/
│   ├── CanvasService.luau      # Handle ownership & claiming
│   ├── DrawingService.luau     # Handle drawing replication
│   └── init.server.luau        # Server entry point
├── client/
│   ├── CanvasClient.luau       # UI & canvas management
│   ├── DrawingClient.luau      # Mouse drawing logic
│   └── init.client.luau        # Client entry point
└── shared/
    ├── Types.luau              # Shared type definitions
    └── RemoteEvents.luau       # RemoteEvents setup
```

## 🔧 Customization

### Ubah Warna Default
Edit di `src/client/DrawingClient.luau`:
```lua
DrawingClient.CurrentColor = Color3.fromRGB(0, 0, 0) -- Ganti dengan warna lain
```

### Ubah Ukuran Brush Default
Edit di `src/client/DrawingClient.luau`:
```lua
DrawingClient.BrushSize = 3 -- Ganti angka (1-20)
```

### Tambah Warna di Palette
Edit di `src/client/CanvasClient.luau` di bagian `colors` array:
```lua
local colors = {
    Color3.fromRGB(255, 192, 203), -- Pink
    -- tambah warna lain...
}
```

## 📝 TODO / Ideas

- [ ] Save/Load drawings (DataStore)
- [ ] Eraser tool
- [ ] Undo/Redo functionality
- [ ] Shape tools (circle, rectangle, line)
- [ ] Text tool
- [ ] Canvas permissions (allow friends to draw)
- [ ] Export drawing as image

## 🤝 Kolaborasi

Project ini menggunakan Rojo + Git untuk kolaborasi tim:

```bash
# Pull latest changes
git pull origin main

# Make changes, then:
git add .
git commit -m "Deskripsi perubahan"
git push origin main
```

---

Generated with [Rojo](https://rojo.space) 7.7.0
