### StartController

The **StartController.lua** module is the main controller for all interactions triggered by the **Start** button. It manages the navigation between the different customization menus and coordinates the communication between the available modules.

The customization system is divided into three dedicated modules:

* **Musics.lua** – Handles the selection and application of background music.
* **Wallpapers.lua** – Manages desktop wallpaper selection and updates.
* **UserIcons.lua** – Handles user icon selection and customization.

All three modules rely on **UIFunctions.lua**, which contains shared user interface utilities used throughout the customization system. By centralizing common UI behavior, the project avoids code duplication and keeps each customization module focused solely on its specific responsibility.

This modular structure makes the Start menu easy to maintain and allows new customization categories to be added with minimal changes to the existing architecture.
