#include "GenericButtonCommon.as"
#include "TunnelCommon.as"
#include "StandardRespawnCommand.as"
#include "StandardControlsCommon.as"
// original idea by SK
void onInit(CBlob@ this){
    this.set_TileType("background tile", CMap::tile_wood_back);
    this.set_u16("castle level", 1); //required to be set at level 1 to start
    this.set_u16("max level", 3);
    this.set_u16("wood cost", 0); //assume the costs are for level 2
    this.set_u16("stone cost", 500);
    this.set_u16("gold cost", 500);
    this.addCommandID("Upgrade Level");
    this.getSprite().SetZ(100.0f);
    this.set_u16("day", getRules().get_u16("dayNumber")); //DAY EQUATION IN ZOMBIE_RULES.AS

    // InitRespawnCommand(this);
    InitClasses(this);
    // this.Tag("respawn");
    this.Tag("change class drop inventory");
    
    this.Tag("travel tunnel"); //tunnel stuff
    this.set_Vec2f("travel button pos", Vec2f(-6, 0));
    this.set_Vec2f("travel offset", Vec2f(-10, 0));
    this.Tag("teamlocked tunnel");
    this.Tag("ignore raid");

    this.inventoryButtonPos = Vec2f(0, -16);
    this.Tag("builder always hit");

    AddIconToken("$upgrade$", "/GUI/InteractionIcons.png", Vec2f(32, 32), 15, 2); //builder hammer icon
    AddIconToken("$tunnel_travel$", "/GUI/InteractionIcons.png", Vec2f(32, 32), 9, 2); //tunnel travel icon
    AddIconToken("$change_class$", "/GUI/InteractionIcons.png", Vec2f(32, 32), 12, 2); //change class icon
}

void onTick(CBlob@ this){
    if(getGameTime() % 30 == 0){ //prevent lag
        if(getRules().get_u16("dayNumber") != this.get_u16("day")){
            this.set_u16("day", getRules().get_u16("dayNumber"));
            if(this !is null){
                int coinamount = getGoldinInv(this);
                if(coinamount == 0){return;}
                for(int i = 0; i < getPlayerCount(); ++i){
                    CPlayer@ p = getPlayer(i);
                    if(p !is null){
                        p.server_setCoins(p.getCoins()+coinamount); //give coins
                    }
                }
            }
        }
    }
}

void GetButtonsFor(CBlob@ this, CBlob@ caller){
	if (!canSeeButtons(this, caller)) return;
    
	if (caller.isOverlapping(this))
    {
        if (canChangeClass(this, caller)){
        	caller.CreateGenericButton("$change_class$", Vec2f(6, 0), this, buildSpawnMenu, getTranslatedString("Swap Class"));
        }
        if(this.get_u16("castle level") < 3){
            CBitStream params;
            params.write_u16(caller.getNetworkID());
            int castlelvl = this.get_u16("castle level")+1;
            caller.CreateGenericButton("$upgrade$", Vec2f(-6, -8), this, this.getCommandID("Upgrade Level"), getTranslatedString("Upgrade to level " + castlelvl + "!"), params);
        }
    }
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params){
	if (getNet().isServer())
	{
        onRespawnCommand(this, cmd, params);
		if (cmd == this.getCommandID("Upgrade Level"))
		{
            CBlob@ caller = getBlobByNetworkID(params.read_u16());
            if(caller !is null && this !is null){
                CInventory@ inv = caller.getInventory();
                if(hasMats(caller,this)){
                    stealmats(caller, this); //take away the mats from person
                    this.set_u16("castle level", this.get_u16("castle level") + 1);
                    this.set_u16("wood cost", this.get_u16("wood cost")+250);
                    this.set_u16("stone cost", this.get_u16("stone cost")+250);
                    this.set_u16("gold cost", this.get_u16("gold cost")+250);
                }
            }
        }
    }
}

void stealmats(CBlob@ caller, CBlob@ castle){
    CInventory@ inv = caller.getInventory();
    if(inv !is null){
        inv.server_RemoveItems("mat_gold", castle.get_u16("gold cost"));
        inv.server_RemoveItems("mat_stone", castle.get_u16("stone cost"));
        inv.server_RemoveItems("mat_wood", castle.get_u16("wood cost"));
    }
}

bool hasMats(CBlob@ caller, CBlob@ castle){
    CInventory@ inv = caller.getInventory();
    if(castle.get_u16("castle level") < castle.get_u16("max level")){
        if(inv !is null){
            if(inv.getCount("mat_stone") >= castle.get_u16("stone cost")){ //enough stone?
                if(inv.getCount("mat_gold") >= castle.get_u16("gold cost")){ //enough gold?
                    if(inv.getCount("mat_wood") >= castle.get_u16("wood cost")){ //enough wood?
                        return true;
                    }
                }
            }
        }
    }
    return false;
}

int getGoldinInv(CBlob@ this){ //get amount of coins it should produce
    if(this !is null){
        CInventory@ inv = this.getInventory();
        if(inv !is null){
            int coins = 50; // tier 1 coin amount
            if(this.get_u16("castle level") == 2){
                coins = 80;
            }
            else if(this.get_u16("castle level") == 3){
                coins = 90;
            } //dont give more than 90 for levels above this
            int goldininv = 0;

            for(int i = 0; i < inv.getItemsCount(); i++){
                CBlob@ item = inv.getItem(i);
                if(item.getName() == "mat_gold"){
                    if(item.getQuantity() == 250){
                        goldininv++;
                    }
                }
            }
            int coinstoreturn = int(goldininv*0.5 * coins);
            return coinstoreturn;
        }
    }
    return 0;
}