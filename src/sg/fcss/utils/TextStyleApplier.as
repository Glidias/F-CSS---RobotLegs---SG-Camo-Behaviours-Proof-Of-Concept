package sg.fcss.utils 
{
	import flash.text.TextField;
	import sg.camo.interfaces.IPropertyApplier;
	import com.flashartofwar.fcss.utils.TextFieldUtil;
	/**
	 * IPropertyApplier interface for TextFieldUtil
	 * @author Glenn Ko
	 */
	public class TextStyleApplier implements IPropertyApplier
	{
		
		public function TextStyleApplier() 
		{
			
		}
		
		public function applyProperties(target:Object, properties:Object):void {
			TextFieldUtil.applyStyle(target as TextField, properties);
		}
		
	}

}