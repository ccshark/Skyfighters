package state.gameStates
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Bitmap;
	import character.BulletManager;
	import character.PlayerManager;
	import gameModes.MapManager;
	import se.lnu.stickossdk.display.DisplayState;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	
	
	public class GameState extends DisplayState
	{
		
		//----------------------------------------------------------------------
		// public methods
		//----------------------------------------------------------------------
		
		
		/**
		 * Lager för spelobjekt.
		 */
		public var _layerGame:DisplayStateLayer;
		
		
		/**
		 * Lager för kartan.
		 */
		public var _layerMap:DisplayStateLayer;
		
		/**
		 * Lager för Counter.
		 */
		public var _layerCounter:DisplayStateLayer;
		
		
		/**
		 * Referens till PlayerManager-klassen.
		 */
		public var _players:PlayerManager;
		
		/**
		 * Referens till BulletManager-klassen.
		 */
		public var bulletManager:BulletManager;
		
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		
		/**
		 * Referens till bakgrunden.
		 */
		private var _background:Bitmap;
		
		
		/**
		 * Antalet spelare som är aktiva.
		 */
		private var _numPlayers:int;
		
		
		/**
		 * Lager för bakgrunden.
		 */
		private var _layerBackground:DisplayStateLayer;
		
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Referens till MapManager-klassen.
		 */
		protected var mapManager:MapManager;
		
		
		//----------------------------------------------------------------------
		// Public constans
		//----------------------------------------------------------------------
		
		
		/**
		 * Sätter en backgrundsbild för background.
		 */
		[Embed(source="../../../asset/png/Default_Background.png")]
		public static const BACKGROUND:Class;
		
		[Embed(source="../../../asset/sound/music/Skyfighters Samurais Theme T1.mp3")]
		private static const MUSICBATTLE_NINJA:Class;
		
		[Embed(source="../../../asset/sound/music/Skyfighters_Main_Theme_Battle_Version_T1.mp3")]
		private static const MUSICBATTLE_SRC:Class;
		
		[Embed(source="../../../asset/sound/music/Skyfighters Samurais Theme T1.mp3")]
		private static const MUSICBATTLE_VIKING:Class;
		
		
		//----------------------------------------------------------------------
		// Konstructor
		//----------------------------------------------------------------------
		
		
		/**
		 * 
		 * @param numPlayers 			Antalet spelare som är aktiva.
		 */
		public function GameState(numPlayers:int) {
			super();
			_numPlayers = numPlayers;
		}
		
		
		/**
		 * Skriver över den tidigare init metoden.
		 */
		override public function init():void {
			super.init();
			initLayers();
			initBackground();
			initMusic();
			initPlayer();
			initBullet();
			initMaps();
			initHud();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar alla lager som kommer användas under
		 * spel sessionen
		 */
		private function initLayers():void {		
			_layerBackground = layers.add("backgroundLayer");
			_layerMap = layers.add("mapLayer");
			_layerGame = layers.add("gameLayer");
			_layerCounter = layers.add("counter");
		}
		
		/**
		 * Skapar en ny instans av backgrunden
		 * och lägger ut den på scenen.
		 */
		private function initBackground():void {
			_background = new BACKGROUND();
			_background.scaleX = 1;
			_background.scaleY = 1;
			
			_layerBackground.addChild(_background);
		}
		
		/**
		 * Initierar musiken för banan.
		 * 
		 * TODO: byta musik till en annan låt när första låten är slut.
		 */
		public function initMusic():void {
			var rand:int = Math.random() * 3;
			
			switch(rand) {
				case 0:
					Session.sound.musicChannel.sources.add("musicBattle", MUSICBATTLE_SRC);
					var musicBattle:SoundObject = Session.sound.musicChannel.get("musicBattle"); 
					musicBattle.play(10);
					musicBattle.volume = 0.8;
					break;
				case 1:
					Session.sound.musicChannel.sources.add("musicBattleNinja", MUSICBATTLE_NINJA);
					var musicBattleNinja:SoundObject = Session.sound.musicChannel.get("musicBattleNinja"); 
					musicBattleNinja.play(10);
					musicBattleNinja.volume = 0.8;
					break;
				case 2:
					Session.sound.musicChannel.sources.add("musicBattleViking", MUSICBATTLE_VIKING);
					var musicBattleViking:SoundObject = Session.sound.musicChannel.get("musicBattleViking"); 
					musicBattleViking.play(10);
					musicBattleViking.volume = 0.8;
					break;
			}
		}
		
		/**
		 * Skapar en ny instans av spelar sessionen
		 * och lägger ut spelaren på scenen.
		 */
		private function initPlayer():void {
			_players = new PlayerManager(_layerGame);
			for (var i:int = 0; i < _numPlayers; i++) {
				_players.add(i);
			}
			_players.updateRound();
		}
		
		/**
		 * Skapar en hud för varje spelare.
		 */
		private function initHud():void {
			for (var i:int = 0; i < _numPlayers; i++) {
				_players.addHud(i);
			}
		}
		
		/**
		 * Skapar en ny instans av BulletManager
		 * Skickar med spellager samt spelar-refferenser.
		 */
		private function initBullet():void {
			bulletManager = new BulletManager(_layerGame, _players);
			for (var i:int = 0; i < _numPlayers; i++) {
				bulletManager.addBullets(i);
			}
		}
		
		/**
		 * Skapar en ny instans av MapManager.
		 * Skickar med lagren för karta samt spelobjekt.
		 */
		private function initMaps():void {
			mapManager = new MapManager(_layerMap, _players);
		}
		
		/**
		 * Överskriver updatefunktionen
		 * Aktiverar 
		 */
		override public function update():void {
			super.update();
			for(var i:int = 0; i < _numPlayers; i++) {
				_players.initCollision(i);
				bulletManager.initCollision(i);
				_players.outOfMap(i);
			}
		}
		
		/**
		 * Överskriver disposemetoden.
		 */
		override public function dispose():void {
			super.dispose();
			bulletManager.dispose();
		}
	}
}