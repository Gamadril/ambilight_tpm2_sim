-- uncomment for debugging with tomblind.local-lua-debugger-vscode
-- require("lldebugger").start()

require("config")

local server_thread
local server_channel

local dot_side
local MIN_DOT_SIDE = 6
local MAX_DOT_SIDE = 15
local MIN_DOT_SPACE = 2
local dot_space_x = MIN_DOT_SPACE
local dot_space_y = MIN_DOT_SPACE

local screen_width, screen_height, flags = love.window.getMode()

local function calc_dot_side(screen_width, screen_height)
    screen_width, screen_height, flags = love.window.getMode()

    dot_side = (screen_width - (DOTS_H - 1) * dot_space_x) / DOTS_H
    if (dot_side > MAX_DOT_SIDE) then
        dot_side = MAX_DOT_SIDE
    elseif (dot_side < MIN_DOT_SIDE) then
        dot_side = MIN_DOT_SIDE
    end

    while (true) do
        dot_space_x = (screen_width - DOTS_H * dot_side) / (DOTS_H - 1)
        dot_space_y = (screen_height - DOTS_V * dot_side) / (DOTS_V - 1)
        if ((dot_space_x <= MIN_DOT_SPACE or dot_space_y <= MIN_DOT_SPACE) and dot_side > MIN_DOT_SIDE) then
            dot_side = dot_side - 1
        else
            break
        end
    end
end

function love.resize(w, h)
    calc_dot_side()    
end

function love.load()
    calc_dot_side()
    server_thread = love.thread.newThread("server.lua")
    server_channel = love.thread.getChannel("server")
    server_thread:start(HOST, PORT)
end

local led_data

local function reverse(t)
    local n = #t
    local i = 2
    while i < n do
        t[i], t[n] = t[n], t[i]
        i = i + 1
        n = n - 1
    end
end

local function print_rgb_data(rgb_data)
    for i=1, #rgb_data do
        local rgb = rgb_data[i]
        print((i - 1) .. " - RGB: (".. rgb.r.. "," .. rgb.g .. "," .. rgb.b .. ")")
    end
end

function love.draw()
    local new_data = server_channel:pop()


    if new_data then
        if (DIRECTION == "anti-clockwise") then
            reverse(new_data)
        end

        led_data = new_data
    end

    if led_data then
        local led_idx = 0
        local x
        local y
        local dot

        if (ORIGIN == "top_right") then
            led_idx = led_idx + DOTS_V - 1 + (DOTS_H - 1) * 2
        elseif (ORIGIN == "bottom_right") then
            led_idx = led_idx + DOTS_V - 1 + DOTS_H - 1
        elseif (ORIGIN == "bottom_left") then
            led_idx = led_idx + DOTS_V - 1
        end

        led_idx = led_idx % #led_data

        if CORNERS then
            dot = led_data[led_idx + 1]
            x = 0
            y = 0
            love.graphics.setColor(dot.r / 255, dot.g / 255, dot.b / 255, 1)
            love.graphics.rectangle("fill", x, y, dot_side, dot_side)
            led_idx = (led_idx + 1) % #led_data
        end

        for i = 1, DOTS_H - 2 do
            dot = led_data[led_idx + 1]
            x = i * (dot_side + dot_space_x)
            y = 0
            love.graphics.setColor(dot.r / 255, dot.g / 255, dot.b / 255, 1)
            love.graphics.rectangle("fill", x, y, dot_side, dot_side)
            led_idx = (led_idx + 1) % #led_data
        end

        if CORNERS then
            dot = led_data[led_idx + 1]
            x = screen_width - dot_side
            y = 0
            love.graphics.setColor(dot.r / 255, dot.g / 255, dot.b / 255, 1)
            love.graphics.rectangle("fill", x, y, dot_side, dot_side)
            led_idx = (led_idx + 1) % #led_data
        end

        for i = 1, DOTS_V - 2 do
            dot = led_data[led_idx + 1]
            x = screen_width - dot_side
            y = i * (dot_side + dot_space_y)
            love.graphics.setColor(dot.r / 255, dot.g / 255, dot.b / 255, 1)
            love.graphics.rectangle("fill", x, y, dot_side, dot_side)
            led_idx = (led_idx + 1) % #led_data
        end

        if CORNERS then
            dot = led_data[led_idx + 1]
            x = screen_width - dot_side
            y = screen_height - dot_side
            love.graphics.setColor(dot.r / 255, dot.g / 255, dot.b / 255, 1)
            love.graphics.rectangle("fill", x, y, dot_side, dot_side)
            led_idx = (led_idx + 1) % #led_data
        end

        for i = 1, DOTS_H - 2 do
            dot = led_data[led_idx + 1]
            x = screen_width - dot_side - i * (dot_side + dot_space_x)
            y = screen_height - dot_side
            love.graphics.setColor(dot.r / 255, dot.g / 255, dot.b / 255, 1)
            love.graphics.rectangle("fill", x, y, dot_side, dot_side)
            led_idx = (led_idx + 1) % #led_data
        end

        if CORNERS then
            dot = led_data[led_idx + 1]
            x = 0
            y = screen_height - dot_side
            love.graphics.setColor(dot.r / 255, dot.g / 255, dot.b / 255, 1)
            love.graphics.rectangle("fill", x, y, dot_side, dot_side)
            led_idx = (led_idx + 1) % #led_data
        end

        for i = 1, DOTS_V - 2 do
            dot = led_data[led_idx + 1]
            x = 0
            y = screen_height - dot_side - i * (dot_side + dot_space_y)
            love.graphics.setColor(dot.r / 255, dot.g / 255, dot.b / 255, 1)
            love.graphics.rectangle("fill", x, y, dot_side, dot_side)
            led_idx = (led_idx + 1) % #led_data
        end
    end
end
