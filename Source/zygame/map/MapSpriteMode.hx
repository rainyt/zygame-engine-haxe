package zygame.map;


/**
	 * 地图精灵模式 
	 * @author grtf
	 * 
	 */
class MapSpriteMode
{
    /**
		 * 不可穿透地形 
		 */
    public static inline var NOT_PENETRATE : String = "not_penetrate";
    
    /**
		 * 可见的，左右下可穿透地形 
		 */
    public static inline var VISIBLE_STES : String = "visible_stes";
    
    /**
		 * 不可见的，左右下课穿透地形 
		 */
    public static inline var NOT_VISIBLE_STES : String = "not_visible_stes";
    
    /**
		 * 触碰隐藏的地形，可穿透 
		 */
    public static inline var DYNAMIC_VISIBLE : String = "dynamic_visible";
    
    /**
		 * 没有碰撞 
		 */
    public static inline var NOT_HIT : String = "not_hit";
    
    /**
		 * 不可见的，实体的
		 */
    public static inline var NOT_VISIBLE_NOT_PENETRATE : String = "not_visible_not_penetrate";
    
    
    /**
		 * 获取颜色 
		 * @param str
		 * @return 
		 * 
		 */
    public static function getColor(str : String) : Int
    {
        switch (str)
        {
            case NOT_PENETRATE:
                return 0x00ff00;
            case VISIBLE_STES:
                return 0x0000ff;
            case NOT_VISIBLE_STES:
                return 0xff0000;
        }
        return 0xffffff;
    }

    public function new()
    {
    }
}
