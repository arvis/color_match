package  {
	
	import flash.display.MovieClip;
	import flash.display.*;
	
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent; 	
	import flash.events.*;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.*;
	import flash.display.DisplayObject;
	import flash.external.ExternalInterface;


	
	public class FriendsList extends MovieClip {
		public var bulkLoader : BulkLoader; 
		private var jsonObj:Object;
		private var myLoader:Loader;
		private var picturesArr:Array;
		private var db:DbAccess;
		private var currentPage:int=1;
		private var pageCount:int=1;
		private var friendsCount:int=1;
		private const friendsPerPage:int=5;
		
		public function FriendsList() {
			
			forwardButton.addEventListener( MouseEvent.CLICK, goForward);
			backButton.addEventListener( MouseEvent.CLICK, goBack);
			
			// getting data from javascript
			
			 //ExternalInterface.call("getFriendCount");
			
			if (!bulkLoader) loadData();
		}
		
		private function loadData() {
			setPageCount();
			if (!db){
				db=new DbAccess();
				db.addEventListener( GameEvent.GET_FRIENDS_LIST, loadImages);
			}
			db.getFriendsList(currentPage,friendsPerPage );
		}
		
		public function loadImages(evt:GameEvent) {
			try {
				//bulkLoader = new BulkLoader("friends_list"); 
				//bulkLoader.logLevel = BulkLoader.LOG_INFO;
				jsonObj= evt.gameData[0];
				
				//get friend count param and remove it
				trace("friend_count is "+ jsonObj['friend_count']);
				if (jsonObj['friend_count']) 
					friendsCount=Number(jsonObj['friend_count']);
				
				setPageCount();
				//friendsCount=Number(jsonObj.pop() );
				delete jsonObj['friend_count'];
				
				var friendInfo:Object;
				var friendObj:FriendScore;
				var friendIndex:int=0;


				//clear prevoius page pictures 
				for (var a:int=0;a<friendsPerPage;a++){
					friendObj=this.getChildByName("friend"+a) as FriendScore;
					friendObj.resetFriendField();
				}
				
				friendIndex=0;
				for(var i in jsonObj){
					//if (friendIndex>friendsPerPage) break;
					friendInfo=jsonObj[i];
					friendObj=this.getChildByName("friend"+friendIndex) as FriendScore;
					friendObj.setupFriend(friendInfo['uid'],friendInfo['img'],friendInfo['level'],Number(friendInfo['experience']));
					friendIndex=friendIndex+1;
				}
				
/*				
				bulkLoader.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded); 
				bulkLoader.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress); 
				bulkLoader.start();
*/				
			}
			catch (e:Error) {
				trace("loadImages error "+e.message);
			}
		}

		private function loadProgress(event:ProgressEvent):void
		{
		   var percentLoaded:Number = Math.round((event.bytesLoaded/event.bytesTotal) * 100);
		   trace("Loading: "+percentLoaded+"%");
		}
		
		public function onAllItemsLoaded(evt : Event) : void{ 
				
			try {	
				trace("all items loaded"  );
	
				//TODO: labaaks veids kaa ielaadeet bildes
					var picObj:Object;
					var picBmp:Bitmap;
					var tmpMov: FriendScore ;
					
					for(var i in jsonObj){
						picObj=jsonObj[i];
						picBmp=bulkLoader.getBitmap(picObj['img']);
						
						tmpMov= this.getChildByName("friend"+i) as FriendScore;
						trace("player level is "+picObj['level']+" exp "+picObj['experience']);
						
					}
			}
			catch (e:Error) {
				trace("onAllItemsLoaded error "+e.message);
			}

		
		}
		
		
		public function onAllItemsProgress(evt : BulkProgressEvent) : void{
            //trace(evt.loadingStatus());
        } 
		

		public function getImagesBulk(){
			bulkLoader=BulkLoader.getLoader("friends_list");
			
			if (!bulkLoader) {
				loadFriendsImagesBulk();
				return;
			}
			// if exists load from cache
			else {
				trace(bulkLoader.items.length);

				}
				
			
			
		}
		
		
		public function loadFriendsImagesBulk(){
			var db:DbAccess=new DbAccess();
			jsonObj=db.getFriendsList(currentPage,friendsPerPage);
			
			
			bulkLoader = new BulkLoader("friends_list"); 
			//bulkLoader.logLevel = BulkLoader.LOG_INFO;
			
			var a:Object;
			for(var i in jsonObj){
				//trace(jsonObj[i]);
				a=jsonObj[i];
				//trace(a['img']);
				bulkLoader.add(a['img']); 
			}
			bulkLoader.addEventListener(BulkLoader.COMPLETE, onAllItemsLoaded); 
			bulkLoader.addEventListener(BulkLoader.PROGRESS, onAllItemsProgress); 
			bulkLoader.start(); 
		}
		
		

		private function loadComplete(event:Event):void
		{
			try{
				var bmp:Bitmap=Bitmap(myLoader.content);
				addChild(bmp);
				//bmp.y=this.numChildren*20;
				//loader=null;
			   
			}
			catch(err:Error){
				trace("loadComplete error "+err.message );
			}
		}

		public function getAndLoadImages(){
			var db:DbAccess=new DbAccess();
			jsonObj=db.testgetFriendsList("");
			
			var a:Object;
			for(var i in jsonObj){
				//trace(jsonObj[i]);
				//FIXME: for testing
				//if (i==10226) return;
				a=jsonObj[i];
				trace(a['img']);
				loadImage(a['img']);
			}
		}
		
		
		public function loadImage(url:String){
			trace("start loading image "+url );
			var urlObj:URLRequest = new URLRequest(url);
			myLoader= new Loader();
			myLoader.load(urlObj);
			
			myLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadProgress);
			myLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		
		private function setPageCount(){
			try {
				pageCount=Math.ceil(friendsCount/friendsPerPage);
				trace("page count is " + pageCount);
			}
			catch(err:Error){
				trace("loadComplete error "+err.message );
			}
		}
		
		private function getFriendCountFromJs(count){
			trace("count is "+count);
			friendsCount=Number(count);
			if (!friendsCount || friendsCount<1 ) {
				pageCount=1;
				return;
			}
			
			pageCount=Math.ceil(friendsCount/friendsPerPage);
		}
		
		
		private function goBack(evt:MouseEvent){
			if (currentPage==1) return; 
			trace("go back");
			currentPage=currentPage-1;
			loadData();
			
		}

		private function goForward(evt:MouseEvent){
			if (pageCount==currentPage) return;
			trace("go Forward");
			currentPage=currentPage+1;
			loadData();
		}

		
	}
	
}
