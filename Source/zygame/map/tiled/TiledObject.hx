package zygame.map.tiled;

import zygame.map.tiled.TiledBase;
import nape.geom.Vec2;

class TiledObject extends TiledBase {

    public var name:String = null;

    public var type:String = null;

    public var x:Float;

    public var y:Float;

    public var points:Array<Vec2>;

    public function new(xml:Xml)
    { 
        super(xml);
        //获取当前坐标
        x = Std.parseFloat(xml.get("x"));
        y = Std.parseFloat(xml.get("y"));
        //解析坐标
        parsingPoints(xml.elementsNamed("polygon").next().get("points"));
    }

    private function parsingPoints(pointsString:String):Void
    {
        points = new Array<Vec2>();
        var arr:Array<String> = pointsString.split(" ");
        var i:Int = 0;
        while(i < arr.length)
        {
            var pointArr:Array<String> = arr[i].split(",");
            points.push(new Vec2(Std.parseFloat(pointArr[0]),Std.parseFloat(pointArr[1])));
            i++;
        }
    }

}