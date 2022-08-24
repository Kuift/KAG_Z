#include "NamesCommon.as";

void onDie(CBlob@ blob){
    for(int i = 0; i < starter_classes.length; i++){
        if(blob.getName() == starter_classes[i]) { return; } //prevent default classes from trying to call creating a uniform
    }
    server_CreateBlob(blob.getName() + "uniform",blob.getTeamNum(), blob.getPosition());
}