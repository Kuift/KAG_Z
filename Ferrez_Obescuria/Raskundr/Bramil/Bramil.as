
#include "Hitters_mod.as"
#include "TeamColour.as";

#include "FireCommon.as"

void onInit(CBlob@ this)
{
	CShape@ shape = this.getShape();
	shape.getConsts().mapCollisions = false;
	shape.SetRotationsAllowed(false);
	shape.SetStatic(true);
	this.set_u16("lifetime", 5);
	//this.getSprite().SetZ(-50); //background
	this.Tag("builder always hit");

}

void onTick( CBlob@ this )
{
	if (this.getTickSinceCreated() < 1)
	{		
		this.server_SetTimeToDie(this.get_u16("lifetime"));
		
		CShape@ shape = this.getShape();
		shape.SetStatic(true);
		
		
		CSprite@ sprite = this.getSprite();
		sprite.getConsts().accurateLighting = false;
		
	}
	
	CMap@ map = this.getMap();
	Vec2f thisPos = this.getPosition();
		
	TileType overtile = map.getTile(thisPos).type;
	if(map.isTileSolid(overtile))
	{
		//this.server_Die();
	}
}

void onDie(CBlob@ this)
{
	
	//this.getSprite().PlaySound("rocks_explode2.ogg", 1.0f, 1.0f);
}

void onSetStatic(CBlob@ this, const bool isStatic)
{
	if (!isStatic) return;

	//this.getSprite().PlaySound("/build_wood.ogg");
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false;
}

bool isEnemy( CBlob@ this, CBlob@ target )
{
	CBlob@ friend = getBlobByNetworkID(target.get_netid("brain_friend_id"));
	return ( !target.hasTag("dead") 
		&& target.getTeamNum() != this.getTeamNum() 
		&& (friend is null
			|| friend.getTeamNum() != this.getTeamNum()
		)
	);
}

bool doesCollideWithBlob( CBlob@ this, CBlob@ b )
{
	return ( isEnemy( this, b ) && !b.hasTag("player") );
}


void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (blob !is null && blob.hasTag("player"))
	{
		if (isServer()) this.server_Hit(blob, this.getPosition(), blob.getVelocity() * -1, 2.0f, Hitters_modfall, true);
	}
}


f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{
	if (hitterBlob !is null && hitterBlob.hasTag("player"))
	{
		if (isServer()) this.server_Hit(hitterBlob, this.getPosition(), Vec2f(0, 0), 1.0f, Hitters_modfall, false);
	}

	return damage;
}
