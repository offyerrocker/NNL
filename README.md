# NNL
[Networked Player Lasers Mod for PAYDAY 2]

Most of this mod is fairly self explanatory, but in-depth explanations can be found in this readme. However, this mod is so new, even the readme is in beta, so bear with me.

New Networked Lasers, by popular consensus also known as "NNL," "New Networked Lasers," "Networked Player Lasers Mod," and "Would You Stop Asking Me What To Name Your Stupid Mod, Get Out Of My Face Already, Weirdo," is a BLT (Lua) mod for the video game PAYDAY 2, also known as "ACCESS VIOLATION SIMULATOR."


This mod is designed to let you change the color of your weapon laser attachments from the normal green. 
Unlike other mods on the market, it also lets you sync this color with any other clients who have this mod.
Also unlike other mods on the market, the mod lets you create your own flashing color patterns (referred to henceforth as "gradients") as one would with a fancy RGB keyboard/mouse.

The in-game mod options will control most of your settings, and are largely self-explanatory, but if you're reading this they're obviously not self-explanatory enough.
OH, LET'S BREAK IT DOWN!


[Master Enable Gradients:] (Checkbox)

This option is a master control that enables gradients for the entire mod. Disabling this will stop any gradiented lasers from being rendered, and instead will only use solid single colors, regardless of other "Enable [x] Gradient Lasers" checkboxes.


[Enable My Gradient Lasers:] (Checkbox)

This option enables gradients for your weapons. Disabling this will only prevent your weapons from using gradient lasers, and will instead only use solid single colors. As long as you have Master Enable Gradients enabled, other entities' laser colors will not be affected by this option.


[Enable Team Gradient Lasers:] (Checkbox)

This option enables gradients for your heister teammates' weapons. Disabling this will only prevent their weapons from using gradient lasers, and will instead only use solid single colors. As long as you have Master Enable Gradients enabled, other, non-teammate entities' laser colors, including but not limited to your own and snipers' lasers, will not be affected by this option.


[Enable Sniper Gradient Lasers:] (Checkbox)

You should know the drill by now.
Snipers are the enemies with sniper rifles and lasers like yours, and they're kind of jerks. ZEAL snipers from the Crime Spree game mode do not have lasers.


[Enable World Gradient Lasers:] (Checkbox)

Seriously. It's pretty obvious. 
World Lasers are lasers emitted from non-weapons, mostly vault lasers, such as the ones in the heists GO Bank, The Diamond, Murky Station, Big Bank, and Golden Grin Casino.


[Enable Turret Gradient Lasers:] (Checkbox)

I'm not sure what else to say.
Here, "Turrets" refers to the [enemy SWAT Van Turrets only,] *not* to either the Sentry Gun, nor the Suppressed Sentry Gun Deployables.
I avoided changing turret lasers because the "Sentry Gun Contours" mod already changes these, and also because I'm lazy.


[Laser Color Sliders:]

The basics:

This mod, as well as the base game, uses RGB/a values to determine the color of your laser.
RGB/a stands for Red, Green, Blue, alpha. Red, Green and Blue are the base colors of light; assembling them in different amounts can give you any color visible to the human eye. Alpha is the opacity of your laser/color- the higher, the more easily visible. Alpha is independent of RGB.
Make a color at http://colorpicker.com or just wing it and learn as you go.


**ADVANCED SETTINGS:**

Laser Color Gradients: ADVANCED OR INTREPID USERS ONLY!
Laser Color Gradients, or laser color patterns, are a feature new and exclusive (so far) to this mod. Using them, you can make your lasers shift through the colors of your choosing, at intervals of your choosing, as you would with any moderately fancy customizable LED RGB keyboard or mouse. 

Currently, I'm unable to find a good way to add gradients to the in-game menu. Since there's no defined limit to how many colors you can choose to use, except practical memory limits, I only have an idea about how to make a static menu reflect a variable amount of menu options. Don't worry, though, I expect I'll make a menu option for that later on.

[NNL's gradient system]
NNL uses a system known as "color locations," involving two different kinds of data: Colors and locations. (The name makes it easy to remember.) If you've made a gradient in CSS, or if you've made a custom gradient setting in photomanipulation/drawing software like Adobe Photoshop, or if you've customized an LED gaming keyboard or mouse with flashy lights, you may have used this system before.

[Here's the rundown on the color location system:]
Colors are colors. That's also easy to remember. 
Locations are the "markers" (tag markers, not art markers) representing the time where the color with the corresponding list number (or "key," if you know Lua) will be displayed, in the format of a percentage value.

For example, take the following NNL-formatted gradient, written as a table data structure in Lua:

	Lasers.my_gradient = Lasers.my_gradient or {
		colors = {
			[1] = Color(1,0,0.1):with_alpha(0.5),
			[2] = Color(1,1,0.1):with_alpha(0.7),
			[3] = Color(0.1,0.1,1):with_alpha(0.3)
		},
		locations = {
			[1] = 0,
			[2] = 33,
			[3] = 66
		}
		
	}

If you don't know Lua, don't worry.
The first color will start out as

	[1] = Color(1,0,0):with_alpha(0.07)
  
which is pure red. It starts at 0 seconds, because its corresponding "locations" value,

	[1] = 0

is zero seconds. The next value in "locations" is

	[2] = 33

so the gradient will shift color slowly over the next 33 seconds to the next color

	[2] = Color(0,1,0):with_alpha(0.07)

which is green, until after exactly 33 seconds, whereupon it will be pure green, and begin to switch to the last color.

You can *technically* have as many locations as you want, but I'd recommend using 10 at most. They also don't have to be at even intervals- locations only need to follow these requirements:
* Locations must be above 0 (zero). 
* Locations must be below 100 (one hundred).
* Locations must be larger than previous location before them.
* Locations must be numbers. 

Anything else will throw an error, or if you're lucky, be caught by my failsafe and only display a boring green laser.

[Colors must follow these requirements:]
Formatting for colors must be one of the following two methods:

* Color(REDVALUE,GREENVALUE,BLUEVALUE):with_alpha(ALPHA)
where REDVALUE, GREENVALUE, BLUEVALUE and ALPHA are number values from 0 to 1; or else the Color can be formatted as a hex code, as such:

* Color("xxxxxx"):with_alpha(ALPHA)
where xxxxxx is a hexadecimal code (base16 number system) with characters 0-f. The quotation marks are mandatory. (Yes, it's a string.)

------

**IMPORTANT!**
Your own gradient setting is stored in nnl:37 (at the moment.) You must change the values in this one if it's the gradient you want your laser to display to yourself and others!

**More advanced settings:**
*These settings can be found in nnl.lua. You can change them by manually setting their values to "true" or "false."* 
*Disturb and edit these settings at your own risk!*

Lasers.debugLogsEnabled: Enables writing of debug logs to your Lua log files, located in your mods/logs/ folder. If you don't have a logs folder, and you want PAYDAY 2 BLT to start writing logs, create a folder called "logs" in your mods folder. *Note that these are completely separate and different from PAYDAY 2's crashlogs.* False by default.

Lasers.default_laser_speed: the default laser speed multiplier to display laser gradients at. This does not affect performance any more than the mod usually would. Higher values will make a laser flash through its preset faster. Default value of 20.

Lasers.lowquality_gradients: Enables/disables low quality gradients, for those who don't have high-performing PCs. Setting it to true makes the mod display colors at their normal specified intervals, but without slowly shifting colors, instead switching colors instantly from color to color. False by default. 

Lasers.update_interval: Changes how frequently laser gradients update, again for those who don't have high performing PCs. Every number of frames equal to this setting, the mod will update your laser gradient. Higher values will give better performance but worse quality, up to a certain point. Setting this to 0 or 1 will make laser gradients update at maximum quality, every frame if possible.
Default value of 2.

Lasers.my_gradient: The table containing your gradient data. Change it! Make it something cool-looking and unique! But do it right. Consult the above documentation if you want to be sure.

More coming soon.


[That's all for now. Ask me if you have questions!]

Contact me:

GitHub: offyerrocker

Reddit: /u/offyerrocker

Steam: /id/offyerrocker

MySpace: I don't have myspace but if I did you can bet your badonkadonks it'd be "offyerrocker"