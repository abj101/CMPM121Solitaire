# CMPM121Solitaire by Ayush Bandopadhyay
 
#Patterns

Game Loop: Use the engine’s update() and draw() callbacks as the central loop to process input, update state, and render each frame. IN main.lua

Module Pattern: Organize related functions and constructors into separate Lua files and require them to encapsulate functionality and avoid globals. IN main.lua load function

Prototype-Based Classes: Implement lightweight "classes" with tables, metatables, and a new constructor for per-instance state and shared methods. USED BY stack.lua and card.lua

Composite Pattern: Treat piles (tableau, foundations, waste) as containers of card objects that share uniform update, draw, and move behaviors. IN stack.lua

Command/Input Handler: Isolate raw mouse/keyboard detection in a single module that translates user actions into high-level game commands. IN grabber.lua

State Machine: Manage overall game phases (dealing, playing, won, lost) with state objects that implement enter(), update(), and exit() methods. IN card.lua

Observer/Event System: Emit and subscribe to events  to decouple game logic from UI, audio IN reset.lua, deck.lua, and main.lua

#Postmortem

I’ve organized the game into a clear, modular architecture where each major element—cards, stacks, and deck—is encapsulated in its own class. The Stack class powers all stack-like structures (tableaus, foundations, draw pile) by accepting configuration parameters that tailor its behavior. Game rules (e.g. dealing three cards, enforcing ace‑first foundations, legal moves) live in dedicated helper functions to keep rule logic separate from data structures. In **main.lua**, I instantiate and position every object, wire up input handlers and update loops, and orchestrate the render cycle. Future “Project 2” modules will plug into this scaffold to add polish—animations, sound, UI overlays—without touching core mechanics. Over time I’ll streamline some data structures and perhaps split a few classes further, but this layered, single‑responsibility design ensures each moving part stays isolated, testable, and easy to refactor.

In the latest iteration I tackled several bugs and added new features: I fixed the draw‑pile flickering so the cards now redraw smoothly, and resolved the card‑stacking glitch so stacks behave correctly when you move cards. Another longstanding bug was also flickering that occured between layered cards, I solved that as well using a new looping method. I also introduced a reset function for quick restarts, and built a win screen with a flexible victory condition that recognizes a win even if not all cards end up in the tableaus.

#Assets
 Assets were pulled directly from Balatro.exe game files, for private use only on this project. I looked online and many sources have them as well. I decided to cut the sprites myself as well.
 
 Sprites 
 |-> Cards( From Balatro)
 |-> Backs( From Balatro)
 |-> Emppty cards of varying opacity( From Balatro)
 
 Font is unused, it is from google fonts.
 
