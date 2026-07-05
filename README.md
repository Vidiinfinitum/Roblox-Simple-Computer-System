# Roblox Computer System

A modular Windows XP-inspired computer system developed in LuaU for Roblox. The project focuses on code organization, scalability, and maintainability through a modular client-server architecture.

# System Architecture

This computer system is divided into three main components, each with a specific responsibility:

## InitShutdown

The **InitShutdown** module is responsible for the computer's startup and shutdown process. It contains the corresponding **LocalScript** and **ServerScript**, handling the boot sequence, shutdown animation, and related events. Due to its simplicity, this component does not require the use of **ModuleScripts**.

## Login

The **Login** module manages the computer's authentication screen. It includes its own **LocalScript** and **ServerScript**, responsible for the login interface. Like the previous component, it does not make use of **ModuleScripts**, as its functionality is relatively self-contained.

## Workspace

The **Workspace** module represents the computer itself and contains the majority of the project's functionality.

It is responsible for features such as:

* Wallpaper customization
* User icon customization
* Background music selection
* The game's main executable interface

Because of its larger scope and complexity, this component uses a modular architecture based on **ModuleScripts**. This approach improves code organization, maintainability, and scalability.

The system was designed to be easily expandable. New features can be added with minimal changes, including:

* New desktop applications
* Additional wallpapers
* New user icons
* Additional background music
* New game chapters

Most of these additions only require registering the new content in the corresponding **Data Module**, without modifying the core system logic.
