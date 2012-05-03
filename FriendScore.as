package  {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import fl.containers.UILoader;
	
	
	public class FriendScore extends MovieClip {
		
		private var friendAvatar:Bitmap;

		public function FriendScore() {
/*			
			friendLevel.visible=false;
			friendExp.visible=false;
			friendAvatar=new Bitmap();
			inviteFriend.visible=true;
*/
			resetFriendField();
			friendPic.addEventListener(IOErrorEvent.IO_ERROR, handleIOError);

			inviteFriend.addEventListener(MouseEvent.CLICK,onClickInvite);
			
		}
		
		public function onClickInvite(event:MouseEvent){
			trace("on click invite");
			ExternalInterface.call("inviteFriend");
		}

		public function onClickDetails(){
			
		}
		
		public function handleIOError(event:IOErrorEvent):void{
			trace("handleIOError occured ");
			trace(event.target);
		}


		public function setupFriend(uid:Number, picUrl:String,level:Number,exp:Number ) {
			try {
				inviteFriend.visible=false;
				inviteFriend.enabled=false;
				this.removeEventListener(MouseEvent.CLICK,onClickInvite);
				
				//trace("start on setupFriend "+ picUrl);
				setBitmap(picUrl );
				setLevel(level);
				setExp(exp);
			}
			catch (e:Error) {
				trace("setupFriend error "+e.message);
			}
			
			
		}
		
		public function resetFriendField(){
			//friendAvatar=new Bitmap();
			friendPic.unload();
			friendLevel.visible=false;
			friendExp.visible=false;
			friendLevel.text="";
			friendExp.text="";
			inviteFriend.visible=true;
			
		}
		
		
		
		
		public function setLevel(level:Number){
			friendLevel.visible=true;
			friendLevel.text=""+level;
			inviteFriend.visible=false;

		}
		
		public function setExp(exp:Number){
			friendExp.visible=true;
			friendExp.text=""+exp ;
			inviteFriend.visible=false;
			
		}
		
		public function setBitmap(picUrl:String) {
			try {
				//friendPic.source = "http://i4.ifrype.com/profile/127/704/v1298139593/sm_127704.jpg";
				inviteFriend.visible=false;
				
				//TODO: need to check if bitmap exists or something like that
				if (picUrl=="false")
					friendPic.load(null);
				else
					friendPic.source = picUrl;// "http://i4.ifrype.com/profile/127/704/v1298139593/sm_127704.jpg";
			}
			catch (e:Error) {
				trace("setBitmap error "+e.message);
			}
			
			
			
		}
		
		
	}
	
}
