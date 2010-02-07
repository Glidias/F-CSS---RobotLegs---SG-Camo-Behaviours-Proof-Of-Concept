package sg.fcss.adaptors 
{
	import sg.camo.interfaces.ITypeHelper;
	import com.flashartofwar.fcss.utils.TypeHelperUtil;
	
	/**
	 * Proxy on behalf of static TypeHelperUtil under FCSS core
	 * @author Glenn Ko
	 */
	public class TypeHelperUtilProxyFCSS implements ITypeHelper
	{
		
		public function TypeHelperUtilProxyFCSS() 
		{
			
		}
		
		public function getType(data : String, type : String) : *  {
			return TypeHelperUtil.getType(data, type);
		}
		
		
		
	}

}