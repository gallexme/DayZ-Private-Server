/*
delete object from db
parameters: _obj

Edited by Kane "Alby" Stone
[NEW] Handles placing object back into player invnetory.
[NEW] Allows for new construction system.
*/
private["_obj","_objectID","_objectUID","_item","_id","_serverUpdate"];
_obj		= _this select 3;
_objectID 	= _obj getVariable ["ObjectID","0"];
_objectUID	= _obj getVariable ["ObjectUID","0"];
_serverUpdate = true;

_item = getText (configFile >> "CfgVehicles" >> (typeOf _obj) >> "inventoryItem");

player playActionNow "Medic";
sleep 1;
[player,"repair",0,false] call dayz_zombieSpeak;
_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;
sleep 5;

_itemSlots = _item call player_getSlots;
_freeSlots = [] call player_freeSlots;
	
if (_freeSlots >= _itemSlots) then {
	player addMagazine _item;
	if (player getVariable ["constructionObject", objNull] == _obj) then {
		player setVariable ["constructionObject", objNull];
	};
	deleteVehicle _obj;
} else {
	cutText ["Unable to remove object, insufficient inventory space.", "PLAIN DOWN"];
	_serverUpdate = false;
};

player removeAction s_player_deleteBuild;
s_player_deleteBuild = -1;

if (_serverUpdate) then {
	dayzDeleteObj = [_objectID,_objectUID];
	publicVariableServer "dayzDeleteObj";
	if (isServer) then {
		dayzDeleteObj call local_deleteObj;
	};
};



