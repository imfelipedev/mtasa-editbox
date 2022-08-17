-- <####################################################################################>
--
--                █▀▀▀█ █▀▀▀ █▀▀▀ █░░░ █▀▀█ █▀▀▀█ █▀▀▀█ █▀▀█ █▀▀▄ █▀▀█
--                ▄▄▄▀▀ █▀▀▀ █▀▀▀ █░░░ █▄▄█ ▀▀▀▄▄ ▄▄▄▀▀ █▄▄█ █░▒█ █▄▄█
--                █▄▄▄█ █░░░ █▄▄▄ █▄▄█ █░░░ █▄▄▄█ █▄▄▄█ █░▒█ █▄▄▀ █░▒█
--                                                       
--                  ~# DEUS ACIMA DE TUDO. CONTATO: ! zFelpszada#7276 #~      
--                                                      
-- <####################################################################################>

--// Local variables

local screenW, screenH = guiGetScreenSize()

local allowed_numbers_keys = { ["0"] = true,  ["1"] = true,  ["2"] = true,  ["3"] = true,  ["4"] = true,  ["5"] = true,  ["6"] = true,  ["7"] = true,  ["8"] = true,  ["9"] = true }

local allowed_text_keys = { ["a"] = true, ["b"] = true, ["c"] = true, ["d"] = true, ["e"] = true, ["f"] = true, ["g"] = true, ["h"] = true, ["i"] = true, ["j"] = true, ["k"] = true, ["l"] = true, ["m"] = true, ["n"] = true, ["o"] = true, ["p"] = true, ["q"] = true, ["r"] = true, ["s"] = true, ["t"] = true, ["u"] = true, ["v"] = true, ["w"] = true, ["x"] = true, ["y"] = true, ["z"] = true, ["A"] = true, ["B"] = true, ["C"] = true, ["D"] = true, ["E"] = true, ["F"] = true, ["G"] = true, ["H"] = true, ["I"] = true, ["J"] = true, ["K"] = true, ["L"] = true, ["M"] = true, ["N"] = true, ["O"] = true, ["P"] = true, ["Q"] = true, ["R"] = true, ["S"] = true, ["T"] = true, ["U"] = true, ["V"] = true, ["W"] = true, ["X"] = true, ["Y"] = true, ["Z"] = true, [" "] = true, [","] = true, ["."] = true, ["ç"] = true, ["é"] = true, ["á"] = true, ["õ"] = true, ["ã"] = true, ["?"] = true, ["$"] = true, ["#"] = true, ["&"] = true, ["@"] = true, ["+"] = true, ["="] = true, ["("] = true, [")"] = true, ["%"] = true }

--// Premature Optimization

local pairs = pairs
local min = math.min
local len = utf8.len
local dxDrawText = dxDrawText
local dxGetTextWidth = dxGetTextWidth
local dxDrawRectangle = dxDrawRectangle
local isCursorShowing = isCursorShowing
local getCursorPosition = getCursorPosition
local interpolateBetween = interpolateBetween

--// Class

dxEditBox = { 
    instances = {}, 
    hoverSelf = false, 
    selectedSelf = false 
}

--// Local function

local function renderEditBox()
    dxEditBox.hoverSelf = false
    for self in pairs(dxEditBox.instances) do
        if self.visible then
            local text = self.mask and string.gsub(self.text, ".", "*") or self.text
            local textLength = len(text)
            local textWidth = dxGetTextWidth(text, 1, font)
            local isTextSide = (self.x + textWidth > self.x + self.w and "right" or "left")
            if (textLength == 0 and not self.atived) then
                dxDrawText(self.name, self.x, self.y, self.x + self.w, self.y + self.h, tocolor(150, 150, 150, 255), 1.0, "default", isTextSide, "center", true, false, true)
            else
                dxDrawText(text, self.x, self.y, self.x + self.w, self.y + self.h, tocolor(150, 150, 150, 255), 1.0, "default", isTextSide, "center", true, false, true)
            end

            if (self.atived) then 
                local caretPosX = min(self.x + self.w, self.x + textWidth)
                local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - self.tick) / 1000, "SineCurve")
                dxDrawRectangle(caretPosX, self.y, 1, self.h, tocolor(200, 200, 200, alpha), true)
            end

            if (self.selected) then 
                local selectedW = min(self.w, textWidth)
                dxDrawRectangle(self.x, self.y, selectedW, self.h, tocolor(0, 174, 255, 100), true)
            end

            if isMouseInPosition(self.x, self.y, self.w, self.h) then
                dxEditBox.hoverSelf = self
            end
        end
    end
end

local function clickEditBox(button, state)
    local isUp = (state == "up")
    local isLeft = (button == "left")
    local preSelf = dxEditBox.selectedSelf
    if (preSelf and not isUp) then
        if preSelf.selected then 
            preSelf.selected = false
        end
        
        preSelf.atived = false
        dxEditBox.selectedSelf = false
        guiSetInputMode("allow_binds")
    end
    
    local self = dxEditBox.hoverSelf
    if (not self) then
        return false
    end

    if (isLeft and not isUp) then
        dxEditBox.selectedSelf = self
        dxEditBox.selectedSelf.atived = true
        self.tick = getTickCount()
        guiSetInputMode("no_binds")
    end
end

local function clickKeyEditBox(button, state)
    local self = dxEditBox.selectedSelf
    if (not self) then 
        return false 
    end

    if (not state) then 
        return false 
    end

    local isControl = getKeyState("lctrl")
    if (button == "c" and isControl and self.selected) then
        setClipboard(self.text)
    elseif (button == "a" and isControl) then 
        self.selected = true
    elseif (button == "backspace") then
        if self.selected then 
            self.text = ""
            self.selected = false
            return false 
        end

        self.text = utf8.remove(self.text, -1, -1) 
    end
end

local function characterEditBox(character)
    local self = dxEditBox.selectedSelf
    if (not self) then 
        return false 
    end

    local textLength = len(self.text)
    if (textLength >= self.max) then 
        return false 
    end

    textLength = textLength + 1

    if (self.type == "number") then 
        if allowed_numbers_keys[character] then 
            self.text = utf8.insert(self.text, textLength, character)
        end
        return true 
    end

    if (self.type == "text_2" and character == " ") then 
        return false 
    end

    if allowed_text_keys[character] then 
        self.text = utf8.insert(self.text, textLength, character)
        return true
    end
    return false
end

local function pastEditBox(pastText)
    local self = dxEditBox.selectedSelf
    if (not self) then 
        return false 
    end

    if (self.type == "number") or (self.type == "text_2") then 
        return false 
    end

    local newText = self.text..pastText
    local newTextLength = len(newText)
    self.text = (newTextLength > self.max and utf8.sub(newText, 1, self.max) or newText)
    return true
end

--// Global functions

function dxEditBox.new(x, y, w, h, name, type, maxCharacters, mask, visible)
    local data = {
        x = x,
        y = y,
        w = w, 
        h = h,
        text = "",
        name = name,
        type = type,
        max = maxCharacters,
        atived = false,
        tick = false,
        clicked = false,
        selected = false,
        mask = mask or false,
        visible = visible or false,
    }

    setmetatable(data, {__index = dxEditBox})
    dxEditBox.instances[data] = true
    if (table.length(dxEditBox.instances) == 1) then
        addEventHandler("onClientPaste", root, pastEditBox)
        addEventHandler("onClientKey", root, clickKeyEditBox)
        addEventHandler("onClientRender", root, renderEditBox)
        addEventHandler("onClientCharacter", root, characterEditBox)
        addEventHandler("onClientClick", root, clickEditBox, false, "high")
    end
    return data
end

function dxEditBox.destroyAll()
    dxEditBox.instances = {}
    removeEventHandler("onClientPaste", root, pastEditBox)
    removeEventHandler("onClientClick", root, clickEditBox)
    removeEventHandler("onClientKey", root, clickKeyEditBox)
    removeEventHandler("onClientRender", root, renderEditBox)
    removeEventHandler("onClientCharacter", root, characterEditBox)
    return true
end

function dxEditBox.resetAllText()
    for self in pairs(dxEditBox.instances) do
        self.text = ""
    end
end

function dxEditBox:destroy()
    if (not self:isValidInstance()) then
        return false
    end

    dxEditBox.instances[self] = nil
    if (table.length(dxEditBox.instances) == 0) then
        removeEventHandler("onClientPaste", root, pastEditBox)
        removeEventHandler("onClientClick", root, clickEditBox)
        removeEventHandler("onClientKey", root, clickKeyEditBox)
        removeEventHandler("onClientRender", root, renderEditBox)
        removeEventHandler("onClientCharacter", root, characterEditBox)
    end
end

function dxEditBox:setText(text)
    if (not self:isValidInstance()) then
        return false
    end

    self.text = text
end

function dxEditBox:getText()
    if (not self:isValidInstance()) then
        return false
    end
    return self.text
end

function dxEditBox:setVisible(bool)
    if (not self:isValidInstance()) then
        return false
    end

    self.visible = bool
end

function dxEditBox:isValidInstance()
    return dxEditBox.instances[self]
end

--// Util function

function table.length(t)
    local c = 0
    for _ in pairs(t) do
        c = c + 1
    end
    return c
end

function isMouseInPosition(x, y, width, height)
    if not isCursorShowing() then
        return false 
    end

    local cx, cy = getCursorPosition()
    cx, cy = cx * screenW, cy * screenH
    if (cx >= x and cx <= x + width) and (cy >= y and cy <= y + height) then
        return true
    end
    return false
end