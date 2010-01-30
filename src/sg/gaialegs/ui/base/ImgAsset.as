package sg.gaialegs.ui.base
{
	import flash.display.Sprite;
	import sg.camo.interfaces.IReflectClass;
	/**
	 * Base class to indicate loading of Gaia image asset.
	 * 
	 * Uses IReflectClass to reflect a base class signature for the F*CSS sheet
	 * to externally inject behaviours into display component.
	 * 
	 * @author Glenn Ko
	 */
	public class ImgAsset extends Sprite implements IReflectClass
	{
		
		public function ImgAsset() 
		{
			super();
		}
		
		public function get reflectClass():Class {
			return ImgAsset;
		}
		
	}

}