/** 
 * <p>Original Author:  jessefreeman</p>
 * <p>Class File: CamoStyleSheet.as</p>
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
 * 	2.0  Initial version Jan 7, 2009</p>
 *	
 */

package camo.core.property
{
	/**
	 * @author jessefreeman
	 */
	public class PropertySheet implements IPropertySheet
	{
		public static const CSS_BLOCKS : RegExp = /[^{]*\{([^}]*)*}/g;
		public static const FIND_A_HREF_CLASS : RegExp = /a\.([^\:]+)/gi;
		public static const COMPRESS_CSS : RegExp = /\s*([@{}:;,]|\)\s|\s\()\s*|\/\*([^*\\\\]|\*(?!\/))+\*\/|[\n\r\t]|(px)/g;
		private var cssText : String;
		private var selectorIndex : Array = []; // holds a lookup table for all parsed CSS classes
		private var relatedSelectorIndex : Array = []; // holds arrays for related classes base on Class's Name ID 
		private var cachedProperties : Array = [];
		private var _selectorNames : Array = [];
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function get selectorNames() : Array
		{
			return _selectorNames;
		}
		/**
		 * <p>Class constructor. Can accept raw css cssText in string format.</p>
		 */
		public function PropertySheet()
		{
			super( );
		}
		/**
		 * 
		 * @return 
		 * 
		 */		
		protected function createEmptyProperties() : PropertySelector
		{
			return new PropertySelector( );
		}
		
		
		/**
		 *  IPropertySheet public interface factory method
		 * @return
		 */
		public function createNewPropertySelector():IPropertySelector {
			return new PropertySelector();
		}
		/**
		 * 
		 * @param CSSText
		 * 
		 */		
		public function parseCSS(CSSText : String, compressText : Boolean = true) : void
		{
			cssText = compressText ? compress( CSSText ) : CSSText;
			indexCSS( cssText );
		}
		/**
		 * 
		 * @param CSSText
		 * @return 
		 * 
		 */		
		protected function compress(CSSText : String) : String
		{
			return CSSText.replace( COMPRESS_CSS, "$1" );
		}
		/**
		 * <p>Does a preliminary run through of the css selectors and indexes them.
		 * This is only done once and to helps speed up the retrieval of the raw
		 * css selector cssText. Its important to note that this index is only for 
		 * the selector and its string content. Any CSS props inside of the 
		 * selector are not parsed here. This is simply used as a lookup table 
		 * for the raw cssText.</p>
		 * 
		 * @param css
		 * 
		 */		 
		protected function indexCSS(css : String) : void
		{
			// Use RegEx to get all css blocks - anything inside of { }  along with the selector (name)
			var blocks : Array = css.match( CSS_BLOCKS );
			// get reference of the total blocks found to speed up for i loop
			var total : Number = blocks.length;
			
			// Loop through all selectors, get the selector name and its cssText, then store it in the index
			for (var i : int = 0; i < total ; i ++)
			{
				var tempSplit : Array = splitClass( blocks[i] );
				selectorIndex[tempSplit[0]] = tempSplit[1];
				_selectorNames.push( tempSplit[0] );
			}
		}
		/**
		 * <p>This splits up a CSS Selector from its cssText. By doing the split on 
		 * the "{" we can assume anything in index 0 of the array is the selector's 
		 * name, and the rest is the css props. Also we cut off the last character
		 * (in this case the trailing "}") to make sure we get a clean reference 
		 * to the css properties inside.</p>
		 * 
		 * @param cssClass
		 * @return 
		 * 
		 */		 
		protected function splitClass(cssClass : String) : Array
		{
			var split:Array = cssClass.split("{");
			split[0] = relatedClasses(split[0]); // Clean up and index css class name
			split[1] = String(split[1]).substr(0,split[1].length - 1);
			return split;
		}
		
		/**
		 * <p>This goes through a selector's name and looks for any related 
		 * classes separated by a space. With this we can keep an index of related 
		 * classes based on the class's id as a key. This lets us quickly 
		 * reference any related class names on the fly without having to reloop 
		 * through the css cssText.</p>
		 *  
		 * @param classes
		 * @param index
		 * @return 
		 * 
		 */		 
		protected function relatedClasses(classes:String):String
		{
			// Split out names of classes
			var related:Array = classes.split(" ");
			var classID:String = related.pop();
			
			var indexOfColon:Number = classID.indexOf(":");
			
			if (indexOfColon != -1)
			{
				var pseudoBasePropertiesID:String = classID.substring(0,indexOfColon);
				related.push(pseudoBasePropertiesID);
			}
			
			// Save out array of left over classes
			relatedSelectorIndex[classID] = related;
			// Return what was found
			return classID;
		}
		
		/**
		 * Quick method to retrieve selector by name if available.
		 * @param	selectorName	The name of the selector
		 * @return	A IPropertySelector instance or null if not found
		 */
		public function findSelector(selectorName:String):IPropertySelector {
			return selectorLookup(selectorName);
		}
		
		/**
		 * <p>This looks up a selector and returns an object. To help support selector 
		 * inheritance you can also pass in an comma delimited string and have 
		 * the list merged into one selector based on the order of the list. The 
		 * first item being lower all the way up to the last in the list.</p>
		 * 
		 * @param selectorName
		 * @return 
		 * 
		 */		 
		public function getSelector( ... selectorNames ):Object
		{
			// Split styles and get the total related classes
			var total:Number = selectorNames.length;
			var baseProperties:PropertySelector = createEmptyProperties();
			// Loop through styles and merges them into a single selector.
			for (var i : Number = 0; i < total; i++)
			{
				if(hasSelector(selectorNames[i]))
				{
					
					var currentPropertiesID:String = selectorNames[i]; 
					var tempProperties:PropertySelector = selectorLookup(currentPropertiesID);
					
					baseProperties.merge(tempProperties);
				}
			}
	
			// Returns megred selector
			return baseProperties;
		}
		
		/**
		 * <p>Core lookup function and is responsible for parsing out css 
		 * selectors, finding related classes, and putting them all together 
		 * into a clean Properties.</p>
		 * 
		 * <p>The first step is to look for a cached version of the class already 
		 * requested. If that does not exist it looks up the class id from the 
		 * cssIndex. Once the cssText is found it can start looping through related 
		 * classes to build a base css object for the desired class to inherit 
		 * then override. Once this is done, it is cached in the cachedProperties 
		 * dictionary and the created object is returned.</p>
		 * 
		 * @param selectorName
		 * @return 
		 * 
		 */		 
		protected function selectorLookup(selectorName:String):PropertySelector
		{
			
			var tempProperties:PropertySelector = (cachedProperties[selectorName]) ? cachedProperties[selectorName] : null;
			
			if(!tempProperties)
			{
				tempProperties = createEmptyProperties();
				if(hasSelector(selectorName))
				{
					// Begin CSS lookup
					var styleData:String = selectorIndex[selectorName];
					var subjectProperties:PropertySelector = convertStringListToProperties(styleData);
					
					var ancestors:Array = relatedSelectorIndex[selectorName];
					var totalAncestors:Number = ancestors.length;
					var ancestorProperties:PropertySelector;
					
					for(var i:int = 0; i < totalAncestors; i++)
					{
						ancestorProperties = selectorLookup(ancestors[i]);
						tempProperties.merge(ancestorProperties);
					}
					
					tempProperties.merge(subjectProperties);
					tempProperties.selectorName = selectorName;
					
					newSelector(selectorName, tempProperties);
				}
			}			
			
			return tempProperties.clone() as PropertySelector;
		}
		
		/**
		 * 
		 * @param selectorName
		 *   //@param propertySelector	
		 * 	 // Removed strict typing for more versatility, since selectors are dynamic objects anyway.
		 * @param selectorObject  A generic selector object proxy in untyped format.
		 * 
		 */		
		public function newSelector(selectorName : String, selectorObject : Object) : void
		{
			if(!hasSelector(selectorName))
			{
				selectorObject.selectorName = selectorName;
				cachedProperties[selectorName] = selectorObject;
				
				_selectorNames.push( selectorName );   
			}
		}
		
		/**
		 * <p>Creates a selector sheet string from suppplied selector names. You can combine
		 * Propertiess into a larger selector sheet by separating selectors by a comma.
		 * If no selectorName is provided the entire set of styles will be included
		 * in the new styleSheet.</p>
		 * 
		 * <p>Its important to note that this is incredibly expensive to perform
		 * on large CamoStyeSheets. To avoid this, make sure you pass in only
		 * the styles you need.</p>
		 * 
		 * @param selectorName comma separated list of selectors that will be used
		 * to create a selector sheet string.
		 * @return String selector sheet from passed in selectors
		 * 
		 */		
		public function clone( ... selectorNames ):PropertySheet
		{
			var tempStyleSheet:PropertySheet = new PropertySheet();
			var total:Number = selectorNames.length;
			
			if(total == 0)
			{
				tempStyleSheet.parseCSS(cssText.toString());
			}
			else
			{
				var tempCSSText:String = "";
				
				// Loop through styles and merges them into a single selector.
				for (var i : Number = 0; i < total; i++)
				{
					if((hasSelector(selectorNames[i]) && (selectorNames[i] is String)))
					{
						tempCSSText += getSelector(selectorNames[i]).toString();
					}
				}
				// Strip classes from a styles
				tempCSSText = tempCSSText.replace(FIND_A_HREF_CLASS,"a");
				
				tempStyleSheet.parseCSS(tempCSSText);
			}
			
			return tempStyleSheet;
			
		}
		
		/**
		 * <p>Check to see if selector exists.</p>
		 */
		// Returns direct Boolean value. Set method to public interface as well.
		public function hasSelector(id:String):Boolean
		{
			return selectorNames.indexOf(id) != -1;  //(selectorNames.indexOf(id) == -1) ? false : true;
		}
		
		/**
		 * <p>This function converts a String list to an object. Used to help 
		 * split up complex, string lists form css cssText.</p>
		 * 
		 * @param cssText
		 * @param propDelim
		 * @param listDelim
		 */
		internal function convertStringListToProperties(cssText : String, propDelim : String = ":", listDelim : String = ";") : PropertySelector
		{
			var tempObject : PropertySelector = createEmptyProperties();
			var list : Array = cssText.split(listDelim);
			var total : Number = list.length;
			// Loop through properties
			for (var i : Number = 0;i < total; i++)
			{
				var delimLocation:Number = list[i].indexOf(propDelim);
				var prop:String = cleanUpProp(list[i].slice(0,delimLocation));
				
				if(prop != ""){
					var value:String = cleanUpValue(prop, list[i].slice(delimLocation+1));
					tempObject[prop] = value;
				}
			}
			
			return tempObject;
		}
		
		/**
		 * 
		 * @param prop
		 * @return 
		 * 
		 */		
		protected function cleanUpProp(prop:String):String
		{
			return prop;
		}
		
		/**
		 * 
		 * @param prop
		 * @param value
		 * @return 
		 * 
		 */		
		protected function cleanUpValue(prop:String, value:String):String
		{
			return value;	
		}
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		public function toString():String
		{
			return cssText;
		}
		
		/**
		 * 
		 * 
		 */		
		public function clear():void
		{
			cssText = "";
			_selectorNames = new Array();
		}
	}
}
