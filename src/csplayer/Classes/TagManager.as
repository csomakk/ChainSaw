package csplayer.Classes {
import flash.filesystem.File;

import mx.collections.ArrayCollection;

public class TagManager {
    [Bindable]
    public var tags:ArrayCollection = new ArrayCollection;

    private static var _instance:TagManager;

    public function TagManager() {
        load();
    }

    public static function get instance():TagManager {
        if (_instance == null) _instance = new TagManager();
        return _instance;
    }

    public function tagsAsArrayColl():ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for each (var t:Tag in tags) {
            ac.addItem(t);
        }
        return ac
    }

    public function addTag(tag:Tag):void {
        tags.addItem(tag);
    }

    public function addIfNotHas(tag:String):void {
        if (has(tag) == false) tags.addItem(new Tag(tag))
    }

    public function has(tag:String):Boolean {
        for each (var t:Tag in tags) {
            if (tag.search(t.nameWithoutSpecs()) != -1) {
                return true;
            }
        }
        return false;
    }

    public function get(tag:String):Tag {
        for each (var t:Tag in tags) {
            if (tag.search(t.nameWithoutSpecs()) != -1) {
                return t;
            }
        }
        return null;
    }

    public static function convertToXML(tag:Tag):XML {
        var xml:XML = <tag>
            <color1/>
            <color2/>
            <textColor/>
            <nameWithSpecs/>
            <shuffleAllDisabled/>
        </tag>;

        xml.color1 = tag.color1;
        xml.color2 = tag.color2;
        xml.textColor = tag.textColor;
        xml.nameWithSpecs = tag.nameWithSpecs;
        xml.shuffleAllDisabled = tag.shuffleAllDisabled;

        return xml;

    } //convertToXML end

    public function save():void {
        var file:File = File.applicationStorageDirectory;
        file = file.resolvePath("tagmanager.xml");
        var xml:XML = new XML("<tagmanager/>");
        for (var i:String in tags) {
            xml.appendChild(convertToXML(tags[i]));
        }
        CsUtils.saveAsXML(xml, file.url);
    }

    public function load():void {
        var file:File = File.applicationStorageDirectory;
        file = file.resolvePath("tagmanager.xml");
        if (file.exists) {
            var xml:XML = CsUtils.loadXML(file.url);
            if (xml != null) {
                for each (var node:XML in xml.tag) {
                    var tag:Tag = new Tag();
                    tag.color1 = node.color1;
                    tag.color2 = node.color2;
                    tag.nameWithSpecs = node.nameWithSpecs;
                    tag.textColor = node.textColor;
                    if (node.shuffleAllDisabled == "true") tag.shuffleAllDisabled = true;
                    tags.addItem(tag)
                }//for each node
            }//if !=null
        }//if file exists
    }

}//class
}//package