// scroll script that makes enemies insta gib within some radius

#include "/Entities/Common/Attacks/Hitters.as";
#include "RespawnCommandCommon.as"
#include "StandardRespawnCommand.as"
#include "UniformCommon.as"
void onInit( CBlob@ this )
{
	this.addCommandID("threestarpolearm");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	CBitStream params;
	params.write_u16(caller.getNetworkID());
	u8 kek = caller.getTeamNum();	
	if (kek == 0)
	{	
		caller.Tag("threestarpolearm");
		caller.CreateGenericButton( 11, Vec2f_zero, this, this.getCommandID("threestarpolearm"), "Use this to change into a tier 3 polearm.", params );
	}
}