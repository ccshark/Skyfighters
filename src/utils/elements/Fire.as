package utils.elements
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import character.Player;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	public class Fire extends Element
	{

		
		//----------------------------------------------------------------------
		// Constructor
		//----------------------------------------------------------------------
		
		/**
		 * Skickar med grafiken för elementet
		 * till superklassen.
		 */
		public function Fire()
		{
			super(Potions_Damage_Rotate_GFX);
		}
		
		/**
		 * Överskriver superklassens activate metod.
		 * Uppdaterar värden i superklassen till player.
		 */
		override public function activate(currentPlayer:Player, tag:DisplayStateLayer, numPlayer:int):void {
			target = tag;
			player = currentPlayer;
			player.damage = 50;
			removeSkin();
			elementTimer();
			setHudElement(Potions_Damage_Idle_GFX, numPlayer);
			setElementEffect("2x damage");
		}
	}
}

