# CMPM121Solitaire by Ayush Bandopadhyay
 
#Patterns

Game Loop: Use the engine’s update() and draw() callbacks as the central loop to process input, update state, and render each frame.

Module Pattern: Organize related functions and constructors into separate Lua files and require them to encapsulate functionality and avoid globals.

Prototype-Based Classes: Implement lightweight "classes" with tables, metatables, and a new constructor for per-instance state and shared methods.

Factory Method: Centralize the creation and initialization of decks, stacks, and cards in dedicated constructor functions.

Composite Pattern: Treat piles (tableau, foundations, waste) as containers of card objects that share uniform update, draw, and move behaviors.

Command/Input Handler: Isolate raw mouse/keyboard detection in a single module that translates user actions into high-level game commands.

State Machine: Manage overall game phases (dealing, playing, won, lost) with state objects that implement enter(), update(), and exit() methods.

Observer/Event System: Emit and subscribe to events (e.g., cardMoved, scoreChanged) to decouple game logic from UI, audio, or undo handling.

#Postmortem

Overall this project uses a lot of building on top of previous structures in a layer like system that is partitioned to handle different moving parts. My cards, stacks to hold cards, and deck are all seperate "classes". I use the stack class to make tableaus, the foundation, and the draw pile as well, passing in certain variables to change behavior as needed. I also have specific functions for ensuring everything behaves like Solitaire, ensuring cards go where they are supposed to, and other aspects are kept in order like drawing three cards at a time, putting Aces first in the foundation, etc. The main.lua file ties together all these classes to setup the board, create all the objects, update them as needed to detect mouse input or move objects, and to draw them as well. There are some other files which are going to be used later in Project 2 which will give the game more polish. I definitely could clean up some of the data structures and the way I refer to some things by simplifying and consolidating certain things. I also may need to partition some modules even further and reorganize where certain functions are.

#Assets
 Assets were pulled directly from Balatro.exe game files, for private use only on this project. I looked online and many sources have them as well. I decided to cut the sprites myself as well.
 
 Sprites 
 |-> Cards( From Balatro)
 |-> Backs( From Balatro)
 |-> Emppty cards of varying opacity( From Balatro)
 
 Font is unused, it is from google fonts.
 
