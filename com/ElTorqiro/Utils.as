import com.GameInterface.UtilsBase;
import flash.geom.ColorTransform;
import flash.geom.Point;

/**
 * Utility class for TSW addons
 */
class com.ElTorqiro.Utils
{
	// cannot be instantiated, static class only
	private function Utils() {}
	
	/**
	 * Checks if a movieclip is fully within the visible area of the Stage, and returns the closest coordinates that would make it so
	 * 
	 * @param	mc MovieClip to check for
	 * @return	Point which would bring the movieclip fully into Stage.visibleRect (in mc-local coordinates)
	 */
	public static function OnScreen(mc:MovieClip):Point
	{
		// TODO: adjust for global / visible coordinates and back to local
		// Not sure how to do this successfully, as localToGlobal seems to give a result that is 2x bigger than (e.g. a real 500 becomes a "global" 1000)
		//    var s_ResolutionScaleMonitor = DistributedValueBase.GetDValue("GUIResolutionScale");
		//    var s_HUDScaleMonitor = DistributedValueBase.GetDValue("GUIScaleHUD");
		
		var onScreenPosition:Point = new Point(mc._x, mc._y);
		
		// check if bounds are outside visible area
		if ( mc._x < 0 ) onScreenPosition.x = 0;
		else if ( mc._x + mc._width > Stage.visibleRect.width ) onScreenPosition.x = Stage.visibleRect.width - mc._x - mc._width;

		if ( mc._y < 0 ) onScreenPosition.y = 0;
		else if ( mc._y + mc._height > Stage.visibleRect.height ) onScreenPosition.y = Stage.visibleRect.height - mc._y - mc._y;

		return onScreenPosition;
	}

	
	/**
	 * Prints the content of an object in the chat window in game
	 * 
	 * @param	o The object to dump
	 */
	public static function VarDump(o:Object):Void
	{
		for ( var s:String in o )
		{
			UtilsBase.PrintChatText( s + ": " + o[s] );
		}
	}
	
	
	/**
	 * Colorize movieclip using color multiply method rather than flat color
	 * 
	 * Courtesy of user "bummzack" at http://gamedev.stackexchange.com/a/51087
	 * 
	 * @param	object The object to colorizee
	 * @param	color Color to apply
	 */	
	public static function Colorize(object:MovieClip, color:Number):Void {
		// get individual color components 0-1 range
		var r:Number = ((color >> 16) & 0xff) / 255;
		var g:Number = ((color >> 8) & 0xff) / 255;
		var b:Number = ((color) & 0xff) / 255;

		// get the color transform and update its color multipliers
		var ct:ColorTransform = object.transform.colorTransform;
		ct.redMultiplier = r;
		ct.greenMultiplier = g;
		ct.blueMultiplier = b;

		// assign transform back to sprite/movieclip
		object.transform.colorTransform = ct;
	}	
	
}