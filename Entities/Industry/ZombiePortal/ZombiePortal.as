// Builder Workshop
#include "Hitters.as";
//#include "Requirements.as"
//#include "ShopCommon.as";
//#include "Descriptions.as";
//#include "WARCosts.as";
//#include "CheckSpam.as";

void onInit( CBlob@ this )
{	 
	//this.set_TileType("background tile", CMap::tile_wood_back);
	//this.getSprite().getConsts().accurateLighting = true;
	
	this.SetMinimapVars("PortalIcon.png", 1, Vec2f(4, 4));
	this.SetMinimapRenderAlways(true);

	this.Tag("ZombiePortalz"); //HOPEFULLY YOU STOPPED DISAPPEARING - Tsilliev
	this.getSprite().SetZ(-50); //background
	CSpriteLayer@ portal = this.getSprite().addSpriteLayer( "portal", "ZombiePortal.png" , 64, 64, -1, -1 );
	CSpriteLayer@ lightning = this.getSprite().addSpriteLayer( "lightning", "EvilLightning.png" , 32, 32, -1, -1 );
	Animation@ anim = portal.addAnimation( "default", 0, true );
	Animation@ lanim = lightning.addAnimation( "default", 4, false );
	for (int i=0; i<7; i++) lanim.AddFrame(i*4);
	Animation@ lanim2 = lightning.addAnimation( "default2", 4, false );
	for (int i=0; i<7; i++) lanim2.AddFrame(i*4+1);
	anim.AddFrame(1);
	portal.SetRelativeZ( 1000 );
//	portal.SetOffset(Vec2f(0,-24));
//	lightning.SetOffset(Vec2f(0,-24));
	this.getShape().getConsts().mapCollisions = false;
	this.set_bool("portalbreach",false);
	this.set_bool("portalplaybreach",false);
	this.SetLight(false);
	this.SetLightRadius( 64.0f );
	
}

void onDie( CBlob@ this)
{
	server_DropCoins(this.getPosition() + Vec2f(0,-32.0f), 1000);
}
void onTick( CBlob@ this)
{
	int spawnRate = 46 + (this.getHealth());
	/*if (spawnRate <= 0)
	{
	this.server_Die();
	}*/
	if (getGameTime() % spawnRate == 0 && this.get_bool("portalbreach"))
	{
		this.getSprite().PlaySound("Thunder");
		CSpriteLayer@ lightning = this.getSprite().getSpriteLayer("lightning");
		if (XORRandom(4)>2) lightning.SetAnimation("default"); else lightning.SetAnimation("default2");
		//lightning.SetFrame(0);
	}

	if (this.get_bool("portalplaybreach")) {
		this.getSprite().PlaySound("PortalBreach");
		this.set_bool("portalplaybreach",false);
		this.SetLight(true);
		this.SetLightRadius( 64.0f );		
	}
	if (!getNet().isServer()) return;
	int num_portal_zombies = getRules().get_s32("num_portal_zombies");
	int max_portal_zombies = getRules().get_s32("max_portal_zombies");
	//int num_zombies = 40;
	if (this.get_bool("portalbreach"))
	{
		if ((getGameTime() % spawnRate == 0) && num_portal_zombies < max_portal_zombies)
		{
		CBlob@[] blobs; //hello
		getMap().getBlobsInRadius( this.getPosition(), 250, @blobs );
		if (blobs.length == 0) return;

			Vec2f sp = this.getPosition();
			
			int r;
			r = XORRandom(10);
			int rr = XORRandom(8);
			if (r==9 && rr<2) {
				CBlob@ spawned_zombie = server_CreateBlob( "ukkon", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			else
			if (r==8 && rr<8) {
				CBlob@ spawned_zombie = server_CreateBlob( "Wraith", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			else										
			if (r==7 && rr<22) {
				CBlob@ spawned_zombie = server_CreateBlob( "Greg", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			else					
			if (r==6) {
				CBlob@ spawned_zombie = server_CreateBlob( "hellknight", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			else					
			if (r==5) {
				CBlob@ spawned_zombie = server_CreateBlob( "ZombieKnight", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			else					
			if (r==4) {
				CBlob@ spawned_zombie = server_CreateBlob( "crawler", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			else
			if (r>=3) {
				CBlob@ spawned_zombie = server_CreateBlob( "Zombie", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			else {
				CBlob@ spawned_zombie = server_CreateBlob( "Skeleton", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			if ((r==7 && rr<12) || (r==8 && rr<8) || (r<7) || r==9 && rr<4)
			{
				num_portal_zombies++;
				getRules().set_s32("num_portal_zombies",num_portal_zombies);
				
			}
		}
	}

	if ((getGameTime()  + (this.getNetworkID() % 100)) % 260 == 0) //changed to be lower to activate from players faster
	{
		Vec2f sp = this.getPosition();
		
	
		CBlob@[] blobs;
		this.getMap().getBlobsInRadius( sp, 64, @blobs );
		bool activate = false; //this may need to be synced as well idk 
		for (uint step = 0; step < blobs.length; ++step)
		{
			CBlob@ other = blobs[step];
			if (other.hasTag("player"))
			{
				activate = true;
				break;
			}
		}
		this.set_bool("portalbreach",activate);
		this.set_bool("portalplaybreach",activate);
		this.Sync("portalplaybreach",activate); 
		this.Sync("portalbreach",activate); 
		if(!activate){
			this.SetLight(false);
		}
	}
}
void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
//	this.set_bool("shop available", this.isOverlapping(caller) /*&& caller.getName() == "builder"*/ );
}

f32 onHit(CBlob@ this, Vec2f worldPoint, Vec2f velocity, f32 damage, CBlob@ hitterBlob, u8 customData)
{						   
	switch (customData)
	{
		case Hitters::bomb_arrow:
			damage *= 0.25f; //quarter damage from these
		break;
	}
	return damage;
}