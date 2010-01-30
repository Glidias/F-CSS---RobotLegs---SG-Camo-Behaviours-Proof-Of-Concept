package sg.gaialegs.ui.base 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import sg.camo.interfaces.IReflectClass;
	import sg.camo.interfaces.IText;
	import sg.camo.interfaces.ITextField;
	/**
	 * Base class to indicate a ITextField/IText module of a sprite housing a textfield
	 * 
	 * Uses IReflectClass to reflect a base class signature for the F*CSS sheet
	 * to externally inject any required properties for the base class.
	 * 
	 * @author Glenn Ko
	 */
	public class TextSpr extends Sprite implements ITextField, IText, IReflectClass
	{
		private var _textField:TextField;
		
		public function TextSpr() 
		{
			
		}
		
		// -- IReflectClass
		public function get reflectClass():Class {
			return TextSpr;
		}
		
		// [Stage]
		public function set txtLabel(txtField:TextField):void {
			_textField = txtField;
		}
		
		// -- ITextField
		public function get textField():TextField {
			return _textField;
		}
			
		// -- IText
		public function set text (str:String):void {
			_textField.text = str;
		}
		public function get text ():String {
			return _textField.text;
		}
		
		
		
	}

}