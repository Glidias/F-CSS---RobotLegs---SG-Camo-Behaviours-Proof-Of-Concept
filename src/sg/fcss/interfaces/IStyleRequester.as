package sg.fcss.interfaces 
{
	import com.flashartofwar.fcss.styles.IStyle;
	
	/**
	 * Limited interface to retrieve IStyles only
	 * @author Glenn Ko
	 */
	public interface IStyleRequester 
	{
		function getStyle(...args):IStyle;
		function hasStyle(val:String):Boolean;
		function styleLookup(styleName:String, getRelated:Boolean = true):IStyle
		function get styleNames():Array;
	}
	
}