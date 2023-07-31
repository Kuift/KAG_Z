// scroll script that makes enemies insta gib within some radius

#include "Hitters_mod.as";
#include "RespawnCommandCommon.as"
#include "StandardRespawnCommand.as"
#include "UniformCommon.as"
void onInit( CBlob@ this )
{
	this.addCommandID("threestararcher");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{	
		caller.Tag("threestararcher");
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("threestararcher"), "Use this to change into a tier 3 archer.", params );
	}
}