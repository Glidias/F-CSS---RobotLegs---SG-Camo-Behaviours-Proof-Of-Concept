﻿package sg.camogxmlgaia.robotlegs.pages
{
	import com.gaiaframework.api.IDisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import org.robotlegs.core.IInjector;
	import sg.camogxmlgaia.pages.GXMLIndexTree;
	import sg.camogxmlgaia.robotlegs.adaptors.*;
	import sg.camogxmlgaia.robotlegs.api.*;
	
	
	/**
	 * A standard root page for CamoGXMLGaia with RobotLegs support
	 * @author Glenn Ko
	 */
	public class GXMLRobotTree extends GXMLIndexTree
	{
		
		protected var _injector:IInjector;
		protected var _mainContextProvider:IMainContextProvider;
		
		public function GXMLRobotTree() 
		{
			super();
			RobotlegsInterfaces;
		}
		
		/**
		 *  Sets up main context provider on preloaded "robotlegs" asset under index tree page branch.
		 * It is assumed the loader content implements the IMainContextProvider interface which provide
		 * access to a crossplatform injector/reflector being used for Robotlegs.
		 */
		override public function transitionIn():void {
			super.transitionIn();
			
			var mainContextProvider:IMainContextProvider = (assets.robotlegs as IDisplayObject).loader.content as IMainContextProvider;
			_mainContextProvider = mainContextProvider;
			mainContextProvider.startup(mainStartupContext);
			_injector = mainContextProvider.getInjector();
			
			// NOTE: Need to call _mainContextProvider.init() in super implementation. 
		}
		
		/**
		 * Overwrites this method to return your own custom startup context. By default,
		 * the context is restricted to the asset loader content's  display object container. 
		 * As such, the Robotlegs asset can act as a IOC container.
		 */
		public function get mainStartupContext():DisplayObjectContainer {
			return (assets.robotlegs as IDisplayObject).loader.content as DisplayObjectContainer;
		}
		
		/**
		 * Retrieves an already-available, or not yet available, page instance and inject dependencies
		 * accordingly through RobotLegs IInjector and optionally with CamoGXMLGaia's INodeClassSpawner,
		 * registering either a mediator or context to the RobotLegs framework.
		 * @param	vc		The view component, which is usually a DisplayObject for the mediator or a 
		 * 					DisplayObjectContainer for the context.
		 * @param	payload	 A class / class name to instantiate
		 * @param	branch	A specified page branch to determine the lifecycle of the instance, 
		 * 					otherwise if null or blank, uses current index page branch. You can use unique named instances under
		 * 					a page branch by specifying a single '*' character and the name after it.
		 * 					(eg. index/home/*someNamedInstance)
		 * @param	node	  Any XML node to use to enable usage of INodeClassSpawner, which will attempt
		 * 					  to inject node settings into the instance.
		 * @param   subject	  A subject key you might want to pass to INodeClassSpawner
		 * @param   nodeInjectOnly	If set to true, uses INodeClassSpawner's to instantiate entire class
		 * 							and it's dependencies, foregoing RobotLegs/SwiftSuspenders' constructor injection
		 * 							 However, setter and method injection will still be done through
		 * 							RobotLegs/SwiftSuspenders.
		 * @return
		 */
		public function createMediator(vc:Object, payload:*, branch:String=null, node:XML = null, subject:*=null, nodeSpawn:Boolean=false):void {
			checkPageInstance(payload, branch, node, subject, createRLModule, [nodeSpawn,vc,RLDestroyableMediator]);
		}
		
		public function createContext(vc:DisplayObjectContainer, payload:*, branch:String = null, node:XML = null, subject:*= null, nodeSpawn:Boolean = false):void {
			checkPageInstance(payload, branch, node, subject, createRLModule, [nodeSpawn,vc,RLDestroyableContext]);
		}
		
		/** @private */
		protected function createRLModule(payload:*, branch:String, node:XML, subject:*, dictToRegister:Dictionary, keyToRegister:String, nodeSpawn:Boolean, containerObj:Object, moduleClass:Class):* {
			var classe:Class = payload as Class || getClass(payload);
			var instance:*;
			if (node!=null) {
				if (!nodeSpawn) {
					instance = _injector.instantiate(classe);
					_nodeClassSpawnerManager.injectInto(instance, node, subject);
				}
				else {
					instance = _nodeClassSpawnerManager.spawnClassWithNode(classe, node, subject);
					_injector.injectInto(instance);
				}
			}
			else instance = _injector.instantiate(classe);
			var mod:* = new moduleClass(containerObj, instance);
			_injector.injectInto(mod);
			dictToRegister[keyToRegister] = mod; 
			return instance;
		}
		
	}

}
