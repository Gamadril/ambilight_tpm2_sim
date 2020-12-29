-- require("lldebugger").start()

local HOST, PORT = ...
local socket = require("socket")
local udp = socket.udp()

udp:settimeout()
udp:setsockname(HOST, PORT)

local channel = love.thread.getChannel("server")

while true do
	data, msg = udp:receive()
	if data then
		h1, h2 = string.byte(data, 1, 2)
		if (h1 == 0xC9 and h2 == 0xDA) then
			frame_size = string.byte(data, 3) * 0x10
			frame_size = frame_size + string.byte(data, 4)
			led_count = frame_size / 3
			buffer = {}
			index = 5
			for i = 1, led_count do
				buffer[i] = {
					r = string.byte(data, index + 1),
					g = string.byte(data, index),
					b = string.byte(data, index + 2),
				}
				index = index + 3
			end
			channel:push(buffer)
		elseif (h1 == 0x9C and h2 == 0xDA) then
		end
	else
		error("Unknown network error: " .. tostring(msg))
	end

	socket.sleep(0.01)
end
