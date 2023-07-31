#include "Hitters_mod.as";
#include "TeamStructureNear.as";


void onInit(CBlob@ this)
{
	this.SetLight(true);
	this.SetLightRadius(372.0f);
	this.SetLightColor(SColor(255, 255, 201, 250));
	this.getShape().getVars().waterDragScale = 24.0f;
	this.getCurrentScript().tickIfTag = "activated";
	this.getShape().SetGravityScale(0.0f);
	this.server_SetTimeToDie(27);
	Sound::Play("/Tsuyanispeaks.ogg", this.getPosition());
}


void onTick(CBlob@ this)
{
	if (this.hasTag("activated"))
	{

		this.SetLight(true);
		this.SetLightRadius(32);


	}
}

bool canBePickedUp(CBlob@ this, CBlob@ byBlob)
{
	return false; //maybe make a knocked out state? for loading to cata?
}


void onInit(CSprite@ this)
{
	this.getCurrentScript().tickIfTag = "exploding";
}





void onCollision(CBlob@ this, CBlob@ blob, bool solid)
{
	if (!solid)
	{
		return;
	}

	f32 vellen = this.getOldVelocity().Length();

	if (vellen > 1.7f)
	{
		Sound::Play("/material_drop", this.getPosition(), Maths::Min(vellen / 8.0f, 1.1f));
	}
}

