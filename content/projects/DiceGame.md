## DiceGame

I began this project at the start of COVID lockdown.  The goal was to make a networked clone of the dice game Qwixx
to play with family and friends.  To make it usable for everyone, I had to make the application cross-platform (Linux, Windows,
and Mac).  Because of this, I made the following choices:

- Use `conan` for package management
- Use `CMake` as the build system
- Use `SFML` for the graphics, networking, sound, input, etc.

This was my first experience using `CMake` and `conan` and needless to say I ran into some challenges, but I did learn
a lot.  While it took a while to get `CMake` and `conan` set up nicely, once it was configured it was awesome
to be able to clone the repo on a new machine and build the executable in only a few commands.

Prior to this, I had never done any network programming, so I also learned a lot about basic networking concepts like
sockets and sending packets.  This is a turned based game, so it made sense to use TCP over UDP, which meant I did not have
to handle the issue of packet loss.  I researched a bit on multiplayer network architecture's and settled on
a client-server architecture.  Again, the game is turn-based, it made sense to have a central server verify player moves
and then propagate the move to all players.

Overall, the project was a pretty good success.  There were plenty of nights where we played the game while on a Zoom call
which was a great way to connect during lockdown.
