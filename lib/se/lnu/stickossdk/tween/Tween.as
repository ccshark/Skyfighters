package se.lnu.stickossdk.tween {
	
	//-----------------------------------------------------------
	// Public class
	//-----------------------------------------------------------
	
	import se.lnu.stickossdk.system.Session;
	import se.lnu.stickossdk.tween.easing.Sine;
	import se.lnu.stickossdk.util.ObjectUtils;
	
	//-----------------------------------------------------------
	// Public class
	//-----------------------------------------------------------
	
	/**
	 *	Tween-klassen representerar ett objekt som interpoleras. 
	 *	Interpoleringen gör det möjligt att påverka en eller 
	 *	flera egenskaper hos objektet.
	 *
	 *	@version	1.0
	 *	@copyright	Copyright (c) 2012-2014.
	 *	@license	Creative Commons (BY-NC-SA)
	 *	@since		2014-01-15
	 *	@author		Henrik Andersen <henrik.andersen@lnu.se>
	 */
	public class Tween {
		
		//-------------------------------------------------------
		// Public properties
		//-------------------------------------------------------
		
		/**
		 *	Om tween-objektet är pausat eller inte.
		 * 
		 *	@default false
		 */
		public var paused:Boolean;
		
		//-------------------------------------------------------
		// Public getter and setter methods
		//-------------------------------------------------------
		
		/**
		 *	Ett objekt innehållande de egenskaper som ska 
		 *	animeras med tween-objektet. Objektet innehåller 
		 *	inte egenskaper som är reserverade av tween-motorn 
		 *	(onComplete, onUpdate, duration, osv..). Objektet 
		 *	fungerar som ett inställningsobjekt för en 
		 *	interpolering (Tween).
		 */
		public function get arguments():Object {
			return _argument;
		}
		
		/**
		 *	Objektet vars värden ska interpoleras.
		 */
		public function get object():Object {
			return _objectCurrent;
		}
		
		/**
		 *	Antalet egenskaper som är under förvandling. När 
		 *	resultatet når noll är interpoleringen färdig.
		 */
		public function get numActiveTweens():int {
			return _propertyList.length;
		}
		
		//-------------------------------------------------------
		// Private getter and setter methods
		//-------------------------------------------------------
		
		/**
		 *	Tidstämpel för den tidpunkt då interpoleringen 
		 *	påbörjades. Starttiden är relativ till 
		 *	interpoleringens aktiva tid.
		 */
		private function get _tweenStart():Number {
			return Session.application.time.timeOfCurrentFrame - _activeTimeElapsed;
		}
		
		/**
		 *	Tidstämpel för den tidpunkt då interpoleringen 
		 *	beräknas vara färdig. Sluttiden är relativt till 
		 *	interpoleringens aktiva tid.
		 */
		private function get _tweenEnd():Number {
			return Session.application.time.timeOfCurrentFrame + (_duration - _activeTimeElapsed);
		}
		
		//-------------------------------------------------------
		// Private properties
		//-------------------------------------------------------
		
		/**
		 *	Ett objekt innehållande de egenskaper som ska 
		 *	animeras med tween-objektet. Objektet innehåller 
		 *	inte egenskaper som är reserverade av tween-motorn 
		 *	(onComplete, onUpdate, duration, osv..).
		 * 
		 *	@default null
		 */
		private var _argument:Object;
		
		/**
		 *	Tiden det tar för interpoleringen att slutföras. 
		 *	Tidsenheten som används är millisekunder och 
		 *	standardtiden är en sekund (1000).
		 * 
		 *	@default 1000
		 */
		private var _duration:Number = 1000;
		
		/**
		 *	Referens till objektet vars egenskaper ska 
		 *	interpoleras.
		 * 
		 *	@default null
		 */
		private var _objectCurrent:Object;
		
		/**
		 *	En klon av objektet som ska interpoleras. Klonen 
		 *	skapas innan interpoleringen påbörjas. Objektet 
		 *	fungerar som en säkerhetskopia över hur objektet såg 
		 *	ut i det initiala skedet.
		 * 
		 *	@default null
		 */
		private var _objectInitial:Object;
		
		/**
		 *	Lista innehållande samtliga egenskaper som påverkas 
		 *	av interpoleringen. Varje egenskap består av ett 
		 * 	TweenObject.
		 * 
		 *	@default Vector
		 */
		private var _propertyList:Vector.<TweenProperty> = new Vector.<TweenProperty>();
		
		/**
		 *	Referens till en "Ease-metod". Metoden används för 
		 *	att påverka interpoleringens hastighet och 
		 *	acceleration. 
		 * 
		 *	@default null
		 */
		private var _transition:Function;
		
		/**
		 *	Beräknar under hur lång tid interpoleringen har varit 
		 *	aktiv. Tidsenheten som används är millisekunder.
		 * 
		 *	@default 0
		 */
		private var _activeTimeElapsed:Number = 0;
		
		/**
		 *	Återuppringningsmetod (callback) som aktiveras när 
		 *	interpoleringen är klar. Metoden är valbar och 
		 *	aktiveras enbart då det finns en giltig referens.
		 * 
		 *	@default null
		 */
		private var _onComplete:Function;
		
		//-------------------------------------------------------
		// Constructor method
		//-------------------------------------------------------
		
		/**
		 *	Skapar en ny instans av Tween.
		 * 
		 *	@param	object		...
		 *	@param	argument	...
		 */
		public function Tween(object:Object, argument:Object) {
			_objectCurrent 	= object;
			_objectInitial	= ObjectUtils.clone(object);
			_argument 		= argument;
			_transition 	= argument.transition || Sine.easeInOut;
			_duration 		= _argument.duration;
			_onComplete    	= _argument.onComplete;
			
			triggerCallback(_argument.onInit);
			removeReservedArguments();
			createPropertyTween();
		}
		
		//-------------------------------------------------------
		// Public methods
		//-------------------------------------------------------
		
		/**
		 *	Uppdaterar den aktuella interpoleringens 
		 *	underliggande objekt.
		 * 
		 *	@return void
		 */
		public function update():void {
			if (paused == false) {
				_activeTimeElapsed += Session.application.time.timeSinceLastFrame;
				updateTweens();
			}
		}
		
		/**
		 *	Tar bort objekt och deallokerar minne som allokerats 
		 *	av objektet.
		 * 
		 *	@return void
		 */
		public function dispose():void {
			disposeTweenProperties();
			_argument = null;
			_objectCurrent = null;
			_objectInitial = null;
		}
		
		//-------------------------------------------------------
		// Private methods
		//-------------------------------------------------------
		
		/**
		 *	Aktiverar en återuppringningsmetod (callback), 
		 *	förutsatt att metoden finns tillgänglig.
		 * 
		 *	@param	callback	Återuppringningsmetoden.
		 * 
		 *	@return void
		 */
		private function triggerCallback(callback:Function):void {
			if (callback is Function) {
				callback();
			}
		}
		
		/**
		 *	Tar bort egenskaper från inställningsobjektet som är 
		 *	reserverade av interpoleringsmotorn. 
		 * 
		 *	@return void
		 */
		private function removeReservedArguments():void {
			var reservedArguments:Object = {
				duration	: null, 
				transition	: null,
				onComplete	: null,
				onInit		: null
			};
			
			for (var property:String in reservedArguments) {
				delete _argument[property];
			}
		}
		
		/**
		 *	Skapar ett nytt egenskapsobjekt (TweenProperty) för 
		 *	varje egenskap som ska interpoleras. Objektet 
		 *	innehåller information för att kunna genomföra 
		 *	interpoleringen, exempelvis som start- och 
		 *	slutvärden.
		 * 
		 *	@return void
		 */
		private function createPropertyTween():void {
			for (var property:String in _argument) {
				if (_objectInitial[property] !== _argument[property]) {
					createTweenProperty(property);
				}
			}
		}
		
		/**
		 *	Skapar ett nytt inställningsobjekt (TweenProperty) 
		 *	för en egenskap som ska interpoleras.
		 * 
		 *	@param	name	Namn på egenskapen som ska interpoleras.
		 * 
		 *	@return void
		 */
		private function createTweenProperty(name:String):void {
			var propertyTween:TweenProperty = new TweenProperty(
				name,
				_objectInitial[name],
				_argument[name]
			);
			
			_propertyList.push(propertyTween);
		}
		
		/**
		 *	...
		 * 
		 *	@return void
		 */
		private function updateTweens():void {
			var i:int = 0;
			for (i = 0; i < _propertyList.length; i++) {
				updateTween(i);
			}
		}
		
		/**
		 *	Uppdaterar en specifik egenskap i 
		 *	interpoleringsprocessen. Om en egenskap har nått sin 
		 *	slutpunkt tar metoden bort och deallokerar 
		 *	egenskapen.
		 * 
		 *	@param	index	Index för egenskapen.
		 * 
		 *	@return void
		 */
		private function updateTween(index:int):void {
			if (Session.application.time.timeOfCurrentFrame < _tweenEnd) updateTweenProperty(index);
			else completeTweenProperty(index);
		}
		
		/**
		 *	Genomför beräkningarna för interpoleringen. Metoden 
		 *	beräknar förflyttningen för en specifik egenskap. 
		 *	Resultatet anges alltid som ett decimaltal (Number).
		 * 
		 *	@param	index	Index för egenskapen.
		 * 
		 *	@return void
		 */
		private function updateTweenProperty(index:int):void {
			var p:Object = _propertyList[index];
			var t:Number = _activeTimeElapsed;
			var b:Number = p.valueStart;
			var c:Number = p.valueComplete - p.valueStart;
			var d:Number = _tweenEnd - _tweenStart;
			var v:Number = _transition(t, b, c, d);
			
			_objectCurrent[p.name] = v;
		}
		
		/**
		 *	Färdigställer interpoleringsprocessen hos en 
		 *	egenskap. Metoden aktiverar återupprigningsmetoden, 
		 *	om den finns tillgänglig.
		 * 
		 *	@param	index	Index för egenskapensinställningen.
		 * 
		 *	@return void
		 */
		private function completeTweenProperty(index:int):void {
			var p:Object = _propertyList[index];
			_objectCurrent[p.name] = p.valueComplete;
			disposeTweenProperty(index);
			triggerCallback(_onComplete);
		}
		
		/**
		 *	Tar bort och deallokerar samtliga registrerade 
		 *	egenskapsinställningar.
		 * 
		 *	@return void
		 */
		private function disposeTweenProperties():void {
			for (var i:int = 0; i < _propertyList.length; i++) {
				disposeTweenProperty(i);
			}
			
			_propertyList.length = 0;
		}
		
		/**
		 *	Tar bort och deallokerar en specifik 
		 *	egenskapsinställning.
		 * 
		 *	@param	index	Index för egenskapensinställningen.
		 * 
		 *	@return void
		 */
		private function disposeTweenProperty(index:int):void {
			_propertyList[index].dispose();
			_propertyList[index] = null;
			_propertyList.splice(index, 1);
		}
	}
}