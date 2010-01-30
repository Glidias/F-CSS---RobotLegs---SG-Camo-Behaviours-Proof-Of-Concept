package sg.gaialegs.ui.base
{
	import flash.display.Sprite;
	import sg.camo.interfaces.IReflectClass;
	/**
	 * Base class to indicate loading of external image src.
	 * 
	 * Uses IReflectClass to reflect a base class signature for the F*CSS sheet
	 * to externally inject behaviours into display component.
	 * 
	 * @author Glenn Ko
	 */
	public class Img extends Sprite implements IReflectClass
	{
		
		public function Img() 
		{
			super();
		}
		
		public function get reflectClass():Class {
			return Img;
		}
		
	}

}