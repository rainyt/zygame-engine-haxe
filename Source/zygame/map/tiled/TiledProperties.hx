package zygame.map.tiled;

class TiledProperties {
    
    public var properties:Map<String,Dynamic>;

    /**
     *  图块属性
     *  @param xml - 
     */
    public function new(xml:Xml)
    {
        properties = new Map<String,Dynamic>();
        var list:Iterator<Xml> = xml.elements();
        while(list.hasNext())
        {
            var listChild:Xml = list.next();
            properties.set(listChild.get("name"),listChild.get("value"));
        }
    }
    
}