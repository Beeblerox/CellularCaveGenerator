package source;

/**
 * Cave Generator With Cellular Automata
 * Gamedevtuts+ Tutorial Code
 * Code partly by Michael Cook - @mtrc on Twitter
 * With thanks to Christer Kaitilia - @mcfunkypants!
 * Read the full tutorial:
 * http://gamedev.tutsplus.com/tutorials/implementation/cave-levels-cellular-automata

 * Permission is granted to use this source in any
 * way you like, commercial or otherwise. Enjoy!

 * 
 * 
 * This is just a Haxe port made by Zaphod
 */
class CaveGenerator
{
	// the world grid: a 2d array of tiles
	public var cellMap:Array<Array<Int>>;
	
	// size in the world in sprite tiles
	public var worldWidth:Int = 48;
	public var worldHeight:Int = 48;
	
	/**
	 Variables we can use to tweak our demo!
	 */
	public var chanceToStartAlive:Float = 0.4;
	public var deathLimit:Int = 3;
	public var birthLimit:Int = 4;
	public var numberOfSteps = 2;
	
	public function new() {  }
	
	public function generateMap():Array<Array<Int>>
	{
		//Create a new map
		cellMap = new Array<Array<Int>>();
		//Set up the map with random values
		cellMap = initialiseMap(cellMap);
		
		//And now run the simulation for a set number of steps
		for (i in 0...numberOfSteps)
		{
			cellMap = doSimulationStep(cellMap);
		}
		
		return cellMap;
	}
	
	private function initialiseMap(map:Array<Array<Int>>):Array<Array<Int>>
	{
		for (x in 0...worldWidth)
		{
			map[x] = new Array<Int>();
			for (y in 0...worldHeight)
			{
				map[x][y] = (Math.random() < chanceToStartAlive) ? 1 : 0;
			}
		}
		
		return map;
	}
	
	private function doSimulationStep(oldMap:Array<Array<Int>>):Array<Array<Int>>
	{
		//Here's the new map we're going to copy our data into
		var newMap:Array<Array<Int>> = new Array<Array<Int>>();
		//Loop over each row and column of the map
		for (x in 0...oldMap.length)
		{
			newMap[x] = new Array<Int>();
			
			for (y in 0...oldMap[0].length)
			{
				var nbs:Int = countAliveNeighbours(oldMap, x, y);
				//The new value is based on our simulation rules
				//First, if a cell is alive but has too few neighbours, kill it.
				if (oldMap[x][y] > 0)
				{
					//See if it should die
					if (nbs < deathLimit)
					{
						newMap[x][y] = 0;
					}
					//Otherwise keep it solid
					else
					{
						newMap[x][y] = 1;
					}
				} //Otherwise, if the cell is dead now, check if it has the right number of neighbours to be 'born'
				else
				{
					if (nbs > birthLimit)
					{
						newMap[x][y] = 1;
					}
					else
					{
						newMap[x][y] = 0;
					}
				}
			}
		}
		
		return newMap;
	}
	
	//Returns the number of cells in a ring around (x,y) that are alive.
	private function countAliveNeighbours(map:Array<Array<Int>>, x:Int, y:Int):Int
	{
		var count:Int = 0;
		for (i in ( -1)...2)
		{
			for (j in ( -1)...2)
			{
				var neighbourX:Int = x + i;
				var neighbourY:Int = y + j;
				//If we're looking at the middle point
				if (i == 0 && j == 0)
				{
					//Do nothing, we don't want to add ourselves in!
				}
				//In case the index we're looking at it off the edge of the map
				else if (neighbourX < 0 || neighbourY < 0 || neighbourX >= map.length || neighbourY >= map[0].length)
				{
					count = count + 1;
				}
				//Otherwise, a normal check of the neighbour
				else if (map[neighbourX][neighbourY] > 0)
				{
					count = count + 1;
				}
			}
		}
		
		return count;
	}
	
	/**
	 * Extra credit assignment! Let's loop through the
	 * map and place treasure in the nooks and crannies.
	 * 
	 * @param	world					Map to place treasures on
	 * @param	treasureHiddenLimit		How hidden does a spot need to be for treasure? I find 5 or 6 is good. 6 for very rare treasure.
	 */
	public function placeTreasure(world:Array<Array<Int>>, treasureHiddenLimit:Int = 5):Void
	{
		for (x in 0...worldWidth)
		{
			for (y in 0...worldHeight)
			{
				if (world[x][y] == 0)
				{
					var nbs:Int = countAliveNeighbours(world, x, y);
					if (nbs >= treasureHiddenLimit)
					{
						world[x][y] = 2;
					}
				}
			}
		}   
	}
}