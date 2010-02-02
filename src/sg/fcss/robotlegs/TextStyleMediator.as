package sg.fcss.robotlegs  
{
	import com.flashartofwar.fcss.styles.IStyle;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	import flash.text.TextField;
	import org.robotlegs.mvcs.Mediator;
	import sg.camo.interfaces.IReflectClass;
	import sg.camo.interfaces.ISelectorSource;
	import sg.camo.interfaces.ITextField;
	import sg.fcss.interfaces.IStyleRequester;
	import sg.fcss.events.StyleBubble;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

	/**
	 * ...
	 * @author Glenn Ko
	 */
	
	 
	public class TextStyleMediator extends Mediator
	{
		[Inject]
		public function set styleSource(src:IStyleRequester):void {
			_styleSource = src;
		}
		protected var _styleSource:IStyleRequester;	
	
		
		
		public function TextStyleMediator() 
		{
			super();
		}
		
		override public function setViewComponent (vc:Object) : void {
			
			super.setViewComponent(vc);
			if (vc == null) return;
			
			var txtField:TextField = vc as TextField;
			if (txtField == null) return;
			
			var derivedStyle:IStyle;
			var className:String = getQualifiedClassName(vc).split("::").pop();
			var arr:Array;

				arr = className != "TextField" ? vc is IReflectClass  ? validateReflectClassStyles(className, txtField) : ["TextField", "."+className, "."+className+"#"+txtField.name] : ["TextField", "TextField#"+txtField.name];
				
				derivedStyle = _styleSource.getStyle.apply(null,  arr);
				
				if ( !txtField.embedFonts ) txtField.dispatchEvent( new StyleBubble(StyleBubble.TEXT_STYLE, derivedStyle, arr.concat()) );
				txtField.dispatchEvent( new StyleBubble(StyleBubble.DESCENDANT_STYLE, _styleSource.styleLookup("EmptyStyle"), arr.concat() ) );
			
				// consider keeping?
				mediatorMap.removeMediator(this);  
			
		}
		
		protected function validateReflectClassStyles(className:String, txtField:TextField):Array {
			var baseClassName:String = getQualifiedClassName((txtField as IReflectClass).reflectClass).split("::").pop();
			return baseClassName != className ?  ["TextField", baseClassName, "." + className, "." + className + "#" + txtField.name] : ["TextField", "." + className, "." + className + "#" + txtField.name];
		}
		

		
		
	
		
		
		
	}

}