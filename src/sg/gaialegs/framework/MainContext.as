package sg.gaialegs.framework 
{
	import com.flashartofwar.fcss.applicators.IApplicator;
	import com.flashartofwar.fcss.applicators.StyleApplicator;
	import com.flashartofwar.fcss.applicators.TextFieldApplicator;
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.Context;
	import sg.camo.greensock.GSGlobals;
	import sg.camo.interfaces.IPropertyMapCache;
	import sg.camo.interfaces.ITypeHelper;
	import sg.fcss.adaptors.PropertyMapCacheAdaptor;
	import sg.fcss.adaptors.TypeHelperUtilProxyFCSS;
	import sg.fcss.events.StyleBubble;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.utils.*;
	import sg.fcss.robotlegs.*;
	
	
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class MainContext extends Context
	{

		private var _inited:Boolean = false;
		private var _mappedModules:Dictionary = new Dictionary();
		
		public function MainContext(contextView:DisplayObjectContainer, autoStartup:Boolean = true) 
		{
			super(contextView, autoStartup);  
		}
		
		/**
		 * Manually called from Gaia's IndexPage through IMainContextProvider under MainCore.
		 * @see MainCore
		 */
		public function init():void {
			if (_inited) return;
			
			_inited = true;
			
			//  Note: 
			// You can factor these out to a seperate bootstrap Command class from
			// which different settings can be injected in. This configuration is merely convention.
			
		
			injector.mapSingletonOf(IPropertyMapCache, PropertyMapCacheAdaptor);
			injector.mapSingletonOf(ITypeHelper, TypeHelperUtilProxyFCSS);
			//GSGlobals 
			injector.instantiate(GSGlobals); // (required if using Greensock tweening and behaviours under sg.camo.greensock)
			
			// Core FCSS
			injector.mapSingletonOf(IApplicator, StyleApplicator );
			injector.mapSingletonOf(IApplicator, TextFieldApplicator, "textStyle");
			
			
			// All auto-mapped modules to BehaviourStyleMediator
			injector.mapValue(Class, BehaviourStyleMediator, "mapModulesTo");
			injector.mapValue(Dictionary, _mappedModules, "registeredModules");
			(injector.instantiate(MapModuleStylesCommand) as Command).execute();
			
			// All textfields
			mediatorMap.mapView("flash.text::TextField", TextStyleMediator );
			
			// Root level listening for textfields and other dispatched style bubbles
			injector.mapValue(IEventDispatcher, _contextView, "contextStyle");	
			mediatorMap.registerMediator( _contextView, injector.instantiate(ContextStyleApplierMediator) );

		}
		
		/**
		 * Use this method to register your own mediators in this context.
		 * It'll register one's own custom mediator to a view class and stores the value in a dictionary
		 * to prevent it from being auto-mapped again by MapModuleStylesCommand. <br/><br/>
		 * 
		 * It is assumed that if you still need the F*CSS behaviour/property application functionality, 
		 * your custom mediator would still need to extend from the standard BehaviourStyleMediator class.
		 * 
		 * @see sg.fcss.robotlegs.MapModuleStylesCommand
		 * @see sg.fcss.robotlegs.BehaviourStyleMediator
		 */
		protected function mapView(viewClassOrName:*, mediatorClass:Class, injectViewAs:Class = null, autoCreate:Boolean = true, autoRemove:Boolean = true):void {
			_mappedModules[viewClassOrName] = true;
			mediatorMap.mapView(viewClassOrName, mediatorClass, injectViewAs, autoCreate, autoRemove);
		}
		
		
		public function get __injector():IInjector {
			return injector;
		}
		
		public function get __reflector():IReflector {
			return reflector;
		}
		
		
		
	}

}