# 🎨 Smart Panel - Smart Layout Manager

A magical panel that automatically arranges your UI elements like a well-organized bookshelf! ✨

## 🚀 Quick Start

```lua
local panel = vgui.Create("clib.panel")
panel:SetPos(50, 50)
panel:SetColor(Color(30, 30, 30, 200))
panel:SetRounded(8)

-- 🎯 Make it pretty
panel:SetAlign(ALIGN_PANEL_LEFT, ALIGN_PANEL_TOP)
panel:SetOffset(2)
panel:SetPadding(20, 20)

-- ✨ Add some content magic!
panel:SetInfo({
    {{mat = Material("icon16/star.png"), size = 16}, 8, {text = "Awesome!", font = "DermaDefaultBold"}},
    {{text = "Hello World", color = Color(100, 200, 255)}, {gap = 6}, {text = "👋"}},
})

panel:SizeToContents()
```

## 🎪 API Circus

### 🧭 `SetAlign(horizontal, vertical)`
**Where to put all the things?**

| Alignment | Values | What it does |
|-----------|--------|--------------|
| Horizontal | `ALIGN_PANEL_LEFT` \| `ALIGN_PANEL_CENTER` \| `ALIGN_PANEL_RIGHT` | Left, center, or right? |
| Vertical | `ALIGN_PANEL_TOP` \| `ALIGN_PANEL_CENTER` \| `ALIGN_PANEL_BOTTOM` | Top, middle, or bottom? |

### 📏 `SetOffset(space)`
**Breathing room between rows**  
`space` - How much personal space each row gets (in pixels)

### 🛋️ `SetPadding(horizontal, vertical)`
**Inner cushioning**  
- `horizontal` - Left/right comfort zone  
- `vertical` - Top/bottom cozy space

### 🎁 `SetInfo(rows)`
**The main event!** Fill me with goodies!
`rows` - An array of rows, each row is a treasure chest of elements

### 🚦 `AddRow(row)`  
**Just fill me with row. So this function adds row to the end of list.**  
`row` - One row table. Not two or more. Alike
```lua
{
    p:AddRow({
        {text = "Added row", font = "DermaDefaultBold"}
    })
}
```

## 🎈 Element Types - Pick Your Poison!

### 📝 Plain Text
```lua
"Just some text"  -- Simple & boring
```

### 🎨 Fancy Text
```lua
{
    text = "I'm fancy!",
    font = "DermaDefaultBold",  -- Optional (default: DermaDefault)
    color = Color(255, 0, 0)    -- Optional (default: 255, 255, 255)
}
```

### 🖼️ Icons & Images
```lua
{
    mat = Material("path/to/image.png"),  -- or just "path/to/image.png"
    size = 16,                           -- Make it big or small!
    color = Color(255, 255, 255, 128)    -- Optional tint
}
```

### ↔️ Horizontal Gap
```lua
8        -- Quick spacing
{gap = 8} -- Fancy spacing
```

### 🧩 Embedded Panel
```lua
{
    pnl = vgui.Create("DButton"),  -- Any panel you want!
    sizeX = 100,                   -- Width (Optional)
    sizeY = 100,                   -- Height (Optional)
    size = {100, 25},              -- Width & height (Optional. If there isn't will auto-size)
    on_added = function(panel)     -- Callback (Optional)
        panel:SetText("Click me! 🎯")
    end
}
```

## 🎯 Pro Tips

- 🚀 **Mix & Match**: Combine different element types in the same row!
- 🎨 **Color Everything**: Most elements support color customization
- 🔧 **Callbacks Rule**: Use `on_added` to configure embedded panels

## 🖼️ Showcase

### 🎯 Center-Aligned Layouts
**Perfect for dashboards and main menus**

<img width="252" height="165" alt="image" src="https://github.com/user-attachments/assets/337689b0-17e1-4f44-9d84-7fecc44d69c4" />

### 🎨 Left-Aligned Layouts  
**Great for settings and lists**

<img width="252" height="165" alt="image" src="https://github.com/user-attachments/assets/0543624d-c9ec-452c-a607-65e8aeffa42d" />

### 🔥 Right-Aligned Layouts
**Ideal for status bars and HUD elements**

<img width="252" height="165" alt="image" src="https://github.com/user-attachments/assets/f757c831-a645-4da6-8140-055c2f3b2217" />
