package  
{
	import flash.events.Event;
	public class NavigationEvent extends Event 
	{
		public static const RESTART:String = "restart";
		public static const START:String = "start";

		public static const OK:String = "ok";
		public static const CANCEL:String = "cancel";

		public static const START_OFFLINE:String = "start_offline";
		
		public static const GAMEOVER:String = "gameover";
		
		
		public function NavigationEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) 
		{ 
			super( type, bubbles, cancelable );
			
		} 
		
		public override function clone():Event 
		{ 
			return new NavigationEvent( type, bubbles, cancelable );
		} 
		
		public override function toString():String 
		{ 
			return formatToString( "NavigationEvent", "type", "bubbles", "cancelable", "eventPhase" ); 
		}
	}
}