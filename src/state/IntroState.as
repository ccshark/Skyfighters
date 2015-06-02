package state
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Bitmap;
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	import state.menuStates.MainMenuState;
	
	public class IntroState extends DisplayState
	{
		
		/**
		 * Referens till bakgrundsbilden.
		 */
		private var _background:Bitmap;
		
		/**
		 * Lager som grafiken kan placeras på.
		 */
		private var _layerBackground:DisplayStateLayer;
		
		/**
		 * Kontroller för evertron.
		 */
		private var _controls:EvertronControls = new EvertronControls(2);
		
		/**
		 * Bakgrundsbild.
		 */
		[Embed(source="../../asset/png/studio_SRK_logo.png")]
		public static const BACKGROUND:Class;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function IntroState()
		{
			super();
			initLayers();
			initBackground();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar lagret för bakgrunden.
		 */
		private function initLayers():void {		
			_layerBackground = layers.add("backgroundLayer");
		}
		
		/**
		 * Skapar bilden som placeras på bakgrundslagret.
		 */
		private function initBackground():void {
			_background = new BACKGROUND();
			_background.scaleX = 1;
			_background.scaleY = 1;
			
			_layerBackground.addChild(_background);
		}
		
		/**
		 * Överskriver update metoden.
		 * Aktiverar en timer för visningen av bilden.
		 */
		override public function update():void {	
			super.update();
			Session.timer.add(new Timer(2000, startMenu));
		}
		
		/**
		 * Startar menyn.
		 */
		private function startMenu():void {
			Session.application.displayState = new MainMenuState();
		}
	}
}