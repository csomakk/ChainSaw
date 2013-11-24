package csplayer.Classes {
	import mx.utils.ColorUtil;

	public class Tag {
		
		[Bindable]
		public var color1:uint=0xFFFFFF;
		[Bindable]
		public var color2:uint=0xFFFFFF;
		[Bindable]
		public var textColor:uint=0x000000;
		/**helps on label editing. do not need to keep. 
		 * 0:unselected, 1:selected, 2:undecided*/
		public var selected:int=-1;
		[Bindable]
		public var shuffleAllDisabled:Boolean=false;
		
		/** Tag like: tagname or tagname§spec1§spec2...  
		 * specs: album, occasional, pathelement, ... 
		 * online is defined in soundTrack */
		public var nameWithSpecs:String="Label"
		
		/**returns visible part of tag*/
		public function nameWithoutSpecs():String {
			var i:int=nameWithSpecs.search("§")
			if(i==-1) i=int.MAX_VALUE
			return nameWithSpecs.slice(0,i)
		}
		
		/**def constr*/
		public function Tag(val:String="Label") {
			nameWithSpecs=val;
		}
		
	}
}