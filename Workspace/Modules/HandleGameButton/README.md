### GameController

The **GameController.lua** module serves as the main controller for the **Game** application.

The execution flow is organized as follows:

* **Loading.lua** is responsible for displaying the loading screen.
* **ChaptersSelection.lua** presents the chapter selection interface, allowing the player to browse and choose from the available chapters.
* **ChapterScreen.lua** displays the selected chapter's information, including its status and progression. It also handles the confirmation process and, once approved by the player, initiates the corresponding chapter.

All modules communicate with **Functions.lua**, which provides shared utility functions used across the application.
