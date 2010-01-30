/*****************************************************************************************************
* Gaia Framework for Adobe Flash ©2007-2009
* Author: Steven Sacks
*
* blog: http://www.stevensacks.net/
* forum: http://www.gaiaflashframework.com/forum/
* wiki: http://www.gaiaflashframework.com/wiki/
* 
* By using the Gaia Framework, you agree to keep the above contact information in the source code.
* 
* Gaia Framework for Adobe Flash is released under the GPL License:
* http://www.opensource.org/licenses/gpl-2.0.php 
*****************************************************************************************************/

package com.gaiaframework.assets
{
	import flash.events.Event;

	public class SEOAsset extends XMLAsset
	{	
		private var _copy:Object;
		private var _cachedSEO:XML;
		
		function SEOAsset()
		{
			super();
		}
		public function get copy():Object
		{
			return _copy;
		}
		override protected function onComplete(event:Event):void
		{
			super.onComplete(event);
			
			var prevIgnore:Boolean = XML.ignoreWhitespace;
			var prevPrinting:Boolean = XML.prettyPrinting;
			
			parseCopy();
			
			// added revert back to previous settings
			XML.ignoreWhitespace = prevIgnore;
			XML.prettyPrinting = prevPrinting;
		}
		
	
		private function parseCopy():void
		{

			_copy = { }; 
			
			XML.ignoreWhitespace = false;
			XML.prettyPrinting = false;
			
	
			default xml namespace = new Namespace("http://www.w3.org/1999/xhtml");
			var html:XML = XML(_data);
			
			// Run check if got no copy in list
			var chkList:XMLList = html..div.(hasOwnProperty("@id") && @id == "copy");
			if (chkList.length() < 1) {
				// No inner HTML found. Dispatch warning.
				return;
			}
			
			var copyTags:XMLList = chkList[0]..p;
			var copyTag:XML;
			
			_copy.innerHTML = XMLList(chkList.toXMLString().replace(/\s+xmlns(:[^=]+)?=\"[^=]*?\"/g, ""))[0];
	
			for each (copyTag in copyTags)
			{
				var str:String = "";
				var innerTagList:XMLList = copyTag.children();   // save out list of inner tags
				var len:int = innerTagList.length();
				for (var i:int = 0; i < len; i++)
				{ 
					str += innerTagList[i].toXMLString();  // don't call children() again in loop
				}
				_copy[copyTag.@id] = str.replace(/\s+xmlns(:[^=]+)?=\"[^=]*?\"/g, "");
			}

		}
		

		
	
		override public function toString():String
		{
			return "[SEOAsset] " + _id;
		}
	}
}