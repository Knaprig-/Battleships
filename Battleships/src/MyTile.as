package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Gustav Grännsjö
	 */
	public class MyTile extends Sprite
	{
		[Embed(source = "../lib/Water.png")]
		public var waterBmp:Class;
		[Embed(source = "../lib/Miss.png")]
		public var missBmp:Class;
		[Embed(source="../lib/VerStart.png")]
		public var vertStartBmp:Class;
		[Embed(source = "../lib/VerMiddle.png")]
		public var vertMiddleBmp:Class;
		[Embed(source = "../lib/VerEnd.png")]
		public var vertEndBmp:Class;
		[Embed(source = "../lib/HorStart.png")]
		public var horStartBmp:Class;
		[Embed(source = "../lib/HorMiddle.png")]
		public var horMiddleBmp:Class;
		[Embed(source = "../lib/HorEnd.png")]
		public var horEndBmp:Class;
		
		public var waterImage:Bitmap = new waterBmp(); //I make three different images and then put them on top of each other.
		public var hitImage:Bitmap = new horStartBmp();
		public var missImage:Bitmap = new missBmp();
		public var containsBoat:Boolean = false;
		public var isClicked:Boolean = false;
		public var isForbidden:Boolean = false;
		public var myHandler:BoatHandler;
		
		public function MyTile() 
		{
			addChild(waterImage);
			addChild(hitImage);
			addChild(missImage);
			
			missImage.visible = false; //Here I make sure only the Water image is visible
			hitImage.visible = false;
			
			//this.addEventListener(Event.ENTER_FRAME, showBoat);
			this.addEventListener(MouseEvent.CLICK, tileHit);
		}
		
		//This was used for testing purposes so I could see where the boats were spawned.
		public function showBoat():void 
		{
			if ((containsBoat == true) && (isClicked == false) && (hitImage.visible == false))
			{
				missImage.visible = false;
				hitImage.visible = true;
				waterImage.visible = false;
			}
			else if (isClicked == false)
			{
				missImage.visible = false;
				hitImage.visible = false;
				waterImage.visible = true;
			}
		}
		
		public function becomeBoat(currX:int, currY:int, boatSection:int, horizontal:Boolean):void //Self-explanatory
		{
			containsBoat = true;
			
			// This draws the correct image for the tile.
			if (boatSection == 1 && horizontal == true) 
			{
				hitImage = new horStartBmp();
				addChild(hitImage);
			}
			if (boatSection == 2 && horizontal == true) 
			{
				hitImage = new horMiddleBmp();
				addChild(hitImage);
			}
			if (boatSection == 3 && horizontal == true) 
			{
				hitImage = new horEndBmp();
				addChild(hitImage);
			}
			
			//For vertical boats
			if (boatSection == 1 && horizontal == false) 
			{
				hitImage = new vertStartBmp();
				addChild(hitImage);
			}
			if (boatSection == 2 && horizontal == false) 
			{
				hitImage = new vertMiddleBmp();
				addChild(hitImage);
			}
			if (boatSection == 3 && horizontal == false) 
			{
				hitImage = new vertEndBmp();
				addChild(hitImage);
			}
			
			hitImage.visible = false;
			
			
			if (currY > 0) //All these ifs are to make sure no boat can spawn next to this one by making them forbidden. If you remember, we didn't allow any boat to spawn on a tile that was Foerbidden in the collision check in the Spawnboats function in main.
			{
				Main.mapVector[currY - 1][currX].isForbidden = true;
			}
			
			if (currY < 9)
			{
				Main.mapVector[currY + 1][currX].isForbidden = true;
			}
			
			if (currX < 9)
			{
				Main.mapVector[currY][currX + 1].isForbidden = true;
			}
			
			if (currX > 0)
			{
				Main.mapVector[currY][currX - 1].isForbidden = true;
			}
		}
		
		public function tileHit(mouse:MouseEvent):void //This handles what to do when we click on a tile.
		{
			if (isClicked == false) //Just to make sure you can't click the same tile twice.
			{
				if (containsBoat == true) //THese are all pretty self-explanatory.
				{
					missImage.visible = false;
					hitImage.visible = true;
					waterImage.visible = false;
					
					isClicked = true;
					Main.updateScore(1, 0);
					
					myHandler.checkDestruction();
				}
				else
				{
					missImage.visible = true;
					hitImage.visible = false;
					waterImage.visible = false;
					
					isClicked = true;
					Main.updateScore(0, 1);
				}
			}
		}
		
		public function giveParent(handler:BoatHandler):void 
		{
			myHandler = handler;
		}
		
		
		
		
	}

}












/*
                             \
                              \
                               \\
                                \\
                                 >\/7
                             _.-(6'  \
                            (=___._/` \
                                 )  \ |
                                /   / |
                               /    > /
                              j    < _\
                          _.-' :      ``.
                          \ r=._\        `.
                         <`\\_  \         .`-.
                          \ r-7  `-. ._  ' .  `\
                           \`,      `-.`7  7)   )
                            \/         \|  \'  / `-._
                                       ||    .'
                                        \\  (
                                         >\  >
                                     ,.-' >.'
                                    <.'_.''
                                      <'      Sorry, Johan tvingade mig att lägga till den här
*/