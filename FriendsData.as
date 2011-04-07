package {
	
    import br.com.stimuli.loading.BulkLoader;
    import br.com.stimuli.loading.BulkProgressEvent; 	
	import flash.events.*;
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.net.*;
	import flash.display.DisplayObject;
	
	
	public class FriendsData() {
		public var bulkLoader : BulkLoader; 
		private var jsonObj:Object;
		private var loader:Loader;
		private var picturesArr:Array;
		
		
		public static function getFriendsImages() {
			if (!bulkLoader) initData();
		}
		
		private function initData() {
			var db:DbAccess=new DbAccess();
			db.addEventListener( GameEvent.GET_FRIENDS_LIST, loadImages);
			db.getFriendsList();
		}
		
		public function loadImages(evt:GameEvent) {
			bulkLoader = new BulkLoader("friends_list"); 
			//loader.logLevel = BulkLoader.LOG_INFO;
			jsonObj= evt.gameData[0];
			
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
		
		
		public function onAllItemsLoaded(evt : Event) : void{ 
			trace("all items loaded"  );
			
			//TODO: labaaks veids kaa ielaadeet bildes
				var picObj:Object;
				var picArr:Array=new Array();
				var picBmp:Bitmap;
				for(var i in jsonObj){
					//trace(jsonObj[i]);
					picObj=jsonObj[i];
					picArr.push(bulkLoader.getBitmap(picObj['img']));
				}
				
				bulkLoader.resumeAll();
				bulkLoader=null;
				
		}
		
		
		public function onAllItemsProgress(evt : BulkProgressEvent) : void{
            //trace(evt.loadingStatus());
        } 

		
		
		
	}

	


}