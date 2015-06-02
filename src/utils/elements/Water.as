package utils.elements
{
	
	//----------------------------------------------------------------------
	// Imports
	//----------------------------------------------------------------------
	
	import character.Player;
	import se.lnu.stickossdk.display.DisplayStateLayer;
	
	public class Water extends Element
	{
		
		//----------------------------------------------------------------------
		// Conbstructor
		//----------------------------------------------------------------------
		
		/**
		 * Skickar med grafiken för elementet
		 * till superklassen.
		 */
		public function Water()
		{
			super(Potions_Health_Rotate_GFX);
		}
		
		/**
		 * Överskriver superklassens activate metod.
		 * Uppdaterar värden i superklassen till player.
		 */
		override public function activate(currentPlayer:Player, tag:DisplayStateLayer, numPlayer:int):void {
			target = tag;
			player = currentPlayer;
			player.hp = 100;
			removeSkin();
			elementTimer();
			setHudElement(Potions_Health_Idle_GFX, numPlayer);
			setElementEffect("Full HP");
		}
	}
}

