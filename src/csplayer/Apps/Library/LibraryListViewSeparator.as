package csplayer.Apps.Library
{
	import csplayer.Classes.SoundTrack;

	public class LibraryListViewSeparator
	{
		
		public var display:String="---";
		public var songs:Vector.<SoundTrack> = new Vector.<SoundTrack>();
		public var collapsed:Boolean = false;
		
		public function LibraryListViewSeparator(pDisplay:String) {
			display=pDisplay;
		}
		
		
	}
}