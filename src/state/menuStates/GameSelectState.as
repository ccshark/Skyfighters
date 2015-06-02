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
	import state.splash.SplashCTF;
	import state.splash.SplashDM;
	import state.splash.SplashMB;
	
	public class GameSelectState extends MenuState
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till bakgrundsbilden.
		 */
		private var _background:Bitmap;
		
		/**
		 * Lager för grafiken till bakgrundsbilden.
		 */
		private var _layerBackground:DisplayStateLayer;
		
		/**
		 * Lager för menyvalen
		 */
		private var _layerOptions:DisplayStateLayer;
		
		/**
		 * Referens till ctf bilden, ej vald.
		 */
		private var _ctf:Bitmap;
		
		/**
		 * Referens till dm bilden, ej vald.
		 */
		private var _dm:Bitmap;
		
		/**
		 * Referens till mb bilden, ej vald.
		 */
		private var _mb:Bitmap;
		
		/**
		 * Referens till ctf bilden, vald.
		 */
		private var _ctfs:Bitmap;
		
		/**
		 * Referens till dm bilden, vald.
		 */
		private var _dms:Bitmap;
		
		/**
		 * Referens till mb bilden, vald.
		 */
		private var _mbs:Bitmap;
		
		/**
		 * Lagrar alla menyval.
		 */
		private var _selector:Array = new Array();
		
		/**
		 * Lagrar det markerade menyvalet.
		 */
		private var _selected:Array = new Array();
		
		/**
		 * Index för markörens possition.
		 */
		private var _index:int = 1;
		
		/**
		 * Index för markörens tidigare possition.
		 */
		private var _preIndex:int = _index;
		
		/**
		 * Kontroller för om ett menyval är gjort.
		 */
		private var _marker:Boolean = false;
		
		/**
		 * Kontroller för evertron.
		 */
		private var _controls:EvertronControls = new EvertronControls();
		
		/**
		 * Bakgrundsbild.
		 */
		[Embed(source="../../../asset/png/Mode_Menu_BG.png")]
		public static const BACKGROUND:Class;
		
		/**
		 * Grafik för menyval mb, ej vald.
		 */
		[Embed(source="../../../asset/png/MB/Mode_Menu_MB.png")]
		public static const MB:Class;
		
		/**
		 * Grafik för menyval dm, ej vald.
		 */
		[Embed(source="../../../asset/png/DM/Mode_Menu_DM.png")]
		public static const DM:Class;
		
		/**
		 * Grafik för menyval ctf, ej vald.
		 */
		[Embed(source="../../../asset/png/CTF/Mode_Menu_CTF.png")]
		public static const CTF:Class;
		
		/**
		 * Grafik för menyval mb, vald.
		 */
		[Embed(source="../../../asset/png/MB/Mode_Menu_MB_Active.png")]
		public static const MBs:Class;
		
		/**
		 * Grafik för menyval dm, vald.
		 */
		[Embed(source="../../../asset/png/DM/Mode_Menu_DM_Active.png")]
		public static const DMs:Class;
		
		/**
		 * Grafik för menyval ctf, vald.
		 */
		[Embed(source="../../../asset/png/CTF/Mode_Menu_CTF_Active.png")]
		public static const CTFs:Class;

		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function GameSelectState()
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
			initDm();
			initMb();
			initCtf();
			preSelect();
		}
		
		/**
		 * Skapar lager för bakgrunden.
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
		 * Initierar grafiken för menyval dm
		 */
		private function initDm():void {
			_dm = new DM();
			_dm.scaleX = 1;
			_dm.scaleY = 1;
			_dm.x = 55;
			_dm.y = 165;
			_layerOptions.addChild(_dm);
			
			_dms = new DMs();
			_dms.scaleX = 1;
			_dms.scaleY = 1;
			_dms.x = 55;
			_dms.y = 165;
			_selector.push(_dms);
		}
		
		/**
		 * Initierar grafiken för menyval mb
		 */
		private function initMb():void {
			_mb = new MB();
			_mb.scaleX = 1;
			_mb.scaleY = 1;
			_mb.x = 301;
			_mb.y = 165;
			_layerOptions.addChild(_mb);
			
			_mbs = new MBs();
			_mbs.scaleX = 1;
			_mbs.scaleY = 1;
			_mbs.x = 301;
			_mbs.y = 165;
			_selector.push(_mbs);
		}
		
		/**
		 * Initierar grafiken för menyval ctf
		 */
		private function initCtf():void {
			_ctf = new CTF();
			_ctf.scaleX = 1;
			_ctf.scaleY = 1;
			_ctf.x = 549;
			_ctf.y = 165;
			_layerOptions.addChild(_ctf);
			
			_ctfs = new CTFs();
			_ctfs.scaleX = 1;
			_ctfs.scaleY = 1;
			_ctfs.x = 549;
			_ctfs.y = 165;
			_selector.push(_ctfs);
		}
		
		/**
		 * Placerar markören på ett menyval.
		 */
		private function preSelect():void {
			var active:Bitmap = _selector[_index];

			_layerOptions.addChild(active);
			_selected.push(active);
		}
		
		/**
		 * Ändrar markörens possition beroende på värdet
		 * i Index.
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
		 * Aktiverar kontrollerna för navigering i menyn.
		 */
		override public function update():void {
			super.update();
			if(Input.keyboard.justPressed(_controls.PLAYER_LEFT)) {
				if(_index > 0) {
					moveSound();
					_preIndex = _index;
					_index--;
					getSelected();
				}
			}
			if(Input.keyboard.justPressed(_controls.PLAYER_RIGHT)) {
				if(_index < 2) {
					moveSound();
					_preIndex = _index;
					_index++;
					getSelected();
				}
			}
			if(Input.keyboard.justPressed(_controls.PLAYER_BUTTON_1)) {
				if(_index == 0) {
					Session.application.displayState = new SplashDM();
				}
				if(_index == 1) {
					Session.application.displayState = new SplashMB();
				}
				if(_index == 2) {
					Session.application.displayState = new SplashCTF();
				}
				
			}
		}
	}
}