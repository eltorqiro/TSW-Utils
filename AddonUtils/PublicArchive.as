import com.Utils.Archive;

/**
 * extends TSWs archive object, which is used for all the persistence of module settings
 * the base class doesn't give raw access to the underlying internal data
 * all this one does is provide that through the dictionary property
 * 
 * this becomes useful when trying to do something other than FindEntry()
 * to find out what is in the dictionary without knowing what is there ahead of time
 */
class com.ElTorqiro.AddonUtils.PublicArchive extends com.Utils.Archive {
	
	public function PublicArchive() {
		super();
	}
	
	// readonly
	public function get dictionary():Object {
		return m_Dictionary;
	}
	
}