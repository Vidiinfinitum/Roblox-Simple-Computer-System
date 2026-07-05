## Modules

The **Modules** directory contains the core logic of the computer system. By adopting a modular architecture, each component is responsible for a single feature, resulting in cleaner, more maintainable, and highly scalable code.

### Clock.lua

Responsible for managing the desktop clock, including updating and displaying the current time.

### ConnectionsFunctions.lua

Provides utility functions for connect and disconnect event connections

### HandleStartButton

Responsible for all functionality related to the **Start** button.

This module is organized using a parent-child architecture:

* **StartController.lua** acts as the main controller, coordinating the system.
* Additional child modules handle the individual features associated with the Start menu.

### HandleGameButton

Responsible for the **Game** application.

Like the Start button, this feature follows a modular parent-child architecture:

* **GameController.lua** acts as the central controller.
* Child modules implement the different screens and interactions of the game application.
