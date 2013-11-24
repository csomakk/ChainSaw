package csplayer.Classes
{
	import flash.events.Event;

	public class CsPlayerEvents extends Event
	{
		
		public static const TRISTATE_CHECKBOX_CHANGE:String = "csplayer.tristate.change	";
		
		public var params:Object;
		
		public function CsPlayerEvents($type:String, $params:Object, $bubbles:Boolean = false, $cancelable:Boolean = false)	{
			super($type, $bubbles, $cancelable);
			this.params = $params;	
		}
	}
}