package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	
	public class GameField extends MovieClip {
		
		
		const max_y:int=10;
		const max_x:int=16;
		const tile_height:int=40;
		const tile_width:int=40;
		const min_similar:int=3; //minimum number of similar tiles to count
		
		private var game_tiles:Array;
		private var similar_tiles:Array;
		private var myTimer:Timer;  
		private var scoreDisplay:GameScore;
		private var gameScore:Number=0;
		private var gameTimer:Timer;
		private var timeLeft:int=60; //how long game will last, in seconds
		
		var timer_speed:int=1500; //how fast line will go 1000=1sec, the smaller number, the faster you go
		var boomAmount:int=0;
		var max_colors:int=4;
		
		private var levelSpeeds:Array=[1500,1500,1300,17000]; //all values really starts on 1, first record is just for cenvenciance
		private var levelColors:Array=[3,3,4,4]; //
		private var levelBoom:Array=[0,0,0,0,2,2];
		
		private var gameFieldData:Array;
		
		
		public function GameField(level:int=1) {
			
			boom.visible=false;
			adjustFieldForLevel(level);
			initGameFieldData();
			addTileColumnArr();
			startGame();
		}
		
		private function initGameFieldData(){
			gameFieldData=new Array();
			var row:int=0;
			var col:int=0;
			var tile:Bricks;
			var gameFieldColum:Array;
			
			for (row=0;row<max_x;row++){
				gameFieldColum=new Array();
				for (col=0;col<max_y;col++){
					tile=new Bricks();
					createTile(tile,row,col);
					moveTile(tile,row,col);
					addChild(tile);
					gameFieldColum.push(tile);
				}
				
				gameFieldData.push(gameFieldColum);
			}
			
			
		}
		
		/**
		adjusting gamefield according to player level
		*/
		private function adjustFieldForLevel(level:int){
			timer_speed=levelSpeeds[level];
			max_colors=levelColors[level];
			boomAmount=levelBoom[level];
			
		}
		
		
		public function startGame(){
			
			game_tiles=new Array();
			//addTileRow();

			gameTimer=new Timer(1000);
			gameTimer.addEventListener(TimerEvent.TIMER, onGameTimeTick);
			gameTimer.start();


			myTimer = new Timer(timer_speed);
			myTimer.addEventListener(TimerEvent.TIMER, onTick);
			myTimer.start();
		}
		
		
		private function createTile(tile:Bricks,row:int,col:int){
			tile.row=row;
			tile.col=col;
			tile.height=tile_height;
			tile.width=tile_width;
			tile.name="tile_"+row+col; //column names are reformated according in which position they are
			tile.addEventListener(MouseEvent.CLICK,tileClicked);

		}
		
		private function moveTile(tile:Bricks,row:int,col:int){
			tile.x=row*tile_height;
			tile.y=col*tile_width;
			tile.row=row;
			tile.col=col;
			tile.name="tile_"+row+col; //column names are reformated according in which position they are
		}
		
		private function changeFrame(tile:Bricks, frameNr:int){
			tile.setFrame(frameNr);
			//tile.frame_no=frame_no;
			//tile.gotoAndStop(frame_no);
		}
		
		
		
		private function addTile(tile:Bricks){
			this.addChild(tile);
		}
		
		
		private function addTileColumnArr(start_row:int=0){
			try {
				var rnd:int;
				var tile:Bricks;
				var col:int;
				for (col=0;col<max_y ;col++){
					rnd=random_number(1,max_colors);
					tile=getTileFromArr(start_row,col);
					tile.setFrame(rnd);
				}
				
			}
			catch (err:Error) {
				trace("addTileColumnArr "+err.message); 
			}
			
		}
		
		private function getTileFromArr(row:int,col:int):Bricks{
			try {
				var tile:Bricks;
				tile=(gameFieldData[row][col] as Bricks);
				if (tile) return tile;
			}
			catch (err:Error) {
				trace("error "+err.message); 
				return null;
			}
			return null;
			
		}
		
		private function moveRightArr(){
			try {
				var row:int;
				var col:int;
				var tile:Bricks;
				var tile2:Bricks;
				var start_row:int=max_x-1;
				
				for (row=start_row;row>0;row--){
					for (col=0;col<max_y ;col++){
						tile=getTileFromArr(row,col);
						tile2=getTileFromArr(row-1,col);
						tile.setFrame(tile2.getFrame());
						//tile.setFrame(2);

					}
				}
			}
			catch(err:Error){
				trace("moveRightArr "+ err.message);
			}
		}
		
		
		

/**
try/ catch template

	try {
		}
		
	}
	catch (err:Error) {
		trace("error "+err.message); 
	}


*/



		
		
		
/*		
		private function addTileRow(start_col:int=0){
			var y:int=0;
			var tile:Bricks;
			var rnd:int;
			

			for (y=0;y<max_y ;y++){
				tile =new Bricks();
				createTile(tile,start_col,y);
				moveTile(tile,start_col,y);
				rnd=Math.floor(Math.random() * (1+max_colors-1)) + 1;
				changeFrame(tile,rnd);
				addTile(tile);
			}

		}
		
		private function addTileColumn(start_row:int=0){
			var y:int=0;
			var tile:Bricks;
			var rnd:int;
			

			for (y=0;x<max_x ;x++){
				tile =new Bricks();
				createTile(tile,x,start_row);
				//moveTile(tile,x,start_row);
				rnd=Math.floor(Math.random() * max_colors) + 1;
				changeFrame(tile,rnd);
				addTile(tile);
			}

		}
*/		
		
		
		
		
		private function getFirstEmptyCol():int {
			
			var tile:Bricks;
			var x:int;
			for (x=0;x<max_x;x++){
				tile=(this.getChildByName("tile_"+x+ (max_y-1)) as Bricks);
				if (!tile){
					return x;
				}
			}
			return max_x-1;
			
		}

		
		private function moveRight(){
			
			var tile:Bricks;
			
			var first_empty:int;
			first_empty=getFirstEmptyCol();
			if (first_empty>=(max_x-1)) {
				myTimer.stop();
				gameOver();
				//return;
				
			}
			for (x=first_empty;x>=0;x--){
				// if next column is empty dont move to the right 
					for (y=0;y<max_y ;y++){
						tile=(this.getChildByName("tile_"+x+y) as Bricks);
						if (tile){
							moveTile(tile,x+1,y);
						}
					}
			}
			
		}
		
		
		private function gameOver(){
			var scoreArr:Array=new Array();
			scoreArr.push(""+gameScore);
			myTimer.stop();
			gameTimer.stop();
			
			trace("game over. Score: "+gameScore+" time left "+timeLeft);
			dispatchEvent( new GameEvent(scoreArr, GameEvent.GAME_OVER ) );
		}
		
		private function tileClicked(event:MouseEvent) {
			
			var tile:Bricks = (event.currentTarget as Bricks);
			
			//trace("tile clicked "+ tile.name);
			similar_tiles=new Array();
			floodFill(tile.row,tile.col,tile.frameNr);
			
			//trace("similar len "+similar_tiles.length );
			var marked_tile:Bricks;
			if (similar_tiles.length>=min_similar){
				process_similar();
			}
			else {
				for each (marked_tile in similar_tiles) {
					trace("similar "+ " "+marked_tile.col+" "+ marked_tile.row + " "+ marked_tile.frameNr );
					marked_tile.marked_for_delete=false;
				}
			}
			similar_tiles=new Array();
			
		}


		private function floodFill(row:int,col:int, frameNr:int){
				var tile:Bricks=(this.getChildByName("tile_"+row+col) as Bricks);
				
				if (!tile) {
					return;
				}
				
				if (tile.marked_for_delete){
					//trace("already marked");
					return;
				}
				
				if (tile.frameNr !=frameNr) {
					return;
				
				}
				//tile.gotoAndStop(6);
				//changeFrame(tile,6);
				tile.marked_for_delete=true;
				similar_tiles.push(tile);
				
				if (row!=0) floodFill(row-1,col,frameNr);
				if (row<max_y-1) floodFill(row+1,col,frameNr);
				if (col!=0) floodFill(row,col-1,frameNr);
				if (col<max_x-1) floodFill(row,col+1,frameNr);
			
		}
		
		private function remove_tile(tile:Bricks){
			//gameScore=gameScore+tile.score;
			//trace("current score "+gameScore);
			this.removeChild(tile);
		}
		
		
		private function process_similar(){
			/*
			ejam cauri liidziigajiem tailiem
			skatamies, vai ir kaads augstaak
			ja ir, tad biidam to uz leju
			ja ir kaads augstaak, tad lai kriit uz leju
			*/
			
			var x:int=0;
			var y:int=0;
			var i:int;
			
			var tile:Bricks;
			var tile2:Bricks;
			var next_pos:int;
			
			for each (tile in similar_tiles ) {
				//var scoreBefore:int=gameScore;
				gameScore=gameScore+tile.getTileScore();
				//trace("total score "+gameScore +" tile score "+tile.getTileScore()+" before "+scoreBefore );
				remove_tile(tile);
			}
			//scoreDisplay.setScore(gameScore);

			var shrink_array:Array;
			var corrected_arr:Array;
			
			for (x=0;x<max_x;x++){
				shrink_array=new Array();
				
				for (y=0;y<max_y ;y++){
					//trace("tile_"+x+y);
					tile=(this.getChildByName("tile_"+x+y) as Bricks);
					if (tile){
						shrink_array.push(y);

					}
					else {
						//move_dowm(x,y,false);
						shrink_array.push(-1);
					}
				}
				//trace(shrink_array);
				corrected_arr=shrink_tiles(shrink_array);
				
				for (y=0;y<corrected_arr.length;y++){
					if (corrected_arr[y]!=-1){
						tile=(this.getChildByName("tile_"+x+corrected_arr[y]) as Bricks);
						moveTile(tile,x,y);
					}
				}
			}
		}
		
			private function shrink_tiles(test_arr:Array):Array{
				//var test_arr:Array = new Array(1, 2, 3, 0, 4, 0, 5,6, 0);
				const empty_val:int=-1; //tuksas ailes numurs
				
				
				var tmp_arr:Array = new Array();
				for (var y:int=0 ; y<test_arr.length ; y++) {
					if (test_arr[y]!=empty_val) tmp_arr.push(test_arr[y]);
					//trace(tmp_arr);
				}
				var diff:int=test_arr.length-tmp_arr.length;
				
				for (var a:int=0; a< diff; a++) {
					//trace("adding value");
					tmp_arr.unshift(empty_val);
				}
				
				//trace(tmp_arr);
				return tmp_arr;
		}

		
		
		
		private function move_dowm(x:int,y:int,delete_orig:Boolean=true){
			if (y<=0) return;
			//trace("moving down "+x+y);
			
			var next_pos:int; 
			next_pos=y-1;
			var tile2:Bricks;
			tile2=(this.getChildByName("tile_"+x+next_pos) as Bricks);
			if (tile2) {
				this.moveTile(tile2,x,y);
				//if (delete_orig) remove_tile(tile);
			}
			else{
				//trace("move more down "+x+y );
				move_dowm(x,next_pos,false);
			}
		}
		
		private function random_number(min:int,max:int):int{
			var rnd:int=Math.floor(Math.random() * (min+max-min)) + min;
			return rnd;
		}
		
		
		/**
		destroys last rows to prevent game over too early
		*/
		
		private function shootLastRows(rowcount:int=2){
			
			/**
			varianti:
			idzeest n rindas liidz n sekundes pirsm beigaam
			izdzeest random rindu
			idzeest apakseejaas rindas
			*/
			
			
			//dzeesam peedeejaas rindas tikai tad, kad veel laiks daudz, lai buutu vismaz 40 sekundes vienai speelei
			if (timeLeft<15) return;
			
			var x:int=0;
			var y:int=0;
			var tile:Bricks;
			var tileColsToLeave:int=max_x-5; // how many columns leave 
			for (x=max_x;x>tileColsToLeave;x--){
				for (y=0;y<=max_y;y++){
					tile=(this.getChildByName("tile_"+x+y) as Bricks);
						if (tile){
							remove_tile(tile);
							gameScore--; // less score for deleted tiles
						}
				}
				
			}
			
		}
		
		/**
		removes random tile from the field
		*/
		
		private function removeRandom(upgrade_level:int=0){
			// removes 2, 4, 6, 8 tiles
			
			//var roll:int=random_number(1,10);
			if ((random_number(1,10))<5) return; // no luck
			
			var tile_count_arr:Array=[1,2,3,4,5,6];
			var tile_count=1;
			var x:int=random_number(1,max_x);
			var y:int=random_number(1,max_y);
			//var y:int=max_y-1;// random_number(1,max_y);
			var i:int;
						
			//showing Boom!! amimation			
			if (tileGetAndRemove(x,y)){
				boom.visible=true;
				boom.x=x*tile_width;
				boom.y=y*tile_height;
			}
			
			for (i=1;i<=tile_count;i++){
				tileGetAndRemove(x,y+i);
				tileGetAndRemove(x+i,y);
				tileGetAndRemove(x+i,y+i);
				
			}
			
		}
		
		private function tileGetAndRemove(x:int,y:int):Boolean{
			var tile:Bricks;
			tile=(this.getChildByName("tile_"+x+y) as Bricks);
				if (tile){
					remove_tile(tile);
					return true;
				}
			return false;
		}
	
	
		private function onTick(e:TimerEvent){
			//shootLastRows();
			// !!!
			//FIXME: paarbiide notiek nepareizi
			// iespeejams taapeec arii ir taas probleemas, kad kaut kas neklikskinaas
			//moveRight();
			moveRightArr();
			addTileColumnArr();
			//addTileRow();
			asd.setScore(gameScore);
			
		}
		
		private function onGameTimeTick(e:TimerEvent){
			boom.visible=false;
			timeLeft--;
			if (boomAmount>0) removeRandom(); //removing random rows
			asd.gameTimeLeft(timeLeft);
			
		}
		
		public function updateDisplay():void{
			
		}

	
	
		
	}
}