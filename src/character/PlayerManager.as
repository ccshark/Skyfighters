package character {
	
	//--------------------------------------------------------------------------
	// Imports
	//--------------------------------------------------------------------------

	import flash.display.Sprite;
	import gameModes.Round;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import state.killScreens.WinNinja;
	import state.killScreens.WinViking;
	
	
	public class PlayerManager {
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 *	Vector som håller alla spelarna.
		 */
		public var players:Vector.<Player> = new Vector.<Player>();
		
		/**
		 * Vector som håller Hud'sen för alla spelarna.
		 */
		public var _huds:Vector.<HUD> = new Vector.<HUD>();
		
		/**
		 * Vector som gåller alla skott.
		 */
		public var bullets:Vector.<Bullet> = new Vector.<Bullet>();
		
		/**
		 * Det aktuella spelarläget.
		 */
		public var gameMode:String;
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Nummer på den aktuella rundan.
		 */
		private var _roundCount:int = 0;
		
		/**
		 * Kontroller för att avgöra rundan är räknad.
		 */
		private var _countedRound:Boolean = false;
		
		/**
		 * Referens till Round-klassen.
		 */
		private var _round:Round;
		

		//----------------------------------------------------------------------
		// Protected properties
		//----------------------------------------------------------------------
		
		/**
		 *	Lager för spelobjekt.
		 */
		protected var _target:DisplayStateLayer;
		
		//----------------------------------------------------------------------
		// Sounds
		//----------------------------------------------------------------------
		
		/**
		 * Ljud för när spelaren dör.
		 */
		[Embed(source="../../asset/sound/SFX_Player_Dead.mp3")]
		public static const DEAD_SRC:Class;
		
		/**
		 * Ljud för när rundan startar.
		 */
		[Embed(source="../../asset/sound/SFX_Element_Pickup.mp3")]
		public static const ROUND_SRC:Class;
		
		//----------------------------------------------------------------------
		// Constructor method
		//----------------------------------------------------------------------
		
		/**
		 *	
		 * 
		 *	@param target 			Lager för spelarobjekt.
		 */
		public function PlayerManager(target:DisplayStateLayer) {
			_target = target;
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Placerar spelaren i mitten av skärmen.
		 * skapar en ny instans av player-objektet.
		 */
		public function add(numPlayer:int):void {
				var player:Player = new Player(numPlayer);
				
				if(numPlayer == 0) {
					player.x = 100;
					player.y = 200;
					//player.x = (Session.application.width  >> 1) - player.width;
					//player.y = (Session.application.height >> 1) - player.height;
				}
				if(numPlayer == 1) {
					player.x = 700;
					player.y = 200;
				}
				player.scaleX = 1;
				player.scaleY = 1;
				
				players.push(player);
				_target.addChild(player);
		}
		
		/**
		 * Skapar en HUD för varje spelare, och placerar den
		 * i spelarlagret.
		 */
		public function addHud(numPlayer:int):void {
			var hud:HUD = new HUD(numPlayer, players);
			
			if(numPlayer == 0) {
				hud.x = 100;
				hud.y = 50;
			}
			if(numPlayer == 1) {
				hud.x = 600;
				hud.y = 50;
			}
			hud.scaleX = 1;
			hud.scaleY = 1;
			
			_huds.push(hud);
			_target.addChild(hud);
		}
		
		/**
		 * Kollisionshanterare för slag.
		 */
		public function initCollision(numPlayer:int):void {
			var punshHitbox:Sprite = players[numPlayer].punshHitBox;
			for (var i:int = 0; i < players.length; i++) {
				if(players[i] != players[numPlayer]) {
					var targetPlayer:Sprite = players[i].bodyHitbox;
					var index:int = i;
				}
			}
			if(punshHitbox.hitTestObject(targetPlayer)) {
				var player:Player = players[index]
				
				if(player.hp > 10) {
					player.takeHit(players[numPlayer].damage);
				}
				else {
					var death:String = 'killed';
					checkWins(numPlayer, death);
				}
			}
		}
		
		/**
		 * Kontroller för om spelaren befinner sig utanför 
		 * banans parametrar. 
		 */
		public function outOfMap(numPlayer:int):void {
			var player:Player = players[numPlayer];
			if(player.y > 850) {
				var death:String = 'jump';
				checkWins(numPlayer, death);
			}
		}
		
		
		/**
		 * Kontrollerar om en spelare har vunnit eller om den andra spelaren vinner 
		 * ett poäng. Placerar spelaren på respektive bas om den dör.
		 *  Rensar upp spelsessionen och pressenterar killscreen.
		 */
		public function checkWins(numPlayer:int, death:String):void {
			var player:Player = players[numPlayer];
			for (var i:int = 0; i < players.length; i++) {
				if(players[i] != players[numPlayer]) {
					var targetPlayer:Player = players[i];
					var index:int = i;
				}
			}
			//TODO dispose classes
				
			Session.sound.soundChannel.sources.add("dead", DEAD_SRC);
			var deadSound:SoundObject = Session.sound.soundChannel.get("dead"); 
			deadSound.play();
			deadSound.volume = 0.5;
				
			if(death == 'killed') {
				targetPlayer.hp = 100;
				targetPlayer.playerDead = true;
				if(numPlayer == 0) {
					players[1].hasFlag = false;
					returnPlayer(1);
					players[1].killed();
					if(gameMode == "DM") {
						players[0].wins++;
					}
				}
				if(numPlayer == 1) {
					players[0].hasFlag = false;
					returnPlayer(0);
					players[0].killed();
					if(gameMode == "DM") {
						players[1].wins++;
					}
				}
			} 
			if(death == 'jump') {
				targetPlayer.hp = 100;
				if(numPlayer == 0) {
					returnPlayer(numPlayer);
				}
				if(numPlayer == 1) {
					returnPlayer(numPlayer);
				}
			}
		}
		
		/**
		 * Placerar spelaren på startpossitionen.
		 */
		public function returnPlayer(numPlayer:int):void {
			if(numPlayer == 0) {
				players[0].x = 100;
				players[0].y = 200;
				players[0].skin.gotoAndStop(1);
				players[0].punshing = false;
			}
			if(numPlayer == 1) {
				players[1].x = 700;
				players[1].y = 200;
				players[1].skin.gotoAndStop(1);
				players[0].punshing = false;
			}
		}
		
		/**
		 * Uppdaterar grafiken för presentation av den
		 * aktuella rundan.
		 */
		public function updateRound():void {
			_round = new Round(_roundCount);
			
			_round.x = (Session.application.width  >> 1) - _round.width - 150;
			_round.y = (Session.application.height >> 1) - _round.height;
			_target.addChild(_round);
			
			Session.sound.soundChannel.sources.add("round", ROUND_SRC);
			var roundSound:SoundObject = Session.sound.soundChannel.get("round"); 
			roundSound.play();
			roundSound.volume = 0.5;
			
			Session.timer.create(2000, startRound);
		}
		
		/**
		 * Uppdaterar den aktuella rundan.
		 */
		public function roundCounter(count:int):void {
			if(!_countedRound) {
				_countedRound = true;
				_roundCount = _roundCount + count;
				for(var i:int = 0; i < players.length; i++) {
					players[i].activeRound = false;
				}
				
				var playerOne:Player = players[0];
				var playerTwo:Player = players[1];
				
				if(playerOne.wins == 1 && playerTwo.wins == 0) {
					//matchpoint
					updateRound();
				}
				if(playerOne.wins == 0 && playerTwo.wins == 1) {
					//matchpoint
					updateRound();
				}
				if(playerOne.wins == 1 && playerTwo.wins == 1) {
					updateRound();
				}
				if(playerOne.wins == 2) {
					// Timern kan balla ur
					//Session.timer.create(2000, wikingWin);
					wikingWin()
				}
				if(playerTwo.wins == 2) {
					// Timern kan balla ur
					//Session.timer.create(2000, ninjaWin);
					ninjaWin();
				}
			}
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Startar spelomgången.
		 */
		private function startRound():void {
			_target.removeChild(_round);
			_countedRound = false;
			
			for(var i:int = 0; i < players.length; i++) {
				players[i].activeRound = true;
			}
		}
		
		/**
		 * Startar WinViking-klassen
		 */
		private function wikingWin():void {
		//	Session.timer.dispose();
			Session.application.displayState = new WinViking(gameMode);
		}
		
		/**
		 * Startar WinNinja-klassen.
		 */
		private function ninjaWin():void {
		//	Session.timer.dispose();
			Session.application.displayState = new WinNinja(gameMode);
		}
		
		/**
		 * Städar upp klassen.
		 */
		public function dispose():void {
			for (var i:int = 0; i < players.length; i++) {
				_target.removeChild(players[i]);
				//_tile[i] = null;
			}
			//_currentMap.dispose();
		}
	}
}

