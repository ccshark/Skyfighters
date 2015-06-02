package character
{
	
	//----------------------------------------------------------------------
	// Imports properties
	//----------------------------------------------------------------------
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;
	import se.lnu.stickossdk.fx.Flicker;
	import se.lnu.stickossdk.media.SoundObject;
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.timer.Timer;
	
	
	public class Entity extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Public properties
		//----------------------------------------------------------------------
		
		/**
		 * Kontroller för om en runda är aktiverad.
		 */
		public var activeRound:Boolean = false;
		
		/**
		 * Kontroller om spelaren hoppar.
		 */
		public var jumping:Boolean = false;
		
		/**
		 * Kontrollerar om spelaren befinner sig på marken
		 */
		public var onGround:Boolean = false;
		
		/**
		 * Hitbox för att kontrollera om en spelare 
		 * blir slagen.
		 */
		public var bodyHitbox:Sprite;
		
		/**
		 * Kollisions parametrar, används för
		 * att avgöra om spelaren slår emot en tile.
		 */
		public var leftHitPoint:Point;	
		public var rightHitPoint:Point; 
		public var topHitPoint:Point;	
		public var botHitPoint:Point;
		
		/**
		 * Kontroller om spelaren slår.
		 */
		public var punshing:Boolean = false;
		
		/**
		 * Sprite för att kolla kollision vid slag.
		 */
		public var punshHitBox:Sprite = new Sprite();
		
		/**
		 * Grafisk representation av spelaren.
		 */
		public var skin:MovieClip;
		
		/**
		 * Spelarenns senaste possition.
		 */
		public var oldPoss:Point;
		
		/**
		 * Spelarens hälsopoäng.
		 */
		public var hp:int = 100;
		
		/**
		 * Kontroller om spelaren har tagit
		 * motspelarens flagga.
		 */
		public var hasFlag:Boolean = false;
		
		/**
		 * Kontroller för om spelaren kan plocka upp
		 * motspelarens flagga.
		 */
		public var canPickFlag:Boolean = true;
		
		/**
		 * Kontroller för om dubbelhopp är använt
		 */
		public var doubleJump:Boolean = true;
		
		/**
		 * Vector for all active bullets
		 */
		public var activeBullets:Vector.<Bullet> = new Vector.<Bullet>;
		
		/**
		 * Kontroller för om flaggan befinner sig på marken.
		 */
		public var dropedFlag:Boolean = false;
		
		/**
		 * Kontroller för om spelaren är död.
		 */
		public var playerDead:Boolean = false;
		
		/**
		 * Antal vunna rundor för den aktuella spelaren
		 */
		public var wins:int = 0;
		
		/**
		 * Attackernas skada.
		 */
		public var damage:int = 25;
		
		/**
		 * Spelarenns förflyttningshastighet.
		 */
		public var speed:Number = 4;
		
		/**
		 * Kontrollerar hur spelaren dog.
		 */
		public var death:String;
		
		/**
		 * Kontroller för om spelaren har tagit ett element.
		 */
		public var activeElement:Boolean = false;
		
		/**
		 * Håller alla avståndsattacker.
		 */
		public var bullets:Vector.<Bullet> = new Vector.<Bullet>;
		
		//----------------------------------------------------------------------
		// Private properties
		//----------------------------------------------------------------------
		
		/**
		 * Kontroller för om spelaren tar skada.
		 */
		public var _hit:Boolean = true;
		
		/**
		 * Spelarens hopphastighet.
		 */
		private var _jumpSpeed:int = _MAXJUMP;
		
		/**
		 * Timer för slag.
		 */
		private var _punshTimer:Timer;
		
		/**
		 * Värde som spelarens hastighet minskas med
		 * När den bär på bollen i madball.
		 */
		private var _speedDec:Number = 0.004;
		
		/**
		 * Kontroller för vilket håll spelaren är vänd åt.
		 * Används för att bestämma avståndsattackens riktning.
		 */
		private var _turnedLeft:Boolean = false;
		
		/**
		 * Spelarens maximala hopphastighet.
		 */
		private const _MAXJUMP:int = 15;
		
		
		//----------------------------------------------------------------------
		// Sounds
		//----------------------------------------------------------------------
		
		/**
		 * Ljud för hopp.
		 */
		[Embed(source="../../asset/sound/SFX_Player_Jump.mp3")]
		public static const JUMP_SRC:Class;
		
		/**
		 * Ljud för att gå.
		 */
		[Embed(source="../../asset/sound/SFX_Player_Jump.mp3")]
		public static const WALK:Class;
		
		/**
		 * Ljud för slag.
		 */
		[Embed(source="../../asset/sound/SFX_Punch.mp3")]
		public static const PUNCH_SRC:Class;
		
		/**
		 * Ljud för slag som träffar spelaren.
		 */
		[Embed(source="../../asset/sound/SFX_Punch_Hit.mp3")]
		public static const HIT_SRC:Class;
		
		/**
		 * Ljud för när spelaren tar upp en flagga eller bollen.
		 */
		[Embed(source="../../asset/sound/SFX_Element_Pickup.mp3")]
		public static const PICKUP_FLAG_SRC:Class;
		
		/**
		 * Ljud för när spelaren tabbar flaggan eller bollen.
		 */
		[Embed(source="../../asset/sound/SFX_Flag_Dropped.mp3")]
		public static const DROP_SRC:Class;
		
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function Entity()
		{
			super();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Spelar idle animationen när
		 * inga kommandon ges till spelaren.
		 */
		public function idle():void {
			skin.gotoAndStop(1);
		}
		
		//----------------------------------------------------------------------
		// Movement control
		//----------------------------------------------------------------------
		
		/**
		 * Flyttar spelaren till vänster.
		 */
		public function moveLeft():void {
			if(punshing) {
				
			} else {
				skin.gotoAndStop(2);
			}
			this.x -= speed;
			this.scaleX = -1;
			_turnedLeft = true;
		}
		
		/**
		 * Flyttar spelaren till höger.
		 */
		public function moveRight():void {
			if(punshing) {
				
			} else {
				skin.gotoAndStop(2);
			}
			this.x += speed;
			this.scaleX = 1;
			_turnedLeft = false;
		}
		
		/**
		 * Gör så att spelaren slår.
		 * Skadeboxen finns ute under en begränsad tid
		 * för att mäta om den träffar objektet.
		 */
		public function punsh():void {
			if(!punshing) {
				punshing = true;
				
				//_punshHitBox.graphics.beginFill(0xFFFFFF, 0.5);
				punshHitBox.graphics.drawRect(0, 0, 15, 15);
				//_punshHitBox.graphics.endFill();
				punshHitBox.x = 5;
				punshHitBox.y = 5;
				
				addChild(punshHitBox);
				
				Session.timer.create(20, removePunchbox);
				
				_punshTimer = Session.timer.create(300, endPunsh);
				_punshTimer.start();
				skin.gotoAndStop(3);
				
				//Sound
				Session.sound.soundChannel.sources.add("punsh", PUNCH_SRC);
				var punshSound:SoundObject = Session.sound.soundChannel.get("punsh"); 
				
				punshSound.play();
				punshSound.volume = 1;
			}
		}
		
		/**
		 * Tar bort hitboxen för slaget.
		 */
		private function removePunchbox():void {
			removeChild(punshHitBox);
		}
		
		/**
		 * Avslutar animationen för slaget.
		 */
		public function endPunsh():void {
			_punshTimer.stop();
			skin.gotoAndStop(1);
		}

		/**
		 * Gör så att spelaren hoppar och faller till marken.
		 */
		public function jump():void {
			if(!jumping) {
					Session.sound.soundChannel.sources.add("jump", JUMP_SRC);
					var jumpSound:SoundObject = Session.sound.soundChannel.get("jump"); 
					jumpSound.play();
					jumpSound.volume = 0.7;
				
					
					skin.gotoAndStop(2);
					jumping = true;
					_jumpSpeed = _MAXJUMP*-1;
					this.y += _jumpSpeed;
				} else {
					if(_jumpSpeed < 0){
						_jumpSpeed *= 1 - _MAXJUMP/220;
						if(_jumpSpeed > -_MAXJUMP/4) {
							_jumpSpeed *= -1.8;
						}
					}
					this.y += _jumpSpeed;
					//kod för hoppanimation.
			}
		}
		
		/**
		 * Metod som hanterar range attack.
		 */
		public function bullet():void {
			if(bullets.length > 0) {
				var currentBullet:Bullet = bullets[0];
				activeBullets.push(currentBullet);
				bullets.splice(0, 1);
				currentBullet.shootBullet();
				currentBullet.x = this.x;
				currentBullet.y = this.y;
				
				if(_turnedLeft) {
					currentBullet.bulletLeft = true;
				} else {
					currentBullet.bulletLeft = false;
				}
			}
		}

		/**
		 * Gör så att spelaren stannar på 
		 * den tilen som den träffar.
		 */
		public function botHit(tile:DisplayObject):void {
			var hitBlock:DisplayObject = tile;
			onGround = true;
			this.y = (hitBlock.y - hitBlock.height) - (bodyHitbox.height * 0.5 ) + 8;
			jumping = false;
			doubleJump = true;
		}
		
		/**
		 * Gör så att spelaren inte kan 
		 * hoppa genom en tile.
		 */
		public function topHit(tile:DisplayObject):void {
			var hitBlock:DisplayObject = tile;
			onGround = false;
			this.y = (hitBlock.y + hitBlock.height) - (this.height - hitBlock.height);
		}
		
		/**
		 * Gör så att spelaren inte kan
		 * hoppa från vänster genom en tile.
		 */
		public function leftHit(tile:DisplayObject):void {
			var hitBlock:DisplayObject = tile;
			if(this.x < oldPoss.x) {
				onGround = false;
				this.x = (hitBlock.x + hitBlock.width) + (this.width * 0.5) - 3;
			}
		}
		
		/**	
		 * Gör så att spelaren inte kan
		 * hoppa från höger genom en tile.
		 */
		public function rightHit(tile:DisplayObject):void {
			var hitBlock:DisplayObject = tile;
			if(this.x > oldPoss.x) {
				onGround = false;
				this.x = (hitBlock.x - hitBlock.width) + (this.width * 0.5) + 3;
			}
		}
		
		/**
		 * Gravitation som aktiveras när spelaren inte 
		 * befinner sig på någon plattform
		 */
		public function gravity():void {
			onGround = false;
			if(!onGround && !jumping) {
				this.y += _MAXJUMP * 0.3;
			} 
			if(this.y > 600) {
				this.y = 0;
			}
			if(this.y < 0) {
				this.y = 600;
			}
			if(this.x > 800) {
				this.x = 0;
			}
			if(this.x < 0) {
				this.x = 800;
			}
		}
		
		//----------------------------------------------------------------------
		// Hit control
		//----------------------------------------------------------------------
		
		/**
		 * Kontrollerar om spelaren är träffad.
		 * Utför beräkning för spelarens liv samt annimation för
		 * träff.
		 */
		public function takeHit(dmg:int):void {
			if(_hit) {
				_hit = false;
				hasFlag = false;
				punshing = true;
				Session.effects.add(new Flicker(skin, 1000));
				Session.timer.add(new Timer(1000, hitDone));
				hp = hp - dmg;
				
				Session.sound.soundChannel.sources.add("hit", HIT_SRC);
				var hitSound:SoundObject = Session.sound.soundChannel.get("hit"); 
				hitSound.play();
				hitSound.volume = 0.8;
			}
		}
		
		/**
		 * Kontroller, spelaren kan inte ta 
		 * skada när den är träffad.
		 */
		private function hitDone():void {
			_hit = true;
			punshing = false;
		}
		
		/**
		 * Avaktiverar styrning för spelaren när den är dödad
		 */
		public function killed():void {
			activeRound = false;
			Session.effects.add(new Flicker(skin, 2000));
			Session.timer.create(2000, activePlayer);
		}
		
		/**
		 * Aktiverar spelarens kontroller när timern för 
		 * att vara död har gått ut.
		 */
		private function activePlayer():void {
			activeRound = true;
		}
		
		//----------------------------------------------------------------------
		// Flag control
		//----------------------------------------------------------------------
		
		/**
		 * Aktiverar booleans för om spelaren plockar 
		 * upp motspelarens flagga.
		 */
		public function pickUpFlag(flag:DisplayObject):void {
			hasFlag = true;
			canPickFlag = false;
			
			Session.sound.soundChannel.sources.add("pickFlag", PICKUP_FLAG_SRC);
			var pickupFlagSound:SoundObject = Session.sound.soundChannel.get("pickFlag"); 
			pickupFlagSound.play();
			pickupFlagSound.volume = 0.5;
		}
		
		/**
		 * Huvud metod för flagkontrollen. Låser flaggan till spelaren
		 * om den är tagen. och släpper den om spelaren tar skada.
		 */
		public function carryFlag(flag:DisplayObject):void {
			if(hasFlag) {
				flag.x = this.x + 3;
				flag.y = this.y + 5;
			} 
			if(!hasFlag) {
				if(!canPickFlag && !dropedFlag) {
					dropFlag(flag);
				}
			}
		}
		
		/**
		 * Spelaren tappar flaggan om den tar skada. Metoden körs
		 * en gång och aktiverar en timer för när spelaren kan ta upp
		 * flaggan på nytt.
		 */
		private function dropFlag(flag:DisplayObject):void {
			Session.sound.soundChannel.sources.add("drop", DROP_SRC);
			var dropSound:SoundObject = Session.sound.soundChannel.get("drop"); 
			dropSound.play();
			dropSound.volume = 0.4;
			
			dropedFlag = true;
			Session.timer.add(new Timer(2000, pickFlagCD));
			flag.x = this.x + 20;
			flag.y = this.y + 10;
			speed = 4;
		}
		
		/**
		 * Gör så att spelaren kan plocka upp flaggan
		 * på nytt när timern är avslutad.
		 */
		private function pickFlagCD():void {
			canPickFlag = true;
			dropedFlag = false;
		}
		
		//----------------------------------------------------------------------
		// Ball control
		//----------------------------------------------------------------------
		
		/**
		 * Minskar spelarens hastighet när den innehar
		 * bollen.
		 */
		public function ballSpeed():void {
			if(speed > 1) {
				speed -= _speedDec;
			}
			else {
				speed = 1;
			}
		}
	}
}