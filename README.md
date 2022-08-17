# mtasa-editbox
Framework which allows you to create custom dx editbox.

# Functions & Events
## Functions
``new``
##### Create a new instance and a editbox.
```lua
dxEditBox.new(x, y, w, h, name, type, maxCharacters, mask, visible)
```

``destroy``
##### Destroy the instance.
```lua
dxEditBox:destroy()
```

``destroyAll``
##### This function destroy all instance.
```lua
dxEditBox:destroyAll()
```

``setText``
##### This function set new text in editbox.
```lua
dxEditBox:setText(text)
```

``getText``
##### This function get the text in editbox.
```lua
dxEditBox:getText()
```

``setVisible``
##### It makes the dxEditBox visible or not.
```lua
dxEditBox:setVisible(bool)
```

``resetAllText``
##### This function resets all dxEditBox text.
```lua
dxEditBox:resetAllText()
```

# Usage
```lua

local editbox

local screenW, screenH = guiGetScreenSize()

local function togglePanel()
    if not editbox then 
        editbox = dxEditBox.new(0, 0, screenW / 2, screenH / 2, "teste", "text", 100, false, true) --// Create an instance
    else
        editbox:destroy() --// Destroy instance
    end
end

```

# License
#### You can use this framework in all your projects. Feel free to edit aswell!
