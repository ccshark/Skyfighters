package state.killScreens
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Bitmap;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import state.menuStates.GameSelectState;
	import state.splash.SplashCTF;
	import state.splash.SplashDM;
	import state.splash.SplashMB;
	
	public class WinViking extends DisplayState
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
		private var _controls:EvertronControls = new EvertronControls();
		
		/**
		 * Referens till det aktuella indexvärdet.
		 * Används för att avgöra vilket menyval som är markerat.
		 */
		private var _index:int = 0;
		
		/**
		 * Format för textfälten.
		 */
		private var _form:TextFormat;
		
		/**
		 * Textfält för menyval rematch.
		 */
		private var _play:TextField;
		
		/**
		 * Textfält för menyval return to main manu.
		 */
		private var _menu:TextField;
		
		/**
		 * Referens till markören.
		 */
		private var _pointer:Bitmap;
		
		/**
		 * Kontroller för om menyvalen är initierade.
		 */
		private var _options:Boolean = false;
		
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
		[Embed(source="../../../asset/png/winScreen/Viking_Win_Screen_GFX.png")]
		private static const BACKGROUND:Class;
		
		/**
		 * Markör för menyval
		 */
		[Embed(source="../../../asset/png/Win_Screen_Marker_GFX.png")]
		private static const POINTER:Class;
		
		/**
		 * Ljud för navigation i meny
		 */
		[Embed(source="../../../asset/sound/SFX_Menu_Navigation.mp3")]
		private static const MOVE_SRC:Class;
		
		/**
		 * Font för textfälten.
		 */
		[Embed(source="../../../asset/fonts/emulogic.ttf", fontName = "emulogic", mimeType = "application/x-font", embedAsCFF="false")]
		private var visitor:Class;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function WinViking(gameMode:String)
		{
			super();
			_gameMode = gameMode;
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		override public function init():void {
			super.init();
			initLayers();
			initBackground();
			initForm();
			initPlay();
			initMenu();
			
			initPointer();
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
		 * Deklarerar formatet som textfälten använder.
		 */
		private function initForm():void {
			_form = new TextFormat();
			_form.color = 0x000000;
			_form.size = 16;
			_form.font = "emulogic";
		}
		
		/**
		 * Skapar ett nytt textfält för att starta
		 * om spelomgången.
		 */
		private function initPlay():void {
			_play = new TextField();
			_play.embedFonts = true;
			_play.defaultTextFormat = _form;
			_play.text = "Rematch";
			_play.width = 200;
			_play.x = 350;
			_play.y = 470;
		}
		
		/**
		 * Skapar ett nytt textfält för att gå
		 * tillbaka till menyn.
		 */
		private function initMenu():void {
			_menu = new TextField();
			_menu.embedFonts = true;
			_menu.defaultTextFormat = _form;
			_menu.text = "Return to main menu";
			_menu.width = 450;
			_menu.x = 250;
			_menu.y = 531;
		}
		
		/**
		 * Placerar markören.
		 */
		private function initPointer():void {
			_pointer = new POINTER();
			_pointer.scaleX = 1;
			_pointer.scaleY = 1;
			_pointer.x = 300;
			_pointer.y = 475;
		}
		
		/**
		 * Överskriver update metoden.
		 * 
		 * Aktiverar input för menynavigering.
		 */
		override public function update():void {
			super.update();
			Session.timer.create(1000, initOptions);
			if(_options) {
				if(Input.keyboard.justPressed(_controls.PLAYER_UP)) {
					if(_index == 1) {
						_index = 0;
						getSelected();
						moveSound();
					}
				}
				if(Input.keyboard.justPressed(_controls.PLAYER_DOWN)) {
					if(_index == 0) {
						_index = 1;
						getSelected();
						moveSound();
					}
				}
				if(Input.keyboard.justPressed(_controls.PLAYER_BUTTON_1)) {
					if(_index == 0) {
						if(_gameMode == "CTF") {
							Session.application.displayState = new SplashCTF();
						}
						if(_gameMode == "DM") {
							Session.application.displayState = new SplashDM();
						}
						if(_gameMode == "MB") {
							Session.application.displayState = new SplashMB();
						}
					}
					if(_index == 1) {
						setMenu();
						//Session.timer.create(400, setMenu);
						//Session.effects.add(new Flicker(menu, 400));
					}
				}
			}
		}
		
		/**
		 * Lägger ut menyallternativen på spelplanen.
		 */
		private function initOptions():void {
			_layerOptions.addChild(_pointer);
			_layerOptions.addChild(_play);
			_layerOptions.addChild(_menu);
			_options = true;
			Session.timer.dispose();
		}
		
		/**
		 * Ljud för att växla mellan menyvalen.
		 */
		private function moveSound():void {
			Session.sound.soundChannel.sources.add("move", MOVE_SRC);
			var navSound:SoundObject = Session.sound.soundChannel.get("move"); 
			navSound.play();
			navSound.volume = 0.5;
		}
		
		/**
		 * Flyttar markören beroende värdet i index.
		 */
		private function getSelected():void {
			trace(_index);
			if(_index == 0) {
				_pointer.x = 300;
				_pointer.y = 475;
			}
			if(_index == 1) {
				_pointer.x = 200;
				_pointer.y = 535;
			}
		}
		
		/**
		 * Startar MenuState-klassen.
		 */
		private function setMenu():void {
			Session.application.displayState = new GameSelectState();
		}
	}
}

