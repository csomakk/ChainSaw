package csplayer.Classes {
import flash.display.Loader;
import flash.display.Stage;

public class SafeLoader extends Loader {
    public function SafeLoader() {
        super();
    }

    override public function get stage():Stage {
        trace("SafeLoader: giving back false stage")
        return null;
    }
}
}