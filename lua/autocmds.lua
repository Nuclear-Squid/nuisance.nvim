local utils = require("utils")

local M = {}

vim.api.nvim_create_augroup("nuisance", {
    clear = true,
})

local missing_sounds = {}

RUNNING_PROCESSES = 0

-- Helper function to pick a random sound file if 'sound.path' is a list
local function get_sound_path(sound)
    if type(sound.path) == "table" then
        local index = math.random(#sound.path)
        return vim.fn.expand(sound.path[index])
    else
        return vim.fn.expand(sound.path)
    end
end

local function wait(time)
    if type(time) == "nil" then
        return
    end
    vim.cmd.sleep(time .. 'm')
end

local cb = function(event, sound, player, max_sounds)
    -- Don't do anything if the plugin is disabled
    if not PLUGIN_ENABLED then
        return
    end

    -- Get the path to the audio file
    local path = get_sound_path(sound)

    if math.random(1, math.abs(1 / (sound.probability or 1))) ~= 1 then
        return
    end

    -- Don't play if enough processes are already playing
    local max_running_processes = max_sounds or 20
    if RUNNING_PROCESSES >= max_running_processes then
        return
    end

    -- Choose which player command should be used
    -- Choose paplay as default
    local player_function = utils.paplay_play_sound
    if player == "paplay" then
        player_function = utils.paplay_play_sound
    elseif player == "pw-play" then
        player_function = utils.pw_play_play_sound
    elseif player == "mpv" then
        player_function = utils.mpv_play_sound
    end

    -- wait(1000)

    if utils.path_exists(path) then
        -- There could be other events?
        if event == "BufWrite" then
            -- only if the buffer has been modified ?
            local buf = vim.api.nvim_get_current_buf()
            local buf_modified = vim.api.nvim_buf_get_option(buf, "modified")
            if buf_modified then
                RUNNING_PROCESSES = RUNNING_PROCESSES + 1
                player_function(path, sound.volume)
                wait(sound.delay)
            end
        else
            RUNNING_PROCESSES = RUNNING_PROCESSES + 1
            player_function(path, sound.volume)
            wait(sound.delay)
        end
    else
        if not missing_sounds[path] then
            missing_sounds[path] = true
            print("file " .. path .. "does not exist")
        end
    end
end

-- Options are loaded from lua/nuisance.lua
M.load = function(opts)
    local sounds = opts.sounds
    for event, sound in pairs(sounds) do
        vim.api.nvim_create_autocmd(event, {
            group = "nuisance",
            pattern = "*",
            callback = function()
                cb(event, sound, opts.player, opts.max_sounds)
            end,
        })
    end
end

return M
