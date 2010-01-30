package sg.gaialegs.framework 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.mvcs.Command;
	import org.robotlegs.mvcs.Context;
	import sg.fcss.events.StyleRequestBubble;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.utils.*;
	import sg.camo.interfaces.IPropertyApplier;
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
			injector.mapSingletonOf(IPropertyApplier, StyleApplier );
			injector.mapSingletonOf(IPropertyApplier, TextStyleApplier, "textStyle");
			
			
			// View Modules to register locally in context to one own custom mediator
			//mapView("sg.gaialegs.ui::AnotherTextModule", SomeCustomMediatorExtendsBehavioualMediator );
			
		
			// Instantiate default stylings for all unregistered view modules in CSS, and all default Flash textfields
			injector.mapValue(Class, BehaviourStyleMediator, "mapModulesTo");
			injector.mapValue(Dictionary, _mappedModules, "registeredModules");
			(injector.instantiate(MapModuleStylesCommand) as Command).execute();
			mediatorMap.mapView("flash.text::TextField", TextStyleMediator );
			
			
			injector.mapValue(IEventDispatcher, _contextView, "textStyle");	
			mediatorMap.registerMediator( _contextView, injector.instantiate(TextStyleApplierMediator) );

		}
		
		/**
		 * Registers a view module to one's own custom mediator 
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