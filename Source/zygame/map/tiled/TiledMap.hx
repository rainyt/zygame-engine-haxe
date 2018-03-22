package zygame.map.tiled;

import zygame.map.tiled.TiledProperties;
import zygame.map.tiled.TiledObjectLayer;

/**
 *  TMX数据解析
 */
class TiledMap extends TiledBase {

    public var objectLayers:Array<TiledObjectLayer>;

    public var width:Int;

    public var tileWidth:Int;

    public var height:Int;

    public var tileHeight:Int;

    public function new(tmx:Xml)
    {
        super(tmx);
        var xml:Xml = tmx;  
        width = Std.parseInt(xml.get("width"));
        height = Std.parseInt(xml.get("height"));
        tileWidth = Std.parseInt(xml.get("tilewidth"));
        tileHeight = Std.parseInt(xml.get("tileheight"));

        //解析图层
        parsing(tmx.elements());
    }

    private function parsing(tmx:Iterator<Xml>):Void
    {
        objectLayers = new Array<TiledObjectLayer>();
        while(tmx.hasNext())
        {
            var xml:Xml = tmx.next();
            var localName:String = xml.nodeName;
            switch(localName)
            {
                case "objectgroup":
                    objectLayers.push(new TiledObjectLayer(xml));
            }
        }
    }
}