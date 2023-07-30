// Genreic building

#include "Requirements.as"
#include "ShopCommon.as";
#include "WARCosts.as";
#include "CheckSpam.as";
#include "Requirements_Tech.as";
//Military2 = civil building
//are builders the only ones that can finish construction?
const bool builder_only = false;

void onInit( CBlob@ this )
{	 
	AddIconToken( "$kitchen$", "kitchen.png", Vec2f(32,16), 0 );
	AddIconToken( "$apartment$", "apartment.png", Vec2f(32,16), 0 );
	AddIconToken( "$siren$", "siren.png", Vec2f(32,16), 0 );
	//AddIconToken( "$hall$", "hall.png", Vec2f(32,32), 0 );
	//AddIconToken( "$war_base$", "war_base.png", Vec2f(32,32), 0 );
	AddIconToken( "$boulderfactory$", "ResIconspng.png", Vec2f(32,16), 5 );
	AddIconToken( "$lanternfactory$", "ResIconspng.png", Vec2f(32,16), 6 );
	AddIconToken( "$sawfactory$", "ResIconspng.png", Vec2f(32,16), 7 );
	AddIconToken( "$flagfactory$", "ResIconspng.png", Vec2f(32,16), 8 );
	//AddIconToken( "$building$", "building.png", Vec2f(32,16), 0 );
	AddIconToken( "$pa$", "PA.png", Vec2f(32,16), 0 );
	AddIconToken("$scrollshop$", "ScrollShop.png", Vec2f(32,16), 1);
	AddIconToken("$castle$", "Castle_icon.png", Vec2f(32,16), 1);

	this.set_TileType("background tile", CMap::tile_wood_back);
	//this.getSprite().getConsts().accurateLighting = true;
	

	this.getSprite().SetZ(-50); //background
	this.getShape().getConsts().mapCollisions = false;

	// SHOP

	this.set_Vec2f("shop offset", Vec2f(0, 0));
	this.set_Vec2f("shop menu size", Vec2f(2,8));
	this.set_string("shop description", "Construct");
	this.set_u8("shop icon", 12);
	
	this.Tag(SHOP_AUTOCLOSE);
	
	
	{
		ShopItem@ s = addShopItem( this, "Builder Shop", "$buildershop$", "buildershop", "Builder supplies" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", COST_WOOD_FACTORY );
	}
	{
		ShopItem@ s = addShopItem( this, "Quarters", "$quarters$", "quarters", "food and rest stop" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", COST_WOOD_FACTORY );
	}
	{
		ShopItem@ s = addShopItem( this, "Transport Tunnel", "$tunnel$", "tunnel", "quick transportation" );
		AddRequirement( s.requirements, "blob", "mat_stone", "Stone", COST_STONE_TUNNEL );
	}
	{
		ShopItem@ s = addShopItem( this, "Lantern Factory", "$lanternfactory$", "lanternfactory", "Factory for gas lanterns, best quality!" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", 300 );
		AddRequirement( s.requirements, "blob", "mat_stone", "Stone", 100 );
		AddRequirement( s.requirements, "no more", "lanternfactory", "Lantern Factory", 12 );
	}
	{
		ShopItem@ s = addShopItem( this, "McDonalds", "$kitchen$", "kitchen", "used for cooking"  );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", 300 );
	}
	{
		ShopItem@ s = addShopItem( this, "Runes Trader", "$pa$", "pa", "A trader selling runes at his shop" );
		AddRequirement( s.requirements, "blob", "mat_wood", "Wood", 600 );
	}
	/*{
		ShopItem@ s = addShopItem(this, "Castle", "$castle$", "castle", "A giant castle to upgrade!");
		AddRequirement(s.requirements, "blob", "mat_wood", "Wood", 500);
		AddRequirement(s.requirements, "blob", "mat_stone", "Stone", 250);
		AddRequirement(s.requirements, "not tech no extra text", "Castle", "There is already an existing Castle!\n", 1);
		s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;
		
	}*/
	{
		ShopItem@ s = addShopItem( this, "Back", "$building$", "building", "Go Back" );
			//	s.customButton = true;
		s.buttonwidth = 2;
		s.buttonheight = 1;
	}
	
}

void GetButtonsFor( CBlob@ this, CBlob@ caller )
{
	this.set_bool("shop available", !builder_only || caller.getName() == "builder" );
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	bool isServer = getNet().isServer();

	if (cmd == this.getCommandID("shop made item"))
	{
		CBlob@ caller = getBlobByNetworkID( params.read_netid() );
		CBlob@ item = getBlobByNetworkID( params.read_netid() );
		if(params.read_string() == "castle"){
			GiveFakeTech(getRules(), "Castle", this.getTeamNum());
		}
		if (item !is null && caller !is null)
		{				
			this.getSprite().PlaySound("/select.ogg" ); 
			this.getSprite().getVars().gibbed = true;

			// open factory upgrade menu immediately
			if (item.getName() == "building")
			{
				CBitStream factoryParams;
				factoryParams.write_netid( caller.getNetworkID() );
				item.SendCommand( item.getCommandID("shop menu"), factoryParams );
			}
		
		}
		this.server_Die();
	}
}