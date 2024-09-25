# 🔊 reverb.nvim

reverb.nvim is a Neovim plugin that adds sound effects to specific autocmd events. With this plugin, you can enhance your Neovim experience by associating various sounds with different actions, providing an auditory dimension to your coding environment.

https://github.com/whleucka/reverb.nvim/assets/71740767/1e3a16f0-8562-41fd-8d71-bb136ab953e3

⭐ *Turn sound on* 

Any suggestions or help is welcome and appreciated 😄

## Dependencies

Sound files cam be played with `paplay`, `pw-play` or `mpv`. Check with your local package manager if you're not sure.

## Installation

To get started, configure the plugin's options in your Neovim configuration. Here's an example of customizing the sounds using [Lazy](https://github.com/folke/lazy.nvim):

```lua
{
  "whleucka/reverb.nvim",
  event = "BufReadPre",
  opts = {
    player = "paplay", -- options: paplay (default), pw-play, mpv
    max_sounds = 20, -- Limit the amount of sounds that can play at the same time
    sounds = {
      -- add custom sound paths for other events here
      -- eg. EVENT = "/some/path/to/sound.mp3"
      BufRead = { path = sound_dir .. "start.ogg", volume = 0-100 },
      CursorMovedI = { path = sound_dir .. "click.ogg", volume = 0-100 },
      InsertLeave = { path = sound_dir .. "toggle.ogg", volume = 0-100 },
      ExitPre = { path = sound_dir .. "exit.ogg", volume = 0-100 },
      BufWrite = { path = sound_dir .. "save.ogg", volume = 0-100 },
    },
  },
}
```

You can manage the sound settings in reverb.nvim with the following commands:

- `:ReverbToggle` to switch sounds on or off.
- `:ReverbEnable` to turn sounds on.
- `:ReverbDisable` to turn sounds off.


## Sound Effects

- By default, reverb.nvim does *not* ship with any sounds. 
- Free (CC0) interface sounds at [https://www.kenney.nl/assets/interface-sounds](https://www.kenney.nl/assets/interface-sounds)

## License

This project is licensed under the [MIT License](LICENSE).
