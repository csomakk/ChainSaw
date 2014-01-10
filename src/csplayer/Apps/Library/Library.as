package csplayer.Apps.Library {
import csplayer.Classes.CsUtils;
import csplayer.Classes.SoundTrack;
import csplayer.Classes.SoundTrack;
import csplayer.Classes.Tag;
import csplayer.Classes.TagManager;
import csplayer.Components.Control;
import csplayer.Components.Playlist.PlayList;
import csplayer.Components.TagList;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.filesystem.File;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CloseEvent;
import mx.events.CollectionEvent;

public class Library {


    [Bindable]
    public var soundTracks:ArrayCollection = new ArrayCollection();
    private var changed:Boolean = false;
    [Bindable]
    public static var instance:Library;
    //TODO following 3 and functions for
    private var soundTrack:SoundTrack;
    private var id3Sound:Sound = new Sound();
    private var files:Vector.<File> = new Vector.<File>();

    public function Library() {
        instance = this;
        soundTracks.addEventListener(CollectionEvent.COLLECTION_CHANGE, soundTracks_ChangeHandler)
    }

    protected function soundTracks_ChangeHandler(event:Event = null):void {
        changed = true;
    }

    public function getAllWithTag(tag:Tag):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for each (var s:SoundTrack in soundTracks) {
            if (s.hasTag(tag)) ac.addItem(s);
        }
        return ac;
    }

    /** load library from xml*/
    public function loadLibrary():void {
        //trace("Library:loadLibrary")
        var file:File = File.applicationStorageDirectory;
        file = file.resolvePath("library.xml");
        if (file.exists) {
            var xml:XML = CsUtils.loadXML(file.url);
            if (xml != null) {
                for each (var node:XML in xml.soundTrack) {
                    var st:SoundTrack = new SoundTrack();
                    st.title = node.title;
                    st.rating = node.rating;
                    st.artist = node.artist;
                    st.urlString = node.urlString;
                    for each (var tag:XML in node.labels.label) {
                        if (TagManager.instance.get(tag)) {
                            st.labels.push(TagManager.instance.get(tag))
                        } else {
                            var t:Tag = new Tag(tag);
                            TagManager.instance.addIfNotHas(tag);
                            st.labels.push(t);
                        }
                    }//for each label
                    soundTracks.addItem(st);
                    PlayList.instance.whenHasSameURLReplaceIt(st);
                }//for each node
            }//if !=null
        }//if file exists

        TagList.instance.refresh()

    }//loadLibrary()


    /** saveLibrary: saves all songs. */
    public function saveLibrary():void {
        if (changed) {
            //trace("Library:saveLibrary")
            var file:File = File.applicationStorageDirectory;
            file = file.resolvePath("library.xml");
            var xml:XML = new XML("<library/>");
            for (var i:String in soundTracks) {
                xml.appendChild((soundTracks[i] as SoundTrack).convertToXML());
            }
            CsUtils.saveAsXML(xml, file.url);

            changed = false
        }
    }

    /** clearLibrary: returns an empty the library. */
    public function clearLibrary():void {
        //trace("Library:clearLibrary")
        Alert.buttonWidth = 100;
        Alert.yesLabel = "Yes";
        Alert.noLabel = "No";
        Alert.cancelLabel = "WTF?";
        Alert.show("Do you really want to COMPLETELY ERASE your LIBRARY?", "Erasing Library", 1 | 2 | 8, null, alertClickHandlerForLibClear);
        function alertClickHandlerForLibClear(event:CloseEvent):void {
            if (event.detail == Alert.YES) {
                soundTracks = new ArrayCollection();
            }
        }
    }

    public function addFolder(folder:File):void {
        var timer:Timer = new Timer(100, 0);

        //trace("Library:addFolder")
        var folders:Vector.<File> = new Vector.<File>();
        Control.instance.statusLabel.text = "Started listing files";
        function checkFolder(folder:File):void {
            if (folder.isDirectory) {
                var myArray:Array = folder.getDirectoryListing();
                for (var i:String in myArray) {
                    if (myArray[i].isDirectory) folders.push(myArray[i]);
                    else files.push(myArray[i]);
                }
            }
        }

        folders.push(folder);

        while (folders.length > 0) {
            checkFolder(folders.pop())
        }

        Control.instance.statusLabel.text = "Found " + files.length + "files";

        var done:Boolean = false;	//done with id3
        getNext();

        timer.start();
        timer.addEventListener(TimerEvent.TIMER, tick);

        var ticks:int = 0;

        function tick(e:Event = null):void {
            if (files.length >= 0) {
                if (done) {
                    soundTracks.addItem(soundTrack);
                    done = false;
                    getNext();
                } else if (ticks > 50) {
                    finishCurrent();//puts in library, according to var done:bool.
                    getNext();//gets next file to process
                } else {
                    ticks++;
                }
                if (files.length % 20 == 1) CsUtils.collectGarbage();
                Control.instance.statusLabel.text = "Remaining files: " + files.length

            } else {
                timer.stop(); //if there is no more files, escape
                timer.removeEventListener(TimerEvent.TIMER, tick);
                Control.instance.statusLabel.text = "";
                saveLibrary();
            }


        }

        function finishCurrent():void {
            trace("Library:addfolder.finishCurrent");
            soundTrack.title = "unknown";  //if no id3, call it unknown
            soundTrack.artist = "unknown";
            soundTracks.addItem(soundTrack);
            id3Sound.removeEventListener(Event.ID3, id3Ready);
            done = false;
        }

        function getNext():void {
            trace("Library:addfolder.getNext");
            if (files.length > 0) var file:File = files.pop(); //if we can pop, pop
            while (file && file.type.search("mp3") == -1 && files.length > 1) {
                file = files.pop(); //if its not mp3, try to find one
            }

            if (file && file.type.search("mp3") != -1) { //if mp3, request id3

                soundTrack = new SoundTrack();
                soundTrack.urlString = file.url;
                id3Sound = new Sound(new URLRequest(file.url));
                id3Sound.addEventListener(Event.ID3, id3Ready)
            } // if not mp3, and files is empty, the clock event will handle it.
            ticks = 0;
            if (files.length == 0){
                timer.stop();
                saveLibrary();
            }
        }

        function id3Ready(e:Event = null):void {
            trace("Library:addfolder.id3ready");
            id3Sound.removeEventListener(Event.ID3, id3Ready);
            soundTrack.artist = e.currentTarget.id3.artist;
            soundTrack.title = e.currentTarget.id3.songName;
            if (e.currentTarget.id3.songName == null) {
                soundTrack.title = "unknown";
            }
            done = true;
        }
    }
}
}