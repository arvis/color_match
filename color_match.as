package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	
	public class color_match extends Sprite {
		// TODO rename class
		
		const max_y:int=6;
		const max_x:int=16;
		const max_colors:int=3;
		const tile_height:int=20;
		const tile_width:int=20;
		const min_similar:int=3; //minimum number of similar tiles to count
		const timer_speed:int=1500; //how fast line will go 1000=1sec
		
		private var game_tiles:Array;
		private var similar_tiles:Array;
		private var myTimer:Timer;  
		private var scoreDisplay:GameScore;
		private var gameScore:Number=0;
		
		
		public function color_match() {

			
		}
		
		
		public function startGame(){
			game_tiles=new Array();
			addTileRow();
			scoreDisplay= new GameScore();
			scoreDisplay.name="score";
			this.addChild(scoreDisplay);

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
		
		private function changeFrame(tile:Bricks, frame_no:int){
			tile.frame_no=frame_no;
			tile.gotoAndStop(frame_no);
		}
		
		
		
		private function addTile(tile:Bricks){
			this.addChild(tile);
		}
		
		
		private function addTileRow(start_col:int=0){
			var y:int=0;
			var tile:Bricks;
			var rnd:int;
			

			for (y=0;y<max_y ;y++){
				tile =new Bricks();
				createTile(tile,start_col,y);
				moveTile(tile,start_col,y);
				rnd=Math.floor(Math.random() * max_colors) + 1;
				changeFrame(tile,rnd);
				addTile(tile);
			}

		}
		
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
				trace("Game over");
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
		
		private function tileClicked(event:MouseEvent) {
			var tile:Bricks = (event.currentTarget as Bricks);
			
			trace("tile clicked "+ tile.name);
			similar_tiles=new Array();
			floodFill(tile.row,tile.col,tile.frame_no);
			
			trace("similar len "+similar_tiles.length );
			var marked_tile:Bricks;
			if (similar_tiles.length>=min_similar){
				process_similar();
			}
			else {
				for each (marked_tile in similar_tiles) {
					trace("similar "+ " "+marked_tile.col+" "+ marked_tile.row + " "+ marked_tile.frame_no );
					marked_tile.marked_for_delete=false;
				}
			}
			similar_tiles=new Array();
			
		}


		private function floodFill(row:int,col:int, frame_no:int){
				var tile:Bricks=(this.getChildByName("tile_"+row+col) as Bricks);
				
				if (!tile) {
					return;
				}
				
				if (tile.marked_for_delete){
					//trace("already marked");
					return;
				}
				
				if (tile.frame_no !=frame_no) {
					return;
				
				}
				//tile.gotoAndStop(6);
				//changeFrame(tile,6);
				tile.marked_for_delete=true;
				similar_tiles.push(tile);
				
				if (row!=0) floodFill(row-1,col,frame_no);
				if (row<max_y-1) floodFill(row+1,col,frame_no);
				if (col!=0) floodFill(row,col-1,frame_no);
				if (col<max_x-1) floodFill(row,col+1,frame_no);
			
		}
		
		private function remove_tile(tile:Bricks){
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
				gameScore+=tile.getTileScore();
				remove_tile(tile);
			}
			scoreDisplay.setScore(gameScore);

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
				trace("move more down "+x+y );
				move_dowm(x,next_pos,false);
			}
		}
		
	
		private function onTick(e:TimerEvent){
			moveRight();
			addTileRow();
			scoreDisplay.setScore(gameScore);
			
			
		}
	
	
		
	}
}