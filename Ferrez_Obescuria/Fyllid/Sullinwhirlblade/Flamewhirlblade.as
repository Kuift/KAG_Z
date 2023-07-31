#include "Hitters_mod.as";
#include "ShieldCommon.as";
#include "TeamColour.as";

void onInit( CBlob@ this )
{

	this.addCommandID("aim A1");
	this.getSprite().SetZ(10.0f);
	
	this.set_f32("explosive_radius", 32.0f);
	this.set_f32("explosive_damage", 8.0f);
	this.set_f32("map_damage_radius", 32.0f);
	this.set_f32("map_damage_ratio", 1.5f);
	this.set_bool("map_damage_raycast", true);
	this.set_bool("explosive_teamkill", false);
	this.set_u8("custom_hitter", Hitters_modnotnormalfire);
	this.set_string("custom_explosion_sound", "KegExplosion.ogg");
	this.Tag("exploding");
}	

void onTick( CBlob@ this )
{     
	if(this.getCurrentScript().tickFrequency == 1)
	{
		//this.getShape().SetGravityScale( 0.0f );
		this.server_SetTimeToDie(7);
		this.SetLight( true );
		this.SetLightRadius( 32.0f );
		this.SetLightColor( getTeamColor(this.getTeamNum()) );
		this.Tag("surge");	
		// done post init
		this.getCurrentScript().tickFrequency = 3;
	}
	
	const u32 gametime = getGameTime();

}

bool isEnemy( CBlob@ this, CBlob@ target )
{
	CBlob@ friend = getBlobByNetworkID(target.get_netid("brain_friend_id"));
	return (( target.getTeamNum() != this.getTeamNum() )||(target.hasTag("flesh") && !target.hasTag("dead") && target.getTeamNum() != this.getTeamNum() && ( friend is null || friend.getTeamNum() != this.getTeamNum() )));
}	

bool doesCollideWithBlob( CBlob@ this, CBlob@ b )
{
	return (isEnemy(this, b) || (b.getPlayer() !is null && this.getDamageOwnerPlayer() !is null&& b.getPlayer() is this.getDamageOwnerPlayer()|| b.getName() == this.getName() )); 
}

void onCollision( CBlob@ this, CBlob@ blob, bool solid, Vec2f normal)
{
	if (solid)
	{
		if(blob !is null && (isEnemy(this, blob)))
		{
			this.server_Hit(blob, blob.getPosition(), Vec2f(0,0), 4.0f, Hitters_modfire, true); 
		} 
	}
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
    if (cmd == this.getCommandID("aim A1"))
    {
        this.set_Vec2f("aimpos", params.read_Vec2f());
    }
}
void onDie(CBlob@ this)
{
	if (getNet().isServer() && this.hasTag("exploding"))
	{
		const Vec2f POSITION = this.getPosition();

		CBlob@[] blobs;
		getMap().getBlobsInRadius(POSITION, this.getRadius() + 4, @blobs);
		for(u16 i = 0; i < blobs.length; i++)
		{
			CBlob@ target = blobs[i];
			if (target.hasTag("flesh") &&
			(target.getTeamNum() != this.getTeamNum() || !target.hasTag("EndlessFlame")))
			{
				this.server_Hit(target, POSITION, Vec2f_zero, 0.0f, Hitters_modnotnormalfire, true);
			}
		}
	}
}


