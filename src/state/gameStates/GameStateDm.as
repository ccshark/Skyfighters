package state.gameStates
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import utils.UtilManager;
	import gameModes.PointsManager;
	import gameModes.dm.DeathManager;
	import gameModes.maps.MapDM;

	
	/**
	 * Game state för Deathmatch.
	 */
	public class GameStateDm extends GameState
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till MapDM klassen.
		 */
		private var _map:MapDM;
		
		/**
		 * Nummer för den aktuella spelaren.
		 */
		private var _numPlayers:int;
		
		/**
		 * Referens till DeathManager-klassen.
		 */
		private var _deathManager:DeathManager;
		
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
		public function GameStateDm(numPlayers:int)
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
			initDeathManager();
			initElements();
			initGameMode();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Startar initieringen av kartan och skickar med
		 * klassen för den aktuella kartan.
		 */
		private function initMap():void {
			mapManager.initMap(new MapDM());
		}
		
		/**
		 * Initierar PointsManager-klassen.
		 */
		private function initPoints():void {
			_points = new PointsManager(_players, _layerGame);
			for (var i:int = 0; i < _numPlayers; i++) {
				_points.addPoints(i);
			}
		}
		
		/**
		 * Initierar DeathManager-klassen.
		 */
		private function initDeathManager():void {
			_deathManager = new DeathManager(_players, _layerGame);
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
			_players.gameMode = "DM";
		}
		
		/**
		 * Startar kollisionshantering för den aktuella Spelaren.
		 */
		override public function update():void {
			super.update();
			
			for(var i:int = 0; i < _numPlayers; i++) {
				mapManager.initCollision(i);
				_deathManager.initDeathCheck(i);
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