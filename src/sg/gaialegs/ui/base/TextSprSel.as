package sg.gaialegs.ui.base 
{
	/**
	 * Base class to indiciate selectable sprites with ITextFIeld/IText capability
	 * 
	 * Uses IReflectClass to reflect a base class signature for the F*CSS sheet
	 * to externally inject the required behaviours for display component.
	 * 
	 * @author Glenn Ko
	 */
	public class TextSprSel extends TextSpr
	{
		public function TextSprSel() {
			super();
		}
		
		// -- IReflectClass
		override public function get reflectClass():Class {
			return TextSprSel;
		}
		
	}

}