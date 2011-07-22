The Adventures of Pirate Pete
=============================

!["Screenshot"](http://eddmorgan.com/misc/pirate-pete-screenshot.png)

Not gonna lie, this is a pretty bad game. But it's built in Ruby, and it's much more fun to work on than to play.

It's a simple platformer, what with the jumping and the enemies and swinging on vines and stuff. Hit the **H** key in-game for controls.

Please, go ahead and fork this. It would be nice if you opened a pull request back here though, just for my own education.

Dependencies
------------

At time of writing, it only requires [`gosu`](http://www.libgosu.org):

	bundle install

To-do list
----------

1. Better optimisations (i.e. Only draw objects that are within camera range - this should already happen with terrain)
2. Handle the 'end game' better. At the moment it just quits.
3. Actually build some maps!

Credits
-------

* I did some of the art, but most of it was done by the awesome [Andy](http://twitter.com/twandy).
* Sound effects from the following freesound.org users: Vixuxx, Snoman, acclivity, willpio, HerbertBoland, simon.rue, theta4, bennychico11, Mirors, sandyrb, domrodrig, AGFX
* Various music tracks from the very talented [Kevin MacLeod](http://incompetech.com/).