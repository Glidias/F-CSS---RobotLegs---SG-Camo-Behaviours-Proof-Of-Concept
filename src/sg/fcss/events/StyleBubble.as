package sg.fcss.events 
{
	import com.flashartofwar.fcss.styles.IStyle;
	import flash.events.Event;
	
	/**
	 * Bubbled event with style information payload.<br/>
	 * This is a multi-purpose event that can support descendant styles up the display list
	 * chain, from which eventual stylings can be applied finally on the root context level.
	 * 
	 * @author Glenn Ko
	 */
	public class StyleBubble extends Event 
	{
		public static const TEXT_STYLE:String = "StyleBubble.TEXT_STYLE";
		public static const DESCENDANT_STYLE:String = "StyleBubble.DESCENDANT_STYLE";
		
		public var style:IStyle;
		public var styleArray:Array;
		
		/**
		 * Constructor
		 * @param	type		The event type
		 * @param	style		The current IStyle object payload to be applied
		 * @param	styleArray	An array of style names that was used to derive the style		
		 */
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