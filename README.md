BlobFamily
==========

A family of physically-based blobs. Soft body simulation using a Verlet-based mass-spring system, modeling point mass as particles with semi-rigid constraints, and rendered using metaballs.

Instruction
-----------

Basic
- 'up/down/left/right': move blob, doing so will disable blob ai
- 'mouse': drag blob around, right-click on the screen and the blob will move towards it
- 'q': enable blob ai (the blob will lazily roll around)
- 'space': reset

Debug
- 'd': display debug info
- 'f': toggle fps info
- 'g': toggle gravity
- 'l': lock particle in place
- 'm': toggle rendering mode (metaballs or mass-spring)
- 'a': decrease metaball size
- 's': increase metaball size
- 'z': decrease metaball render threshold
- 'x': increase metaball render threshold

Create blob
- '1': create a small simple blob
- '2': create a big simple blob
- '3': create a small braced blob
- '4': create a big braced blob
- '5': create a small complex blob
- '6': create a big complex blob
- '7': create a BIG simple blob, disables metaballs to improve performance
- '8': create a BIG braced blob, disables metaballs to improve performance
- '9': create a BIG skinned blob, disables metaballs to improve performance
- '0': create a BIG complex blob, disables metaballs to improve performance
