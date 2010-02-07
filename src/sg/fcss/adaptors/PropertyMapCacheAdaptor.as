package sg.fcss.adaptors 
{
	import com.flashartofwar.fcss.utils.PropertyMapUtil;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import sg.camo.interfaces.IPropertyMapCache;
	
	/**
	 * Adaptor proxy on behalf of PropertyMapUtil
	 * @author Glenn Ko
	 */
	public class PropertyMapCacheAdaptor implements IPropertyMapCache
	{
		// temporary until PropertyMapUtil allows public access to retrieve
		// from className cache directly .
		private var myCachedPropertyMaps:Dictionary = new Dictionary();
		
		public function PropertyMapCacheAdaptor() 
		{
			
		}
		
		public function getPropertyMapCache(className:String):Object {
			return myCachedPropertyMaps[className];
		}
		
		public function getPropertyMap(target : * ) : Object {
			// temporary until PropertyMapUtil allows public access to retrieve
			// from className cache directly.
			var propMap:Object = PropertyMapUtil.propertyMap(target );
			myCachedPropertyMaps[ getQualifiedClassName(target) ] = propMap;
			return propMap;
		}
		
	}

}