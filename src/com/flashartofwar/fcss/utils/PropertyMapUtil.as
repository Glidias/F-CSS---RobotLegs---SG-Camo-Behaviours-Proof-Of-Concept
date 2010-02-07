
/**
 * <p>Original Author:  jessefreeman</p>
 * <p>Class File: PropertyMapUtil.as</p>
 *
 * <p>Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:</p>
 *
 * <p>The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.</p>
 *
 * <p>THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.</p>
 *
 * <p>Licensed under The MIT License</p>
 * <p>Redistributions of files must retain the above copyright notice.</p>
 *
 * <p>Revisions<br/>
 *		1.0  Initial version Jan 28, 2009</p>
 *
 */

package com.flashartofwar.fcss.utils
{

import com.flashartofwar.fcss.objects.PropertyMapObject;
import flash.utils.getQualifiedClassName;

import flash.utils.Dictionary;
import flash.utils.describeType;

public class PropertyMapUtil
{
    protected static var cachedPropertyMaps:Dictionary = new Dictionary(true);

	/**
	 * Gets property map from the cache if available
	 * @param	className
	 * @return	The PropertyMapObject or null if not found
	 */
	public static function getPropertyMapCache(className:String):PropertyMapObject {
		return cachedPropertyMaps[className] ? cachedPropertyMaps[className].clone() : null;
	}
		
		
    /**
     *
     * @param target
     * @return
     *
     */
    public static function propertyMap(target:Object):PropertyMapObject
    {

        var propMap:PropertyMapObject = new PropertyMapObject();

		// Ges qualified class name first
		var className:String = getQualifiedClassName(target);
	
        if (!cachedPropertyMaps[className])
        {
			var classXML:XML = describeType(target);  // Only call describe type if necessary
					
            var list:XMLList = classXML..*.((name() == "accessor") || (name() == "variable"));;

            var item:XML;
            for each (item in list)
            {
                var itemName:String = item.name().toString();

                switch (itemName)
                {
                    case "variable":
                        propMap[item.@name.toString()] = item.@type.toString();
                        break;
                    case "accessor":
                        var access:String = item.@access;
                        if ((access == "readwrite") || (access == "writeonly"))
                        {
                            propMap[item.@name.toString()] = item.@type.toString();
                        }
                        break;
                }
                cachedPropertyMaps[className] = propMap;
            }
        }

        else
        {
            propMap = cachedPropertyMaps[className];
        }

        return propMap.clone();  // as PropertyMapObject   casting needed?
    }


}
}