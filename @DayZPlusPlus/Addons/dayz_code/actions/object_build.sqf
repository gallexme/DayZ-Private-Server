private["_array","_object","_item","_classname","_text","_build"];
_array = _this select 3;
_object = _array select 0;
_item = _array select 1;
_classname = _array select 2;
_text = _array select 3;
_build = _array select 4;

if (isNull _object) exitWith {};

player playActionNow "Medic";
[player,"repair",0,false] call dayz_zombieSpeak;
sleep 5;

if (_build) then {
	detach _object;
	_object setPos [getPos _object select 0, getPos _object select 1, 0.1];
	_object setDir (getDir _object);
	player reveal _object;
	_object setVariable ["characterID",dayz_characterID,true];
	cutText [format[localize "str_build_01",_text], "PLAIN DOWN"];	
	dayzPublishObj = [dayz_characterID,_object,[getDir _object, getPosATL _object],_classname];
	publicVariable "dayzPublishObj";
} else {
	deleteVehicle _object; 
	player addMagazine _item;
};

player setVariable ["constructionObject", objNull];