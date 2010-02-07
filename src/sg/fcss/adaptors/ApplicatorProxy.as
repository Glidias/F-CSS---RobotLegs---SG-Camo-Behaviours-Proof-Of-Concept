package sg.fcss.adaptors 
{

	import sg.camo.interfaces.IPropertyApplier;
	import com.flashartofwar.fcss.applicators.IApplicator;
	
	/**
	 * Adaptor proxy to share interface signatures between SG-Camo and F*CSS,
	 * implementing both IApplicator and IPropertyApplier signatures to allow cross-platform
	 * usage between the two frameworks.
	 * 
	 * @author Glenn Ko
	 */
	
	public class ApplicatorProxy implements IPropertyApplier, IApplicator
	{
		private var _applicator:IApplicator;
		
		public function ApplicatorProxy(applicator:IApplicator) 
		{
			_applicator = applicator;
		}
		
		public function applyStyle(target:Object, style:Object):void {
			_applicator.applyStyle(target, style);
		}
		
		public function applyProperties(target:Object, properties:Object):void {
			_applicator.applyStyle(target, properties);
		}
		
		
		
		
	}

}