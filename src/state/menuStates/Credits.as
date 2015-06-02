package state.menuStates
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	import state.menuStates.MainMenuState;
	
	public class Credits extends MenuState
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till bakgrunden.
		 */
		private var _background:Bitmap;
		
		/**
		 * Lager som hanterar bakgrunden.
		 */
		private var _layerBackground:DisplayStateLayer;
		
		/**
		 * Lager som hanterar menyobjekten.
		 */
		private var _layerOptions:DisplayStateLayer;
		
		/**
		 * Kontroller för navigering
		 */
		private var _controls:EvertronControls = new EvertronControls(2);
		
		/**
		 * Referens till det aktuella indexvärdet.
		 * Används för att avgöra vilket menyval som är markerat.
		 */
		private var _index:int = 0;
		
		/**
		 * Format för textfälten.
		 */
		private var form:TextFormat;
		
		/**
		 * Textfält för menyval rematch.
		 */
		private var play:TextField;
		
		/**
		 * Textfält för menyval return to main manu.
		 */
		private var menu:TextField;
		
		/**
		 * Referens till markören.
		 */
		private var pointer:Bitmap;
		
		/**
		 * Kontroller för om menyvalen är initierade.
		 */
		private var options:Boolean = false;
		
		/**
		 * Det aktuella spelläget.
		 */
		private var _gameMode:String;
		
		
		//----------------------------------------------------------------------
		// Sounds
		//----------------------------------------------------------------------
		
		/**
		 * Bakgrundsbild.
		 */
		[Embed(source="../../../asset/png/Credits.png")]
		private static const BACKGROUND:Class;
		
		/**
		 * Font för textfälten.
		 */
		[Embed(source="../../../asset/fonts/emulogic.ttf", fontName = "emulogic", mimeType = "application/x-font", embedAsCFF="false")]
		private var visitor:Class;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function Credits()
		{
			super();
		}
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		override public function init():void {
			super.init();
			initLayers();
			initBackground();
		}
		
		/**
		 * Skapar de lager som klassen använder.
		 */
		private function initLayers():void {		
			_layerBackground = layers.add("backgroundLayer");
			_layerOptions = layers.add("optionsLayer");
		}
		
		/**
		 * Lägger ut bakgrundsbilden på spelplanen.
		 */
		private function initBackground():void {
			_background = new BACKGROUND();
			_background.scaleX = 1;
			_background.scaleY = 1;
			
			_layerBackground.addChild(_background);
		}
		
		/**
		 * Överskriver update metoden.
		 * 
		 * Aktiverar input för menynavigering.
		 */
		override public function update():void {
			super.update();
			Session.timer.create(1000, initOptions);
			if(options) {
				if(Input.keyboard.anyPressed()) {
					setMenu();
				}
			}
		}
		
		/**
		 * Kontroller för att tvinga spelaren till att
		 * se bilden.
		 */
		private function initOptions():void {
			options = true;
		}
		
		/**
		 * Startar MenuState-klassen.
		 */
		private function setMenu():void {
			Session.application.displayState = new MainMenuState();
		}
	}
}

