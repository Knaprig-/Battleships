package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.engine.BreakOpportunity;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Gustav Grännsjö
	 */
	public class Main extends Sprite 
	{
		
		
		public var boatVector:Vector.<int> = new Vector.<int>;
		public static var mapVector:Vector.<Vector.<MyTile>> = new Vector.<Vector.<MyTile>>;
		public static var scoreBox:TextField = new TextField();
		public static var hits:int = 0;
		public static var misses:int = 0;
		public static var firstSpawn:Boolean = true;
			
		public static var twosDestroyed:int = 0;
		public static var threesDestroyed:int = 0;
		public static var foursDestroyed:int = 0;
		public static var sixesDestroyed:int = 0;
		
		public const MAP_HEIGHT:int = 10;
		public const MAP_WIDTH:int = 10;
		public const TILE_SIDE:int = 32;
		
		public var keyHolder:Boolean = true;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, spacePressed);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, showBoats);
			stage.addEventListener(KeyboardEvent.KEY_UP, hideBoats);
			
			var backgroundImage:Sprite = new Sprite();
			backgroundImage.graphics.beginFill(0x000000);
			backgroundImage.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight)
			backgroundImage.graphics.endFill();
			addChild(backgroundImage);
			
			boatVector.push(6); //Specifies the amount and length of the different boats
			boatVector.push(4);
			boatVector.push(4);
			boatVector.push(3);
			boatVector.push(3);
			boatVector.push(2);
			boatVector.push(2);
			boatVector.push(2);
			boatVector.push(2);
			
			
			
			spawnScoreBox();
		}
		
		public function spacePressed(key:KeyboardEvent):void //This starts up everything that should happen when you press space. It clears the board, makes a new board, makes boats, resets the score.
		{
			if (key.keyCode == 32) 
			{
				clearMapVector();
				populateMapVector();
				spawnBoats();
				hits = 0;
				misses = 0;
				twosDestroyed = 0;
				threesDestroyed = 0;
				foursDestroyed = 0;
				sixesDestroyed = 0;
				updateScore();
			}
		}
		
		public function spawnScoreBox():void //Sets the initial settings for the scorebox.
		{
			scoreBox.y = 10;
			scoreBox.x = 350;
			scoreBox.text = "Hits: " + String(hits) + "\n\nMisses: " + String(misses) + "\n\nDestroyers destroyed: " + String(Main.twosDestroyed) + "\nCruisers destroyed: " + String(threesDestroyed) + "\nBattleships destroyed: " + String(foursDestroyed) + "\nAircraft Carriers destroyed: " + String(sixesDestroyed);
			scoreBox.border = true;
			scoreBox.width = 150;
			scoreBox.height = 329; //(the same height as the tiles)
			scoreBox.background = true;
			scoreBox.backgroundColor = 0x0000A0;
			scoreBox.selectable = false;
			addChild(scoreBox);
		}
		
		public function spawnBoats():void 
		{
			for each (var boatLength:int in boatVector) //To make sure that it runs this for each boat we've specified.
			{
				var tempY:int
				var tempX:int
				var horizontal:Boolean = true;
				var collisionCheck:Boolean = false;
				var coinFlip:Number = Math.random(); //This thing decides if it's going to be horizontal or not.
				if (coinFlip > 0.5)
				{
					horizontal = false;
				}
				
				if (!horizontal)
				{
					while (collisionCheck == false) //This while loop will find a random value and see if the boat can be placed there, if not, it will keep looping.
					{
						tempX = Math.random() * (mapVector[0].length);
						tempY = Math.random() * ((mapVector.length) - (boatLength - 1)); //The second clause here is to make sure that the boat won't be jutting out of the board, so we limit how far down it can spawn.
						
						collisionCheck = true; //Just to escape the while loop unless the for loop just below changes things up
						
						for (var p:int = 0; p < boatLength; p++) //The actual collision test
						{
 							if ((mapVector[tempY + p][tempX].containsBoat == true) || (mapVector[tempY + p][tempX].isForbidden == true)) //Checks each tile the boat would inhabit, and if there already is a boat there (Or one right next to that tile), make the while loop keep looping.
							{
								collisionCheck = false;
								break;
							}
						}
					}
					
					
					
					for (var k:int = 0; k < boatLength; k++) //Makes the boat after we've decided a spot to start. 
					{
						var boatSection:int; //This is so that we know what part of the ship we're working with now.
						if (k == 0) 
						{
							boatSection = 1; //(First part)
						}
						else if (k == boatLength - 1) 
						{
							boatSection = 3; //(End part)
						}
						else 
						{
							boatSection = 2; //(Any middle part.)
						}
						
						mapVector[tempY + k][tempX].becomeBoat(tempX, tempY + k, boatSection, horizontal); //Puts a boat into the current tile
						
						if (k == 0) //We need to make an instance of the BoatHandler class that will notify us of the status of the ship.
						{
							var boaty:BoatHandler = new BoatHandler(); //The first time we want to make a fully new boat handler
							boaty.addPiece(mapVector[tempY + k][tempX]);
						}
						else 
						{
							boaty.addPiece(mapVector[tempY + k][tempX]); //After that, just push in the other parts.
						}
					}
				}
				else //Else do the whole same thing for Horizontal boats
				{
					
					while (collisionCheck == false) 
					{
						tempX = (Math.random() * (mapVector[0].length - (boatLength - 1)));
						tempY = (Math.random() * mapVector.length);
						
						collisionCheck = true;
						
						for (var u:int = 0; u < boatLength; u++)
						{
 							if ((mapVector[tempY][tempX + u].containsBoat == true) || (mapVector[tempY][tempX + u].isForbidden == true)) 
							{
								collisionCheck = false;
								break;
							}
						}
					}
					
					if (collisionCheck)
					{
						for (var j:int = 0; j < boatLength; j++) 
						{
							var boatSection2:int; //This is so that we know what part of the ship we're working with now.
							if (j == 0) 
							{
								boatSection2 = 1; //(First part)
							}
							else if (j == boatLength - 1) 
							{
								boatSection2 = 3; //(End part)
							}
							else 
							{
								boatSection2 = 2; //(Any middle part.)
							}
							
							mapVector[tempY][tempX + j].becomeBoat(tempX + j, tempY, boatSection2, horizontal);
							
							if (j == 0)
							{
								var boaty2:BoatHandler = new BoatHandler();
								boaty2.addPiece(mapVector[tempY][tempX + j]);
							}
							else 
							{
								boaty2.addPiece(mapVector[tempY][tempX + j]);
							}
						}
					}
					
				}
				
			}
		}
		
		public function clearMapVector():void //We want to clear the vectors so that when we reset the game the old tiles aren't lying in the way.
		{
			
			for each (var row:Vector.<MyTile> in mapVector) //Simple enough, this will first clear out the nestled vectors
			{
				while (row.length > 0) 
				{
					removeChild(row[0]);
					row.splice(0, 1);
				}
			}
			while (mapVector.length > 0) //And then clear out the main Vector.
			{
				mapVector.splice(0, 1);
			}
		}
		
		public function populateMapVector():void //This function puts vectors inside a vector, to let us use coordinates for each tile. Also populates all the vectors with tiles.
		{
			for (var i:int = 0; i < MAP_HEIGHT; i++) //This creates the Y coordinates
			{
				var mapRow:Vector.<MyTile> = new Vector.<MyTile>;
				
				for (var j:int = 0; j < MAP_WIDTH; j++) //And this all the X coordinates
				{
					var waterTile:MyTile = new MyTile(); //And this finally puts a tile into the coordinate system.
					waterTile.x = 10 + ((TILE_SIDE + 1) * j); //The length of a tile is 32, I use 33 to make a white border between each tile.
					waterTile.y = 10 + ((TILE_SIDE + 1) * i);
					
					addChild(waterTile);
					mapRow.push(waterTile);
				}
				mapVector.push(mapRow);
			}
			
		}
		
		public static function updateScore(hitIncrease:int = 0, missIncrease:int = 0):void //I made this function so that I could update the scoreboard without using an enter-frame loop, also made it static so that I could change the score from anywhere.
		{
			hits += hitIncrease; //Increases our variables by the amount sent into the function.
			misses += missIncrease;
			scoreBox.text = "Hits: " + String(hits) + "\n\nMisses: " + String(misses) + "\n\nDestroyers destroyed: " + String(Main.twosDestroyed) + "\nCruisers destroyed: " + String(threesDestroyed) + "\nBattleships destroyed: " + String(foursDestroyed) + "\nAircraft Carriers destroyed: " + String(sixesDestroyed);
		}
		
		public function showBoats(key:KeyboardEvent):void //Show all boats when you press down f2
		{
			if (key.keyCode == 113 && keyHolder == true)
			{
				keyHolder = false;
				for each (var tempRow:Vector.<MyTile> in mapVector)
				{
					for each (var tempTile:MyTile in tempRow) 
					{
						tempTile.showBoat();
					}
				}
			}
		}
		
		public function hideBoats(key:KeyboardEvent):void //Then hide them again when you release f2
		{
			if (key.keyCode == 113 && keyHolder == false)
			{
				keyHolder = true;
				for each (var tempRow:Vector.<MyTile> in mapVector)
				{
					for each (var tempTile:MyTile in tempRow) 
					{
						tempTile.showBoat();
					}
				}
			}
		}
		
		
		
		/*          
		 *                ____________
		 *               |Utvärdering!|   
		 *                ¯¯¯¯¯¯¯¯¯¯¯¯
		 * 
		 * Jag skulle kunna få programmet att fungera
		 * bättre genom att göra så att den till exempel
		 * själv tar reda på antalet skepp och längd på dem
		 * när den gör rutan med poäng, det är lite
		 * för hårdkodat just nu då den bara accepterar
		 * skepp med längden 2, 3, 4 eller 6 om man
		 * vill att den skall visa hur många skepp
		 * du sänkt.
		 * 
		 * Ett annat problem är det att jag använder 
		 * enter-frame-loops i min boathandlerklass
		 * när den egentligen bara behöver kolla integriteten
		 * på skeppet varje gång man klickar på en tile.
		 * Hade jag istället sett till så att varje tile
		 * visste vilken boathandler den hade kunde jag undvika
		 * onödig processorutrymme.
		 * 
		 * Men med tanke på att det skulle innebära väldigt
		 * mycket extra kod för en ganska minimal ökning
		 * valde jag att skippa det då jag ändå sett
		 * till att den iallafall slutar loopa om skeppet
		 * är sönder, så även när man startar om spelet
		 * ligger det inte massa bortglömda enter-frame-loopar
		 * i bakgrunden.
		 * 
		 *                _____________
		 *               |Uppdatering 1|   
		 *                ¯¯¯¯¯¯¯¯¯¯¯¯¯
		 * Jag har nu ändrat så att om man håller ner f2
		 * så visas alla skepp, så att det är enklare
		 * att se vart alla skepp spawnade.
		 * 
		 * Koden kollar nu om ett skepp är förstörd endast 
		 * efter att spelaren tryckt på ett skepp, istället
		 * för varje frame som det var tidigare. Den kollar
		 * inte ens om man klickar på vatten då det inte
		 * fyller någon funktion.
		 * 
		 */
	}
	
}