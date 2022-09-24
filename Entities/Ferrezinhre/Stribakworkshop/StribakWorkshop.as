// Builder Workshop

#include "Requirements.as"
#include "ShopCommon.as";
#include "WARCosts.as";
#include "CheckSpam.as";

void onInit( CBlob@ this )
{	 
	this.set_TileType("background tile", CMap::tile_wood_back);
	//this.getSprite().getConsts().accurateLighting = true;
	

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP

	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(5,3));	
	this.set_string("shop description", "Buy");
	this.set_u8("shop icon", 25);


	{
		ShopItem@ s = addShopItem( this, "Stribak Hand Cannon ", "$stribakcannon$", "stribakcannon", "Buy Stribak Hand Cannon for 75 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 75 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Siege Bow ", "$stribaksiegebow$", "stribaksiegebow", "Buy Stribak Siege Bow for 175 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 175 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Shotgun ", "$stribakshotgun$", "stribakshotgun", "Buy Stribak Shotgun for 125 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 125 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Pillager ", "$pillager$", "pillager", "Buy Stribak Pillager for 225 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 225 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Travel Stone ", "$to$", "to", "No matter how far, it will find path to other one.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 250 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "PG Overdrive ", "$pgo$", "pgo", "...NO SIGNAL FOUND...", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 250 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Unmaker ", "$unmaker$", "unmaker", "The heavens will weep for eternity.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 32000 );
	}
	
	// this.set_string("required class", "builder");
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{

	this.set_bool("shop available", this.isOverlapping(caller) /*&& caller.getName() == "builder"*/ );
}
								   
void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID("shop made item"))
	{
		this.getSprite().PlaySound( "/ChaChing.ogg" );
	}
}
			
