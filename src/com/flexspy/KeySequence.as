/**
 * FlexSpy 1.1
 * 
 * <p>Code released under WTFPL [http://sam.zoy.org/wtfpl/]</p>
 * @author Arnaud Pichery [http://coderpeon.ovh.org]
 */
package com.flexspy {
	import flash.events.KeyboardEvent;
	
	/**
	 * Represents a sequence of keys (ex: Ctrl-Alt-F1, Alt-D, etc.)
	 */
	public class KeySequence {
		private var _keyCode: uint;
		private var _ctrlPressed: Boolean;
		private var _shiftPressed: Boolean;
		private var _altPressed: Boolean;
		
		/**
		 * Creates a new key sequence associated with the supplied key code and key modifier (Ctrl, Alt and Shift)
		 * <p>A list of available key code can be found 
		 * <a href="http://msdn2.microsoft.com/en-us/library/ms927178.aspx">here</a>
		 * </p>
		 */
		public function KeySequence(keyCode: uint, ctrlPressed: Boolean = true, altPressed: Boolean = true, shiftPressed: Boolean = false) {
			_keyCode = keyCode;
			_ctrlPressed = ctrlPressed;
			_altPressed = altPressed;
			_shiftPressed = shiftPressed;			
		}
		
		/**
		 * Gets a value indicating whether this key sequence has been pressed in the supplied
		 * keyboard event
		 */
		public function isPressed(event: KeyboardEvent): Boolean {
			if (event == null)
				return false;
							
			if (event.keyCode != _keyCode)
				return false;

			if ((_ctrlPressed && !event.ctrlKey) || (_altPressed && !event.altKey) || (_shiftPressed && !event.shiftKey))
				return false;
	
			return true;			
		}
	}
}