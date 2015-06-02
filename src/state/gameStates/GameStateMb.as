package state.gameStates
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import utils.UtilManager;
	import gameModes.PointsManager;
	import gameModes.maps.MapMB;
	import gameModes.mb.BallManager;
	
	
	/**
	 * Game state för Deathmatch.
	 */
	public class GameStateMb extends GameState
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till MapDM klassen.
		 */
		private var _map:MapMB;
		
		/**
		 * Referens till BallManager-klassen.
		 */
		private var _ballManager:BallManager;
		
		/**
		 * Referens till PointsManager-klassen.
		 */
		private var _points:PointsManager;
		
		/**
		 * Nummer för den aktuella spelaren.
		 */
		private var _numPlayers:int;
		
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
		public function GameStateMb(numPlayers:int)
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
			initBall();
			initTimer();
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
			mapManager.initMap(new MapMB());
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
		 * Skapar en ny instans av BallManager-klassen.
		 */
		private function initBall():void {
			_ballManager = new BallManager(_players, _layerGame, _points, _layerCounter);
			_ballManager.addBall();
		}
		
		/**
		 * Skapar nedräkning för när spelaren tar bollen.
		 */
		private function initTimer():void {
			_ballManager.addCountdown();
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
			_players.gameMode = "MB";
		}
		
		/**
		 * Startar kollisionshantering för den aktuella.
		 */
		override public function update():void {
			super.update();
			for(var i:int = 0; i < _numPlayers; i++) {
				mapManager.initCollision(i);
				_ballManager.initCollision(i);
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