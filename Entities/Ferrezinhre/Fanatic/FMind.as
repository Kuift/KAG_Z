


#include "AnimalConsts.as";

const u8 DEFAULT_PERSONALITY = AGGRO_BIT | DONT_GO_DOWN_BIT;

//blob

void onInit(CBlob@ this)
{
	//brain
	this.set_u8(personality_property, DEFAULT_PERSONALITY);
	this.set_u8("random move freq",2);
	this.set_f32(target_searchrad_property, 320.0f);
	this.set_f32(terr_rad_property, 320.0f);
	this.set_u8(target_lose_random,44);
	
	this.getBrain().server_SetActive( true );
	
	//for shape
	this.getShape().SetRotationsAllowed(false);
}


void onTick(CBlob@ this)
{
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
	this.getShape().SetGravityScale(0.1);
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{
	if (blob !is null && blob.getTeamNum() == this.getTeamNum() && blob.getName() != this.getName()) return false;
	
	return true;
}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	this.getSprite().PlaySound("Fanatic_Noise" + XORRandom(9) + ".ogg");
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint @detachedPoint)
{
	this.getSprite().PlaySound("Fanatic_Noise" + XORRandom(9) + ".ogg");
}
