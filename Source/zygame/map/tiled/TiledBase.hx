package zygame.map.tiled;

class TiledBase {

    public var properties:TiledProperties;

    public function new(tmx:Xml)
    {
        //解析属性  
        properties = new TiledProperties(tmx.elementsNamed("properties").next());
    }

}