package  {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.events.*;
	import flash.external.ExternalInterface;
	
	
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
			
			inviteFriend.addEventListener(MouseEvent.CLICK,onClickInvite);
			
		}
		
		public function onClickInvite(event:MouseEvent){
			trace("on click invite");
			ExternalInterface.call("inviteFriend");
		}

		public function onClickDetails(){
			
		}

		public function setupFriend(uid:Number, picUrl:String,level:Number,exp:Number ) {
			inviteFriend.visible=false;
			inviteFriend.enabled=false;
			this.removeEventListener(MouseEvent.CLICK,onClickInvite);
			setBitmap(picUrl );
			setLevel(level);
			setExp(exp);
			
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
				friendPic.source = picUrl;// "http://i4.ifrype.com/profile/127/704/v1298139593/sm_127704.jpg";
				inviteFriend.visible=false;


/*				
				if (!pic) throw new Error("Not a valid bitmap.");
				friendAvatar=pic;
				friendAvatar.height=60;
				friendAvatar.width =60;
				friendAvatar.x=5;
				friendAvatar.y=5;
				//pic.name="usrpic";
				this.addChild(friendAvatar);
*/				
				
			}
			catch (e:Error) {
				trace("setBitmap error "+e.message);
			}
			
			
			
		}
		
		
	}
	
}
