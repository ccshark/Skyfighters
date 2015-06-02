package state.menuStates
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Bitmap;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	import se.lnu.stickossdk.system.Session;
	
	
	public class MainMenuState extends MenuState
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till bakgrundsbilden.
		 */
		private var _background:Bitmap;
		
		/**
		 * Lager för bakgrundsgrafik.
		 */
		private var _layerBackground:DisplayStateLayer;
		
		/**
		 * Lager för menyval.
		 */
		private var _layerOptions:DisplayStateLayer;
		
		/**
		 * Referens till credits grafiken, när den inte är markerad.
		 */
		private var _cred:Bitmap;
		
		/**
		 * Referens till play grafiken, när den inte är markerad.
		 */
		private var _play:Bitmap;
		
		/**
		 * Referens till credits grafiken, när den är markerad.
		 */
		private var _creds:Bitmap;
		
		/**
		 * Referens till play grafiken, när den är markerad.
		 */
		private var _plays:Bitmap;
		
		/**
		 * Lagrar alla menyvalen.
		 */
		private var _selector:Array = new Array();
		
		/**
		 * Lagrar de markerade menyvalen.
		 */
		private var _selected:Array = new Array();
		
		/**
		 * Index för markörens possition.
		 */
		private var _index:int = 0;
		
		/**
		 * Index för det tidigare menyvalet.
		 */
		private var _preIndex:int = _index;
		
		/**
		 * Kontroller för om ett val är gjort
		 */
		private var _marker:Boolean = false;
		
		/**
		 * Kontroller för evertron.
		 */
		private var _controls:EvertronControls = new EvertronControls();
		
		/**
		 * Bakgrundsbild.
		 */
		[Embed(source="../../../asset/png/Main_Menu_BG.png")]
		public static const BACKGROUND:Class;
		
		/**
		 * Menyval play, ej vald.
		 */
		[Embed(source="../../../asset/png/Main_Menu_Play.png")]
		public static const PLAY:Class;
		
		/**
		 * Menyval credits, ej vald.
		 */
		[Embed(source="../../../asset/png/Main_Menu_Credits.png")]
		public static const CREDITS:Class;
		
		/**
		 * Menyval play, vald.
		 */
		[Embed(source="../../../asset/png/Main_Menu_Play_White.png")]
		public static const PLAYs:Class;
		
		/**
		 * Menyval credits, vald.
		 */
		[Embed(source="../../../asset/png/Main_Menu_Credits_White.png")]
		public static const CREDITSs:Class;
	
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function MainMenuState()
		{
			super();
			
		}
		
		/**
		 * Skriver över den tidigare init metoden.
		 */
		override public function init():void {
			super.init();
			initLayers();
			initBackground();
			initPlay();
			initCredits();
			preSelect();
		}
		
		/**
		 * Skapar lager som grafiken kan placeras på.
		 */
		private function initLayers():void {		
			_layerBackground = layers.add("backgroundLayer");
			_layerOptions = layers.add("options");
		}
		
		/**
		 * Skapar bakgrundsbilden och placerar den på lagret.
		 */
		private function initBackground():void {
			_background = new BACKGROUND();
			_background.scaleX = 1;
			_background.scaleY = 1;
			
			_layerBackground.addChild(_background);
		}
		
		/**
		 * Initierar grafiken för menyval play
		 */
		private function initPlay():void {
			_play = new PLAY();
			_play.scaleX = 1;
			_play.scaleY = 1;
			_play.x = 233;
			_play.y = 233;
			_layerOptions.addChild(_play);
			
			_plays = new PLAYs();
			_plays.scaleX = 1;0
			_plays.scaleY = 1;
			_plays.x = 233;
			_plays.y = 233;
			_selector.push(_plays);
		}
		
		/**
		 * Initierar grafiken för menyval credits
		 */
		private function initCredits():void {
			_cred = new CREDITS();
			_cred.scaleX = 1;
			_cred.scaleY = 1;
			_cred.x = 268;
			_cred.y = 296;
			_layerOptions.addChild(_cred);
			
			_creds = new CREDITSs();
			_creds.scaleX = 1;
			_creds.scaleY = 1;
			_creds.x = 268;
			_creds.y = 296;
			_selector.push(_creds);
		}
		
		/**
		 * Placerar markören på det aktuella indexet.
		 */
		private function preSelect():void {
			var active:Bitmap = _selector[_index];
			
			_layerOptions.addChild(active);
			_selected.push(active);
		}
		
		/**
		 * Ändrar markörens possition.
		 */
		private function getSelected():void {
			var active:Bitmap = _selector[_index];
			
			_layerOptions.addChild(active);
			_selected.push(active);
			
			if(_selected.length > 1) {
				var current:Bitmap = _selected[0];
				_layerOptions.removeChild(current);
				_selected.splice(0, 1);
			}
		}
		
		/**
		 * Överskriver update metoden.
		 * 
		 * Hanterar kontrollerna för menyvalet.
		 */
		override public function update():void {
			super.update();
			if(Input.keyboard.justPressed(_controls.PLAYER_UP)) {
				if(_index > 0) {
					moveSound();
					_preIndex = _index;
					_index--;
					getSelected();
				}
			}
			if(Input.keyboard.justPressed(_controls.PLAYER_DOWN)) {
				if(_index < 1) {
					moveSound();
					_preIndex = _index;
					_index++;
					getSelected();
				}
			}
			if(Input.keyboard.justPressed(_controls.PLAYER_BUTTON_1)) {
				if(_index == 0) {
					Session.application.displayState = new GameSelectState();
				}
				if(_index == 1) {
					Session.application.displayState = new Credits();
				}
			}
		}
	}
}
