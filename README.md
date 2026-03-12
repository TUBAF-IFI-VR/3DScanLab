# Immersive XR laboratory for 3D scans
This Godot project represents a template for the visualization and inspection of 3D scanned specimens. It was originally developed for paleontology education. One of the main features is an automatic import function based on a collection of 3D models described via a JSON file. Metadata can be added there for additional educational purposes. Scene files, collision bodies and a dynamic scrollable menu are generated automatically. You can spawn 3D models on demand during runtime and interact with them. A workstation will display the specimen in its actual size and metadata on a holographic panel.

The project is intended for use with VR headsets and supports AR via passthorugh. It includes the Godot XR tools for interactivity. No additional addons are required.

Currently the project is being developed with Godot vesion 4.4.1.

## How to use
**Important:** The binary assets are partially stored using Git LFS (Large File Storage). Make sure you have Git LFS installed, otherwise not all assets will be pulled from the repository.

Clone the repository and adjust the main scene to your requirements. A collection of 3D scanned fossils is provided for an example use case. The project has been tested on Pico 4E and Pico 4 Ultra headsets. If you are using SteamVR and your headset is already set up, you can just hit the play button. To deploy to standalone headsets (Meta, Pico, HTC Focus), you will have to follow these steps:

1. Prepare your computer for Android deployment: [Deploying to Android](https://docs.godotengine.org/en/stable/tutorials/xr/deploying_to_android.html). Android Studio is not required. A commandline setup works as well.
2. Add the Android build template to the project via the Godot menu.
3. Create a primary export profile and check the OpenXR loader for your specific device (e.g. Khronos loader for Pico and HTC).
4. Build an APK or run your application directly via USB cable using the Remote Debug button.

## How to adjust
The asset directory contains the JSON file describing the current collection of 3D models. You can insert new models to the JSON array and add the 3D models to the project folder. To trigger the automatic scene generation for your collection of 3D models, open the tools/importer.tscn scene in the Godot editor. Updating the library file in the importer's root node properties will also trigger the import script.

## Asset License
All third party assets are licensed as CC0. Check the [asset-sources.md](asset-sources.md) file for weblinks to the original sources.
