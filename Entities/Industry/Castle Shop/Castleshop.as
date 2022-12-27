#include "GenericButtonCommon.as"
#include "StandardRespawnCommand.as"
#include "StandardControlsCommon.as"
#include "Requirements_Tech.as" //for only one castle


void onInit(CBlob@ this){
    this.set_TileType("background tile", CMap::tile_castle_back);
    this.setPosition(Vec2f(this.getPosition().x, this.getPosition().y-16.0f)); //required to not dig into ground
    this.set_u16("castle level", 1); //required to be set at level 1 to start
    getRules().set_u16("castle level", this.get_u16("castle level"));
    this.set_u16("max level", 6);
    this.set_u16("wood cost", 0); //assume the costs are for level 2
    this.set_u16("stone cost", 500);
    this.set_u16("gold cost", 500);
    getRules().set_u16("castle level", 1);

    this.addCommandID("Upgrade Level");
    this.addCommandID("addGoldToInv");
    this.set_u16("gold", 0); //how much gold has been fed?
    this.getSprite().SetZ(-50.0f);
    this.set_u16("day", getRules().get_u16("dayNumber")); //DAY EQUATION IN ZOMBIE_RULES.AS

    // InitRespawnCommand(this);
    InitClasses(this);
    // this.Tag("respawn");
    this.Tag("change class drop inventory");

    this.inventoryButtonPos = Vec2f(-4, 16);
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
            caller.CreateGenericButton("$change_class$", Vec2f(6, 8), this, buildSpawnMenu, getTranslatedString("Swap Class"));
        }

        if(this.get_u16("castle level") <= 2){
            if(this.get_u16("gold") < 2000){
                CBitStream params;
                params.write_u16(caller.getNetworkID());
                caller.CreateGenericButton("$mat_gold$", Vec2f(-10.5f, 8), this, this.getCommandID("addGoldToInv"), getTranslatedString("Upgrade coin gain!"), params);
            }
        }
        else{
            if(this.get_u16("gold") < 3000){
                CBitStream params;
                params.write_u16(caller.getNetworkID());
                caller.CreateGenericButton("$mat_gold$", Vec2f(-10.5f, 8), this, this.getCommandID("addGoldToInv"), getTranslatedString("Upgrade coin gain!"), params);
            }
        }

        if(this.get_u16("castle level") < this.get_u16("max level")){
            CBitStream params;
            params.write_u16(caller.getNetworkID());
            int castlelvl = this.get_u16("castle level")+1;
            caller.CreateGenericButton("$upgrade$", Vec2f(6, 0), this, this.getCommandID("Upgrade Level"), getTranslatedString("Upgrade to level " + castlelvl + "!"+extratext(this)), params);
        }
    }
}

string extratext(CBlob@ this){
    return "\nWood Cost: " + this.get_u16("wood cost") + "\nStone Cost: " + this.get_u16("stone cost") + "\nGold Cost: " + this.get_u16("gold cost");
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
                    getRules().set_u16("castle level", this.get_u16("castle level"));
                    this.set_u16("wood cost", this.get_u16("wood cost")+250);
                    this.set_u16("stone cost", this.get_u16("stone cost")+250);
                    this.set_u16("gold cost", this.get_u16("gold cost")+250);
                    this.SendCommand(getRules().getCommandID("trigger_castle_level_sync"));
                }
            }
        }
        if(cmd == this.getCommandID("addGoldToInv")){
            CBlob@ caller = getBlobByNetworkID(params.read_u16());
            if(caller !is null && this !is null){
                CInventory@ inv = caller.getInventory();
                if(inv !is null){
                    
                    int goldcount = this.get_u16("gold"); // GOLD IS STORED LOCALLY ON EACH COMPUTER, AMOUNT OF GOLD SHOULD BE SENT OVER THE NETWORK
                    int goldmax = this.get_u16("castle level") <= 2 ? 2000 : 3000; //set max here
                    
                    if(goldcount >= goldmax){return;}
                    
                    if(inv.getCount("mat_gold") >= 250){ //this is to prevent taking all the gold from a player
                        if(goldcount + 250 <= goldmax){ //under max gold amount
                            this.set_u16("gold",goldcount+250);
                            inv.server_RemoveItems("mat_gold", 250);
                        }
                        else{ //over max amount
                            int surplusAmount = (goldcount + 250) - goldmax; // if limit is 7000, you have 6850 gold, you add 250, then you are at 7100. 7100-7000 = 100
                            this.set_u16("gold",goldmax);//goldcount+amounttoadd); // I THINK THIS SHOULD JUST BE GOLDMAX
                            inv.server_RemoveItems("mat_gold", 250-surplusAmount);
                        }
                    }
                    else{ //dont have 250 or more
                        if(goldcount + inv.getCount("mat_gold") <= goldmax){ //under max gold amount
                            this.set_u16("gold",goldcount+inv.getCount("mat_gold"));
                            inv.server_RemoveItems("mat_gold", inv.getCount("mat_gold"));
                        }
                        else{ //over max amount // SO BASICALLY, YOU WANT IT SO THAT IF YOU HAVE only 50 GOLD, THAT IT TAKES THE WHOLE 50 GOLD ?
                            // this code is to take any amount of gold under 250, two ifs above this one handles the max stack amount
                            int surplusAmount = (goldcount + inv.getCount("mat_gold")) - goldmax; //level 1 max: 2000+0 - 2000 // 6975 + 50 = 7025 - 7000 = 25
                            this.set_u16("gold",goldmax); //this is the only code block that doesnt work
                            inv.server_RemoveItems("mat_gold", inv.getCount("mat_gold"));
                        } //should i start adding upgrades for the uniforms in this? make it so that there's an easy way to retrieve the level of the castle from the CRULES
                    } //this.get_u16("castle level"); yes but it would have to be sync across all instances in CRules, so that we can easily access it
                } //will set in top as a crules thing too :thumbsupemoji: u should test the code i just changed btw
            } //i believe i did it, should be getRules().get_u16("castle level") it wont be synced across clients. lemme fix that for u
        } //need sync()?
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
        int coins = 50; // tier 1 coin amount
        if(this.get_u16("castle level") == 2){
            coins = 80;
        }
        else if(this.get_u16("castle level") == 3){
            coins = 90;
        } //dont give more than 90 coins for levels above this
        return int((this.get_u16("gold")/250)*0.5 * coins); //each stack is 250, thats why we divide by 250 here
    }
    return 0;
}

void onDie(CBlob@ this){
    RemoveFakeTech(getRules(), "Castle", this.getTeamNum());
}