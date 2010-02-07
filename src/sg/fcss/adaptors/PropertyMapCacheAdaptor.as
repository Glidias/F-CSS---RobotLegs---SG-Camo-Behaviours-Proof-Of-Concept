package sg.fcss.adaptors 
{
	import com.flashartofwar.fcss.utils.PropertyMapUtil;
	import sg.camo.interfaces.IPropertyMapCache;
	
	/**
	 * Adaptor proxy on behalf of PropertyMapUtil
	 * @author Glenn Ko
	 */
	public class PropertyMapCacheAdaptor implements IPropertyMapCache
	{
		
		public function PropertyMapCacheAdaptor() 
		{
			
		}
		
		public function getPropertyMapCache(className:String):Object {
			PropertyMapUtil.getPropertyMapCache(className);
		}
		
		public function getPropertyMap(target : * ) : Object {
			return PropertyMapUtil.propertyMap(target);
		}
		
	}

}