package gameModes.mb
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Sprite;
	import character.Player;
	import character.PlayerManager;
	import gameModes.PointsManager;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.fx.Shake;
	import se.lnu.stickossdk.system.Session;
	
	public class BallManager
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
		 * Referens till den aktuella spelarens flagga,
		 */
		private var _ball:Sprite;
		
		/**
		 * Referens till motspelarens flagga.
		 */
		private var _targetFlag:Sprite;
		
		/**
		 * Referens till den aktuella spelaren.
		 */
		private var _player:Player;
		
		/**
		 * Index för den aktuella spelaren.
		 */
		private var _index:int;
		
		/**
		 * Referens till PointsManager.
		 */
		private var _points:PointsManager;
		
		/**
		 * Refferens till motspelaren.
		 */
		private var _enemyPlayer:Player;
		
		/**
		 * Vektor med alla instanser av Flag-objektet.
		 */
		private var _countdown:Countdown;
		
		/**
		 * Lager för counter grafiken.
		 */
		private var _layerCounter:DisplayStateLayer;
		
		
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
		public function BallManager(playerManager:PlayerManager, target:DisplayStateLayer, pointsManager:PointsManager, layerCounter:DisplayStateLayer)
		{
			_target = target;
			_playerManager = playerManager;
			_points = pointsManager;
			_layerCounter = layerCounter;
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instans av Flag-klassen och placerar 
		 * den på den specifika spelarens bas.
		 */
		public function addBall():void {
			var ball:Ball = new Ball();
			
			ball.x = 400;
			ball.y = 450;
			
			ball.scaleX = 1;
			ball.scaleY = 1;
			
			_target.addChild(ball);
			_ball = ball;
		}
		
		/**
		 * Skapa grafiken för nedräkningen.
		 */
		public function addCountdown():void {
			_countdown = new Countdown(_playerManager.players);
			_countdown.x = 400;
			_countdown.y = 40;
				
			_countdown.scaleX = 1;
			_countdown.scaleY = 1;
		
			_layerCounter.addChild(_countdown);
		}
		
		/**
		 * Kontroller för om spelaren går på bollen.
		 */
		public function initCollision(numPlayer:int):void {
			_numPlayer = numPlayer;
			_player = _playerManager.players[numPlayer];
			
			for(var i:int = 0; i < _playerManager.players.length; i++) {
				if(_playerManager.players[i] != _playerManager.players[numPlayer]) {
					_enemyPlayer = _playerManager.players[i];	
				}
			}
			
			if(!_player.hasFlag) {
				ballCollision();
			} else {
				counter();
			}
			_player.carryFlag(_ball);
		}
		
		/**
		 * Kontrollerar om spelaren kolliderar med bollen.
		 */
		private function ballCollision():void {
			if(_player.hitTestObject(_ball)) {
				if(!_player.hasFlag && _player.canPickFlag && !_enemyPlayer.hasFlag) {
					_player.pickUpFlag(_ball);
					Session.effects.add(new Shake(_layerCounter, 400));
				}
			}
		}
		
		/**
		 * Startar beräkningen när spelaren har bollen.
		 */
		private function counter():void {
			if(_countdown.counter < 60 && _countdown.counter > -60) {
				_countdown.startCounter(_numPlayer);
				_player.ballSpeed();
			} else {
				_player.wins++;
				endRound();
			}
		}

		
		/**
		 * Återställer flaggan och startar återställning
		 * av spelarna.
		 */
		private function endRound():void {
			placePlayer();
			_ball.x = 400;
			_ball.y = 450;
			_countdown.resetRound();
		}
		
		/**
		 * Återställer spelarsessionen.
		 */
		private function placePlayer():void {
			for(var i:int = 0; i < _playerManager.players.length; i++) {
				var player:Player = _playerManager.players[i];
				
				player.canPickFlag = true;
				player.hasFlag = false;
				player.speed = 4;
				_playerManager.roundCounter(1);
				
				if(player == _playerManager.players[0]) {
					player.x = 100;
					player.y = 100;
				} else {
					player.x = 700;
					player.y = 200;
				}
			}
		}
	}
}
