package sg.fcss.robotlegs  
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import org.robotlegs.mvcs.Mediator;
	import sg.camo.interfaces.IPropertyApplier;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.events.StyleBubble;
	import sg.fcss.utils.TextStyleMediatorUtil;
	/**
	 * Listens to style bubbles on the context container view from which
	 * final stylings can be eventually applied to objects.
	 * 
	 * @author Glenn Ko
	 */
	
	[Inject(name="textStyle")]
	public class ContextStyleApplierMediator extends Mediator
	{
		[Inject(name="contextStyle")]
		public var listenContainer:IEventDispatcher;
		
		[Inject]
		public function set propApplier(src:IPropertyApplier):void {
			_propApplier = src;
		}
		protected var _propApplier:IPropertyApplier;
		
		[Inject(name="textStyle")]
		public function set textPropApplier(src:IPropertyApplier):void {
			_textPropApplier = src;
		}
		protected var _textPropApplier:IPropertyApplier;
		
		
		public var defaultStylesheet:StyleSheet;
		
		
		/**
		 * 
		 * @param	defaultStylesheet	A native default Flash Stylesheet to use (if available)
		 */
		public function ContextStyleApplierMediator(defaultStylesheet:StyleSheet = null) 
		{
			super();
			this.defaultStylesheet = defaultStylesheet;
		}

		
		override public function onRegister () : void {
			eventMap.mapListener(listenContainer, StyleBubble.TEXT_STYLE, onTextStyleRequest);
			eventMap.mapListener(listenContainer, StyleBubble.DESCENDANT_STYLE, applyDescendantStyleHandler);
		}
		
		private function onTextStyleRequest(e:StyleBubble):void {
			e.stopPropagation();
			TextStyleMediatorUtil.applyTextStyleWith(_textPropApplier, e.style, e.target as TextField, defaultStylesheet);
		}
		
		private function applyDescendantStyleHandler(e:StyleBubble):void {
			_propApplier.applyProperties( e.target, e.style);
		}

		
		
		
	}

}