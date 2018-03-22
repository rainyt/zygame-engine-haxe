package zygame.display;

import zygame.display.KeyDisplayObject;
import nape.phys.Body;
import nape.geom.Vec2;
import nape.phys.BodyType;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.phys.Material;
import nape.shape.Polygon;
import zygame.data.IgnoreData;
import zygame.utils.ZYMath;
import nape.phys.BodyList;

/**
 *  包含了一个Body物理引擎的对象
 */
class BodyDisplayObject extends KeyDisplayObject{

    /**
     *  可设置忽略，如果为null则不跟任何类型排斥
     */
    public var ignoreData(get,set):IgnoreData;
    private function get_ignoreData():IgnoreData
    {
        if(body != null)
            return body.userData.ignoreData;
        return null;
    }
    private function set_ignoreData(data:IgnoreData):IgnoreData
    {
        if(body != null)
            body.userData.ignoreData = data;
        return null;
    }

    /**
     *  获取一个Body
     */
    public var body(get,never):Body;
    private var _body:Body = null;
    private function get_body():Body
    {
        return _body;
    }

    /**
     *  设置X轴坐标
     */
    public var posx(get,set):Float;
    private function get_posx():Float
    {
        if(body != null)
            return body.position.x;
        return super.x;
    }
    private function set_posx(value:Float):Float
    {
        if(body != null)
             body.position.x = value;
        super.x = value;
        return value;
    }

    /**
     *  设置Y轴坐标
     */
    public var posy(get,set):Float;
    private function get_posy():Float
    {
        if(body != null)
            return body.position.y;
        return super.x;
    }
    private function set_posy(value:Float):Float
    {
        if(body != null)
             body.position.y = value;
        super.y = value;
        return value;
    }

    /**
     *  创建一个物理身体
     *  @param arr - 多边形顺时针数组坐标
     */
    public function createBody(arr:Array<Vec2>,type:BodyType):Void
    {
        _body = new Body(type);
        //设置坐标
        _body.userData.ref = this;
        //创建一个形状
        var polygon:GeomPoly = new GeomPoly(arr);
        var polyShapeList:GeomPolyList=polygon.convexDecomposition();
        //遍历这些小的图形，将这些小图形用组合法添加到body.shapes属性中
        polyShapeList.foreach(function(shape:Dynamic):Void{
            var polygon:Polygon = new Polygon(shape);
            polygon.material = createMaterial();
            _body.shapes.push(polygon);
        });

        //设置空间
        _body.space = world.nape;
        _body.position.x = this.x;
        _body.position.y = this.y;
    }

    /**
     *  创建一个圆的身体
     *  @param x - 
     *  @param y - 
     */
    public function createCircle(x:Int,y:Int):Void
    {

    }

    /**
     *  从坐标获取到body
     *  @param x - 
     *  @param y - 
     */
    public function getBodyAtPos(x:Float,y:Float):BodyList
    {  
        if(world == null)
            return null;
        var bodylist:BodyList = world.nape.bodiesUnderPoint(ZYMath.vec2(x,y));
        return bodylist;
    }

    /**
     *  返回一个物理质量
     *  @return Material
     */
    public function createMaterial():Material
    {
        return new Material(0,1,2);
    }

    /**
     *  X轴移动
     *  @param f - 
     */
    public function xMove(f:Float):Void
    {
        if(Math.isNaN(f))
            return;
        if(this.body != null)
        {
            this.body.velocity.x = f * 60;
        }
        else
        {
            this.x += f;
        }
    }

    /**
     *  设置Body是否可以碰撞
     *  @param bool - 
     */
    public function setIsHit(bool:Bool):Void
    {
        if(body != null)   
            body.userData.noHit = !bool;
    }

    /**
     *  Y轴移动
     *  @param f - 
     */
    public function yMove(f:Float):Void
    {
        if(Math.isNaN(f))
            return;
        if(this.body != null)
        {
            this.body.velocity.y = f * 60;
        }
        else
        {
            this.y += f;
        }
    }
}