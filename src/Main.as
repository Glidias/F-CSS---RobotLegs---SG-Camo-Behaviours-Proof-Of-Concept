/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the GPL License:
* http://www.opensource.org/licenses/gpl-2.0.php 
*****************************************************************************************************/

package
{
	import com.gaiaframework.api.IAssetLoader;
	import com.gaiaframework.core.GaiaMain;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.events.Event;
	import sg.camogxmlgaia.inject.NodeClassSpawn;
	import sg.camogxmlgaia.api.*;
	import sg.camo.interfaces.*;
	
	import camo.core.events.*;
	
	import sg.gaialegs.framework.RobotlegsInterfaces;
	import sg.gaialegs.SGInterfaces;

	public class Main extends GaiaMain
	{		

		private var moduleLoader:Loader = new Loader();
		
		public function Main()
		{
			super();
			siteXML = "xml/site.xml";
			
			// Note, all static classes and interfaces must be pre-compiled into the main shell
			// to ensure cross-platform compatibility across different application domains under the parent domain.
			
			// to import all static classes/events
			//NodeClassSpawn;
			// to import all interfaces
			
			SGInterfaces;

			RobotlegsInterfaces
			
			IGXMLIndexTree;
			ITransitionModule;
			CamoChildEvent;
			CamoDisplayEvent;
			
			ISelectable;
			
		
			
		
		}
		/*
		override protected function init():void {
			moduleLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
			moduleLoader.load( new URLRequest("maincore.swf"), new LoaderContext(false, ApplicationDomain.currentDomain) );
		}
		
		private function onComplete(e:Event):void {
			super.init();
		}
		*/
	
		override protected function onAddedToStage(event:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			super.onAddedToStage(event);
		}
		
	}
}
