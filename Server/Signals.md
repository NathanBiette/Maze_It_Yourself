List of messages sent

*Server -> Player*

**error**
Has a 'msg' associated with it

* *game_started*: sent when a player tries to join a game that has already started
* *clients_overflow*: sent when a player tries to join a channel too full
* *hero*: sent when a hero player tries to join a lobby with a hero in it
* *architect*: sent when an architect player tries to join a lobby with an architect in it
* *full*: sent when a player tries to join a lobby with a hero and an architect in it
* *disconnection*: sent to a player during a game when the other one has been disconnected
* *reconnection*: sent to both players of a game when they both rejoined

**channel**
Has a 'channel' associated with it

* Sent when a player has changed channel to update it client side

**start**

* Sent to the players when the game is starting

**end**

* Sent to the players when the game has ended

**soon**

* Sent to the players when the game is starting in 10 seconds

**ack**

* Sent to a new connection to acknowledge it


*Player -> Server*

**connection**
Has an 'id' associated with it

* Sent to give the player id to the server

**reconnection**

* Sent after reconnecting

**join**
Has a 'channel' and a 'role' associated with it

* Sent to try to join a lobby as a certain role

**leave**

* Sent to leave a lobby

**update**
Has an 'info' associated with it

* Sent to multicast the information about the player to the architect

**room**

* Sent to multicast the room information to the hero

**channel**
Has a 'channel' associated with it

* Sent to change channel

**global**

* Sent to join the global channel

**multicast**

* Sent to multicast the whole message to everyone in the channel

**broadcast**

* Sent to broadcast the whole message to everyone connected to the server
