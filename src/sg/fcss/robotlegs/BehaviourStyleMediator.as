package sg.fcss.robotlegs 
{
	import camo.core.display.IDisplay;
	import com.flashartofwar.fcss.applicators.IApplicator;
	import com.flashartofwar.fcss.styles.IStyle;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.mvcs.Mediator;
	import sg.camo.interfaces.IBehaviour;
	import sg.camo.interfaces.IBehaviouralBase;
	import sg.camo.interfaces.IReflectClass;
	import sg.camo.interfaces.ITextField;
	import sg.fcss.events.StyleBubble;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.utils.TextStyleMediatorUtil;
	import sg.camo.ancestor.AncestorListener;


	/**
	 * Applies properties and behaviours to view component
	 * @author Glenn Ko
	 */
	
	[Inject(name='textStyle')]
	public class BehaviourStyleMediator extends Mediator
	{
		
		[Inject]
		public function set behaviourSrc(src:IBehaviouralBase):void {
			_behaviourSrc = src;
		}
		protected var _behaviourSrc:IBehaviouralBase;
		
		[Inject]
		public function set propApplier(src:IApplicator):void {
			_propApplier = src;
		}
		protected var _propApplier:IApplicator;
		

		[Inject]
		public function set styleSource(src:IStyleRequester):void {
			_styleSource = src;
		}
		protected var _styleSource:IStyleRequester;
		
		[Inject(name="textStyle")]
		public function set textPropApplier(src:IApplicator):void {
			_textPropApplier = src;
		}
		protected var _textPropApplier:IApplicator;
	
			
		public var defaultStylesheet:StyleSheet;
		
		/**
		 * An array reference of style names being used for object
		 */
		protected var _myStyleArray:Array;

		/** @private */
		protected var _behaviourCache:Dictionary;
		
		
		public function BehaviourStyleMediator(defaultStylesheet:StyleSheet= null) 
		{
			super();
			this.defaultStylesheet = defaultStylesheet;
		}
		
		/**
		 * @private
		 * Stops any text style bubbles by default, since this mediator applies text styles 
		 * immediately.
		 * @param	e
		 */
		protected function onTextStyleRequest(e:StyleBubble):void { 
			e.stopImmediatePropagation();
		}
		
		override public function setViewComponent(vc:Object):void {
			super.setViewComponent(vc);
			if (vc == null) return;
		
			
			var vcDispatcher:IEventDispatcher = vc as IEventDispatcher;
			if (vcDispatcher.hasEventListener(StyleBubble.DESCENDANT_STYLE) ) vcDispatcher.removeEventListener(StyleBubble.DESCENDANT_STYLE, applyDescendantStyleHandler) 
			
			var baseReflect:String = vc is IReflectClass ? getQualifiedClassName( (vc as IReflectClass).reflectClass ).split("::").pop() : null;
			var className:String = getQualifiedClassName(vc).split("::").pop();
			var superClassName:String = baseReflect!=null ? baseReflect : className;  // getQualifiedSuperclassName(target).split("::").pop();
			var arr:Array = superClassName != className ? [superClassName, "." + className, "." + className + "#" + vc.name] : ["." + className, "." + className + "#" + vc.name];
			if (vc is ITextField) {   
				var textPropsArr:Array =  baseReflect != null ? ["TextField", baseReflect + ">textField", "." + className + ">textField", "." + className + ">textField#"+vc.name] : ["TextField", "." + className + ">textField", "." + className + ">textField#"+vc.name];
				var textProps:IStyle = _styleSource.getStyle.apply(null, textPropsArr); 
				var tProps:Object = textProps;
				var txtField:TextField = (vc as ITextField).textField;
				TextStyleMediatorUtil.applyTextStyleWith(_textPropApplier, tProps, txtField, defaultStylesheet);
				_propApplier.applyStyle(txtField, tProps);
				txtField.dispatchEvent( new StyleBubble(StyleBubble.DESCENDANT_STYLE, textProps, textPropsArr) );
				
				AncestorListener.addEventListenerOf(txtField, StyleBubble.TEXT_STYLE, onTextStyleRequest, 1, false);
				if ( tProps.behaviours ) applyBehavioursToVc(txtField, tProps.behaviours, textPropsArr);
			}
			if (vc is IDisplay) {  
				var dispPropsArr:Array = baseReflect != null ? [baseReflect + ">display", "." + className + ">display", "." + className + ">display#"+vc.name] : ["."+className + ">display", "."+className + ">display#"+vc.name ];
				var dispProps:Object = _styleSource.getStyle.apply(null, dispPropsArr);
				
				if ( dispProps.behaviours ) applyBehavioursToVc((vc as IDisplay).getDisplay(), dispProps.behaviours, dispPropsArr);
				
				_propApplier.applyStyle((vc as IDisplay).getDisplay(), dispProps);
			}
			
			var props:Object =  _styleSource.getStyle.apply(null, arr);
			if (props.behaviours) applyBehavioursToVc(vc, props.behaviours, arr);
			
			_propApplier.applyStyle(vc, props);
			
			_myStyleArray = arr.concat();
			if (textPropsArr != null && dispPropsArr != null) textPropsArr = textPropsArr.concat( dispPropsArr);
			var descArray:Array = textPropsArr!=null ? arr.concat( textPropsArr ) : arr.concat();
			vcDispatcher.dispatchEvent( new StyleBubble(StyleBubble.DESCENDANT_STYLE, _styleSource.styleLookup("EmptyStyle"), descArray ) );
			vcDispatcher.addEventListener(StyleBubble.DESCENDANT_STYLE, applyDescendantStyleHandler, false, 0, true);
		}
		
		/** @private  Handles descendant styles by adding it's own style array to the descendant selector */
		protected function applyDescendantStyleHandler(e:StyleBubble):void {
			var chkArray:Array =  e.styleArray;
			var u:int = chkArray.length;
			var curStyle:Object = e.style;
			while ( --u > -1) {
				var i:int = _myStyleArray.length;
				while (--i > -1) {
					var chkStyle:String = _myStyleArray[i] + ">>" + chkArray[u];
					if ( _styleSource.hasStyle(chkStyle) ) {  // prepend
						var chkObj:Object = _styleSource.styleLookup(chkStyle, false);
						for (var prop:String in chkObj) {
							if (curStyle[prop] == null) curStyle[prop] = chkObj[prop];
						}
					}
				}
			}
		}
		
		/** @private  */
		protected function applyBehavioursToVc(vc:Object, stringToSplit:String, styleArr:Array):void {
			if ( !(vc is IBehaviouralBase) && !_behaviourCache ) _behaviourCache =  new Dictionary();
				var arrBehaviours:Array = stringToSplit.split(" ");
				var behaviouralBase:IBehaviouralBase = vc as IBehaviouralBase;
				var len:int = arrBehaviours.length;
				for (var i:int=0; i < len;i++) {
					var beh:IBehaviour = _behaviourSrc.getBehaviour(arrBehaviours[i]);
					if (beh == null) continue;
					// consider behaviour subselector
				
					applyBehaviourProperties(beh, styleArr);

					if (behaviouralBase == null) {
						_behaviourCache[beh.behaviourName] = beh;
						beh.activate(vc);
					}
					else {
						
						behaviouralBase.addBehaviour(beh);
					}
				}
		}
		
		/**
		 * Helper method to retrieve behaviour of instance by behaviour name
		 * @param	behName
		 * @return
		 */
		protected function getBehaviour(behName:String):IBehaviour {
			return _behaviourCache ? _behaviourCache[behName] : viewComponent is IBehaviouralBase ? (viewComponent as IBehaviouralBase).getBehaviour(behName) : null;
		}
		
		/** @private  */
		protected function applyBehaviourProperties(beh:IBehaviour, styleArr:Array):void {
			var behName:String = beh.behaviourName;
					var arrLen:int = styleArr.length;
					var prevStyle:IStyle;
					for (var u:int = 0; u < arrLen; u++) {
						var styleLookup:String = styleArr[u] + ">" + behName;
						var behStyle:IStyle = _styleSource.hasStyle(styleLookup) ?  _styleSource.styleLookup(styleLookup) : null;
						if (!prevStyle) {
							prevStyle = behStyle;
							continue;
						}
						if (!behStyle) continue;
						prevStyle.merge(behStyle);
					}
					if (prevStyle) _propApplier.applyStyle( beh, prevStyle );
		}
		
		override public function onRemove():void {
			if (viewComponent is ITextField) {
				AncestorListener.removeEventListenerOf(viewComponent as IEventDispatcher, StyleBubble.TEXT_STYLE, onTextStyleRequest);
			}
		}
		
	}

}