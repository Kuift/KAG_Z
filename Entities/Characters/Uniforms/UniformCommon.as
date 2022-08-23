void onCommand(CBlob@ this, u8 command, CBitStream@ params){
    if (command == this.getCommandID("onestarknight") || (command == this.getCommandID("twostarknight")) || (command == this.getCommandID("threestarknight")) || (command == this.getCommandID("onestarbuilder")) || (command == this.getCommandID("twostarbuilder")) || (command == this.getCommandID("threestarbuilder")) || (command == this.getCommandID("onestararcher")) || (command == this.getCommandID("twostararcher")) || (command == this.getCommandID("threestararcher")) || (command == this.getCommandID("onestarpolearm")) || (command == this.getCommandID("twostarpolearm")) || (command == this.getCommandID("threestarpolearm"))){

		u16 caller_id = params.read_u16();
		CBlob@ caller = getBlobByNetworkID(caller_id);

        // if(caller.getName() != "builder" || "archer" || "knight" || "polearm")
        //code here to make sure caller cannot go down by uniforms

        string blob = ""; //what blob are we spawning?
        if(command == this.getCommandID("onestarknight")){ blob = "onestarknight"; }
        if(command == this.getCommandID("twostarknight")){ blob = "twostarknight"; }
        if(command == this.getCommandID("threestarknight")){ blob = "threestarknight"; }

        if(command == this.getCommandID("onestararcher")){ blob = "onestararcher"; }
        if(command == this.getCommandID("twostararcher")){ blob = "twostararcher"; }
        if(command == this.getCommandID("threestararcher")){ blob = "threestararcher"; }

        if(command == this.getCommandID("onestarbuilder")){ blob = "onestarbuilder"; }
        if(command == this.getCommandID("twostarbuilder")){ blob = "twostarbuilder"; }
        if(command == this.getCommandID("threestarbuilder")){ blob = "threestarbuilder"; }

        if(command == this.getCommandID("onestarpolearm")){ blob = "onestarpolearm"; }
        if(command == this.getCommandID("twostarpolearm")){ blob = "twostarpolearm"; }
        if(command == this.getCommandID("threestarpolearm")){ blob = "threestarpolearm"; }

        ParticleZombieLightning(this.getPosition());

		if (caller !is null) {
            CBlob@ uniformtomake = server_CreateBlobNoInit(blob);
            if(uniformtomake !is null){
                if(caller.getInventory() !is null){
                    if(this.hasTag("change class drop inventory")){
                        while (caller.getInventory().getItemsCount() > 0){
                            CBlob@ item = caller.getInventory().getItem(0);
                            caller.server_PutOutInventory(item);
						}
                    }
					else if (this.hasTag("change class store inventory")){
						if (this.getInventory() !is null){ caller.MoveInventoryTo(this); }
						else{ PutInvInStorage(caller); }  //put inventory into a storage
					}
					else { caller.MoveInventoryTo(uniformtomake); }
                }
                if(caller.getHealth() != caller.getInitialHealth()){ uniformtomake.server_SetHealth(Maths::Min(caller.getHealth(), uniformtomake.getInitialHealth())); }

                uniformtomake.Init();

                if(uniformtomake.getBrain() !is null) { uniformtomake.getBrain().server_SetActive(false); }

                uniformtomake.server_SetPlayer(caller.getPlayer());
                uniformtomake.setPosition(caller.getPosition());
                uniformtomake.server_setTeamNum(caller.getTeamNum());
                uniformtomake.Tag("player");
                uniformtomake.Tag("flesh");

                if(caller.exists("spawn immunity time")){
                    uniformtomake.set_u32("spawn immunity time", caller.get_u32("spawn immunity time"));
                    uniformtomake.Sync("spawn immunity time", true);
                }

                caller.Tag("switch class");
                caller.server_SetPlayer(null);
                caller.server_Die();
            }
        }
        this.server_Die();
    }
}