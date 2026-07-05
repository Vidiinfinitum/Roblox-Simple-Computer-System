### GameController

The **GameController.lua** module serves as the main controller for the **Game** application, coordinating the flow between the different interfaces presented to the player.

The execution flow is organized as follows:

*Loading.lua** is responsible for displaying the loading screen.
*ChaptersSelection.lua** presents the chapter selection interface, allowing the player to browse and choose from the available chapters.
*ChapterScreen.lua** displays the selected chapter's information, including its status and progression. It also handles the confirmation process and, once approved by the player, initiates the corresponding chapter.

Throughout this workflow, all modules communicate with **Functions.lua**, which provides shared utility functions used across the application. Centralizing common functionality in a dedicated module helps reduce code duplication while improving maintainability and consistency.
