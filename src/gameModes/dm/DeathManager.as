package gameModes.dm
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import character.Player;
	import character.PlayerManager;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	public class DeathManager
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till PlayerManager.
		 */
		private var _playerManager:PlayerManager;
		
		/**
		 * Referens till den aktuella spelaren
		 */
		private var _numPlayer:int;
		
		/**
		 * Referens till den aktuella spelaren.
		 */
		private var _player:Player;
		
		/**
		 * Index för den aktuella spelaren.
		 */
		private var _index:int;
		
		//----------------------------------------------------------------------
		// Protected properties
		//----------------------------------------------------------------------
		
		/**
		 * Lager för spelarobjekt.
		 */
		protected var _target:DisplayStateLayer;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @param playerManager 				Referens till playerManager-klassen.
		 * @param target 						Lager för spelarobjekt
		 */
		public function DeathManager(playerManager:PlayerManager, target:DisplayStateLayer)
		{
			_target = target;
			_playerManager = playerManager
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Kontrollerar om spelaren dör.
		 */
		public function initDeathCheck(numPlayer:int):void {
			_numPlayer = numPlayer;
			_player = _playerManager.players[numPlayer];
			
			for(var i:int = 0; i < _playerManager.players.length; i++) {
				if(_playerManager.players[numPlayer] != _playerManager.players[i]) {
					var targetPlayer:Player = _playerManager.players[i];
					if(targetPlayer.playerDead) {
						targetPlayer.playerDead = false;
						_playerManager.returnPlayer(0);
						_playerManager.returnPlayer(1);
						_playerManager.roundCounter(1);
					}
				}
			}
		}
	}
}

