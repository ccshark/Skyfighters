package state.splash
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Bitmap;
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	import state.gameStates.GameStateMb;
	
	public class SplashMB extends DisplayState
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till bakgrundsbilden.
		 */
		private var _background:Bitmap;
		
		/**
		 * Lager för bakgrunden.
		 */
		private var _layerBackground:DisplayStateLayer;
		
		/**
		 * Kontroller för evertron.
		 */
		private var _controls:EvertronControls = new EvertronControls(2);
		
		/**
		 * Bakgrundsbild.
		 */
		[Embed(source="../../../asset/png/splash/MB_HTP_GFX.png")]
		public static const BACKGROUND:Class;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function SplashMB()
		{
			super();
			initLayers();
			initBackground();
			//Session.timer.add(new Timer(1000, startMenu));
		}
		
		/**
		 * Skapar lager som grafiken kan placeras på.
		 */
		private function initLayers():void {		
			_layerBackground = layers.add("backgroundLayer");
		}
		
		/**
		 * Skapar bakgrunden.
		 */
		private function initBackground():void {
			_background = new BACKGROUND();
			_background.scaleX = 1;
			_background.scaleY = 1;
			
			_layerBackground.addChild(_background);
		}
		
		/**
		 * Överskriver update metoden.
		 * Aktiverar evertron kontrollerna.
		 */
		override public function update():void {
			super.update();
			if(Input.keyboard.anyPressed()) {
				startMenu();
			}
		}
		
		/**
		 * Startar den aktuella spelsessionen.
		 */
		private function startMenu():void {
			Session.application.displayState = new GameStateMb(2);
		}
	}
}

