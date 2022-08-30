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


	/*{
		ShopItem@ s = addShopItem( this, "Stribak Hand Cannon ", "$stribakcannon$", "stribakcannon", "Buy Stribak Hand Cannon for 125 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 125 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Siege Bow ", "$stribaksiegebow$", "stribaksiegebow", "Buy Stribak Siege Bow for 225 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 225 );
	}*/
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Shotgun ", "$stribakshotgun$", "stribakshotgun", "Buy Stribak Shotgun for 140 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 140 );
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
			