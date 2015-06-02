package character
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import se.lnu.stickossdk.input.EvertronControls;
	import se.lnu.stickossdk.input.Input;
	
	public class Player extends Entity
		
	{
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Referens till den aktuella spelaren.
		 */
		private var _player:int;
		
		/**
		 * Evertron kontroller.
		 */
		private var _controls:EvertronControls;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * 
		 * @param player 			Nummer för den aktuella spelaren.
		 */
		public function Player(player:int)
		{
			super();
			_player = player;
			_controls = new EvertronControls(player);
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Överskriver init funktionen.
		 */
		override public function init():void {
			super.init();
			initSkin();
			initHitbox();
			initHitPoints();
		}
		
		/**
		 * Skapar eventlyssnare för kontrollerna.
		 */
		override public function update():void {
			super.update();
			oldPoss = new Point(this.x, this.y);
			if(activeRound) {
				updateKeyboard();
				keyReleased();
			}
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar en ny instans av spelar-klassen.
		 * Lägger ut grafiken på spelarlagret.
		 */
		private function initSkin():void {
			if(_player == 0) {
				skin = new Viking_Base_GFX;
				skin.gotoAndStop(1);
			}
			if(_player == 1) {
				skin = new Samurai_Base_GFX;
				skin.gotoAndStop(1);
			}
			addChild(skin);
		}
		
		/**
		 * Lägger ut en hitbox för spelaren. Den används för att 
		 * räkna ut om spelaren tar skada.
		 */
		private function initHitbox():void {
			bodyHitbox = new Sprite();
			bodyHitbox.graphics.drawRect(0, 0, 20, 25);
			bodyHitbox.x = -10;
			bodyHitbox.y = 7;
			
			addChild(bodyHitbox);
		}
		
		/**
		 * Skapar fyra hitpoints som används för att avgöra 
		 * om spelaren kolliderar med en tile.
		 */
		private function initHitPoints():void {
			leftHitPoint 		= new Point(-this.width * 0.5, this.height * 0.5);
			rightHitPoint 		= new Point(this.width * 0.5, (this.height * 0.5));
			topHitPoint			= new Point(0, 5);
			botHitPoint 		= new Point(0, this.height);
		}
		
		/**
		 * Tangentbords kontroller som hanterar styrningen av 
		 * karaktären.
		 */
		private function updateKeyboard():void {
			if(Input.keyboard.pressed(_controls.PLAYER_LEFT)) this.moveLeft();
			if(Input.keyboard.pressed(_controls.PLAYER_RIGHT)) this.moveRight();
			if(Input.keyboard.justPressed(_controls.PLAYER_BUTTON_2) || jumping) this.jump();
			if(Input.keyboard.pressed(_controls.PLAYER_BUTTON_1) || punshing) this.punsh();
			if(Input.keyboard.justPressed(_controls.PLAYER_BUTTON_3)) this.bullet();
		}
		
		/**
		 * Tangentbords kontroller som hanterar 
		 * när knapparna släpps.
		 */
		private function keyReleased():void {
			if(Input.keyboard.justReleased(_controls.PLAYER_LEFT)) this.idle();
			if(Input.keyboard.justReleased(_controls.PLAYER_RIGHT)) this.idle();
			if(Input.keyboard.justReleased(_controls.PLAYER_BUTTON_2)) {
				if(doubleJump) {
					jumping = false;
					doubleJump = false;
				}
				this.idle();
			}
			if(Input.keyboard.justReleased(_controls.PLAYER_BUTTON_1)) punshing = false;;
		}
	}
}