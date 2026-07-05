 ## Server Scripts

This folder contains the server-side scripts responsible for managing data and gameplay logic.

### Customization

The **Customization** script is responsible for retrieving the player's customization data and sending it to the corresponding client-side scripts. This includes information such as wallpapers, user icons, and background music, allowing the client to properly initialize the computer's appearance.

### Game

The **Game** script handles the server-side logic related to the computer's game functionality. Its responsibilities include:

* Sending chapter and progression data to the client.
* Validating chapter access based on the player's saved data.
* Managing the teleportation system between places.
* Handling server-side validation to ensure secure communication between the client and the game.
