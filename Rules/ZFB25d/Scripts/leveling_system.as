void onInit(CRules@ this)
{
	this.set_u16("castle level", 1); 
	this.set_u16("builder level", 0);
    this.set_u16("archer level", 0);
    this.set_u16("knight level", 0);
    this.set_u16("polearm level", 0);
	this.addCommandID("castle_level_sync");
    this.addCommandID("trigger_castle_level_sync");
}

void onRestart(CRules@ this)
{
	this.set_u16("castle level", 1); 
	this.set_u16("builder level", 0);
    this.set_u16("archer level", 0);
    this.set_u16("knight level", 0);
    this.set_u16("polearm level", 0);
}

bool justJoined = true;

void onTick( CRules@ this )
{
    if (justJoined)
    {
        justJoined = false;
        CBitStream@ params;
        this.SendCommand(
            this.getCommandID("trigger_castle_level_sync"), 
            params);
    }
}

void onCommand(CRules@ this, u8 cmd, CBitStream @params){
    if (cmd == this.getCommandID("trigger_castle_level_sync"))
    {
        if(isServer())
        {
            u16 castleLevel = getRules().get_u16("castle level");
            u16 builderLevel = getRules().get_u16("builder level");
            u16 archerLevel = getRules().get_u16("archer level");
            u16 knightLevel = getRules().get_u16("knight level");
            u16 polearmLevel = getRules().get_u16("polearm level");
            CBitStream params;
            params.write_u16(castleLevel);
            params.write_u16(builderLevel);
            params.write_u16(archerLevel);
            params.write_u16(knightLevel);
            params.write_u16(polearmLevel);
            this.SendCommand(this.getCommandID("castle_level_sync"), params);
        }
    }
    if (cmd == this.getCommandID("castle_level_sync"))
    {
        if(!isServer())
        {
            u16 castleLevel = params.read_u16();
            u16 builderLevel = params.read_u16();
            u16 archerLevel = params.read_u16();
            u16 knightLevel = params.read_u16();
            u16 polearmLevel = params.read_u16();
            getRules().set_u16("castle level", castleLevel);
            getRules().set_u16("builder level", builderLevel);
            getRules().set_u16("archer level", archerLevel);
            getRules().set_u16("knight level", knightLevel);
            getRules().set_u16("polearm level", polearmLevel);
        }
    }
}