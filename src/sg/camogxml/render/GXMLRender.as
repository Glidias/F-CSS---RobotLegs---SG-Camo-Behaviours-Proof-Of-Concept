﻿package sg.camogxml.render
{
	import camo.core.property.IPropertySheet;
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import sg.camo.interfaces.IDefinitionGetter;
	import sg.camo.interfaces.IPropertyApplier;
	
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	import flash.xml.XMLNodeType;
	
	import sg.camo.interfaces.ITextField;
	import sg.camo.interfaces.IText;
	
	import sg.camo.interfaces.IBehaviouralBase;
	import sg.camo.interfaces.IBehaviour;
	import sg.camo.interfaces.ISelectorSource;
	
	import sg.camo.interfaces.IDestroyable;
	import sg.camo.interfaces.IRecursableDestroyable;
	import sg.camo.interfaces.IDisplayRender;

	import sg.camogxml.api.IGXMLRender;


	/**
	* A basic one-time(render-once) DisplayObjectContainer/DisplayObject renderer in DOM-based XML.
	* 
	* @author Glenn Ko
	*/
	
	[Inject(name='gxml',name='gxml',name='gxml',name='',name='textStyle')]
	public class GXMLRender extends XMLDocument implements IRecursableDestroyable, IDisplayRender, IGXMLRender
	{
		protected var _rootNode:XMLNode;
		protected var _behCache:Dictionary = new Dictionary();
	
		protected var _rendered:DisplayObject;
		protected var _renderId:String = "GXMLRender";
		protected var _isActive:Boolean = false;
		
		protected var bindAttribute:Function = dummyBinding;
		protected var bindText:Function = dummyBinding;
		
		public var dispPropApplier:IPropertyApplier;
		public var behPropApplier:IPropertyApplier;
		public var textPropApplier:IPropertyApplier;
		
		
		// Required (constructor supplied)
		public var stylesheet:ISelectorSource;
		public var behaviours:IBehaviouralBase;
		public var definitionGetter:IDefinitionGetter;
				
		// Required (for inline stylesheet support)
		public var inlineStyleSheetClass:Class;
		
		// Optional Public Settings
		public static var DEFAULT_COMPRESS_CSS:Boolean = true;
		public var compressInlineCSS:Boolean;
		
		// rarely injected (constructor initialised by convention.)
		public var defaultClass:Class;
		public var defaultTextClass:Class;
		public var defaultTextFieldProps:Object;

		// Flags
		protected var _curProps:Object;
		protected var _curPropsArr:Array;
		protected var _parsed:Boolean = false;
		protected var _xmlCache:XML;
		
		
		// NodeClassSpawner must create throwaway.
		// CGGconfig edit from constructor to setter for inline stylesheet
		
		
		public function GXMLRender(definitionGetter:IDefinitionGetter, behaviours:IBehaviouralBase, stylesheet:ISelectorSource, propApplier:IPropertyApplier, textPropApplier:IPropertyApplier=null) 
		{
			super();
	
			if (definitionGetter == null) return;
			
			compressInlineCSS = DEFAULT_COMPRESS_CSS;
			
			this.stylesheet = stylesheet;
			this.behaviours = behaviours;
			this.definitionGetter = definitionGetter;
			
			defaultClass = defaultClass || definitionGetter.getDefinition("DefaultNode") as Class;
			defaultTextClass = defaultTextClass || definitionGetter.getDefinition("DefaultTextNode") as Class;
			defaultTextFieldProps = defaultTextFieldProps || stylesheet.getSelector("TextField") || { };
		
			this.dispPropApplier = propApplier;
			this.behPropApplier = propApplier;
			this.textPropApplier = textPropApplier || propApplier;
			
			ignoreWhite = true;
		}
		
		[PostConstruct(name = 'gxml.display', name = 'gxml.behaviour', name = 'gxml.text')]
		public function setCustomPropAppliers(dispPropApplier:IPropertyApplier=null,behPropApplier:IPropertyApplier=null,textPropApplier:IPropertyApplier=null):void {
			if (dispPropApplier) this.dispPropApplier = dispPropApplier;
			if (behPropApplier)  this.behPropApplier  = behPropApplier;
			if (textPropApplier) this.textPropApplier = textPropApplier;
		}
		
		// -- Bindings
		
		protected function myBinding(str:String):* {
			
		}
	
		/**
		 * Sets string binding method to process inline attribute values in nodes. Inline attribute values are passed to the 
		 * rendered node instance as additional properties for the property selector.<br/><br/>
		 * The function must accept a string and return a string.
		 */
		public function set attributeBinding(func:Function):void {
			bindAttribute = func;
		}
		/**
		 * Sets string binding method to process text values in text nodes.<br/><br/>
		 * The function must accept a string and return a string.
		 */
		public function set textBinding(func:Function):void {
			bindText = func;
		}
		
		private final function dummyBinding(val:String):String {
			return val;
		}

		
		protected function getBehaviour(behName:String):IBehaviour {
			var retBeh:IBehaviour = behaviours.getBehaviour(behName);
			if (_curProps != null) {	
				// apply curProps to behaviour
				behPropApplier.applyProperties(retBeh, _curProps);
			}
			return retBeh;
		}
		
		// -- IGXML
		
		/**
		 * 		
		 * Renders full xml with support for inline stylesheet and inline body.
		 * <br/><br/>
		 * Renders an already validated XML markup instance reference, and stores a XML cache of the reference 
		 * from which an inline stylesheet node and a body node can be retrieved. Use this method to render full GXML with
		 * support for inline stylesheets.
		 * @param	xml	A valid XML instance
		 */
		public function renderGXML(xml:XML):void {
			_xmlCache = xml;
			parseXML(xml);
		}
		
		// ---
		/**
		 * Used internally in parseXML() to retrieves XML cache instance by default, and also cleans up XML cache reference 
		 * after the XMLDocument has been created.<br/>
		 * If you need to keep the XML cache reference for whatever reason in extended classes, you have to overwrite 
		 * this method.
		 */
		protected function toRenderXMLCache():XML {
			var result:XML = _xmlCache;
			_xmlCache = null;
			return result;
		}
		
		/**
		 * Quick setter to parse an XMLDocument as a raw string. Same as parseXML().
		 */
		public function set xml(val:String):void {
			parseXML(val);
		}
	
		
		public function get rendered():DisplayObject {
			return _rendered;
		}
			
		public function getRenderedById(id:String):DisplayObject {
			
			return idMap[id] != null ? idMap[id].attributes.rendered : null;
		}
		
		public function restore(changedHash:Object = null):void {
			
		}
		
		public function get renderId():String { 
			return _renderId;
		}
		public function set isActive(boo:Boolean):void {
			_isActive = boo;
		}
		public function get isActive():Boolean {
			return _isActive;
		}
		
		
		public function get parsed():Boolean {
			return _parsed;
		}
		

		private function validateBody(xml:XML):XML {
			var body:XMLList = xml.body;
			if (body.length() < 1) return null;
			var bodyList:XMLList = body[0].*;
			return bodyList.length() > 0 ? bodyList[0] : null;
		}
		
		/** @private*/
		protected function considerInlineStylesheet(xml:XML):Boolean {
			if (inlineStyleSheetClass != null && xml.stylesheet.length()> 0) {
				
				var inlineCSS:String = xml.body.length() > 0 ? xml.stylesheet[0] : null;
				if (inlineCSS) {
					var propSheet:IPropertySheet = new inlineStyleSheetClass() as IPropertySheet;
					if (propSheet != null) {
						propSheet.parseCSS(inlineCSS, compressInlineCSS);
						if (stylesheet == null) {
							stylesheet = propSheet;
						}
						else {  // merge into current inline property sheet.	
							var selNames:Array = stylesheet.selectorNames;
				
							for each(var selName :String in selNames) {
								// don't overwrite if property sheeet already has selector
								//if ( !propSheet.hasSelector(selName) ) {
								//	trace("Adding selector:", selName, stylesheet.getSelector(selName));
									propSheet.newSelector( selName, stylesheet.findSelector(selName) );
								//}
							}
							stylesheet = propSheet;
						}
						return true;
					}
					else {
						trace("parseXML inlineStylesheet. Cast to IPropertySheet failed for instantiated class:" + inlineStyleSheetClass);
						return false;
					}
				}
				else {
					trace("Parse gxml inline stylesheet and body section failed for gxml markup:" + xml);
					return false;
				}
			}
			return false;
		}
		
		// --XMLDocument
		
		/**
		 * Parses raw source string into an XMLDocument for rendering of display.  If the method<code>renderGXML(xml:XML)</code>
		 * is used to call this,  the parser will also consider it's XML markup's
		 * inline stylesheet node and actual body node to use for rendering the XMLDocument.
		 * @param	source
		 */
		override public function parseXML(source:String):void {
			if (_parsed) return;
			
			var renderXMLCache:XML = toRenderXMLCache();
		
			var body:XML = validateBody(renderXMLCache);
			if (body != null) {
				source = body;
				considerInlineStylesheet(renderXMLCache);
				
			} 
			
			
			super.parseXML(source);
			_parsed = true;
			
			var node:XMLNode = firstChild;
			
			if (node == null) {
				trace("GXMLRender: parseXML() halted. No first child node from root!");
				
				return;
			}
			
			_rootNode = node.firstChild;
			
			_renderId = node.attributes.renderId || node.nodeName;
			
			node = _rootNode;
			
			//delete node.attributes['class'];
			
			_rendered = renderNode(node);
			
			
	
			if (_rendered == null) {
				trace("GXMLRender: parseXML() halted. Root node must be a displayObject");
				
				return;
			}
			
			if (_rendered is DisplayObjectContainer && !isTerminalNode(node) ) createChild(node.firstChild, _rendered as DisplayObjectContainer)  // recurse and create children
			
		
			_curProps = null;
		}
		

		
		protected function createChild(node:XMLNode, parent:DisplayObjectContainer):DisplayObject {
			
			while (node) {
				var disp:DisplayObject = renderNode(node);
				if (disp != null) parent.addChild(disp);
				
				var cont:DisplayObjectContainer = disp as DisplayObjectContainer;
				if (cont != null)  {
					if ( !isTerminalNode(node) ) createChild(node.firstChild, cont);
				}
				node = node.nextSibling;
			}
			
			return disp;
		}

		
		protected function renderUntyped(untyped:*, node:XMLNode, props:Object):void {
			if (untyped is IBehaviour) {
				var behBase:IBehaviouralBase = node.parentNode.attributes.rendered as IBehaviouralBase;
				if (behBase == null) return;
				behBase.addBehaviour( untyped as IBehaviour );
				dispPropApplier.applyProperties(untyped, props);
			}
		}

		protected function renderNode(node:XMLNode):DisplayObject {			
			var props:Object = getSelectorFromNode (node);
			
			_curProps = props;
			var isTxtNode:Boolean = isTextNode (node);
			var renderedItem:* = getRenderedItem(node, isTxtNode);
			if (renderedItem == null) {
				trace("Warning:: renderedItem of " + node.nodeName + " is null");
			}
			var disp:DisplayObject = renderedItem as DisplayObject;
			
		//	if (node.nodeName === "div") trace("SDS"+renderedItem);
			
			if (disp == null) {
				
				renderUntyped(renderedItem, node, props);
				return null;
			}
			
			
			isTxtNode = isTextPropInjectable(renderedItem);
			if (isTxtNode) injectTextFieldProps(disp, props, node)
			
			
			injectDisplayProps(disp, props, node);
			
			injectDisplayBehaviours(disp, props, node);
			

			node.attributes.rendered = disp;
		
			return disp;
		}
		
		protected function isTextPropInjectable(untyped:*):Boolean {
			return untyped is IText || untyped is ITextField || untyped is TextField;
		}
		
		protected function getRenderedItem(node:XMLNode, isTxtNode:Boolean):* {
			// TODO: parse different types of definitions
			return definitionGetter.hasDefinition(node.nodeName) ? new  (definitionGetter.getDefinition(node.nodeName) as Class)() : isTxtNode ? new defaultTextClass() : new defaultClass();
		}
		

		
		
		protected function injectDisplayBehaviours(disp:DisplayObject, props:Object, node:XMLNode):Array {
			var behArray:Array = null;

			 if (props.behaviours) {	
				behArray =  props.behaviours.split(" ");
				var beh:IBehaviour;
				var len:int = behArray.length;
				var i:int = 0 ;
				if (disp is IBehaviouralBase) {  // use interface method to add behaviours, but leave it to the class to activate them
					var behBase:IBehaviouralBase = disp as IBehaviouralBase;
					while (i < len) {
						
						beh = getBehaviour( behArray[i] );
						
						//behArray[i] = beh;
						behBase.addBehaviour( beh);
						i++;
					}
				}
				else  {		// force-add behaviours over DisplayObject and activate them automatically
					
					while (i < len) {	
						beh = getBehaviour( behArray[i] );
						beh.activate(disp);
						
						_behCache[beh] = true;
						i++;
					}
					
					
				}
			}
			
			return behArray;
		}
		
		
		
		protected function findTextField(obj:Object):TextField {
			return obj is ITextField ? (obj as ITextField).textField :  obj as TextField;
		}
		protected function injectTextFieldProps(disp:DisplayObject, props:Object, node:XMLNode):void {
			var txtField:TextField = findTextField(disp);
			if (txtField != null) {
				textPropApplier.applyProperties( txtField, defaultTextFieldProps  );
			}
	
			var tarValue:String = node.firstChild ? node.firstChild.nodeValue : null;
			if (tarValue == null) return; 
			if (disp is IText) (disp as IText).text = bindText(tarValue)
			else if (txtField != null) txtField.text = bindText(tarValue);
		}
		
		protected function injectDisplayProps(disp:DisplayObject, props:Object, node:XMLNode):void {
			dispPropApplier.applyProperties( disp, props );
		}
		
		// -- DOM Helpers
		
				
		protected function isTerminalNode(node:XMLNode):Boolean {
			return node.firstChild ? node.firstChild.nodeType == XMLNodeType.TEXT_NODE : true;
		}
		
		protected function getSelectorFromNode(node:XMLNode):Object {
			var sels:String = node.nodeName;
			var myPattern:RegExp =  /\s/g;
			var attrib:Object = node.attributes;
			sels += attrib["class"] ? ",."+ attrib["class"].replace(myPattern, ",.") : "";
			sels += attrib["id"] ? ",#" + attrib["id"] : "";
			var arr:Array = sels.split (",");
		
			var propSel:Object = stylesheet.getSelector.apply(null, arr);
			for (var i:String in attrib) { // Merge with inline attributes
				propSel[i] = bindAttribute(attrib[i]);
			}
	
			
			return propSel;
		}
		
		protected function isTextNode (node:XMLNode):Boolean {
			return node.firstChild!=null ?  node.firstChild.nodeType === XMLNodeType.TEXT_NODE : false;
		}
		
		// -- Destructors
		
		/**
		 * Automatically calls main <code>destroyRecurse()</code> function to perform full garbage collection.
		 */
		public function destroy():void {
			destroyRecurse(false);
			
		}
		
		public function destroyRecurse(boo:Boolean = false):void {
			for (var i:* in _behCache) {
				i.destroy();
			}
			/*if (boo && _rendered is IRecursableDestroyable) {
				(_rendered as IRecursableDestroyable).destroyRecurse(boo);
			}
			else*/
			destroyDisplay(_rendered, firstChild.attributes);
			destroyAllFromNode(firstChild);
			delete firstChild.attributes.rendered;
			idMap = null;
			_rendered = null;
			_xmlCache = null;
		}
		
	
		
		protected function destroyDisplay(disp:DisplayObject, attrib:Object):void {
			if (disp is IDestroyable) (disp as IDestroyable).destroy();
		}
		
		protected function destroyAllFromNode(baseNode:XMLNode):void {	
			var node:XMLNode = baseNode.firstChild;
			var nextNode:XMLNode;
			var attrib:Object;
			while (node) {
				attrib = node.attributes;
				nextNode = node.nextSibling;
				node.removeNode();
				if (attrib.rendered) { 
					//if (attrib.rendered is IRecursableDestroyable) (attrib.rendered as IRecursableDestroyable).destroyRecurse(false)
					//else 
					destroyDisplay(attrib.rendered, attrib);
					if ( !isTerminalNode (node) ) destroyAllFromNode(node);
					delete attrib.rendered;
				}
				node = nextNode;
			}
		}
		
		override public function toString():String {
			return "[A GXMLRender Instance]{" + _renderId + "}";
		}
		
		public function $toString():String {
			return super.toString();
		}
		
	}
	

	
}