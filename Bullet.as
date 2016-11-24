package  {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Point;
	
	public class Bullet extends MovieClip{
		
		private var id:int;
		private var owner:Boolean;
		private var stageInstance:Stage;
		
		public function Bullet(setOwner:Boolean,point:Point, stageInstance:Stage) {
			// constructor code
			id = getNumber(1,1000);
			this.stageInstance = stageInstance;
			owner = setOwner;
			spawn(point);
		}
		private function getNumber(minInt:int, maxInt:int):int{
			return(Math.floor(Math.random() * (maxInt - minInt + 1)) + minInt);
		}

		public function getID():int{
			return(id);
		}
		
		private function spawn(point:Point):void{
			this.x = point.x;
			this.y = point.y;
			stageInstance.addChild(this);
		}
		
		public function isOwner():Boolean{
			return(owner);
		}
	}	
}
