
#include "Hitters.as";
#include "ShieldCommon.as";
#include "ArcherCommon.as";
#include "TeamStructureNear.as";
#include "Knocked.as"
#include "MakeDustParticle.as";
#include "ParticleSparks.as";

const f32 ARROW_PUSH_FORCE = 22.0f;

//blob functions
void onInit(CBlob@ this)
{
	CShape@ shape = this.getShape();
	ShapeConsts@ consts = shape.getConsts();
	this.set_u8("custom_hitter", Hitters::arrow);
	//consts.mapCollisions = false;	 // weh ave our own map collision
	consts.bullet = true;
	consts.net_threshold_multiplier = 4.0f;
	this.Tag("projectile");
	
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
	if (blob !is null && doesCollideWithBlob(this, blob) && !this.hasTag("collided") && !blob.hasTag("dead") )
	{
	if (!solid && !blob.hasTag("flesh"))
		{
			return;
		}
		
		this.set_u8("custom_hitter", Hitters::arrow);
		this.server_Hit(blob, point1, normal, 2.0f, Hitters::arrow); // You're my favorite little meat grinder!
		this.server_Die();
	}
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{

if(blob.hasTag("projectile"))
{
return false;
}

bool check = this.getTeamNum() != blob.getTeamNum();
if(!check)
{
CShape@ shape = blob.getShape();
check = (shape.isStatic() && !shape.getConsts().platform);
}

if (check)
{
return true;
}

return false;
}


void onTick(CBlob@ this)
{
	f32 angle = (this.getVelocity()).Angle();
	Pierce(this); //hit vs map
	this.setAngleDegrees(-angle);

	CShape@ shape = this.getShape();
	shape.SetGravityScale(this.get_f32("gravity"));
}

void Pierce(CBlob @this)
{
	CMap@ map = this.getMap();
	Vec2f end;
	if (map.rayCastSolidNoBlobs(this.getShape().getVars().oldpos, this.getPosition() ,end))
	{
		HitMap(this, end, this.getOldVelocity(), 0.5f, Hitters::arrow);
	}
}

void HitMap(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, u8 customData)
{
	this.getSprite().PlaySound(XORRandom(4) == 0 ? "BulletRicochet.ogg" : "BulletImpact.ogg");
	MakeDustParticle(worldPoint, "/DustSmall.png");
	CMap@ map = this.getMap();
	f32 vellen = velocity.Length();
	TileType tile = map.getTile(worldPoint).type;
	if (map.isTileCastle(tile) || map.isTileStone(tile))
	{
		sparks (worldPoint, -velocity.Angle(), Maths::Max(vellen*0.05f, damage));
	}
	this.server_Die();
}

void onHitBlob(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitBlob, u8 customData)
{
	// unbomb, stick to blob
	if (this !is hitBlob && customData == Hitters::arrow)
	{
		// affect players velocity
		f32 force = (ARROW_PUSH_FORCE * -0.125f) * Maths::Sqrt(hitBlob.getMass()+1);
		hitBlob.AddForce(velocity * force);
	}
}
