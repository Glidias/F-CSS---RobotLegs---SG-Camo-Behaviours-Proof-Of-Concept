package sg.fcss.events 
{
	import com.flashartofwar.fcss.styles.IStyle;
	import flash.events.Event;
	
	/**
	 * Bubbled event with style request payload
	 * @author Glenn Ko
	 */
	public class StyleRequestBubble extends Event 
	{
		public static const TEXT_STYLE:String = "StyleRequestBubble.TEXT_STYLE";
		public var style:IStyle;
		
		public function StyleRequestBubble(type:String, style:IStyle) 
		{ 
			super(type, true, false);
			this.style = style;
		} 
		
		public override function clone():Event 
		{ 
			return new StyleRequestBubble(type, style );
		} 
		
		public override function toString():String 
		{ 
			return formatToString("StyleRequestBubble", "type", "style"); 
		}
		
	}
	
}