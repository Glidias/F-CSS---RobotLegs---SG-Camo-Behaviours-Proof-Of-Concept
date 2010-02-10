This is a rough 'proof of concept Gaia site' that supports auto-formatting of all TextFields to a global F*CSS stylesheet. It also supports auto-injecting interactive/layout behaviours & properties onto any Flash DisplayObject that designers create. RobotLegs helps auto-wires any of these DisplayObject assets that appear on the stage together with a F*CSS stylesheet running under a Gaia Flash Framework site shell. 



Combining with SG-Camo's behaviours, a swf package behaviour source is preloaded into Gaia to support a precompiled repository of reusable IBehaviour classes that can be remotely applied to any display object.

The F*CSS stylesheet works together with RobotLegs to provide the ability to declare the stylings/behaviours/properties of every on-stage instance through the clever use of class selector declarations which does the auto-mapping on the RobotLeg's end, effectively preventing the need to write manual code to apply varied properties or behaviours to these display objects. 
As a result, no application-side code is being used to explicitly reference any item on the Flash stage, only F*CSS/RobotLegs'/SG-Camo's behaviour style mediators are automatically created when such items appear as declared in the F*CSS stylesheet.



For more information on RobotLegs, F*CSS, SG-Camo and Gaia, check out the following homepages:

http://www.robotlegs.org/ 

http://fcss.flashartofwar.com/

http://github.com/Glidias/SG-Camo-Collections
http://www.gaiaflashframework.com


Here's the links to the important parts of the site's src code:

The main site framework location with Gaia and RobotLegs combined.
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/tree/master/src/sg/gaialegs/

The SG-F*CSS package 
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/tree/master/src/sg/fcss/

How SG-F*CSS works together with RobotLegs to perform auto-wiring magic
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/tree/master/src/sg/fcss/robotlegs

The F*CSS stylesheet that I use to apply my behaviours and properties over any given object that appears on the stage
http://github.com/Glidias/F-CSS---RobotLegs---SG-Camo-Behaviours-Proof-Of-Concept/blob/master/bin/css/props.css


Individual pages under Gaia are usually compiled with Flash IDE.

However, the main Gaia site shell can be compiled through main.fla by the Flash IDE or by the Flex SDK through:
SGCamoGaia_FCSS_RobotLegs_Gaia_Main.as3proj . No RobotLegs dependencies are included except for basic interface signatures which are already saved out externally.

RobotLegs-specific code must compiled through Flex SDK through:
SGCamo_FCSS_RobotLegs_CORE.as3proj
Since, the SwiftSuspenders/RobotLegs SWC libraries are already included in and compiles fully with project, the [Inject] meta-tags being used should be automatically detected and working.

