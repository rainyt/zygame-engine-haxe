package zygame.utils;

import starling.utils.AssetManager;
import zygame.core.GameCore;

/**
 *  只负责地图资源加载，并且这个资源库会独立开使用
 */
class MapManager {

    public static inline var LOADHEAD:String = "assets/";

    public var assets:AssetManager;

    private var _func:Dynamic;

    private var _roleLoad:Array<String>;

    private var _currentMapPath:String;

    public function new(){
        assets = new AssetManager(1,false);
    }

    /**
     *  加载地图，地图每次只能载入一张
     *  @param path - 
     */
    public function loadMap(path:String,proFunc:Dynamic,beLoadRole:Array<String>):Void
    {
        //当前载入地图
        _currentMapPath = path;
        //载入反馈
        _func = proFunc;
        //角色载入
        if(beLoadRole == null)
            _roleLoad = [];
        else
            _roleLoad = beLoadRole;
        //载入地图文件
        assets.enqueue([LOADHEAD + path]);
        assets.loadQueue(onLoadMapAssest);
    }

    /**
     *  开始载入完整的地图资源
     *  @param num - 
     */
    private function onLoadMapAssest(num:Float):Void
    {
        if(num == 1)
        {
            var mapId:String = _currentMapPath.substr(0,_currentMapPath.lastIndexOf("."));
            mapId = mapId.substr(mapId.lastIndexOf("/") + 1);
            var mapXml:Xml = assets.getXml(mapId);
            if(mapXml == null)
            {
                throw "地图"+mapId+"未成功加载!";
            }
            //进行数据修正
            trace("地图数据准备完成！");
            //背景资源确认
            if(mapXml.get("bg") != null)
            {
                trace("存在背景："+mapXml.get("bg"));
            }
            //加载纹理资源
            if(mapXml.get("texture") != null)
            {
                trace("存在纹理："+mapXml.get("texture"));
                assets.enqueue([LOADHEAD + "texture/" + mapXml.get("texture")+".xml",LOADHEAD + mapXml.get("texture")+".png"]);
            }
            //载入扩展数据
            var child:Iterator<Xml> = mapXml.firstElement().elements();
            while(child.hasNext())
            {
                var childXml:Xml = child.next();
                if(childXml.get("name") == "extend")
                {
                    trace("存在扩展数据！");
                    var extendData:Dynamic = haxe.Json.parse(childXml.get("value"));
                    if(extendData.version == "0.0.2")
                    {
                        //2代地图数据
                        trace("属于2代地图数据");
                        var layers:Array<Dynamic> = cast(extendData.layers,Array<Dynamic>);
                        var i:Int = 0;
                        while(i < layers.length)
                        {
                            var layerChild:Dynamic = layers[i];
                            if(layerChild.type == "npc"){
                                loadNpcAssets(Reflect.field(extendData,layerChild.id));
                            }
                            i++;
                        }
                    }
                    //加载地图装饰素材
                    var scenery:Array<Dynamic> = extendData.scenery;
                    var index:Int = 0;
                    while(index < scenery.length)
                    {
                        loadSceneryAssets(scenery[index].path);
                        index++;
                    }
                }
            }
            //开始载入地图资源
            assets.loadQueue(onMapAssetsLoaded);
        }
    }

    private function onMapAssetsLoaded(num:Float):Void
    {
        if(num == 1)
        {
            trace("地图资源载入完毕！");
            //开始载入角色
            GameCore.roleManager.loadQueue(onRoleAssetsLoaded);
        }
        if(_func != null)
            _func(0.5*num);
    }

    private function onRoleAssetsLoaded(num:Float):Void
    {
        if(num == 1)
        {
            trace("角色资源载入完成！");
        }
        if(_func != null)
            _func(0.5 + 0.5*num);
    }

    private function loadSceneryAssets(sceneryPath:String):Void
    {   
        sceneryPath = sceneryPath.substr(0,sceneryPath.lastIndexOf("."));
        trace("载入地图块：",LOADHEAD+sceneryPath+".xml",LOADHEAD+sceneryPath+".png");
    	assets.enqueue([LOADHEAD+sceneryPath+".xml",LOADHEAD+sceneryPath+".png"]);
    }

    /**
     *  加载NPC资源
     *  @param npcData - 
     */
    private function loadNpcAssets(npcData:Array<Dynamic>):Void
    {
        var i:Int = 0;
        while(i < npcData.length)
        {
            var npcOb:Dynamic = npcData[i];
            var npcName:String = npcOb.name;
            var path:String = Std.string(npcOb.path);
            var isDragon:Bool = path.indexOf("_tex") != -1;
            path = path.substr(0,path.lastIndexOf("."));
            if(isDragon)
            {
                throw "暂不支持龙骨角色！";
            }
            else if(GameCore.gameRoleData.hasData(npcName))
            {
                trace("准备载入角色："+npcName);
                GameCore.roleManager.enqueue([npcName]);
            }
            else
            {
                trace("载入"+[LOADHEAD + path + ".xml",LOADHEAD + path + ".png"]);
                assets.enqueue([LOADHEAD + path + ".xml",LOADHEAD + path + ".png"]);
            }
            i++;
        }
        
    }

}