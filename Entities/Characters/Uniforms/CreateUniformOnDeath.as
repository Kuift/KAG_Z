void onDie(CBlob@ blob){
    server_CreateBlob(blob.getName() + "uniform",blob.getTeamNum(), blob.getPosition());
}