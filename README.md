# nvim-camel 🐪

Puts an ASCII camel on your screen.

~[demo](https://github.com/user-attachments/assets/173c3e09-b31f-4bc6-a293-d6b81b99b916)

## Installation

**lazy.nvim**
```lua
{
	"trumpetkern27/nvim-camel",
	opts = {}
}
```

**packer.nvim**
```lua
{
	"trumpetkern27/nvim-camel",
	config = function()
		require("camel").setup()
	end
}
```

## Configuration

```lua
require("camel").setup({
	color = "#C8A97E",	-- hex color for the camel
	right = 5,			-- how many columns from the right the window ends
	top = 5,			-- row position from top
	ticks = 150,		-- ms per animation frame
})
```

## Usage

| Command         | Description               |
|-----------------|---------------------------|
|`:CamelShow`     | Show the camel            |
|`:CamelStart`    | Summon and walk the camel |
|`:CamelStop`     | Stop walking the camel    |
|`:CamelHide`     | Hide the camel            |

## Requirements

- Neovim 0.10+

Copyright (C) 2026 Zach Kern

This project is licensed under the GNU General Public License v3.0 or later.
See the LICENSE file for details.
