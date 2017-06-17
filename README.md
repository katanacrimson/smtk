# SMTk - Starbound Mod Toolkit

SMTk is a collection of tools to assist with building mods quickly and effectively.  Included are several utilities:

* JSON validation (special for Starbound JSON files)
* JSON Patch builder
* PNG Asset compressor
* Starbound mod pak builder

SMTk is currently only available for Windows. A comparable script may be written for Linux at some point in the future (obviously not in batch).

SMTk is licensed under the MIT license.  A copy of the license is also embedded into the buildpak.bat file header comments.

## Installation

*Please note that the following directions are Windows-specific and may need to be adapted to suit your environment.*

* Clone the repository to a directory of your choosing via git.  I chose to clone it to the directory `D:\code\starbound\smtk\`.

### Installing the advanced SMTk tools *(optional)*

* Install the latest release of node.js
* Open a command prompt window as admin
* cd into the directory of your SMTk checkout (like `cd D:\code\starbound\smtk\` on my system)
* Run the command `npm install --global --production windows-build-tools`
* Wait.
* Once the above is completed, run the command `npm install`

With this, SMTk is installed on your system and can be used to help build and develop your mods.  We'll need to set it up for each mod first though, but that's easy with the following...

### Setting SMTk up for a mod

First things first - your mod folder has to have a specific structure.

Create a new folder for your mod - name does not matter.  Inside this folder should be a "modified" folder, a "src" folder, and a "build" folder.  You should end up with something like this: ![image](https://i.imgur.com/ywc0RuX.png)

* The src/ folder is where you'll put all your mod files, such as PNGs, config files, your _metadata file, everything.
* The modified/ folder should contain the copies of Starbound asset files that you modify to create JSON patches via the Patch builder feature.
* The build/ folder is where you will find the pak files built from your mod's files.  These can be distributed to users easily and are the best way to distribute your mod.

Now, we need to open a command prompt window (don't worry, we don't need admin for this) and cd into the mod's folder, like this: ![image](https://i.imgur.com/DeDaa7s.png)

From here, we need to do something very specific - enter the path to your SMTk installation - then add a backslash, the filename "smtk.bat", a space, and "%cd%".  You should end up with something like `D:\code\starbound\smtk\smtk.bat %cd%`.

You should see something like the following: ![image](https://i.imgur.com/YC8qZt1.png)

From here, you should be able to edit the config.bat file using a text editor (I recommend [Notepad++](https://notepad-plus-plus.org/)).
Be sure to set the variable "pakname", since this controls the name of your mod's .pak file.

You should see something like this: ![image](https://i.imgur.com/d5VP840.png)

Be sure to change the values of "BUILD_USE_PATCHBUILDER", "BUILD_USE_PNGSQUEEZE", and "BUILD_USE_JSONVALIDATE" if you want to use those features.
Just remember that they require that you follow the section "Install the advanced SMTk tools" above.

From here, put some mod files in the src/ folder to match how you'd normally do your Starbound mod, then go back up to your mod directory and double click the make.bat file.
With that, you should have a pak file created in the build/ directory!

![image](https://i.imgur.com/x8fFip7.png)

### Humble Store users

Those who have Starbound installed via the Humble Store copy will have to set the STARBOUND_PATH env variable or add their Starbound copy's installation location to the system PATH, as there is no viable way to automatically locate Starbound for Humble Store installations - it just can't be done.

Just set the STARBOUND_PATH environment variable to the root directory of your Starbound installation and you're good to go.

## What else can I do? (Advanced use)

todo

## License

Copyright 2017 Damian Bushong <katana@odios.us>

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the 
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included 
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL 
THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR 
OTHER DEALINGS IN THE SOFTWARE.