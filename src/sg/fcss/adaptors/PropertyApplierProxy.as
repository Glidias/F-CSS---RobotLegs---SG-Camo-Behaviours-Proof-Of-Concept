package sg.fcss.adaptors 
{

	import sg.camo.interfaces.IPropertyApplier;
	import com.flashartofwar.fcss.applicators.IApplicator;
	
	/**
	 * IPropertyApplier proxy to share interface signatures between SG-Camo and F*CSS,
	 * implementing both IApplicator and IPropertyApplier signatures to allow cross-platform
	 * usage between the two frameworks.
	 * 
	 * @author Glenn Ko
	 */
	
	public class PropertyApplierProxy implements IPropertyApplier, IApplicator
	{
		private var _propApplier:IPropertyApplier;
		
		public function ApplicatorProxy(propApplier:IPropertyApplier) 
		{
			_propApplier = propApplier;
		}
		
		public function applyStyle(target:Object, style:Object):void {
			_propApplier.applyProperties(target, style);
		}
		
		public function applyProperties(target:Object, properties:Object):void {
			_propApplier.applyProperties(target, properties);
		}
		
		
		
		
	}

}