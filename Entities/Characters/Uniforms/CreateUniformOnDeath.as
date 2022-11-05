#include "NamesCommon.as";

void onDie(CBlob@ blob){
    bool create = false;
    /*for(int i = 0; i < starter_classes.length; i++){
        if(blob.getName() == starter_classes[i]) { return; } //prevent default classes from trying to call creating a uniform
    }*/

    for(int i = 0; i < uniforms.length; i++){
        if(blob.getName() == uniforms[i]){
            create = true;
        }
    }

    if(!create){ return; }
    server_CreateBlob(blob.getName() + "uniform",blob.getTeamNum(), blob.getPosition());
}