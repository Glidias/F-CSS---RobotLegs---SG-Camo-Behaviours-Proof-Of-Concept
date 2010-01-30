﻿package sg.fcss.robotlegs 
{
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
	import sg.camo.interfaces.IPropertyApplier;
	import sg.camo.interfaces.IReflectClass;
	import sg.camo.interfaces.ITextField;
	import sg.fcss.events.StyleRequestBubble;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.utils.TextStyleMediatorUtil;
	import sg.camo.ancestor.AncestorListener;


	/**
	 * Applies properties and behaviours to view component
	 * @author Glenn Ko
	 */
	public class BehaviourStyleMediator extends Mediator
	{
		
		[Inject]
		public function set behaviourSrc(src:IBehaviouralBase):void {
			_behaviourSrc = src;
		}
		protected var _behaviourSrc:IBehaviouralBase;
		
		[Inject]
		public function set propApplier(src:IPropertyApplier):void {
			_propApplier = src;
		}
		protected var _propApplier:IPropertyApplier;
		

		[Inject]
		public function set styleSource(src:IStyleRequester):void {
			_styleSource = src;
		}
		protected var _styleSource:IStyleRequester;
		
		[Inject(name="textStyle")]
		public function set textPropApplier(src:IPropertyApplier):void {
			_textPropApplier = src;
		}
		protected var _textPropApplier:IPropertyApplier;
	
			
		[Inject(name="textStyle")]
		public var defaultStylesheet:StyleSheet;
		
		
		protected var _behaviourCache:Dictionary;
		
		
		public function BehaviourStyleMediator() 
		{
			super();
		}
		
		protected function onTextStyleRequest(e:StyleRequestBubble):void { 
			e.stopImmediatePropagation();
		}
		
		override public function setViewComponent(vc:Object):void {
			super.setViewComponent(vc);
			
			var baseReflect:String = vc is IReflectClass ? getQualifiedClassName( (vc as IReflectClass).reflectClass ).split("::").pop() : null;
			var className:String = getQualifiedClassName(vc).split("::").pop();
			var superClassName:String = baseReflect!=null ? baseReflect : className;  // getQualifiedSuperclassName(target).split("::").pop();
			var arr:Array = superClassName != className ? [superClassName, "." + className, "." + className + "#" + vc.name] : ["." + className, "." + className + "#" + vc.name];
			if (vc is ITextField) {   // consider textField subselector
				if ( _styleSource.hasStyle("." + className + ">textField") ) {
					var textPropsArr:Array =  baseReflect != null ? ["TextField", baseReflect + ">textField", "." + className + ">textField"] : ["TextField", "." + className + ">textField"];
					var textProps:IStyle = _styleSource.getStyle.apply(null, textPropsArr);
					var tProps:Object = textProps;
					var txtField:TextField = (vc as ITextField).textField;
					TextStyleMediatorUtil.applyTextStyleWith(_textPropApplier, tProps, txtField, defaultStylesheet);
					AncestorListener.addEventListenerOf(txtField, StyleRequestBubble.TEXT_STYLE, onTextStyleRequest, 1, false);
					if ( tProps.behaviours ) applyBehavioursToVc(txtField, tProps.behaviours, textPropsArr);
				}
			}
			var props:Object =  _styleSource.getStyle.apply(null, arr);
			if (props.behaviours) applyBehavioursToVc(vc, props.behaviours, arr);
			
			_propApplier.applyProperties(vc,props);
		}
		
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

					if (_behaviourCache) {
						_behaviourCache[beh.behaviourName] = true;
						beh.activate(vc);
					}
					else {
						behaviouralBase.addBehaviour(beh);
					}
				}
		}
		
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
					if (prevStyle) _propApplier.applyProperties( beh, prevStyle );
		}
		
		override public function onRemove():void {
			if (viewComponent is ITextField) {
				AncestorListener.removeEventListenerOf(viewComponent as IEventDispatcher, StyleRequestBubble.TEXT_STYLE, onTextStyleRequest);
			}
		}
		
	}

}