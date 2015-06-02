package gameModes.ctf
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Sprite;
	import character.Player;
	import character.PlayerManager;
	import gameModes.PointsManager;
	import se.lnu.stickossdk.display.DisplayStateLayer;

	public class FlagManager
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Vektor med alla instanser av Flag-objektet.
		 */
		private var _flags:Vector.<Flag> = new Vector.<Flag>();
		
		/**
		 * Vektor med alla instanser av Base-Klassen.
		 */
		private var _base:Vector.<Base> = new Vector.<Base>();
		
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
		private var _flag:Sprite;
		
		/**
		 * Referens till motspelarens flagga.
		 */
		private var _targetFlag:Flag;
		
		/**
		 * Referens till den aktuella spelaren.
		 */
		private var _player:Sprite;
		
		/**
		 * Index för den aktuella spelaren.
		 */
		private var _index:int;
		
		/**
		 * Referens till PointsManager.
		 */
		private var _points:PointsManager;
		
		
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
		public function FlagManager(playerManager:PlayerManager, target:DisplayStateLayer, pointsManager:PointsManager)
		{
			_target = target;
			_playerManager = playerManager
			_points = pointsManager
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instans av Base-klassen och placerar 
		 * den på den specifika spelarens startpossition.
		 */
		public function addBase(numPlayer:int):void {
			var base:Base = new Base(numPlayer);
			
			if(numPlayer == 0) {
				base.x = 40;
				base.y = 175;
			}
			if(numPlayer == 1) {
				base.x = 670;
				base.y = 175;
			}
			base.scaleX = 1;
			base.scaleY = 1;
			
			_base.push(base);
			_target.addChild(base);
		}
		
		/**
		 * Skapar en ny instans av Flag-klassen och placerar 
		 * den på den specifika spelarens bas.
		 */
		public function addFlag(numPlayer:int):void {
			var flag:Flag = new Flag(numPlayer);
			
			if(numPlayer == 0) {
				flag.x = 65;
				flag.y = 190;
			}
			if(numPlayer == 1) {
				flag.x = 745;
				flag.y = 190;
			}
			flag.scaleX = 1;
			flag.scaleY = 1;
			
			_flags.push(flag);
			_target.addChild(flag);
		}
	
		/**
		 * Kollisionshantering för flaggor. Kontrollerar om spelaren går
		 * på en flagga.
		 */
		public function initCollision(numPlayer:int):void {
			_numPlayer = numPlayer;
			_flag = _flags[numPlayer];
			_player = _playerManager.players[numPlayer].bodyHitbox;
			for (var i:int = 0; i < _flags.length; i++) {
				if(_flags[i] != _flags[numPlayer]) {
					_targetFlag = _flags[i];
					_index = i;
				}
			}
			var player:Player = _playerManager.players[_numPlayer];
			player.carryFlag(_flags[_index]);
			flagCollision(player);
			leaveFlag();
			outOfMap(player);
			returnFlag();
		}
		
		/**
		 * Kontrollerar om flaggan befinner sig på
		 * spelplanen.
		 */
		public function outOfMap(player:Player):void {	
			var flag:Flag = _flags[_numPlayer];
			if(flag.y > 700) {
				if(_numPlayer == 0) {
					player.hasFlag = false;
					player.canPickFlag = true;
					flag.x = 65;
					flag.y = 190;
				}
				if(_numPlayer == 1) {
					player.hasFlag = false;
					player.canPickFlag = true;
					flag.x = 745;
					flag.y = 190;
				}	
			}
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Kontrollerar om spelaren kolliderar med motspelarens flagga.
		 */
		private function flagCollision(player:Player):void {
			if(_player.hitTestObject(_targetFlag)) {
				if(!player.hasFlag && player.canPickFlag) {
					player.pickUpFlag(_flags[_index]);
					_targetFlag.flag.gotoAndStop(1);
				} 
			}
		}
		
		/**
		 * Kontrollerar om spelaren kan lämna in sin flagga i sin bas
		 */
		private function leaveFlag():void {
			var picked:Player = _playerManager.players[_numPlayer];
			var base:Sprite = _base[_numPlayer];
			var enemy:Player = _playerManager.players[_index];
			if(_targetFlag.hitTestObject(base)) {
				if(!enemy.hasFlag) {
					if(_numPlayer == 0) {
						_targetFlag.x = 745;
						_targetFlag.y = 190;
						_targetFlag.flag.gotoAndStop(2);
					}
					if(_numPlayer == 1) {
						_targetFlag.x = 65;
						_targetFlag.y = 190;
						_targetFlag.flag.gotoAndStop(2);
					}
					if(picked.hasFlag) {
						picked.wins++;
					}
					picked.hasFlag = false;
					_playerManager.returnPlayer(0);
					_playerManager.returnPlayer(1);
					_playerManager.roundCounter(1);	
				}
				else {
					//trace("enemy has your flag");
				}
			}
		}
		
		/**
		 * Kontrollerar om spelaren går på sin egen flagga. Flaggan
		 * återspawnas i motspelarens bas.
		 */
		private function returnFlag():void {
			var enemy:Player = _playerManager.players[_index];
			if(_player.hitTestObject(_flag)) {
				if(!enemy.hasFlag) {
					if(_numPlayer == 0) {
						enemy.hasFlag = false;
						enemy.canPickFlag = true;
						_flag.x = 65;
						_flag.y = 190;
						_targetFlag.flag.gotoAndStop(2);
					}
					if(_numPlayer == 1) {
						enemy.hasFlag = false;
						enemy.canPickFlag = true;
						_flag.x = 745;
						_flag.y = 190;
						_targetFlag.flag.gotoAndStop(2);
					}	
				}
			}
		}
	}
}