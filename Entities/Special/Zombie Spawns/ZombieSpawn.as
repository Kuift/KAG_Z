void onInit(CBlob@ this){
    getMap().AddMarker(this.getPosition(), "zombie spawn");
    this.Tag("invincible");
	this.SetLight(true);
	this.SetLightRadius(124.0f);
	this.SetLightColor(SColor(255, 255, 255, 255));

	// this.SetMinimapVars("ZombieSpawnIcon.png", 1, Vec2f(4, 4));
	// this.SetMinimapRenderAlways(true);
}

void onTick(CBlob@ this){ //todo: maybe not allow building nearby this?
    if(getGameTime() % 10*30 == 0){
        if(this.getHealth() < 999.0f){
            this.server_SetHealth(999.0f); //do not go below max health
        }
    }
}