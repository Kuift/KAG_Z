
#include "Hitters.as";

void onInit(CBlob@ this)
{

	this.Tag("ignore fall");
	this.Tag("ignore_saw");
	this.getShape().SetGravityScale(0.0f);
	this.server_SetTimeToDie(12);
}



void onTick(CBlob@ this)
{
	
}

void onCommand(CBlob@ this, u8 cmd, CBitStream@ params)
{

}






bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	return blob.getShape().isStatic() && blob.isCollidable();
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	
}



bool canBePickedUp(CBlob@ this, CBlob@ blob)
{
	return false;
}

