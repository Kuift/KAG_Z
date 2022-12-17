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
	CSpriteLayer@ portal = this.getSprite().addSpriteLayer( "portal", "bukavacportal.png" , 64, 64, -1, -1 );
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
	int spawnRate = 31 + (this.getHealth());
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
		Vec2f sp = this.getPosition();
		int random_nb = XORRandom(4);
		switch (random_nb) // make the spawnpoint alternate between up down left or right part of the portal
		{
			case 0:
				sp += Vec2f(8.0f*5,0.0f);
				break;
			case 1:
				sp += Vec2f(-8.0f*5,0.0f);
				break;
			case 2:
				sp += Vec2f(0.0f,8.0f*3);
				break;
			case 3:
				sp += Vec2f(0.0f,-8.0f*3);	
				break;
			default:
				break;
		}
		if ((getGameTime() % spawnRate == 0) && num_portal_zombies < max_portal_zombies)
		{
		//	CBlob@[] blobs;
		// getMap().getBlobsInRadius( this.getPosition(), 40, @blobs ); //wait, might be related to the deactive, reactive thing, lemme see where that is
		// if (blobs.length == 0) return; //wait, maybe it was already "deactivating" before, we just didn't notice it because the range was fucking 250

			
			int r;
			r = XORRandom(10);
			int rr = XORRandom(8);
			if (r<5 ) {
				CBlob@ spawned_zombie = server_CreateBlob( "bukavac", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			else
			if (r>5 ) {
				CBlob@ spawned_zombie = server_CreateBlob( "bukavacadult", -1, sp);
				spawned_zombie.Untag("zombie");
				spawned_zombie.Tag("portal_zombie");
			}
			if ((r==7 && rr<12) || (r==8 && rr<8) || (r<7) || r==9 && rr<4)
			{
				num_portal_zombies++;
				getRules().set_s32("num_portal_zombies",num_portal_zombies);
			}
		}
		else if (!isClient() && (getGameTime() % spawnRate == 0) && num_portal_zombies >= max_portal_zombies)
		{ //if the maximum of portal zombie are on the map, we just take an existing portal zombie and tp it to the portal.
			CBlob@[] portal_zombie_list;
			getBlobsByTag("portal_zombie", portal_zombie_list);
			float currentDistance = -1;
			int furthest_zombie_index = 0;
			for(int i = 0; i < portal_zombie_list.size(); ++i)
			{
				float distance = (sp - portal_zombie_list[i].getPosition()).getLength();
				if (currentDistance < distance)
				{ //change below untested, if something breaks its probably from that.
					if(portal_zombie_list[i].getName() == 'Greg'){ //drop player before teleporting
						portal_zombie_list[i].server_DetachAll();
					}
					currentDistance = distance;
					furthest_zombie_index = i;
				}
			}
			portal_zombie_list[furthest_zombie_index].setPosition(sp);
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
			
		case Hitters::arc:
			damage *= 0.3f; //1/3 damage from pillager
		break;
	}
	if(hitterBlob.hasTag("megasaw blade")){
		damage *= 0.01f; //quarter damage from megasaw
	}
	return damage;
}

bool doesCollideWithBlob(CBlob@ this, CBlob@ blob) {
	//"this" is the portal and blob is collider.
	if(blob.hasTag("portal_zombie") || blob.hasTag("zombie") || blob.hasTag("player")){
		return false;
	}
	return true;
}
/*array<@CBlob> getPlayers()
{
	array<@CBlob> muharray;
	CBlob@ playerpos;
	getBlobsByTag("player", muharray); //getblobsbytag take a list as a argument and modify said list
	return muharray;
}*/
