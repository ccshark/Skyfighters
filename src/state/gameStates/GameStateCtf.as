package state.gameStates
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import utils.UtilManager;
	import gameModes.PointsManager;
	import gameModes.ctf.FlagManager;
	import gameModes.maps.MapCTF;
	
	/**
	 * Game state för Deathmatch.
	 */
	public class GameStateCtf extends GameState
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till MapCTF klassen.
		 */
		private var _map:MapCTF;
		
		/**
		 * Antalet spelare.
		 */
		private var _numPlayers:int;
		
		/**
		 * Referens till FlagManager-klassen.
		 */
		private var _flagManager:FlagManager;
		
		/**
		 * Referens till PointsManager-klassen.
		 */
		private var _points:PointsManager;
		
		/**
		 * Referens till ElementManager-klassen.
		 */
		private var _elementManager:UtilManager;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * Tar emot antalet spelare från MenuState och
		 * skickar parametern till superklassen.
		 */
		public function GameStateCtf(numPlayers:int)
		{
			super(numPlayers);
			_numPlayers = numPlayers;
		}
		
		/**
		 * Aktiverar initMap genom överskrift av init
		 * funktionen.
		 */
		override public function init():void {
			super.init();
			initMap();
			initPoints();
			initFlags();
			initElements();
			initGameMode();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instance av den aktuella kartan.
		 */
		private function initMap():void {
			mapManager.initMap(new MapCTF());
		}
		
		/**
		 * Lägger ut poäng räknaren på spelplanen.
		 */
		private function initPoints():void {
			_points = new PointsManager(_players, _layerGame);
			for (var i:int = 0; i < _numPlayers; i++) {
				_points.addPoints(i);
			}
		}
		
		/**
		 * Skapar en ny instans av flaggorna i basen.
		 */
		private function initFlags():void {
			_flagManager = new FlagManager(_players, _layerGame, _points);
			for (var i:int = 0; i < _numPlayers; i++) {
				_flagManager.addBase(i);
				_flagManager.addFlag(i);
			}
		}
		
		/**
		 * Skapar en ny instance av den aktuella kartan.
		 */
		private function initElements():void {
			_elementManager = new UtilManager(_players, _layerGame, mapManager.elements, bulletManager, mapManager.ammunition);
			_elementManager.addElement();
			_elementManager.addAmmunition();
		}
		
		/**
		 * Sätter gameMode i PlayerManager till det
		 * aktuella gameModet. Används i avslutningsskärmen.
		 */
		private function initGameMode():void {
			_players.gameMode = "CTF";
		}
		
		/**
		 * Startar kollisionshantering för den aktuella.
		 */
		override public function update():void {
			super.update();
			for(var i:int = 0; i < _numPlayers; i++) {
				mapManager.initCollision(i);
				_flagManager.initCollision(i);
				_elementManager.initCollision(i);
			}
		}
		
		/**
		 * Överskriver dispose metoden.
		 */
		override public function dispose():void {
			mapManager.dispose();
			_players.dispose();
			bulletManager.dispose();
		}
	}
}