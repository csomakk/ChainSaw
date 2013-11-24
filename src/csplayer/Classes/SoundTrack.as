package csplayer.Classes {
	import flash.xml.XMLNode;

	/**Defines a SoundTrack.*/
	public class SoundTrack {
		
		[Bindable] public var urlString:String=new String();
		[Bindable] public var artist:String=new String();
		[Bindable] public var title:String=new String();
		[Bindable] public var labels:Vector.<Tag>=new Vector.<Tag>();
		[Bindable] public var rating:Number=0;
			
		/**def constr*/
		public function SoundTrack() {
			urlString=new String();
			artist=new String();
			title=new String();
			labels=new Vector.<Tag>();
			rating=0;
		}
		
		public function removeTag(tag:Tag):void{
			for(var i:int=0; i<labels.length;i++){
				if(labels[i].nameWithSpecs==tag.nameWithSpecs){
					labels.splice(i,1)
				}
			}
		}
		
		public function hasTag(tag:Tag):Boolean{
			for(var i:int=0; i<labels.length;i++){
				if(labels[i].nameWithSpecs==tag.nameWithSpecs){
					return true;
				}
			}
			return false;
		}
		
		public function addTag(tag:Tag):void{
			if(hasTag(tag)==false) labels.push(tag)
		}
		
		
		/**if urlString youtube:// true else false*/
		public function isYoutube():Boolean{
			///TODO!!
			trace("TODO!! SoundTrack: isYoutube()")
			return false
		}
		
		/**if urlString http:// true else false*/
		public function isOnline():Boolean{
			return false
		}
		
		/**convert self to xmlnode*/
		public function convertToXML():XML{
			var xml:XML = <soundTrack>
									<title/>
									<artist/>
									<urlString/>
									<labels/>
									<rating/>
								</soundTrack> ;
			
			xml.title=title
			xml.artist=artist
			xml.urlString=urlString;
			xml.rating=rating.toString();
			
			for each (var i:Tag in labels){
				var x:XML=XML("<label>"	+i.nameWithSpecs+"</label>")
				xml.labels.appendChild(x)
			}
			
			return xml;	
			
		} //convertToXML end
		
	}
}