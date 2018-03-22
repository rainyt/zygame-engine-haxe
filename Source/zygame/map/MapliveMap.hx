package zygame.map;

import zygame.display.World;
import zygame.map.tiled.TiledObjectLayer;
import zygame.map.tiled.TiledObject;
import nape.geom.Vec2;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import zygame.map.MapCanvas;
import nape.phys.Body;
import nape.phys.BodyType;
import nape.shape.Polygon;
import openfl.geom.Point;
import zygame.map.MapPolygon;
import nape.phys.Material;

/**
 *  Maplive的地图渲染！
 */
class MapliveMap extends BaseMap {

    public var extendsData:Dynamic;

    public function new(id:String,world:World)
    {
        super(id,world);
    }

    override public function onInit():Void
    {
        super.onInit();
        var extendsDataString:String = tmxData.properties.properties.get("extend");
        if(extendsDataString != null)
            extendsData = haxe.Json.parse(extendsDataString);
        //绘制对象层
        this.drawObjectLayer();
    }

    private function drawObjectLayer():Void
    {
        //开始绘制图形图层
        var objectLayers:Array<TiledObjectLayer> = tmxData.objectLayers;
        var i:Int = 0;
        while(i < objectLayers.length)
        {
            var layer:TiledObjectLayer = objectLayers[i];
            var o:Int = 0;
            while(o < layer.objects.length)
            {
                var object:TiledObject = layer.objects[o];
                parsingCanvce(object.name,object);
                o ++;
            }
            i ++;
        }
    }

    /**
     *  进行绘制图形地图
     *  @param name - 
     *  @param tiledObject - 
     */
    private function parsingCanvce(name:String,tiledObject:TiledObject):Void
    {
        if(tiledObject.points == null || tiledObject.points.length < 3)
            return;
        var xz:Float = tiledObject.x;
        var yz:Float = tiledObject.y;
        var vertice:Array<Vec2> = tiledObject.points;

        //呈现对象
        var mapCanvas:MapCanvas = new MapCanvas(tiledObject.properties.properties.get("mode"));

        //创建Body
        var polygon:GeomPoly = new GeomPoly(vertice);
        var pbody:Body = new Body(BodyType.STATIC);
        var polyShapeList:GeomPolyList=polygon.convexDecomposition();
        //遍历这些小的图形，将这些小图形用组合法添加到body.shapes属性中
        polyShapeList.foreach(function(shape:Dynamic):Void{
            var polygon:Polygon = new Polygon(shape);
            polygon.material = new Material(0,0.8,1,1);            
            pbody.shapes.push(polygon);
            var m:Int = 0;
            var len:Int = polygon.localVerts.length;				
            var arr:Array<Point> = new Array<Point>();
            while(m < len)
            {
                var v:Vec2 = polygon.localVerts.at(m);
                arr.push(new Point(v.x,v.y));
                m ++;
            }
            mapCanvas.beginFill(0x0);
            mapCanvas.drawPolygon(new MapPolygon(arr));
        });

        pbody.position.x = xz;
        pbody.position.y = yz;
        pbody.space = world.nape;
        mapCanvas.x = xz;
        mapCanvas.y = yz;
        mapCanvas.world = world;
        this.addChild(mapCanvas);

        trace("绘制地图！",polyShapeList.length,xz,yz,vertice);
    }

}