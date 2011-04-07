package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	public class color_match extends Sprite {
		private var first_tile:colors;
		private var second_tile:colors;
		private var pause_timer:Timer;
		//private var maxX:int=5;
		//private var maxY:int=4;
		private var maxRows:int=4;
		private var maxCols:int=5;
		private var tileX:int=32;
		private var tileY:int=32;
		private var moveSpeed:Number=100000;
		private var equalCount:int=0;
		private var maxTileCount=0;
		private var similarTiles:Array;
		
		
		//var colordeck:Array = new Array(1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8);
		var colordeck:Array = new Array(1,1,2,2,3,3);
		public function color_match() {
			
			maxTileCount=maxRows*maxCols;
			var i:int=0;
			for (x=1; x<=5; x++) {
				for (y=1; y<=maxCols; y++) {
					var random_card = Math.floor(Math.random()*colordeck.length);
					var tile:colors = new colors();
					tile.col = colordeck[random_card];
					
					tile.x_index=x;
					tile.y_index=y;
					
					//tile.col2 = 2; //colordeck[random_card];
					//colordeck.splice(random_card,1);
					//tile.gotoAndStop(9);
					tile.gotoAndStop(tile.col);
					tile.height=tileX;
					tile.width=tileY;
					
					tile.x = (x-1)*tileX;
					tile.y = (y-1)*tileY;
					
					tile.tileIndex=i;
					tile.addEventListener(MouseEvent.CLICK,tile_clicked);
					addChild(tile);
					i=i+1;
				}
			}
			pause_timer = new Timer(moveSpeed,1);
			pause_timer.addEventListener(TimerEvent.TIMER_COMPLETE,moveTiles);
			pause_timer.start();
		}
		
		public function tile_clicked(event:MouseEvent) {
/*		
				pause_timer = new Timer(1000,1);
				pause_timer.addEventListener(TimerEvent.TIMER_COMPLETE,remove_tiles);
*/
			// paskatamies sev apkaart
			// ja nav neviena 
	
			similarTiles=new Array();
			var clicked:colors = (event.currentTarget as colors);
			equalCount=0;
			similarTiles.push(clicked);
			
			// need to check i+-1
			// i+-row_len
			
			lookAdjancedTiles(clicked);
			
			//targetCol(clicked.col,this.getChildAt(i).col)
			//this.getChildAt(i));
			trace ("vienaadas lietas"+ equalCount +" masiivaa " + similarTiles.length );
			
		}
		
		public function lookAdjancedTiles(tile:colors){
			var i:int=0;
			var adjancedTile:colors;
			
			var currIndex:int= tile.tileIndex;
			i=currIndex+1;
			trace("lookAdjancedTiles index-"+ currIndex);
			if (i<maxTileCount && (tile.y_index!=(maxCols)) &&  compareTiles(tile,i)){  //(clicked.col==this.getChildAt(i).col))
				trace ("tile on below equal "+i +" y index "+tile.y_index );
				equalCount=equalCount+1;
				// TODO: remove duplicate code
				adjancedTile=this.getChildAt(i) as colors;
				if (canRecurse(adjancedTile))
					this.lookAdjancedTiles(adjancedTile);
			}
			
			i=currIndex-1;
			if (i>0 &&  (tile.y_index!=1) && compareTiles(tile,i)){  //(clicked.col==this.getChildAt(i).col))
				trace ("tile on above equal "+i +" y index "+tile.y_index );
				equalCount=equalCount+1;
				// TODO: remove duplicate code
				adjancedTile=this.getChildAt(i) as colors;
				if (canRecurse(adjancedTile))
					lookAdjancedTiles(adjancedTile);
			}
			i=currIndex-maxCols;
			if (i>0 && compareTiles(tile,i)){  //(clicked.col==this.getChildAt(i).col)){
				trace ("tile on left equal "+i );
				equalCount=equalCount+1;
				// TODO:  remove duplicate code
				adjancedTile=this.getChildAt(i) as colors;
				if (canRecurse(adjancedTile))
					lookAdjancedTiles(adjancedTile);
				
			}
			i=currIndex+maxCols;
			if (i<maxTileCount && compareTiles(tile,i)){ // (clicked.col==this.getChildAt(i).col)){
				trace ("tile on right equal "+i );
				equalCount=equalCount+1;
				// TODO: remove duplicate code
				adjancedTile=this.getChildAt(i) as colors;
				//trace("adjancedTile "+adjancedTile);
				if (canRecurse(adjancedTile))
					lookAdjancedTiles(adjancedTile);
			}
		}
		
		public function canRecurse(tile:colors):Boolean{
			trace("can recurse start" +tile.tileIndex );
			
			for (var i:int=0;i<similarTiles.length;i++){
				trace("canRecurse" + i+"-" + similarTiles[i].tileIndex + " current tile "+tile.tileIndex);
				if (similarTiles[i].tileIndex ==tile.tileIndex) return false;
			}
			similarTiles.push(tile);
			trace ("appended to tile list " + tile.tileIndex);
			// this tile is not yet added to tile list
			return true;
		}
		
		private function compareTiles(sourceTile:colors, targetIndex:int){
			var targetCol:colors= this.getChildAt(targetIndex) as colors;
			
		
			if (sourceTile.col==targetCol.col) return true;
			return false;
		}
		
		
		
		private function moveTiles(event:TimerEvent):void{
			trace("moving tiles");
			
			var i:int = 0;
			for (i = 0; i<this.numChildren; i++)
			{
				//this.getChildAt(i).y=this.getChildAt(i).y+tileY;
				this.getChildAt(i).x=this.getChildAt(i).x+tileX;
			}
			pause_timer.reset();
			pause_timer.start();
		}
		
		
		
		public function reset_tiles(event:TimerEvent) {
			first_tile.gotoAndStop(9);
			second_tile.gotoAndStop(9);
			first_tile = null;
			second_tile = null;
			pause_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,reset_tiles);
		}
		public function remove_tiles(event:TimerEvent) {
			removeChild(first_tile);
			removeChild(second_tile);
			first_tile = null;
			second_tile = null;
			pause_timer.removeEventListener(TimerEvent.TIMER_COMPLETE,remove_tiles);
		}
		
		
		
		
	}
}