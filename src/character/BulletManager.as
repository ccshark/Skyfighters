package character
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	import se.lnu.stickossdk.display.DisplayStateLayer;

	public class BulletManager
	{
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Håller alla bullets objekt.
		 */
		public var bullets:Vector.<Bullet> = new Vector.<Bullet>();
		
		//----------------------------------------------------------------------
		// private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till PlayerManager.
		 */
		private var _players:PlayerManager;
		
		//----------------------------------------------------------------------
		// Protected properties
		//----------------------------------------------------------------------
		
		/**
		 *	Lager för spelobjekt.
		 */
		protected var _target:DisplayStateLayer;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * 
		 * @param target 			Lager för spelobjektet.
		 * @param players 			Referens till PlayerManager-klassen.
		 */
		public function BulletManager(target:DisplayStateLayer, players:PlayerManager) {
			_target = target;
			_players = players;
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar tre nya instanser av Bullet-klassen och lägger till
		 * dem i spelarlagret.
		 */
		public function addBullets(numPlayer:int):void {
			for (var i:int = 0; i < 3; i++) {
				var bullet:Bullet = new Bullet(numPlayer);
				
				_players.players[numPlayer].bullets.push(bullet);
				_target.addChild(bullet);
			}
		}
		
		/**
		 * Kollisionshantering för spelaren och avståndsattackerna.
		 */
		public function initCollision(numPlayer:int):void {
			for(var j:int = 0; j < _players.players.length; j++) {
				if(_players.players[j] != _players.players[numPlayer]) {
					var player:Player = _players.players[j];
				}
				shootingBullet();
			}
			for (var i:int = 0; i < _players.players[numPlayer].activeBullets.length; i++) {
				var bullet:Bullet = _players.players[numPlayer].activeBullets[i];
				
				if(player.hitTestObject(bullet)) {
					if(player.hp > 0) {
						player.takeHit(_players.players[numPlayer].damage);
						bullet.removeBullet();
						_players.players[numPlayer].activeBullets.splice(i, 1);
					}
					else {
						_players.players[numPlayer].playerDead = true;
						bullet.removeBullet();
						
						var death:String = 'killed';
						_players.checkWins(numPlayer, death);
					}
					
				}
			}
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Kontrollerar om det finns aktiva kulor.
		 * Ändrar possitionen för varje kula och tar bort dem om dem
		 * är utanför skärmen.
		 */
		private function shootingBullet():void {			
			for(var j:int = 0; j < _players.players.length; j++) {
				var player:Player = _players.players[j];
				for(var i:int = 0; i < player.activeBullets.length; i++) {
					var currentBullet:Bullet = player.activeBullets[i];
					if(currentBullet.bulletLeft) {
						currentBullet.x -= currentBullet.bulletSpeed;
					} else {
						currentBullet.x += currentBullet.bulletSpeed;
					}
					
					if(currentBullet != null) {
						if(currentBullet.x > 800) {
							_target.removeChild(player.activeBullets[i]);
							player.activeBullets.splice(i, 1);
						}
						if(currentBullet.x < 0) {
							_target.removeChild(player.activeBullets[i]);
							player.activeBullets.splice(i, 1);
						}
					}
				}
			}
		}
		
		/**
		 * Städar upp bullet-klasserna.
		 */
		public function dispose():void {
			for (var i:int = 0; i < bullets.length; i++) {
				if(bullets[i].parent != null) {
					bullets[i].parent.removeChild(bullets[i]);
				}
				bullets[i].dispose();
				bullets[i] = null;
				bullets.splice(i, 1);
			}
			bullets.length = 0;
		}
	}
}