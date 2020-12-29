# TPM2 Ambilight Simulator

Cross-platform ambilight simulator written in Lua.
Acts as UDP Server and waits for incomming messages with RGB data in TPM2(.net) format.

I use it for testing the lightoros LED engine.

Configuration
-------------
The `config.lua` file defines the configuration of the ambilight installation to simulate.

`DOTS_H` defines the number of horizontal LEDs.

`DOTS_V` defines the number of vertical LEDs.

`CORNERS` defines if the installation has additional LEDs in the corners.

`HOST` defines the host name or IP address to bin the UDP server socket to.

`PORT` defines the port number of the UDP server

`ORIGIN` defines the origin of the first LED. Valid values are `top_left`, `top_right`, `bottom_right`, `bottom_left`.

`DIRECTION` defines the direction of the LEDs. Valid values are `clockwise`, `anti-clockwise`

Requirements
------------
[LÖVE](https://love2d.org/) framework/runtime is required to run the simulator.
Check the project documentation for installation instructions. 

Execute `love .` from the root folder to run.

License
-------
MIT license, see [LICENSE](./LICENSE)
