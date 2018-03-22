package zygame.map;

import zygame.display.BodyDisplayObject;
import zygame.display.World;
import zygame.core.GameCore;
import zygame.map.tiled.TiledMap;

/**
 *  基础的地图类
 */
class BaseMap extends BodyDisplayObject
{
    public var mapXmlData:Xml;

    public var tmxData:TiledMap;

    private var _mapLayers:Map<String,MapLayer>;

    public var mapWidth:Int;

    public var mapHeight:Int;

    public function new(id:String,world:World)
    {
        super();
        this.mapXmlData = GameCore.getXml(id);
        if(this.mapXmlData == null)
            throw "地图资源"+id+"为空！";
        this.world = world;
        //解析Tmx资源
        tmxData = new TiledMap(this.mapXmlData);
        //计算出地图的高宽
        mapWidth = tmxData.width * tmxData.tileWidth;
        mapHeight = tmxData.height * tmxData.tileHeight;
    }

    /**
     *  获取指定图层
     *  @param pname - 图层名
     *  @return MapLayer
     */
    public function getLayer(pname:String):MapLayer
    {
        return _mapLayers.get(pname);
    }

}