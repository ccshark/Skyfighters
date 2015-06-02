package character
{
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import se.lnu.stickossdk.display.DisplayStateLayerSprite;

	public class HUD extends DisplayStateLayerSprite
	{
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Vector som håller alla spelarna.
		 */
		private var _players:Vector.<Player>;
		
		/**
		 * Referens till spelaren.
		 */
		private var _player:Player;
		
		/**
		 * Spelarens gamla hälsa.
		 */
		private var _oldHp:int;
		
		/**
		 * Spelarens hälsomätare.
		 */
		private var _hpBase:MovieClip;
		
		/**
		 * Grafik för spelarens hälsopoäng.
		 */
		private var _hpBar:Sprite;
		
		/**
		 * Antalet spelare.
		 */
		private var _numPlayers:int;
		
		private var _bullets:TextField;
		
		private var _form:TextFormat;
		
		//Font
		[Embed(source="../../asset/fonts/emulogic.ttf", fontName = "emulogic", mimeType = "application/x-font", embedAsCFF="false")]
		private var visitor:Class;
		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		public function HUD(numPlayers:int, players:Vector.<Player>) {
			_numPlayers = numPlayers;
			_players =  players;
			_player = _players[numPlayers];
		}
		
		/**
		 * Skriver över init metoden.
		 */
		override public function init():void {
			super.init();
			_oldHp = _player.hp;
			initHpBase();
			initHpBar();
			initAvatar();
			initBullet();
		}
		
		//----------------------------------------------------------------------
		// Public methods
		//----------------------------------------------------------------------
		
		/**
		 * Kontrollerar om spelarens hälsa förändras
		 * och ändrar storleken på hpmätaren vid förändring.
		 */
		public function checkHp():void {
			if(_player.hp < _oldHp) {
				_oldHp = _player.hp;
				_hpBar.width = _oldHp;
			} else {
				_hpBar.width = _player.hp;
			}
		}
		
		/**
		 * Uppdaterar grafiken för hur många skott som
		 * spelaren har kvar.
		 */
		public function checkBullet():void {
			var bullets:int = _player.bullets.length;
			_bullets.text = bullets.toString();
		}
		
		/**
		 * Override, uppdaterar checkHp.
		 */
		override public function update():void {
			super.update();
			checkHp();
			checkBullet();
		}
		
		//----------------------------------------------------------------------
		// Private methods
		//----------------------------------------------------------------------
		
		/**
		 * Skapar Hp mätare för spelaren.
		 */
		private function initHpBar():void {
			_hpBar = new Sprite();
			_hpBar.graphics.beginFill(0x00ff00);
			_hpBar.graphics.drawRect(1, 2.5, 40, 11);
			_hpBar.graphics.endFill();
			
			addChild(_hpBar);
		}
		
		/**
		 * Skapar en bakgrund till hp mätaren.
		 */
		private function initHpBase():void {
			_hpBase = new HUD_HP_Bar;
			addChild(_hpBase);
		}
		
		/**
		 * Skapar en instans av avatarbilden och placerar
		 * i HUD'en.
		 */
		private function initAvatar():void {
			var avatar:MovieClip;
			if(_numPlayers == 0) {
				avatar = new HUD_Profile_Viking_GFX;
				avatar.x = -30;
			}
			if(_numPlayers == 1) {
			    avatar = new HUD_Profile_Samurai_GFX;
				avatar.x = 100;
			}
			
			addChild(avatar);
		}
		
		/**
		 * Skapar en instans av avståndsattack-representationen.
		 */
		private function initBullet():void {
			var bullet:MovieClip;
			
			_form = new TextFormat();
			_form.color = 0x000000;
			_form.size = 12;
			_form.font = "emulogic";
			
			bullet = new HUD_Weapon_GFX;
			bullet.scaleX = 0.5;
			bullet.scaleY = 0.5;
			
			_bullets = new TextField();
			_bullets.defaultTextFormat = _form;
			_bullets.embedFonts = true;
			
			if(_numPlayers == 0) {
				bullet.x = 10;
				bullet.y = 20;
				_bullets.x = 40;
				_bullets.y = 20;
			}
			if(_numPlayers == 1) {
				bullet.x = 70;
				bullet.y = 20;
				_bullets.x = 50;
				_bullets.y = 20;
			}
			
			addChild(_bullets);
			addChild(bullet);
		}
	}
}