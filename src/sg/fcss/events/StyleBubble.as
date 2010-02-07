package sg.fcss.events 
{
	import com.flashartofwar.fcss.styles.IStyle;
	import flash.events.Event;
	
	/**
	 * Bubbled event with style payload and array of strings used to derive the style
	 * @author Glenn Ko
	 */
	public class StyleBubble extends Event 
	{
		public static const TEXT_STYLE:String = "StyleBubble.TEXT_STYLE";
		public static const DESCENDANT_STYLE:String = "StyleBubble.DESCENDANT_STYLE";
		
		public var style:IStyle;
		public var styleArray:Array;
		
		public function StyleBubble(type:String, style:IStyle, styleArray:Array) 
		{ 
			super(type, true, false);
			this.style = style;
			this.styleArray = styleArray;
		} 
		
		public override function clone():Event 
		{ 
			return new StyleBubble(type, style, styleArray );
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StyleBubble", "type", "style"); 
		}
		
	}
	
}