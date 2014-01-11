package csplayer.Classes {
import csplayer.Classes.youTube.YoutubePlayer;

import flash.display.Stage;
import flash.events.SecurityErrorEvent;

import mx.controls.SWFLoader;
import mx.core.FlexGlobals;

public class SafeSWFLoader extends SWFLoader {

    /***
     * needed, because youtube API throws a lot of security errors. we need to move out content from loader
     * */
    public function SafeSWFLoader() {
        super();
        addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }


    public function moveContentToYoutubePlayerStage():void {
        YoutubePlayer.instance.flexSpriteHolder.addChild(content);
    }

    protected static function onSecurityError(event:SecurityErrorEvent):void {
        trace("SafeSWFLoader:onSecurityError")
    }

    override public function get stage():Stage {
        return FlexGlobals.topLevelApplication.stage;
    }

}
}