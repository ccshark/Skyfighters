package state.menuStates
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	
	public class MenuState extends DisplayState
	{
		/**
		 * Ljud för navigation i meny
		 */
		[Embed(source="../../../asset/sound/SFX_Menu_Navigation.mp3")]
		private static const MOVE_SRC:Class;
		
		/**
		 * Musik för menyläget.
		 */
		[Embed(source="../../../asset/sound/music/Skyfighters_Main_Theme.mp3")]
		private static const MUSIC_SRC:Class;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function MenuState()
		{
			super();
		}
		
		/**
		 * Skriver över den tidigare init metoden.
		 */
		override public function init():void {
			super.init();
			initMusic();
		}
		
		/**
		 * Implementerar och aktiverar musiken.
		 */
		public function initMusic():void {
			Session.sound.musicChannel.sources.add("musicTheme", MUSIC_SRC);
			var themeSong:SoundObject = Session.sound.musicChannel.get("musicTheme"); 
				themeSong.play();
				themeSong.continuous = true;
				themeSong.volume = 0.7;
		}
		
		/**
		 * Ljud för att växla mellan menyvalen.
		 */
		public function moveSound():void {
			Session.sound.soundChannel.sources.add("move", MOVE_SRC);
			var navSound:SoundObject = Session.sound.soundChannel.get("move"); 
			navSound.play();
			navSound.volume = 0.9;
		}
	}
}
