package csplayer.Classes
{
	import csplayer.Components.Control;
	import csplayer.Containers.MainContainer;
	
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.utils.*;
	
	import mx.controls.*;
	import mx.core.*;
	
	[Bindable]
	public class CsSoundChannel
	{
		
		private var control:Control
		public var csSound:Sound=new Sound() //ultimate Sound
		public var myChannel:SoundChannel=new SoundChannel()//ultimate channel
		private var mySoundTransform:SoundTransform=new SoundTransform()
		private var mySoundMixer:SoundMixer=new SoundMixer()
		private var seekTimer:Timer=new Timer(30,0)
		private var playWhenYTReady:String;
		
		//def. konstr.
		public function CsSoundChannel(ctrl:Control) {
			control=ctrl
			csSound=new Sound()
			myChannel=new SoundChannel()
		}	
		
		public function seekUpdate(e:Event):void {
			var lenght:Number=csSound.length
			var position:Number=myChannel.position
			control.seekSlider.maximum=lenght
			control.seekSlider.value=position
			control.seekText.text=timeToString(position)+" / "+timeToString(lenght)
		}
		
		public function seekRadio():void {
			var lenght:Number=0;
			var position:Number=0;
			control.seekSlider.maximum=0;
			control.seekSlider.value=0;
			control.seekText.text="??/infinity"
		}
		
		public function timeToString(tousandSecs:Number):String {
			var minutes:Number=0
			tousandSecs/=1000
			tousandSecs=Math.round(tousandSecs)
			while(tousandSecs>59){
				minutes++
					tousandSecs-=60
			}
			return minutes+":"+tousandSecs;
		}
		
		public function setSoundMixer(mixer:SoundMixer):void {
			mySoundMixer=mixer
		}
		
		public function setSoundTransform(transform:SoundTransform):void {
			mySoundTransform=transform
			myChannel.soundTransform=transform
		}
		
		public function setVolume(vol:Number):void {
			var st:SoundTransform = new SoundTransform(vol,0);
			setSoundTransform(st)
		}
		
		public function onYTReady():void {
			if(playWhenYTReady) {
				MainContainer.instance.ytPlayer.loadVideo(playWhenYTReady);
			}
		}
		
		//play from url. sometimes resume from pause. thats pos, and rate.
		public function playSound(url:String, position:Number=0.0, rate:Number=1.0):void {
			var nextReq:URLRequest = new URLRequest(url);
			function complete( event: Event ): void{
				myChannel=csSound.play(position);
				myChannel.addEventListener(Event.SOUND_COMPLETE,callNextSong)
				myChannel.soundTransform=mySoundTransform;
				seekTimer.addEventListener(TimerEvent.TIMER,seekUpdate)
				seekTimer.start()
				
			}	
			
			function callNextSong(e:Event):void {
				control.onSoundComplete();
			}
			
			csSound = new Sound();
			csSound.addEventListener( Event.COMPLETE, complete );//if loaded.
			if( url.search("http") == -1 ){
				//ha nincs az urlben http, local
				if( url.search( "yt://" ) == 0 ) {
					trace("CsSoundChannel: playing yt, id: ", url.substr(5));
					if(MainContainer.instance.ytPlayer.isReady) {
						MainContainer.instance.ytPlayer.loadVideo(url.substr(5));
					} else {
						playWhenYTReady=url.substr(5);
					}
				} else {
					csSound.load(nextReq);
				}
				
			} else {
				//ha van, rádió
				csSound = new Sound (nextReq);
				myChannel = csSound.play()
				myChannel.soundTransform=mySoundTransform;
				seekRadio()
			}
		}	
	}//class csSoundChannel
}//pack