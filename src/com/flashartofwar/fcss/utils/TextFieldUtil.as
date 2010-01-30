
/**
 * <p>Original Author:  jessefreeman</p>
 * <p>Class File: TextFieldUtil.as</p>
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
 *		1.0  Initial version Dec 03, 2009</p>
 *
 */

package com.flashartofwar.fcss.utils {
	import com.flashartofwar.fcss.enum.TextFieldProperties;
	import com.flashartofwar.fcss.enum.TextFormatProperties;

	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class TextFieldUtil
	{

		private static const STYLE_SHEET:String = "styleSheet";

		/**
		 * This utility helps apply Styles to TextFields. Pass in a TextField
		 * and a Style and the utility will handle everything for you. The method
		 * will parse out props for TextField, TextFormat, and native StyleSheet.
		 */
		public static function applyStyle(textField:TextField, styleObject:Object):void
		{

			var textFormat:TextFormat = new TextFormat();
			var camelCasePropName:String;
			var prop:String;
			var value:String;

			for (prop in styleObject)
			{

				camelCasePropName = camelize(prop, "-");
				value = styleObject[prop];
				//trace("Value", value);
				if (TextFieldProperties.isSupported(camelCasePropName))
				{
					textField[camelCasePropName] = TextFieldProperties.cleanupProp(camelCasePropName, value);
				}
				else if (TextFormatProperties.isSupported(camelCasePropName))
				{
					textFormat[TextFormatProperties.convertProp(camelCasePropName)] = TextFormatProperties.cleanupProp(camelCasePropName, value);
				}
				else if (camelCasePropName == STYLE_SHEET)
				{
					if (value)
					{
						var tempStyleSheet:StyleSheet = new StyleSheet();
						tempStyleSheet.parseCSS(TextFieldProperties.cleanupProp(camelCasePropName, value));
					}
					else
					{
						// There was no CSS to parse
					}
				}
				else
				{
					// prop is not supported;
				}
			}

			textField.defaultTextFormat = textFormat;

			if (tempStyleSheet)
			{
				textField.styleSheet = tempStyleSheet;
			}

		}

		/**
		 * <p>Returns given lowercaseandunderscoreword as a camelCased word.</p>
		 *
		 * @param string lowercaseandunderscoreword Word to camelize
		 * @return string Camelized word. likeThis.
		 */
		private static function camelize(lowercaseandunderscoreword:String, deimiter:String = "-"):String
		{
			var tarray:Array = lowercaseandunderscoreword.split(deimiter);

			for (var i:int = 1; i < tarray.length; i++)
			{
				tarray[i] = ucfirst(tarray[i] as String);
			}
			var replace:String = tarray.join("");
			return replace;
		}

		/**
		 * <p>Make first character of word upper case</p>
		 * @param	word
		 * @return string
		 */
		private static function ucfirst(word:String):String
		{
			return word.substr(0, 1).toUpperCase() + word.substr(1);
		}
	}
}

