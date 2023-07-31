// ClusterCharge
#include "Hitters_mod.as";
#include "BombCommon.as";
#include "Explosion.as";


void onTick(CSprite@ this)
{
	CBlob@ blob = this.getBlob();
	if(blob.isOnGround() || blob.getShape().isStatic() || blob.isAttached()) return;

	Vec2f velocity = blob.getVelocity();
	velocity.Normalize();

	f32 angle = velocity.Angle();

	this.ResetTransform();
	this.RotateBy(-angle - 90, Vec2f_zero);
}

const u16 fuse = 45;

void onInit(CBlob@ this)
{

	this.Tag("ignore fall");

	

	// used by Explosion.as
	this.set_f32("explosive_radius", (64.0f)); 
	this.set_f32("explosive_damage", (6.0f)); 
	this.set_f32("map_damage_radius", (12.0f)); 
	this.set_bool("map_damage_raycast", true);
	this.set_f32("map_damage_ratio", (1.0f));
	this.set_bool("explosive_teamkill", false);

	this.set_u8("custom_hitter", Hitters_modblast); //custom hitter
	this.set_string("custom_explosion_sound", "KegExplosion.ogg");


	CShape@ shape = this.getShape();
	shape.getVars().waterDragScale = 12.0f;
	shape.getConsts().collideWhenAttached = false;

	this.getCurrentScript().tickIfTag = "exploding";
	this.set_u32("timer", getGameTime() + fuse);
		this.Tag("exploding");
		this.Tag("spiky");
}

void onTick(CBlob@ this)
{
	const u32 timer = this.get_u32("timer");
	const u32 time = getGameTime();
	const s16 remaining = timer - time;


	if(remaining > 0) return;

	Explode(this, this.get_f32("explosive_radius"), this.get_f32("explosive_damage"));

	if(getNet().isServer())
	{
		this.server_Die();
	}
}

void onCollision(CBlob@ this, CBlob@ blob, bool solid, Vec2f normal, Vec2f point1)
{
	if(!solid && !blob.hasTag("flesh")) return;

	CShape@ shape = this.getShape();
	if(this.hasTag("spiky") && !shape.isStatic())
	{
		this.setPosition(normal * this.getRadius() + point1);
		shape.SetStatic(true);
		this.Tag("spikyignore");
		this.server_Hit(blob, point1, normal, 4.0f, Hitters_modblast); //custom hitter
	}

	CSprite@ sprite = this.getSprite();
	if(sprite is null) return;

	const f32 angle = normal.Angle();

	sprite.ResetTransform();
	sprite.RotateBy(-angle + 90, Vec2f_zero);


}

void onAttach(CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint)
{
	this.getSprite().ResetTransform();
}

void onDetach(CBlob@ this, CBlob@ detached, AttachmentPoint@ attachedPoint)
{
	// double check static, if static set to false
	CShape@ shape = this.getShape();
	if(!shape.isStatic()) return;

	shape.SetStatic(false);
}

void onThisAddToInventory( CBlob@ this, CBlob@ inventoryBlob )
{
	this.doTickScripts = true;
}

void onCommand(CBlob@ this, u8 cmd, CBitStream @params)
{

	
}

void onDie(CBlob@ this)
{
	this.getSprite().Gib();
	Explode(this, this.get_f32("explosive_radius"), this.get_f32("explosive_damage"));
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob)
{

if(blob.hasTag("projectile") || this.hasTag("spikyignore"))
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


bool canBePickedUp(CBlob@ this, CBlob@ blob)
{
	return false;
}
