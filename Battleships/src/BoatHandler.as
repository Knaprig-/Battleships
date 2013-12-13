package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author Gustav Grännsjö
	 */
	public class BoatHandler extends Sprite //This simply records the position of a ship and tells the program when it's destroyed.
	{
		public var shipVector:Vector.<MyTile> = new Vector.<MyTile>;
		public var isDestroyed:Boolean = false;
		
		
		public function BoatHandler() 
		{
			
		}
		
		public function addPiece(shipPart:MyTile):void 
		{
			shipVector.push(shipPart); //I put all the parts into my own vector here so I can keep track of all of their variables.
			shipPart.giveParent(this);
		}
		
		public function checkDestruction():void
		{
			for each (var part:MyTile in shipVector) //Här cyklar den igenom alla delar av skeppet och kollar om de är träffade än.
			{
				if (part.isClicked == true) 
				{
					isDestroyed = true; //Om alla bitar är sönder kommer variabeln vara true när den är klar.
				}
				else
				{
					isDestroyed = false;
					break; //Om inte alla delar är sönder så kommer den säga att den inte är förstörd och bryta ut. Detta fortsätter så klart tills alla bitar är sönder.
				}
			}
			
			if (isDestroyed == true) //Kollar om for-loopen innan kom fram till att skeppet var förstört.
			{
				if (shipVector.length == 2) //dessa rapporterar vilken typ av skepp som förstördes
				{
					Main.twosDestroyed ++;
				}
				if (shipVector.length == 3) 
				{
					Main.threesDestroyed ++;
				}
				if (shipVector.length == 4) 
				{
					Main.foursDestroyed ++;
				}
				if (shipVector.length == 6) 
				{
					Main.sixesDestroyed ++;
				}
				Main.updateScore();
				
				removeEventListener(Event.ENTER_FRAME, checkDestruction); //Och så ser vi till att objektet slutar att loopa på varje frame.
			}
		}
		
	}

}