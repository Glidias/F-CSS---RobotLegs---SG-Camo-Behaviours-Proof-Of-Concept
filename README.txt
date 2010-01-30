This is a rough 'proof of concept Gaia site' that supports auto-formatting of all TextFields to a global F*CSS stylesheet. It also supports auto-injecting interactive/layout behaviours & properties onto any Flash DisplayObject that designers create. RobotLegs helps auto-wires any of these DisplayObject assets that appear on the stage together with a F*CSS stylesheet running under a Gaia Flash Framework site shell. 

Combinining with SG-Camo's behaviours, a swf package behaviour source is preloaded into Gaia to support a precompiled repository of reusable IBehaviour classes that can be remotely applied to any display object. With the F*CSS stylesheet being able to declare the stylings/behaviours/properties of every on-stage instance and textfield, this effectively prevents the need to write manual code to apply text properties or behaviours to these display objects. 
As a result, no application-side code is being used to explicitly reference any item on the Flash stage, only F*CSS/RobotLegs' mediators are automatically created when such items appear, with any assosiated F*CSS sheet's selector  behaviours/property injected as required. 

For more information on RobotLegs, F*CSS and SG-Camo, check the following homepages: 
http://www.robotlegs.org/ ,
http://fcss.flashartofwar.com/
http://github.com/Glidias/SG-Camo-Collections