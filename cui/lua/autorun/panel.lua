---@class InfoPanel: Panel
---
--- API:
--- panel:SetAlign(number, number)
---  item: number -> align_panel enum [ALIGN_PANEL_CENTER, ALIGN_PANEL_LEFT, ALIGN_PANEL_RIGHT, ALIGN_PANEL_BOTTOM, ALIGN_PANEL_TOP]
--- 
--- panel:SetOffset(number)
---  item: number -> space between rows
--- 
--- panel:SetPadding(number, number)
---  item: number -> space between panel and elements
---
--- panel:SetInfo(rows)  (rows - array of rows; each row - array of items)
---  item: string -> text
---  item: number -> gap
---  item: { text=..., font=..., color=... } -> text
---  item: { mat=Material or \"path\", size=number, color=Color } -> material
---  item: { gap=number } -> horizontal gap
---  item: { pnl=panel, size = {10, 10} } -> simple way to create panel in panel
---
--- Example: 
--- 
--- local p = vgui.Create("InfoPanel")
--- p:SetPos(50, 50)
--- p:SetColor(Color(30,30,30,200))
--- p:SetRounded(8)
--- p:SetAlign(ALIGN_PANEL_LEFT, ALIGN_PANEL_TOP)
--- p:SetOffset(2)
--- p:SetPadding(20, 20)
--- 
--- local matStar = Material("icon16/star.png")
--- 
--- p:SetInfo({
---     {{mat = matStar, size = 16}, 8, {text = "Test1", color = Color(255, 255, 255), font = "DermaDefaultBold"}},
---     {{text = "Aboba 123", color = Color(100, 200, 255), font = "DermaDefault"}, { gap = 6 }, {text = "and more", font = "DermaDefault"} },
---     {{text = "Panel test", font = "DermaDefault"}, 8, {pnl = vgui.Create("DButton"), size = {10, 10}, on_added = function(pnl)
---         pnl:SetText("OnAdded Test")
---     end}},
---     {{text = "Entry full row test", font = "DermaDefault"}, 8, {pnl = vgui.Create("DTextEntry"), sizeY = 50}}
--- })
--- 
--- p:SizeToContents()

local function simple_insert(tbl, element)
    tbl[#tbl + 1] = element
end

local PANEL = {}

ALIGN_PANEL_LEFT   = 0
ALIGN_PANEL_CENTER = 1
ALIGN_PANEL_RIGHT  = 2
ALIGN_PANEL_TOP    = 3
ALIGN_PANEL_BOTTOM = 4

AccessorFunc(PANEL, "m_iRounded", "Rounded", FORCE_NUMBER)
AccessorFunc(PANEL, "m_colColor", "Color")
AccessorFunc(PANEL, "m_strFont", "Font")

function PANEL:Init()
    self.rows = {}
    self.alignX = ALIGN_PANEL_LEFT
    self.alignY = ALIGN_PANEL_CENTER
    self.offsetY = 0
    self.paddingX = 0
    self.paddingY = 0
    self.sizeX = false
    self.sizeY = false

    self:SetRounded(6)
    self:SetFont("DermaDefault")
    self:SetColor(nil)
end

function PANEL:SetAlign(alignX, alignY)
    self.alignX = alignX or ALIGN_PANEL_LEFT
    self.alignY = alignY or ALIGN_PANEL_CENTER
end

function PANEL:SetOffset(offsetY)
    self.offsetY = offsetY or 0
end

function PANEL:SetPadding(paddingX, paddingY)
    self.paddingX = paddingX or 0
    self.paddingY = paddingY or 0
end

function PANEL:ClearInfo()
    for _, rp in ipairs(self.rows) do
        if IsValid(rp) then rp:Remove() end
    end
    self.rows = {}
    self:InvalidateLayout()
end

local function CreateLabel(parent, text, font, col)
    local lbl = vgui.Create("DLabel", parent)
    if font then lbl:SetFont(font) end
    lbl:SetText(tostring(text or ""))
    lbl:SizeToContents()
    lbl:SetTextColor(col or color_white)
    lbl:SetMouseInputEnabled(false)
    return lbl
end

local function CreateIcon(parent, matOrPath, size, col)
    local mat = matOrPath
    if isstring(matOrPath) then mat = Material(matOrPath) end
    local icon = vgui.Create("DPanel", parent)
    icon:SetSize(size or 16, size or 16)
    icon:SetMouseInputEnabled(false)
    icon.Paint = function(_, w, h)
        if not mat then return end
        surface.SetMaterial(mat)
        surface.SetDrawColor(col or color_white)
        surface.DrawTexturedRect(0, 0, w, h)
    end
    return icon
end

-- rows = {
--   { "text", { mat="path", size=16 }, { gap=8 }, { text="hi", color=Color(...) } },
--   { ... } -- second
-- }
function PANEL:SetInfo(rows)
    if not istable(rows) then
        error("InfoPanel:SetInfo expects a table of rows", 2)
        return
    end

    self:ClearInfo()

    for _, rowDef in ipairs(rows) do
        if not istable(rowDef) then continue end

        local row = vgui.Create("DPanel", self)
        row:SetMouseInputEnabled(true)
        row.Paint = function() end
        row.items = {}
        simple_insert(self.rows, row)

        for _, item in ipairs(rowDef) do
            if isstring(item) then
                local lbl = CreateLabel(row, item, self:GetFont(), color_white)
                simple_insert(row.items, lbl)
            elseif isnumber(item) then
                local sp = vgui.Create("DPanel", row)
                sp:SetSize(item, 1)
                sp.Paint = function() end
                simple_insert(row.items, sp)
            elseif istable(item) then
                if item.gap then
                    local sp = vgui.Create("DPanel", row)
                    sp:SetSize(item.gap, 1)
                    sp.Paint = function() end
                    simple_insert(row.items, sp)
                elseif item.text then
                    local font = item.font or self:GetFont()
                    local col = item.color or color_white
                    local lbl = CreateLabel(row, item.text, font, col)
                    simple_insert(row.items, lbl)
                elseif item.mat then
                    local size = item.size or 16
                    local col = item.color or color_white
                    local icon = CreateIcon(row, item.mat, size, col)
                    simple_insert(row.items, icon)
                elseif item.pnl then
                    local panel = item.pnl
                    panel:SetParent(row)
                    if istable(item.size) then panel:SetSize(item.size[1], item.size[2]) else panel.forcedDock = FILL end
                    if isnumber(item.sizeX) then panel:SetTall(item.sizeX) end
                    if isnumber(item.sizeY) then panel:SetTall(item.sizeY) end

                    if isbool(item.mouse_input) then panel:SetMouseInputEnabled(item.mouse_input) end
                    if isfunction(item.on_added) then item.on_added(panel) end

                    simple_insert(row.items, panel)
                end
            elseif type(item) == "IMaterial" then
                local icon = CreateIcon(row, item, 16, color_white)
                simple_insert(row.items, icon)
            else
                local lbl = CreateLabel(row, tostring(item), self:GetFont(), color_white)
                simple_insert(row.items, lbl)
            end
        end
    end

    self:InvalidateLayout()

    for i, row in pairs(self.rows or {}) do
        for _, child in ipairs(row:GetChildren()) do
            if child.autoLayout then
                child:SetSize(self:GetWide(), row:GetTall())
            end
        end
    end
end

function PANEL:SizeToContentsX() self.sizeX = true self:InvalidateLayout() end
function PANEL:SizeToContentsY() self.sizeY = true self:InvalidateLayout() end
function PANEL:SizeToContents() self:SizeToContentsX() self:SizeToContentsY() end

function PANEL:PerformLayout(w, h)
    local rows = self.rows or {}
    if #rows == 0 then return end

    local totalW, totalH = 0, 0
    local rowWidths, rowHeights = {}, {}

    for i, row in ipairs(rows) do
        if not IsValid(row) then continue end

        local rw, rh = 0, 0
        for _, child in ipairs(row:GetChildren()) do
            if child.GetText and child.SizeToContents then pcall(child.SizeToContents, child) end
            rw = rw + child:GetWide()
            rh = math.max(rh, child:GetTall())
        end
        rowWidths[i], rowHeights[i] = rw, rh
        totalW = math.max(totalW, rw)
        totalH = totalH + rh
    end

    local padY = self.paddingY
    if self.alignY == ALIGN_PANEL_TOP then
        padY = self.paddingX / 2
    elseif self.alignY == ALIGN_PANEL_BOTTOM then
        padY = self:GetTall() - totalH - self.paddingY / 2
    end
    self:DockPadding(self.paddingX, padY, self.paddingX, self.paddingY)

    totalW = totalW + self.paddingX * 2
    totalH = totalH + self.paddingY * 2 + (#rows - 1) * (self.offsetY or 0)

    if self.sizeX then self:SetWide(totalW) end
    if self.sizeY then self:SetTall(totalH) end

    for _, row in ipairs(rows) do
        if IsValid(row) then
            row:Dock(NODOCK)
            row:DockMargin(0, 0, 0, 0)
        end
    end

    for i, row in ipairs(rows) do
        if not IsValid(row) then continue end
        row:SetTall(rowHeights[i])
        row:Dock(TOP)
        row:DockMargin(0, 0, 0, (i < #rows) and self.offsetY or 0)

        local rowW = rowWidths[i]
        for _, child in ipairs(row:GetChildren()) do
            child:Dock(NODOCK)
        end

        if self.alignX == ALIGN_PANEL_CENTER then
            row:DockPadding((totalW - self.paddingX * 2 - rowW) / 2, 0, 0, 0)
        elseif self.alignX == ALIGN_PANEL_RIGHT then
            row:DockPadding(totalW - self.paddingX * 2 - rowW, 0, 0, 0)
        else
            row:DockPadding(0, 0, 0, 0)
        end

        for _, child in ipairs(row:GetChildren()) do
            child:Dock(child.forcedDock or LEFT)
            child:DockMargin(0, (rowHeights[i] - child:GetTall()) / 2, 0, (rowHeights[i] - child:GetTall()) / 2)
        end
    end
end

--- simple paint with draw garry's mod library. even you can redefine it
---@param w number
---@param h number
function PANEL:Paint(w, h)
    local col = self:GetColor()
    if not col then return end
    draw.RoundedBox(self:GetRounded() or 0, 0, 0, w, h, col)
end

vgui.Register("InfoPanel", PANEL, "EditablePanel")