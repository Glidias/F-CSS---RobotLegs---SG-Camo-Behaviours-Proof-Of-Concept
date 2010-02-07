package sg.fcss.utils 
{
	import com.flashartofwar.fcss.applicators.IApplicator;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	/**
	 * Defines the standard conventions for mediating textfields that are already
	 * on the stage through this shared static utility.
	 * <br/>
	 * In the future, might consider not using static classes. But for now, it's convention
	 * over configuration, and would continue to be so in the future if the convention works well.
	 * 
	 * @author Glenn Ko
	 */
	public class TextStyleMediatorUtil
	{
		public static const MEDIATOR_STYLE:String = "mediatorStyle";
		public static const MEDIATOR_STYLE_OPENTAG:String = "<mediatorStyle>";
		public static const MEDIATOR_STYLE_CLOSETAG:String = "</mediatorStyle>";
		/**
		 * Mediates an on-stage textfield to apply a certain set of text stylings over an on-stage
		 * textfield.
		 * @param	propApplier
		 * @param	props
		 * @param	txtField
		 * @param	defaultStylesheet
		 * @return	(Boolean) Whether the mediation was successful
		 */
		public static function applyTextStyleWith(propApplier:IApplicator, props:Object, txtField:TextField, defaultStylesheet:StyleSheet=null):Boolean {
				if (txtField.embedFonts) return false; // Don't bother mediating text field styles if textfield already embed
			
				if (props.isHtmlText=="true") {   // property flag to indicate using of html text and native Flash stylesheet
				
					//  Derive new native StyleSheet from current unique set of props in IStyle
					var stylesheet:StyleSheet = new StyleSheet();
				
					var newObj:Object = { }
					
					for (var i:String in props) {
						newObj[camelize(i)] =props[i];
					}
				    // ...and provide a mediatorStyle tag selector.
					stylesheet.setStyle(MEDIATOR_STYLE, newObj );
					
			
					if (defaultStylesheet) {
						var defStyleNames:Array = defaultStylesheet.styleNames;
						// temp clone over all styles from default stylesheet
						for (i in defStyleNames) {
							stylesheet.setStyle(defStyleNames[i], defaultStylesheet.getStyle( defStyleNames[i] ));
						}
					}
					
						// TODO: derive anchor tag stylings through another proper convention under F*CSS, without relying on
					// defalut stylesheet dependency, so that pseudo 'a' selectors can be done under each textfield selector context.
					
						/** Selectors to look out for:
							a!IReflectBaseClassName (if any)
							a#nameOfTextField (if any)
							a.ClassModuleName (if any)
						 */
						// get style "a" from native defaultStylesheet (StyleSheet) (if available), 
						// else create an empty object & iterate through
						// derived properties from F*CSS's IStyleSheet to apply to a new anchor object
						// var aObj:Object = defaultStylesheet ? defaultStylesheet.getStyle("a") || {} : {};
						// derivedAStyle = .....
						// for (var i in derivedAStyle) {
							//aObj[camelize(i)] = derivedAStyle[i];
						//}
						//stylesheet.setStyle("a", aObj );
				
						
					// enclose textfield's text with mediatorStyle
					txtField.styleSheet = stylesheet;
					txtField.htmlText = MEDIATOR_STYLE_OPENTAG + txtField.text + MEDIATOR_STYLE_CLOSETAG;
						
					txtField.embedFonts = true;
					
					return true;
				}
				
				// Apply standard textformat and update textfield
				propApplier.applyStyle(txtField, props);	
				txtField.setTextFormat( txtField.defaultTextFormat );
				return true;
			}
			

		
		
		/**
		 * Borrowed from F*CSS TextFieldUtil
		 * @param	lowercaseandunderscoreword
		 * @param	deimiter
		 * @return
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
		 * Borrowed from F*CSS TextFieldUtil
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