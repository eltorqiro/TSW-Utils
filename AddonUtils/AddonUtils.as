import com.GameInterface.UtilsBase;
import flash.geom.ColorTransform;
import flash.geom.Point;
import com.GameInterface.Inventory;
import com.GameInterface.InventoryItem;
import com.GameInterface.Tooltip.TooltipData;
import com.GameInterface.Tooltip.TooltipDataProvider;
import com.Utils.LDBFormat;

/**
 * Utility class for TSW addons
 */
class <YOUR_NAMESPACE>.AddonUtils.AddonUtils
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
	
	
	/**
	 * Test if a number is within the valid RGB colour range
	 * 
	 * @param	value Number to test for RGB validity
	 */
	public static function isRGB(value:Number):Boolean {
		return value >= 0 && value <= 0xffffff;
	}
	
	
	/**
	 * Test is an object has no properties
	 * 
	 * @param	object
	 * @return	true if there is at least one property in object
	 */
	public static function isObjectEmpty(object:Object):Boolean {
		var isEmpty:Boolean = true;
		for (var n in object) { isEmpty = false; break; }
		
		return isEmpty;
	}
	

	/**
	 * Scans the _global.Enums object for an Enum with the "path" containing the find string
	 * 
	 * @param	find	string to find in the entire Enum path, leave empty to print the entire nested list
	 */
	public static function FindGlobalEnum(find:String) {
		
		if ( find == "" ) find = undefined;
		
		var enumPaths:Array = [ "" ];
		var enums:Array = [ _global.Enums ];
		
		var theEnum = _global.Enums;
		var enumPath = "";
		
		var foundCount:Number = 0;
		
		var findText:String = find != undefined ? find : "[all names]";
		UtilsBase.PrintChatText('<br />');
		UtilsBase.PrintChatText('In _global.Enums, matching <font color="#00ccff">' + findText + "</font><br /><br />");
		
		while ( enums.length ) {
		
			for ( var s:String in theEnum ) {
				
				// push onto stack if it is another Enum blob node
				if ( theEnum[s] instanceof Object ) {
					enums.push( theEnum[s] );
					enumPaths.push( enumPath + "." + s );
				}
				
				// handle value node
				else {
					var varName = enumPath + "." + s;
					// case-insensitive find
					if ( find == undefined || varName.toLowerCase().indexOf( find.toLowerCase() ) > -1 ) {
						foundCount++;
						UtilsBase.PrintChatText( varName + ": " + theEnum[s] );
					}
					
				}
			}
			
			theEnum = enums.pop();
			enumPath = enumPaths.pop();
		}

		UtilsBase.PrintChatText("<br />");		
		UtilsBase.PrintChatText('Found <font color="#00ff00">' + foundCount + '</font> matching <font color="#00ccff">' + findText + '</font>');
	}

	/**
	 * Provides a copy of a string, in reverse character order.
	 * 
	 * @param	string	String to reverse.
	 * @return	The string in reverse character order.
	 */
	public static function ReverseString(string:String):String {
		var charArray:Array = string.split();
		charArray.reverse();
		return charArray.join();
	}
	
	
	/**
	 * Provides a copy of a string, with all HTML removed from it
	 * 
	 * @param	string	String to remove HTML from
	 * @return	The string with HTML removed
	 */
	public static function StripHTML(htmlText:String):String {
		if ( !(htmlText.length > 0) ) return htmlText;
		
		var istart:Number;
		var plainText:String = htmlText;
		while ((istart = plainText.indexOf("<")) != -1) {
			plainText = plainText.split(plainText.substr(istart, plainText.indexOf(">") - istart + 1)).join("");
		}

		return plainText;
	}
	
	
	/**
	 * Provides a copy of a string, with the first letter capitalised and the rest set to lowercase
	 * 
	 * @param	word	String to convert
	 * @return	The string with first letter capitalised
	 */
	public static function firstToUpper(word:String):String {
		var firstLetter = word.substring(1, 0);
		var restOfWord = word.substring(1);
		return ( firstLetter.toUpperCase() + restOfWord.toLowerCase() );
	}
	

	/**
	 * Converts a numeric color value into a HTML compatible hex string, excluding the leading #
	 * 
	 * @param	color	Numeric value representing an RGB color
	 * @return	color converted into a hex string, e.g. "FF88AA", or an empty string if a non-valid RGB value is passed
	 */
	public static function colorToHex(color:Number):String {
		if ( !isRGB(color) ) return '';
		
		var colArr:Array = color.toString(16).toUpperCase().split('');
		var numChars:Number = colArr.length;
		for ( var a:Number = 0; a < (6 - numChars); a++ ) {
			colArr.unshift("0");
		}
		return ( colArr.join('') );
	}

	
	/**
	 * Draws a rectangle on an existing movieclip, with options for rounded corners
	 * 
	 * Does not process any fill or line on the draw, begin those on the movieclip prior to calling this function
	 * 
	 * @param	mc					MovieClip to draw onto
	 * @param	x					x coordinate within the movieclip to start the rectangle
	 * @param	y					y coordinate within the movieclip to start the rectangle
	 * @param	w					width of the coordinate, which will be in movieclip-local scale, not pixel
	 * @param	h					height of the coordinate, which will be in movieclip-local scale, not pixel
	 * @param	topLeftCorner		radius of the top left corner, leave zero to not have a curved corner
	 * @param	topRightCorner		radius of the top right corner, leave zero to not have a curved corner
	 * @param	bottomRightCorner	radius of the bottom right corner, leave zero to not have a curved corner
	 * @param	bottomLeftCorner	radius of the bottom left corner, leave zero to not have a curved corner
	 */
	public static function DrawRectangle(mc:MovieClip, x:Number, y:Number, w:Number, h:Number, topLeftCorner:Number, topRightCorner:Number, bottomRightCorner:Number, bottomLeftCorner:Number):Void {

		if ( mc == undefined || !(mc instanceof MovieClip) ) return;
		
		if ( topLeftCorner == undefined ) topLeftCorner = 0;
		if ( topRightCorner == undefined ) topRightCorner = 0;
		if ( bottomRightCorner == undefined ) bottomRightCorner = 0;
		if ( bottomLeftCorner == undefined ) bottomLeftCorner = 0;
		
		mc.moveTo(topLeftCorner+x, y);
		mc.lineTo(w - topRightCorner, y);
		mc.curveTo(w, y, w, topRightCorner+y);
		mc.lineTo(w, topRightCorner+y);
		mc.lineTo(w, h - bottomRightCorner);
		mc.curveTo(w, h, w - bottomRightCorner, h);
		mc.lineTo(w - bottomRightCorner, h);
		mc.lineTo( bottomLeftCorner+x, h);
		mc.curveTo(x, h, x, h - bottomLeftCorner);
		mc.lineTo(x, h - bottomLeftCorner);
		mc.lineTo(x, topLeftCorner+y);
		mc.curveTo(x, y, topLeftCorner+x, y);
		mc.lineTo(topLeftCorner+x, y);
	}

	
	/**
	 * Extracts numeric sequences (including decimal point) from a string and returns them as an array of numbers
	 * 
	 * Only works with digits 0-9 and . so does not support hex or other base values
	 * 
	 * @param	string	The string to find a number inside
	 * @return	The numeric values found, in an array, zero length if no numbers found
	 */
	public static function NumbersFromString(string:String):Array {
		
		var capturing:Boolean = false;
		var numArray:Array = [];
		var numbers:Array = [];
		
		var length:Number = string.length;
		for ( var i:Number = 0; i < length; i++ ) {
			
			var charCode:Number = string.charCodeAt(i);
			if ( (charCode >= 48 && charCode <= 57) || ( capturing && charCode == 46 && i != length - 1)) {
				capturing = true;
				numArray.push( string.charAt(i) );
			}
			
			else if ( capturing ) {
				capturing = false;
				numbers.push( Number(numArray.join('')) );
				numArray = [];
			};
		}

		if( numArray.length > 0 ) { numbers.push( Number(numArray.join('')) ); }

		return numbers;
	}
	
	
	/**
	 * Extracts stat values from an item and returns an object populated with organised values
	 * 
	 * @param	inventory		inventory the item is in
	 * @param	itemPosition	position in the inventory the item is in
	 * @return	organised object of stat data related to the item
	 */
	public static function GetItemStats(inventory:Inventory, itemPosition:Number):Object {
		
		var inventoryItem:InventoryItem = inventory.GetItemAt( itemPosition );
		if ( inventoryItem == undefined) return {};

		var signetStats:Object = { };
		signetStats[ "heal rating" ] = true;
		signetStats[ LDBFormat.LDBGetText("SkillTypeNames", _global.Enums.SkillType.e_Skill_HealingRating ).toLowerCase() ] = true;
		signetStats[ LDBFormat.LDBGetText("SkillTypeNames", _global.Enums.SkillType.e_Skill_AttackRating ).toLowerCase() ] = true;
		signetStats[ "Health".toLowerCase() ] = true;
		signetStats[ "Santé".toLowerCase() ] = true;
		signetStats[ "Gesundheit".toLowerCase() ] = true;
		
		var tooltipData:TooltipData = TooltipDataProvider.GetInventoryItemTooltip( inventory.GetInventoryID(), itemPosition);
		
		var item:Object = {
				name: inventoryItem.m_Name,
				type: inventoryItem.m_ItemType,
				position: inventoryItem.m_InventoryPos,
				rank: Number(tooltipData.m_ItemRank),
				attributes: {}
		};
		
		var statIndex:Number;
		var value:String;
		var stat:String;
		var attribute:String;
		var typePosition:String;
		
		switch( item.type ) {

			// weapons & talismans
			case _global.Enums.ItemType.e_ItemType_Weapon:
				switch( item.position ) {
					case _global.Enums.ItemEquipLocation.e_Wear_First_WeaponSlot: item.typePosition = 'primary';  break;
					case _global.Enums.ItemEquipLocation.e_Wear_Second_WeaponSlot: item.typePosition = 'secondary';  break;
					case _global.Enums.ItemEquipLocation.e_Wear_Aux_WeaponSlot: item.typePosition = 'auxiliary';
				}
				
			case _global.Enums.ItemType.e_ItemType_Chakra:
				if( item.typePosition == undefined ) item.typePosition = 'talisman';
				
				// base item
				for ( var s:String in tooltipData.m_Attributes ) {
					if ( tooltipData.m_Attributes[s].m_Right != undefined ) {
						attribute = AddonUtils.StripHTML( tooltipData.m_Attributes[s].m_Right );
						statIndex = attribute.indexOf( '+' ) + 1;
						value = attribute.substring( statIndex, attribute.indexOf(' ', statIndex));
						stat = attribute.substr( statIndex + value.length + 1 ).toLowerCase();
						
						item.attributes[ stat ] = { name: stat, value: Number(value) };
					}
				}

				// glyph
				if ( tooltipData.m_PrefixData != undefined ) {
					item.glyph = { name: AddonUtils.StripHTML(tooltipData.m_PrefixData.m_Title), rank: Number(tooltipData.m_PrefixData.m_ItemRank) };
					item.glyph.attributes = { };

					for ( var s:String in tooltipData.m_PrefixData.m_Attributes ) {
						if ( tooltipData.m_PrefixData.m_Attributes[s].m_Right != undefined ) {
							attribute = AddonUtils.StripHTML( tooltipData.m_PrefixData.m_Attributes[s].m_Right );
							statIndex = attribute.indexOf( '+' ) + 1;
							value = attribute.substring( statIndex, attribute.indexOf(' ', statIndex));
							stat = attribute.substr( statIndex + value.length + 1 ).toLowerCase();
							
							item.attributes[ stat ] = { name: stat, value: Number(value) };
						}
					}
				}
				
				// signet
				if ( tooltipData.m_SuffixData != undefined ) {
					
					item.signet = { name: AddonUtils.StripHTML(tooltipData.m_SuffixData.m_Title), rank: Number(tooltipData.m_SuffixData.m_ItemRank) };
					item.signet.attributes = { };
					
					if ( tooltipData.m_SuffixData.m_Descriptions != undefined ) {
						attribute = AddonUtils.StripHTML( tooltipData.m_SuffixData.m_Descriptions[0] );
						var numbers:Array = AddonUtils.NumbersFromString( attribute );
						if( numbers.length == 1 ) {
							
							for( var a:String in signetStats ) {
								if ( attribute.toLowerCase().indexOf(a) >= 0 ) {
									item.signet.attributes[ a ] = { name: a, value: numbers[0] };
									break;
								}
							}
						}
					}
				}
				
			break;
			
			// aegis controllers & capacitors
			case _global.Enums.ItemType.e_ItemType_AegisWeapon:
				switch( item.position ) {
					case _global.Enums.ItemEquipLocation.e_Aegis_Weapon_1:
					case _global.Enums.ItemEquipLocation.e_Aegis_Weapon_1_2:
					case _global.Enums.ItemEquipLocation.e_Aegis_Weapon_1_3:
						item.typePosition = 'primary';
					break;
						
					case _global.Enums.ItemEquipLocation.e_Aegis_Weapon_2:
					case _global.Enums.ItemEquipLocation.e_Aegis_Weapon_2_2:
					case _global.Enums.ItemEquipLocation.e_Aegis_Weapon_2_3:
						item.typePosition = 'secondary';
					break;
				}
			
				item.attributes[ 'aegis xp percent' ] = { name: 'aegis xp percent', value: AddonUtils.NumbersFromString( AddonUtils.StripHTML(tooltipData.m_Descriptions[2]) )[0] };
				
			case _global.Enums.ItemType.e_ItemType_AegisGeneric:
				if( item.typePosition == undefined ) item.typePosition = 'talisman';
				
				var attribute = AddonUtils.StripHTML( tooltipData.m_Descriptions[0] );
				if( attribute != undefined ) {
					item.attributes[ 'aegis damage' ] = { name: 'aegis damage', value: AddonUtils.NumbersFromString( attribute )[0] };
				}

			break;
		}
		
		return item;
	}
	
}