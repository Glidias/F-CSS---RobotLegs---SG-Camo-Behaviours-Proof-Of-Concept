package sg.fcss.robotlegs  
{
	import com.flashartofwar.fcss.applicators.IApplicator;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import org.robotlegs.mvcs.Mediator;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.events.StyleBubble;
	import sg.fcss.utils.TextStyleMediatorUtil;
	/**
	 * ContextStyleApplierMediator, which listens to style bubbles in order to apply
	 * final properties on the event targets.
	 * @author Glenn Ko
	 */
	
	[Inject(name="contextStyle", name="textStyle")]
	public class ContextStyleApplierMediator extends Mediator
	{
		
		// Constructor variables
		public var listenContainer:IEventDispatcher;
		public var defaultStylesheet:StyleSheet;
		
		
		[Inject]
		public function set propApplier(src:IApplicator):void {
			_propApplier = src;
		}
		protected var _propApplier:IApplicator;
		
		[Inject(name="textStyle")]
		public function set textPropApplier(src:IApplicator):void {
			_textPropApplier = src;
		}
		protected var _textPropApplier:IApplicator;

		
		public function ContextStyleApplierMediator(listenContainer:IEventDispatcher, defaultStylesheet:StyleSheet= null) 
		{
			super();
			this.listenContainer = listenContainer;
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
			_propApplier.applyStyle( e.target, e.style);
		}

		
		
		
	}

}