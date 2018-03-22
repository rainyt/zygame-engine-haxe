package zygame.utils;

import starling.utils.AssetManager;
import zygame.data.RoleDataManager;
import zygame.data.SpriteDataManager;
import zygame.utils.ZYMath;

/**
 *  角色资源管理器，只负责加载角色资源
 */
class RoleManager {
    
    /**
     *  角色的XML配置载入，一般载入一次不再删除
     */
    private var assets:AssetManager;

    /**
     *  角色的资源载入
     */
    public var roleAssets:AssetManager;

    /**
     *  角色帧数据管理
     */
    public var roleDataManager:RoleDataManager;

    /**
     *  精灵数据管理
     */
    public var spriteDataManager:SpriteDataManager;

    /**
     *  准备解析的精灵表数据
     */
    private var _readyPasringSpriteIDs:Array<String>;

    /**
     *  载入回调
     */
    private var func:Dynamic;

    /**
     *  载入列表
     */
    private var loadlist:Array<String>;

    public function new(){
        assets = new AssetManager(1,false);
        roleAssets = new AssetManager(1,false);
        roleDataManager = new RoleDataManager();
        spriteDataManager = new SpriteDataManager();
        //保留XML配置
        roleAssets.keepAtlasXmls = true;
        loadlist = [];
    }

    /**
     *  加载角色
     *  @param rolePath - 
     */
    public function enqueue(arr:Array<String>):Void
    {
        loadlist = loadlist.concat(arr);
    }

    /**
     *  开始加载
     *  @param func - 
     */
    public function loadQueue(func:Dynamic):Void
    {
        this.func = func;
        var arr:Array<String> = [];
        var i:Int = 0;
        var len:Int = loadlist.length;
        while(i < len){
            arr.push("assets/role/"+loadlist[i]+".data");
            i++;
        }
        assets.enqueue(arr);
        assets.loadQueue(function(pro:Float):Void{
            if(pro == 1)
            {
                //加载完成后，开始载入角色资源
                parsingRoleXml();
            }
            func(pro*0.5);
        });
    }

    private function parsingRoleXml():Void
    {
        var i:Int = 0;
        _readyPasringSpriteIDs = [];
        var len:Int = loadlist.length;
        while(i < len)
        {
            var id:String = loadlist[i];
            var xml:Xml = assets.getXml(id);
            //解析角色的帧动作使用
            roleDataManager.parsingRoleData(id,xml);
            //解析角色所需的资源载入
            var content:Iterator<Xml> = xml.elementsNamed("content");
            var loads:Iterator<Xml> = xml.elementsNamed("loads");
            if(content.hasNext())
                parsingAssetsXml(content.next().elements());
            if(loads.hasNext())
                parsingAssetsXml(loads.next().elements());
            i++;
        }
        roleAssets.loadQueue(function(pro:Float):Void{
            if(pro == 1){
                parsingSpriteDatas();
            }
            func(pro*0.5+0.5);
        });
    }

    /**
     *  所有资源载入完成后，开始解析所有精灵表数据
     */
    private function parsingSpriteDatas():Void
    {
        var i:Int = 0;
        while(i < _readyPasringSpriteIDs.length)
        {
            var id:String = _readyPasringSpriteIDs[i];
            spriteDataManager.parsingTextureAlats(id,roleAssets.getXml(id));
            i++;
        }
    }

    private function parsingAssetsXml(childs:Iterator<Xml>):Void
    {
        while(childs.hasNext()){
            var xml:Xml = childs.next();
            var path:String = xml.get("path");
            roleAssets.enqueue(["assets/"+path]);
            path = ZYMath.toName(path);
            if(_readyPasringSpriteIDs.indexOf(path) == -1 && loadlist.indexOf(path) == -1)
                _readyPasringSpriteIDs.push(path);
        }
    }

}