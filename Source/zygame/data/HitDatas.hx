package zygame.data;

import nape.phys.Body;
import nape.geom.GeomPoly;
import nape.geom.GeomPolyList;
import nape.shape.Polygon;
import nape.geom.Vec2;
import nape.phys.BodyType;
import zygame.display.BaseRole;
import zygame.data.HitBody;
import zygame.data.BeHitData;

/**
 *  记录所有碰撞块数据，碰撞块垃圾池
 */
class HitDatas {

    public var role:BaseRole;

    private var _hits:Map<String,HitBody>;

    public function new(role:BaseRole){
        this.role = role;
        _hits = new Map<String,HitBody>();
    }

    /**
     *  获取碰撞块
     *  @param id - 碰撞ID
     *  @param hitPoint - 碰撞数据
     *  @return Body
     */
    public function getHitBody(id:String,data:BeHitData,hitPoint:Array<Vec2>):HitBody
    {
        var body:HitBody = _hits.get(id);
        if(body == null)
        {
            body = new HitBody(createBodyVec(hitPoint),data);
            _hits.set(id,body);
        }
        return body;
    }

    /**
     * 绘制地图碰撞数据
     */
    public function createBodyVec(vertice:Array<Vec2>):Body
    {
        var polygon:GeomPoly = new GeomPoly(vertice);
        var pbody:Body = new Body(BodyType.KINEMATIC);
        var polyShapeList:GeomPolyList=polygon.convexDecomposition();
        //遍历这些小的图形，将这些小图形用组合法添加到body.shapes属性中
        polyShapeList.foreach(function(shape:Dynamic):Void{
            var polygon2:Polygon = new Polygon(shape);
            pbody.shapes.push(polygon2);
        });
        pbody.allowRotation = false;
        pbody.gravMass = 0;
        pbody.userData.noHit = true;
        pbody.scaleShapes(Math.abs(role.scaleX),role.scaleY);
        return pbody;
    }

}