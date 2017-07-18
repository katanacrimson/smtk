# SMTk - Starbound Mod Toolkit

SMTk is a collection of tools to assist with building mods quickly and effectively.  Included are several utilities:

* JSON validation (special for Starbound JSON files)
* JSON Patch builder
* PNG Asset compressor
* Starbound mod pak builder

SMTk is currently only available for Windows. A comparable script may be written for Linux at some point in the future (obviously not in batch).

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

Just set the STARBOUND_PATH environment variable to the *root directory of your Starbound installation* and you're good to go.

## What else can I do? (Advanced use)

### On-demand / On-build patch file generation

To build patch files for your mod automatically, all you'll need to do is unpack the Starbound Assets, take a copy of the files you need to patch, then place a copy in your modified/ directory (with the appropriate filepath to match the original file's location) and modify it accordingly.  The tool "sb-buildpatches" will run, compare the modified copy to the original (unpacked) copy, and generate the JSON patch file for you and place it in the src/ directory.

To leverage this functionality, you need to follow the steps outlined in the section "Installing the advanced SMTk tools *(optional)*" above, and then:

* Open a command prompt window as admin
* cd into the directory of your SMTk checkout (like `cd D:\code\starbound\smtk\` on my system)
* run the command `tool.unpackassets.bat` and wait for its completion (it should be unpacking the Starbound packed.pak file)

If you want your patch files rebuild every time you run make.bat, then you'll need to do the following:

* open the config.bat file for your Starbound mod in your preferred code editor
* change the line `set BUILD_USE_PATCHBUILDER=0` to `set BUILD_USE_PATCHBUILDER=1`

***Please note: an invalid JSON file in the modified/ directory will cause the patchbuilder to fail and block the build.***

If you don't want your patch files rebuilt every time you run make.bat, you can rebuild them on demand by running the "patchbuilder.bat" script in your mod's directory.

### On-demand / On-build check for invalid JSON files

![image](https://i.imgur.com/WvhZWip.png)

To help detect fatal mod errors *before* loading your mod up in Starbound, you can have SMTk check for syntax errors in JSON-like files during the build process.

To leverage this functionality, you need to follow the steps outlined in the section "Installing the advanced SMTk tools *(optional)*" above.

If you want JSON files checked every time you run make.bat, then you'll need to do the following:

* open the config.bat file for your Starbound mod in your preferred code editor
* change the line `set BUILD_USE_JSONVALIDATE=0` to `set BUILD_USE_JSONVALIDATE=1`

***Please note: an invalid JSON file in the src/ directory will cause the jsonvalidator to fail and block the build.***

If you don't want your JSON files checked every time you run make.bat, you can validate them on demand by running the "jsonvalidate.bat" script in your mod's directory.

### On-demand / On-build PNG asset compression

To help shrink mods down in size, you can have SMTk also crush PNG assets down in size using the wonderful [sharp](http://sharp.dimens.io/en/stable/) library.

To leverage this functionality, you need to follow the steps outlined in the section "Installing the advanced SMTk tools *(optional)*" above.

If you want PNG assets compressed every time you run make.bat, then you'll need to do the following:

* open the config.bat file for your Starbound mod in your preferred code editor
* change the line `set BUILD_USE_PNGSQUEEZE=0` to `set BUILD_USE_PNGSQUEEZE=1`

If you don't want your PNG assets compressed every time you run make.bat, you can compress them on demand by running the "pngsqueeze.bat" script in your mod's directory.

## License

MIT license; see ./LICENSE for fulltext.