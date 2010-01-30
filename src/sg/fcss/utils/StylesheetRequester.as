package sg.fcss.utils 
{
	import com.flashartofwar.fcss.styles.IStyle;
	import com.flashartofwar.fcss.stylesheets.IStyleSheet;
	import sg.fcss.interfaces.IStyleRequester;

	/**
	 * Limits the functionality of stylesheet to only requesting styles
	 * @author Glenn Ko
	 */
	public class StylesheetRequester implements IStyleRequester
	{
		
		protected var _stylesheet:IStyleSheet;
		
		public function StylesheetRequester(targ:IStyleSheet) 
		{
			_stylesheet = targ;
		}
		
		public function getStyle(...args):IStyle {
			return _stylesheet.getStyle.apply(null, args);
		}
		public function hasStyle(val:String):Boolean {
			return _stylesheet.hasStyle(val);
		}
		
		public function get stylesheet():IStyleSheet {
			return _stylesheet;
		}
		
		public function styleLookup(styleName:String, getRelated:Boolean = true):IStyle {
			return _stylesheet.styleLookup(styleName, getRelated);
		}
		
		public function get styleNames():Array {
			return _stylesheet.styleNames;
		}

		
		
	}

}