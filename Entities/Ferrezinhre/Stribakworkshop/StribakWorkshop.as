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
		ShopItem@ s = addShopItem( this, "Stribak Siege Bow ", "$stribaksiegebow$", "stribaksiegebow", "Buy Stribak Siege Bow for 500 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 500 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Shotgun ", "$stribakshotgun$", "stribakshotgun", "Buy Stribak Shotgun for 250 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 250 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Pillager ", "$pillager$", "pillager", "Buy Stribak Pillager for 800 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 800 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Babel ", "$babel$", "babel", "Buy Stribak Babel for 700 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 700 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Anarchy ", "$anarchy$", "anarchy", "Buy Stribak Anarchy for 675 coins.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 675 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Travel Stone ", "$to$", "to", "No matter how far, it will find path to other one.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 500 );
	}
	
	{
		ShopItem@ s = addShopItem( this, "Stribak Fanatic", "$fanatic$", "fanatic", "Imperative. AURORA APOTHEOSIS.", true );
		AddRequirement( s.requirements, "coin", "", "Coins", 1447 );
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
			
