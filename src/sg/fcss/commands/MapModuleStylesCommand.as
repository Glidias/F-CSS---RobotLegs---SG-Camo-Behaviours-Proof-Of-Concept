package sg.fcss.commands 
{
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	import flash.utils.Dictionary;
	import org.robotlegs.mvcs.Command;
	import sg.fcss.interfaces.IStyleRequester;

	/**
	 * Reads off a stylesheet's class selectors to automatically register classes 
	 * to a default  behavioural base mediator class if no modules are registered yet
	 * for that class.
	 * <code>
	 * .ModuleClassName {
	 *    package:com.company.ui;
	 *    ... your other properties go here for the class
	 * }
	 * </code>
	 * <br/><br/>
	 * Within that selector, a package path can be provided by providing a "package" property
	 * with a string prefix like in above. (eg. <code>com.company.ui</code> ). The resultant registered
	 * class name would be:  com.company.ui::ClassName. 
	 * <br/><br/>
	 * If no package path is provided, just the class name is used in the selector, which is normally
	 * for a simple stand-alone linkage name in the Flash library.
	 * 
	 * @author Glenn Ko
	 */
	
	public class MapModuleStylesCommand extends Command
	{
		
	
		[Inject]
		public var stylesheet:IStyleRequester;
		
		[Inject(name = "mapModulesTo")]
		public var mediatorClass:Class;
		
		[Inject(name = "registeredModules")]
		public var registeredModules:Dictionary;
		
		public function MapModuleStylesCommand() 
		{
			
		}
		
		override public function execute():void {
			
			var styleNames:Array = stylesheet.styleNames;
			for ( var i:String in styleNames) {
				var checkClassStr:String = styleNames[i];
				var packagePrefix:String;
				
				if (checkClassStr.charAt(0) != ".") continue;
				var props:Object = stylesheet.getStyle(checkClassStr);
				
				packagePrefix = props["package"] ? props["package"] + "::" : "";
				var className:String = packagePrefix + checkClassStr.slice(1);
				if (!registeredModules[className]) mediatorMap.mapView(className , mediatorClass );
			}
			
			
		}
		
	}

}