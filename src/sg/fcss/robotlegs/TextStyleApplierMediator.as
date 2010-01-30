package sg.fcss.robotlegs  
{
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import org.robotlegs.mvcs.Mediator;
	import sg.camo.interfaces.IPropertyApplier;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.events.StyleRequestBubble;
	import sg.fcss.utils.TextStyleMediatorUtil;
	/**
	 * ...
	 * @author Glenn Ko
	 */
	public class TextStyleApplierMediator extends Mediator
	{
		[Inject(name="textStyle")]
		public var listenContainer:IEventDispatcher;
		
		
		[Inject(name="textStyle")]
		public function set propApplier(src:IPropertyApplier):void {
			_propApplier = src;
		}
		protected var _propApplier:IPropertyApplier;
		
		[Inject(name="textStyle")]
		public var defaultStylesheet:StyleSheet;
		
		
		public function TextStyleApplierMediator(listenContainer:IEventDispatcher=null) 
		{
			super();
			this.listenContainer = listenContainer;
		}
		

		
		override public function onRegister () : void {
			eventMap.mapListener(listenContainer, StyleRequestBubble.TEXT_STYLE, onTextStyleRequest);
		}
		
		private function onTextStyleRequest(e:StyleRequestBubble):void {
			e.stopPropagation();
			TextStyleMediatorUtil.applyTextStyleWith(_propApplier, e.style, e.target as TextField, defaultStylesheet);
		}
		

		
		
		
	}

}