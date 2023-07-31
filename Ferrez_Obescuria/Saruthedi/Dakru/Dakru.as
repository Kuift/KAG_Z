#include "Hitters_mod.as";
#include "ShieldCommon.as";
#include "TeamColour.as";

void onInit( CBlob@ this )
{

	this.addCommandID("aim A1");
	this.getSprite().SetZ(10.0f);
	
	this.server_SetTimeToDie(20.0f);
	this.set_bool("justHit", false);
	this.Tag("EndlessFlame");

}	

void onTick( CBlob@ this )
{     
	if(this.getCurrentScript().tickFrequency == 1)
	{
		this.getShape().SetGravityScale( 0.3f );
		this.SetLight( true );
		this.SetLightRadius( 32.0f );
		this.SetLightColor( getTeamColor(this.getTeamNum()) );
		this.Tag("surge");	
		// done post init
		this.getCurrentScript().tickFrequency = 3;
	}
	
	const u32 gametime = getGameTime();
	
	f32 x = this.getVelocity().x;
	
	if (Maths::Abs(x) > 1.0f)
	{
		this.SetFacingLeft( x < 0 );
	}
	else
	{
		if (this.isKeyPressed(key_left)) {
			this.SetFacingLeft( true );
		}
		if (this.isKeyPressed(key_right)) {
			this.SetFacingLeft( false );
		}
	}

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

void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
	if (blob !is null && doesCollideWithBlob(this, blob) && !this.hasTag("collided") && !blob.hasTag("dead") )
	{
		if (!solid && !blob.hasTag("flesh"))
		{
			return;
		}
		
		this.set_u8("custom_hitter", Hitters::water_stun);
		if(this.get_bool("justHit") == false)
		{
			this.server_Hit(blob, point1, normal, (0.5f), Hitters::water_stun); // You're my another favorite little meat grinder!
			this.set_bool("justHit", true);
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


}

f32 onHit( CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData )
{	


	if (customData == Hitters::notnormalfire) //need do other custom hitter later, or custom hitters as due this error
	{
		damage*= 0.0;
	}
	return 0.0f; //done, we've used all the damage	
}


