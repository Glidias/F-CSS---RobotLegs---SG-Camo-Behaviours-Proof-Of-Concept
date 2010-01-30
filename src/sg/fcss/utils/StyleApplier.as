package sg.fcss.utils 
{
	import sg.camo.interfaces.IPropertyApplier;
	import com.flashartofwar.fcss.utils.StyleApplierUtil;
	/**
	 * IPropertyApplier proxy on behalf of static StyleApplierUtil
	 * @author Glenn Ko
	 */
	public class StyleApplier implements IPropertyApplier
	{
		
		public function StyleApplier() 
		{
			
		}
		
		public function applyProperties(target:Object, properties:Object):void {
			StyleApplierUtil.applyProperties(target, properties);
		}
		
	}

}