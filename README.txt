This is a rough 'proof of concept Gaia site' that supports auto-formatting of all TextFields to a global F*CSS stylesheet. It also supports auto-injecting interactive/layout behaviours & properties onto any Flash DisplayObject that designers create. RobotLegs helps auto-wires any of these DisplayObject assets that appear on the stage together with a F*CSS stylesheet running under a Gaia Flash Framework site shell. 

Combinining with SG-Camo's behaviours, a swf package behaviour source is preloaded into Gaia to support a precompiled repository of reusable IBehaviour classes that can be remotely applied to any display object. With the F*CSS stylesheet being able to declare the stylings/behaviours/properties of every on-stage instance and textfield, this effectively prevents the need to write manual code to apply such properties or behaviours to these display objects.
 
As a result, no application-side code is being used to explicitly reference any item on the Flash stage, only F*CSS/RobotLegs' mediators are automatically created when such items appear, with any assosiated F*CSS sheet's selector  behaviours/property injected as required. 

For more information on RobotLegs, F*CSS, SG-Camo and Gaia Flash Framework, check the following homepages: 
http://www.robotlegs.org/ ,
http://fcss.flashartofwar.com/
http://github.com/Glidias/SG-Camo-Collections
http://www.gaiaflashframework.com/

/////////////////////////////////////
Note on project file requirements:
/////////////////////////////////////
FlashDevelop AS3 project files

SGCamoGaia_FCSS_RobotLegs_Gaia_Main.as3proj  	Can be used to compile Gaia's Main document class with Flex SDK. (main.fla/main.swf). However, main.fla can be compiled with Flash CS3 as well.

SGCamoGaia_FCSS_RobotLegs_CORE.as3proj  	Flex SDK must be available to compile the FCSS/SG-Camo/RobotLegs core. (maincore.fla/maincore.swf) to support the injection meta tags. By default, all RobotLegs/SwiftSuspenders SWCs are included as full libraries so it should work right off the bat.

//////////////////////////
Files to look into:
//////////////////////////
The entire src code package is really big and contains a lot of unused stuffs from many packages.  So, here are the file locations to pay attention to:

//////////////////
sg.gaialegs
//////////////////
Core site pages for Gaia and general stuff for current application.

Setting up the Robotlegs Framework with Gaia, key context only
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/tree/master/src/sg/gaialegs/framework/

The IndexPage to wire up dependencies remotely and initiate the key context
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/blob/master/src/sg/gaialegs/pages/IndexPage.as

///////////////////
sg.fcss
//////////////////
The main Sg-FCSS branch
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/tree/master/src/sg/fcss/

sg.fcss.robotlegs

The RobotLegs extension branch to support auto-wiring F*CSS properties and SG-Camo's behaviours to textfields/display-objects.
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/tree/master/src/sg/fcss/robotlegs/


////////////////
GAIA and other files:
///////////////////

Gaia's site xml
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/blob/master/bin/xml/site.xml

///////////////
And about stylesheets:
///////////////
The F*CSS stylesheet
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/blob/master/bin/css/props.css

A regular native Flash CSS stylesheet
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/blob/master/bin/css/stylesheet.css



