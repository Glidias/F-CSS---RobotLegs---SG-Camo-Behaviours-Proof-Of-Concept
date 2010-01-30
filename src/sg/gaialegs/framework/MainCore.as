package sg.gaialegs.framework 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import org.robotlegs.core.IContext;
	import org.robotlegs.core.IContextProvider;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.mvcs.Context;
	
	/**
	 * Main compilable .swf containing RobotLegs retrieval injector/reflector and manual startup.
	 * @author Glenn Ko
	 */
	public class MainCore extends Sprite implements IMainContextProvider
	{
		private var _myContext:MainContext;
		
		public function MainCore() 
		{
			
		}
		
		// -- IMainContextProvider
		
		/**
		 * Instantiates context in a particular contextView to gain access to injector/reflector
		 * @param	contextView		
		 * @return
		 */ 
		public function startup(contextView:DisplayObjectContainer):IContext {
			_myContext = new MainContext(contextView);
			return _myContext;
		}
		
		/**
		 * Initializes mapping on this end
		 */
		public function init():void {
			_myContext.init();
		}
		
		
		public function getInjector():IInjector {
			return _myContext.__injector;
		}
		
		public function getReflector():IReflector {
			return _myContext.__reflector;
		}
		
	}

}