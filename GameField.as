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
		const DEFAULT_TIME_LEN:int=60;
		
		
		private var game_tiles:Array;
		private var similar_tiles:Array;
		private var myTimer:Timer;  
		private var scoreDisplay:GameScore;
		private var gameScore:Number=0;
		private var gameTimer:Timer;
		private var timeLeft:int=DEFAULT_TIME_LEN; //how long game will last, in seconds
		
		var timer_speed:int=1500; //how fast line will go 1000=1sec, the smaller number, the faster you go
		var boomAmount:int=0;
		var max_colors:int = 4;
		var fullColumnsAtStart:int = 1; // how many full columns are at start
		
		var mouseXPos:int=0;
		var mouseYPos:int=0;
		
		var multiplierSpawnTime:int = 0; // on how many ticks new multipliers will appear
		var currentLevel:int = 1;
		
		private var levelSpeeds:Array=[4000,4000,4000,3000,3700,3500,2800,2500,2000,1500,1200]; //all values really starts on 1, first record is just for cenvenciance
		private var levelColors:Array=[3,3,3,3,4,4,4,4,4,4]; //
		private var levelBoom:Array=[0,0,0,0,2,2,2,2,2,2,2,2,2,2];
		private var startColArr:Array = [3,3,3,3,3,3,3,3,3,3,3,3];
		private var laserBeamArr:Array= [3,3,3,3,3,3,3,3,3,3,3,3]; // how many lasers are at the end
		private var multiplierSpawnIn:Array= [6,6,6,6,6,6,6,6,6,6,6,6]; // how many multiplier field max are on field 
		
		private var gameFieldData:Array;
		
		private var test_problem:Boolean=false;
		
		//buffs for various atribures 1 is default
		private var perksBuff1:Buff;
		
		
		public function GameField(level:int=1,perk1Id:int=0, userName:String="") {
		
			trace("starting gamefield");
			resetGameField(level,perk1Id,userName);
			
		}
		
		public function resetGameField(level:int,perk1Id:int=0, userName:String=""){
			boom.visible=false;
			gameScore = 0;
			currentLevel = level;
			
			setPerks(perk1Id);

			asd.resetAll();
			asd.setLevel(level);
			//asd.setGamesLeft(games_left);
			asd.setUserName(userName);
			laser1.visible=true;
			adjustFieldForLevel(level);
			initGameFieldData();
			startGame();
			
		}
		
		private function setPerks(perkId:int){
			perksBuff1=new Buff();
			
			if (perkId==0) return;
			
			//TODO: from where to get buff options
			else if (perkId==1 && this.currentLevel<7){
				trace("setting perk "+ perkId);
				perksBuff1.pointsBonus=2; // TODO: make it non hard coded
			}
			
			
		}
		
		
		private function test_fillCustomFields(){
			var tile:Bricks;
			tile=new Bricks();
			
			tile=getTileFromArr(0,1);
			tile.setFrame(3);
			tile=getTileFromArr(0,0);
			tile.setFrame(3);
			tile=getTileFromArr(7,5);
			tile.setFrame(3);
			
			moveAllTilesBottom();
			
		}
		
		public function initGameFieldData(){
			if (gameFieldData){

				var row:int=0;
				var col:int=0;
				var tile:Bricks;
				for (row=0;row<max_x;row++){
					for (col=0;col<max_y;col++){
					tile=getTileFromArr(row,col);
					tile.setEmpty();
					}
				}
			}
			else {
				fillGameField();
			}
		}
		
		
		private function fillGameField(){
			try {			
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
						gameFieldColum.push(tile);
					}
					
					gameFieldData.push(gameFieldColum);
				}
			
			}
			catch (err:Error) {
				trace("fillGameField error "+err.message); 
				
			}

			
		}
		
		/**
		adjusting gamefield according to player level
		*/
		private function adjustFieldForLevel(level:int) {
			//if level cap is reached, just get last level
			var level_cap:int = levelSpeeds.length - 1;
			
			if (level > level_cap) level = level_cap;
			
			timer_speed=levelSpeeds[level];
			max_colors=levelColors[level];
			boomAmount = levelBoom[level];
			fullColumnsAtStart = startColArr[level];			
		}
		
		function fill_gameField(col_count:int = 1 ) {
			var row:int;
			for (row=0;row<col_count;row++ ){
				addTileColumnArr(row);
			}
			
		}
		
		
		public function startGame(){
			trace("on startgame");
			game_tiles=new Array();
			//addTileRow();
			fill_gameField(fullColumnsAtStart);
			gameTimer=new Timer(1000);
			timeLeft=DEFAULT_TIME_LEN; 
			gameTimer.addEventListener(TimerEvent.TIMER, onGameTimeTick);
			gameTimer.start();
			gameScore=0;


			myTimer = new Timer(timer_speed);
			myTimer.addEventListener(TimerEvent.TIMER, onTick);
			myTimer.start();
			
			addMultiplier();
			//setMultiplier(1,1);
			
		}
		
		
		private function createTile(tile:Bricks,row:int,col:int){
			tile.row=row;
			tile.col=col;
			tile.height=tile_height;
			tile.width=tile_width;
			tile.name="tile_"+row+col; //column names are reformated according in which position they are
			tile.addEventListener(MouseEvent.CLICK,tileClicked);
			moveTile(tile,row,col);
			addChild(tile);
		}
		
		private function moveTile(tile:Bricks,row:int,col:int){
			tile.x=row*tile_height;
			tile.y=col*tile_width;
			tile.row=row;
			tile.col=col;
			//tile.name="tile_"+row+col; //column names are reformated according in which position they are
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
				onError(err,"addTileColumnArr "+err.message);
			}
			
		}
		
		private function getTileFromArr(row:int,col:int):Bricks{
			try {
				
				if (row<0 || row>=max_x) return null;
				if (col<0 || col>=max_y) return null;
				
				var tile:Bricks;
				tile=(gameFieldData[row][col] as Bricks);
				if (tile) return tile;
			}
			catch (err:Error) {
				trace("getTileFromArr error "+err.message); 
				onError(err, "getTileFromArr error "+err.message);
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
				var first_empty:int = getFirstEmptyCol();
				
				if (first_empty>=(max_x-1)) {
					myTimer.stop();
					gameOver();
					return;
				}
				
				//var first_empty:int = max_x - 1;// getFirstEmptyCol();
				
				//var start_row:int=getFirstEmptyCol();
				
				for (row=first_empty;row>0;row--){
					for (col=0;col<max_y ;col++){
						tile=getTileFromArr(row,col);
						tile2=getTileFromArr(row-1,col);
						tile.setFrame(tile2.getFrame());
						tile.setMulitplier(tile2.getMulitplier());
						//tile.setFrame(2);

					}
				}
			}
			catch(err:Error){
				trace("moveRightArr "+ err.message);
				onError(err, "moveRightArr "+ err.message);
			}
		}
		
		
		
		private function getFirstEmptyCol():int {

			try {
				var tile:Bricks;
				var row:int;
				for (row = 0; row < max_x; row++) {
					tile = getTileFromArr(row, (max_y-1));
					if (tile.isEmpty()) return row;
				}
				return max_x-1;
				
			}
			catch (err:Error) {
				trace("getFirstEmptyCol error " + err.message );
				onError(err, "getFirstEmptyCol error "+ err.message);
				return -1;
			}
				return -1;
			
		}

		
		private function moveRight(){
			
			var tile:Bricks;
			
			var first_empty:int;
			first_empty=getFirstEmptyCol();
			if (first_empty>=(max_x-1)) {
				myTimer.stop();
				gameOver();
				return;
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
		
		
		private function gameOver(reason:String="game_over"){
			var scoreArr:Array=new Array();
			scoreArr.push(""+gameScore);
			scoreArr.push(reason);
			
			asd.setScore(gameScore);
			asd.setGameOver();
			
			myTimer.stop();
			gameTimer.stop();
			
			trace("game over. Score: "+gameScore+" time left "+timeLeft);
			dispatchEvent( new GameEvent(scoreArr, GameEvent.GAME_OVER ) );
		}
		
		private function tileClicked(event:MouseEvent) {
			
			var tile:Bricks = (event.currentTarget as Bricks);
			
			var marked_tile:Bricks;
			if (tile.isEmpty()) return; 
			
			similar_tiles=new Array();
			floodFill(tile.row,tile.col,tile.frameNr);
			
			if (similar_tiles.length>=min_similar){
				process_similar();
				//myTimer.start();
			}
			else {
				trace("not enough similar tiles" );

				for each (marked_tile in similar_tiles) {
					marked_tile.marked_for_delete=false;
				}
			}
			similar_tiles=new Array();
			
			moveAllTilesBottom();

		}


		private function floodFill(row:int,col:int, frameNr:int){
				var tile:Bricks=getTileFromArr(row,col);//  (this.getChildByName("tile_"+row+col) as Bricks);
				
				// TODO: consolidate under one expreseesion
				if (!tile) return;
				
				if (tile.isEmpty()) return;
				
				if (similar_tiles.indexOf(tile)>-1) {
					//trace("already there "+tile.row+tile.col+ tile.frameNr);
					return;
				}
				
				if (tile.frameNr !=frameNr) {
					return;
				
				}
				//tile.gotoAndStop(6);
				//changeFrame(tile,6);
				tile.marked_for_delete=true;
				similar_tiles.push(tile);

				floodFill(row-1,col,frameNr);
				floodFill(row+1,col,frameNr);
				floodFill(row,col-1,frameNr);
				floodFill(row,col+1,frameNr);

/*
				if (row!=0) floodFill(row-1,col,frameNr);
				if (row<max_x-1) floodFill(row+1,col,frameNr);
				if (col!=0) floodFill(row,col-1,frameNr);
				if (col<max_y-1) floodFill(row,col+1,frameNr);
*/			
		}
		
		private function remove_tile(tile:Bricks){
			tile.setEmpty();
		}
		
		
		/**
		ejam cauri liidziigajiem tailiem
		skatamies, vai ir kaads augstaak
		ja ir, tad biidam to uz leju
		ja ir kaads augstaak, tad lai kriit uz leju
		*/
		private function process_similar(){
			
			var x:int=0;
			var y:int=0;
			var i:int;
			
			trace("bonus points "+perksBuff1.pointsBonus);
			
			var tile:Bricks;
			var tile2:Bricks;
			var next_pos:int;
			for each (tile in similar_tiles ) {
				gameScore=gameScore+(tile.getTileScore()*perksBuff1.pointsBonus);
				remove_tile(tile);
			}
			asd.setScore(gameScore);
			//TODO: enable better way to show earned points
			//showScoreBubble();

		}
		
		/**
		shows bubble with info how much points has bot
		*/
		
		private function showScoreBubble(){
			scoreBubble.visible=true;
			//boom.visible=true;
			
			setChildIndex(scoreBubble,this.numChildren - 1);
			
			scoreBubble.text=""+gameScore;
			scoreBubble.x=this.mouseX+20;
			scoreBubble.y=this.mouseY;
			
			boom.x=this.mouseX;
			boom.y=this.mouseY;
			
			
		}
		private function hideScoreBubble(){
			boom.visible=false;
			scoreBubble.visible=false;
			
		}
		
		
		/**
		moves all tiles that are hanging down to bottom
		
		*/

		private function moveAllTilesBottom(){
			
			try {
				var row:int;
				var col:int;
				var i:int;
				
				var tiles_col:Array;
				var tile:Bricks;
				var tile2:Bricks;
				//trace("all to bottom");
				for (row=0;row<max_x;row++){
					tiles_col=new Array();
					for (col=0;col<(max_y);col++){
						tile = getTileFromArr(row, col);
						if (!tile.isEmpty()) tiles_col.push(col);
						else tiles_col.push(-1);
					}
					
					//trace(tiles_col);
					tiles_col=shrink_tiles(tiles_col);
					//setting shrinked data 
					//trace(tiles_col);
					
					for (col=(max_y-1);col>=0;col--){
						i=tiles_col[col];
						tile=getTileFromArr(row,col);
						if (tiles_col[col]>-1) {
							tile2 = getTileFromArr(row, tiles_col[col]);
							tile.setFrame(tile2.getFrame());
							tile.setMulitplier(tile2.getMulitplier());
						}
						else {
							tile.setEmpty();
						}
					}
					
					
				}
			}
			catch(err:Error){
				trace("moveAllTilesBottom " + err.message );
				onError(err, "moveAllTilesBottom error "+ err.message);
			}
		}
		
		
		
			private function shrink_tiles(test_arr:Array):Array{
				//var test_arr:Array = new Array(1, 2, 3, 0, 4, 0, 5,6, 0);
				
				var col:int;
				var tile:Bricks;
				const empty_val:int=-1;
				var tmp_arr:Array = new Array();
				
				for (col=0 ; col<test_arr.length ; col++) {
					//tile=getTileFromArr(row,col);
					
					if (test_arr[col]!=empty_val) tmp_arr.push(test_arr[col]);
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
			try {
				const removeLaserTimer:int=15; // when to remove laser timer
				
				//dzeesam peedeejaas rindas tikai tad, kad veel laiks daudz, lai buutu vismaz 40 sekundes vienai speelei
				if (timeLeft<removeLaserTimer) {
					laser1.visible=false;
					return;
				}

				laser1.visible=true;
				var row:int=0;
				var col:int=0;
				var tile:Bricks;
				//trace("saakam sist peedeejaas kolonnas"+timeLeft);
				
				var tileColsToLeave:int=(max_x-1)-3; // how many columns leave 
				for (row=(max_x-1);row>tileColsToLeave;row--){
					for (col=0;col<=(max_y-1);col++){
						//trace("get last tile "+row+col);
						tile=getTileFromArr(row,col);
							//FIXME: for testing
							if (!tile){
								trace("why there is no tile?"+ row+col);
							}
						
							if (!tile.isEmpty()){
								remove_tile(tile);
								gameScore--; // less score for deleted tiles
							}
					}
				}
			}
			catch(err:Error){
				onError(err,"shootLastRows error "+err.message);
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
		
		private function tileGetAndRemove(row:int,col:int):Boolean{
			var tile:Bricks;
			//tile=(this.getChildByName("tile_"+x+y) as Bricks);
			tile=getTileFromArr(row,col);
				if (tile.isEmpty()){
					remove_tile(tile);
					return true;
				}
			return false;
		}
	
		/**
		 * adding multipliers to game field
		 * rolls random number, checks if tile exsi
		 * */
		
		private function addMultiplier() {
			if (multiplierSpawnTime > 0) {
				multiplierSpawnTime--;
				return;
			}
			trace("addMultiplier start");
			var tileFound:Boolean = false;
			var randomX:int;
			var randomY:int;
			var tile:Bricks;
			
			
			// getting tile and assigning multiplier to it
			var multiplierSet:Boolean=false;
			
			while (!multiplierSet) {
				randomX=random_number(0, max_x);
				randomY=random_number(0, max_y);
				trace("on random "+randomX+ randomY);
				
				tile=getTileFromArr(randomX,randomY)
				if (!tile.isEmpty()) {
					tile.setMulitplier(2);
					multiplierSet=true;
				}
			}
			multiplierSpawnTime=1;//multiplierSpawnIn[currentLevel];
		}
		
		
		private function setMultiplier(row:int,col:int){
			var tile:Bricks;
			//tile=(this.getChildByName("tile_"+x+y) as Bricks);
			tile=getTileFromArr(row,col);
			tile.setMulitplier(2);

			
		}
	
	
	
		private function onTick(e:TimerEvent){
			
			moveAllTilesBottom();
			moveRightArr();
			shootLastRows();
			addTileColumnArr();
			asd.setScore(gameScore);
			addMultiplier();
			
		}
		
		
		
		private function onGameTimeTick(e:TimerEvent){
			hideScoreBubble();
			boom.visible=false;
			timeLeft--;
			if (timeLeft<=0) {
				gameOver("times_up");
				return;
			}
			
			
			//if (boomAmount>0) removeRandom(); //removing random rows
			asd.gameTimeLeft(timeLeft);
			
		}
		
		private function onError(errObj:Error, errMsg:String) {
			myTimer.stop();
			gameTimer.stop();
			
			var errArr:Array;
			errArr.push(errMsg);
			dispatchEvent(new GameEvent(errArr, GameEvent.GAME_ERROR));
		}
		
		
		public function updateDisplay():void{
			
		}

	
	
		
	}
}