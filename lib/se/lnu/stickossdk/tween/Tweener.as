package se.lnu.stickossdk.tween {
	
	//-----------------------------------------------------------
	// Imports
	//-----------------------------------------------------------
	
	import se.lnu.stickossdk.tween.Tween;	
	
	//-----------------------------------------------------------
	// Public class
	//-----------------------------------------------------------
	
	/**
	 *	StickOS SDKs egna interpoleringsmotor (Tween-motor). 
	 *	Klassen används för att skapa tween-baserade animationer.
	 *
	 *	@version	1.0
	 *	@copyright	Copyright (c) 2012-2014.
	 *	@license	Creative Commons (BY-NC-SA)
	 *	@since		2014-01-15
	 *	@author		Henrik Andersen <henrik.andersen@lnu.se>
	 */
	public class Tweener {
		
		//-------------------------------------------------------
		// Public properties
		//-------------------------------------------------------
		
		/**
		 *	Om samtliga interpoleringar är pausade.
		 * 
		 *	@default false
		 */
		public var paused:Boolean;
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		
		/**
		 *	Lista innehållande samtliga interpoleringar som är 
		 *	registrerade av interpoleringsmotorn. Varje 
		 *	interpolering består av ett Tween-objekt.
		 * 
		 *	@default Vector
		 */
		private var _tweenList:Vector.<Tween> = new Vector.<Tween>();
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		
		/**
		 *	Skapar en ny instans av Tweener.
		 */
		public function Tweener() {
			
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		
		/**
		 *	Applicerar en interpolering på ett objekt. 
		 *	Interpoleringen kan appliceras på flera egenskaper 
		 *	samtidigt.
		 * 
		 *	@param	Object	Interpoleringsobjektet.
		 *	@param	Object	Egenskaper som ska interpoleras.
		 * 
		 *	@return Tween	Det nya interpoleringsobjektet.
		 */
		public function add(object:Object, argument:Object = null):Tween {
			var tween:Tween = createTween(object, argument);
			_tweenList.push(tween);	
			
			return tween;
		}
		
		/**
		 *	Tar bort samtliga interpoleringar från ett objekt.
		 * 
		 *	@param	Object	Interpoleringsobjektet
		 *	
		 *	@return void
		 */
		public function remove(object:Object):void {
			for (var i:int = 0; i < _tweenList.length; i++) {
				if (_tweenList[i].object == object) {
					_tweenList[i].dispose();
					_tweenList[i] = null;
					_tweenList.splice(i, 1);
				}
			}	
		}
		
		/**
		 *	Uppdaterar samtliga aktiva interpoleringar som 
		 *	registrerats i interpoleringsmotorn. Denna metod 
		 *	aktiveras enbart när interpoleringsmotorn är aktiv.
		 * 
		 *	@return void
		 */
		public function update():void {
			if (paused == false) {
				updateTweenList();
			}
		}
		
		/**
		 *	Tar bort och deallokerar samtliga registrerade 
		 *	interpoleringar.
		 * 
		 *	@return void
		 */
		public function dispose():void {
			for (var i:int = 0; i < _tweenList.length; i++) {
				_tweenList[i].dispose();
				_tweenList[i] = null;
				_tweenList.splice(i, 1);
			}
			
			_tweenList.length = 0;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		
		/**
		 *	Uppdaterar samtliga registrerade interpoleringar och 
		 *	tar bort interpoleringar som är klara.
		 * 
		 *	@return void
		 */
		private function updateTweenList():void {
			for (var i:int = 0; i < _tweenList.length; i++) {
				_tweenList[i].update();
				if (_tweenList[i].numActiveTweens < 1) {
					_tweenList[i].dispose();
					_tweenList[i] = null;
					_tweenList.splice(i, 1);
				}
			}
		}
		
		/**
		 *	Skapar ett nytt interpoleringsobjekt (Tween). Om en 
		 *	interpolering appliceras på ett befintligt objekt 
		 *	ersätts den gamla interpoleringen med den nya.
		 * 
		 *	@param	Object	Interpoleringsobjektet
		 *	@param	Object	Egenskaper som ska interpoleras.
		 * 
		 *	@return void
		 */
		private function createTween(object:Object, argument:Object):Tween {
			var tween:Tween = new Tween(object, argument);
			for (var i:int = 0; i < _tweenList.length; i++) {
				if (_tweenList[i].object == object) {
					_tweenList[i].dispose();
					_tweenList[i] = null;
					_tweenList.splice(i, 1);
					break;
				}
			}
			
			return tween;
		}
	}
}