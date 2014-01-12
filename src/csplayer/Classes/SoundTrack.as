package csplayer.Classes {

import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;

import mx.events.FlexEvent;

public class SoundTrack extends EventDispatcher {

    [Bindable]
    public var urlString:String = "";
    [Bindable]
    public var artist:String = "";
    [Bindable]
    public var title:String = "";
    [Bindable]
    public var labels:ArrayCollection = new ArrayCollection();
    [Bindable]
    public var rating:Number = 0;

    /**def constr*/
    public function SoundTrack() {
        urlString = "";
        artist = "";
        title = "";
        labels = new ArrayCollection();
        rating = 0;
    }

    public function removeTag(tag:Tag):void {
        labels.removeItemAt(labels.getItemIndex(tag));
    }

    public function hasTag(tag:Tag):Boolean {
        for (var i:int = 0; i < labels.length; i++) {
            if (labels[i].nameWithSpecs == tag.nameWithSpecs) {
                return true;
            }
        }
        return false;
    }

    public function addTag(tag:Tag):void {
        if (hasTag(tag) == false) {
            labels.addItem(tag);
        }
        dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
    }

    public function isDisabledForShuffleAll():Boolean {
        for each(var tag:Tag in labels) {
            if (tag.shuffleAllDisabled) return true;
        }
        return false;
    }

    /**convert self to xmlnode*/
    public function convertToXML():XML {
        var xml:XML = <soundTrack>
            <title/>
            <artist/>
            <urlString/>
            <labels/>
            <rating/>
        </soundTrack>;

        xml.title = title;
        xml.artist = artist;
        xml.urlString = urlString;
        xml.rating = rating.toString();

        for each (var i:Tag in labels) {
            var x:XML = XML("<label>" + i.nameWithSpecs + "</label>");
            xml.labels.appendChild(x);
        }

        return xml;

    } //convertToXML end
}
}