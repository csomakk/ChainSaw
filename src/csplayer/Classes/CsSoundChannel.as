package csplayer.Classes {
import csplayer.Classes.youTube.YoutubePlayer;
import csplayer.Components.Control;
import csplayer.Containers.MainContainer;

import flash.events.*;
import flash.media.*;
import flash.net.*;
import flash.sampler.startSampling;
import flash.utils.*;

[Bindable]
public class CsSoundChannel {

    private var control:Control;
    public var csSound:Sound = new Sound(); //ultimate Sound
    public var myChannel:SoundChannel = new SoundChannel();//ultimate channel
    private var mySoundTransform:SoundTransform = new SoundTransform();
    private var mySoundMixer:SoundMixer = new SoundMixer();
    private var seekTimer:Timer = new Timer(30, 0);
    private var playWhenYTReady:String;

    //def. konstr.
    public function CsSoundChannel(ctrl:Control) {
        control = ctrl;
        csSound = new Sound();
        myChannel = new SoundChannel();
    }

    public function seekUpdate(e:Event):void {
        var length:Number = csSound.length;
        var position:Number = myChannel.position;
        control.seekSlider.value = position / length;
        control.seekText.text = timeToString(position) + " / " + timeToString(length);
    }

    public function seekRadio():void {
        control.seekSlider.value = 0;
        control.seekText.text = "??/infinity";
    }

    public static function timeToString(tousandSecs:Number):String {
        var minutes:Number = 0;
        tousandSecs /= 1000;
        tousandSecs = Math.round(tousandSecs);
        while (tousandSecs > 59) {
            minutes++;
            tousandSecs -= 60;
        }
        return minutes + ":" + tousandSecs;
    }

    public function setSoundMixer(mixer:SoundMixer):void {
        mySoundMixer = mixer;
    }

    public function setSoundTransform(transform:SoundTransform):void {
        mySoundTransform = transform;
        myChannel.soundTransform = transform;
    }

    private var _volume:Number = 1;

    [Bindable(event="volumeChange")]
    public function get volume():Number {
        return _volume
    }

    public function set volume(vol:Number):void {
        _volume = vol;
        dispatchEvent(new Event("volumeChange"));
        var st:SoundTransform = new SoundTransform(vol, 0);
        setSoundTransform(st);
    }

    public function onYTReady():void {
        if (playWhenYTReady) {
            MainContainer.instance.ytPlayer.loadVideo(playWhenYTReady);
        }
    }

    public static function isYouTube(url:String):Boolean {
        return url.search(YoutubePlayer.YT_PREFIX) == 0;
    }

    //play from url. sometimes resume from pause. thats pos, and rate.
    public function playSound(url:String, position:Number = 0.0, rate:Number = 1.0):void {
        var nextReq:URLRequest = new URLRequest(url);

        function complete(event:Event):void {
            myChannel = csSound.play(position);
            myChannel.addEventListener(Event.SOUND_COMPLETE, callNextSong);
            myChannel.soundTransform = mySoundTransform;
            seekTimer.addEventListener(TimerEvent.TIMER, seekUpdate);
            seekTimer.start();
        }

        function callNextSong(e:Event):void {
            control.onSoundComplete();
        }

        if (isYouTube(url)) {
            trace("CsSoundChannel: playing yt, id: ", url.substr(YoutubePlayer.YT_PREFIX.length));
            if (MainContainer.instance.ytPlayer.isReady) {
                MainContainer.instance.ytPlayer.loadVideo(url.substr(YoutubePlayer.YT_PREFIX.length));
            } else {
                playWhenYTReady = url.substr(YoutubePlayer.YT_PREFIX.length);
            }
        } else if (url.search("http") == 0) {
            //online radio
            csSound = new Sound(nextReq);
            csSound.addEventListener(Event.COMPLETE, complete);//if loaded.
            myChannel = csSound.play();
            myChannel.soundTransform = mySoundTransform;
            seekRadio();
        } else {
            csSound = new Sound();
            csSound.addEventListener(Event.COMPLETE, complete);//if loaded.
            csSound.load(nextReq);
        }
    }
}//class csSoundChannel
}//pack