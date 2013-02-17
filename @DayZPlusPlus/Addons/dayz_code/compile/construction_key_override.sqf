private ["_keyCode","_object","_dir"];
disableSerialization;
diag_log "ROTATE CALLED";
_keyCode = _this select 0;

_object = player getVariable ["constructionObject", objNull];
if (isNull _object) exitWith {};

_dir = getDir _object;
diag_log format["ROTATE: Direction = %1", _dir];

switch (_keyCode) do {
	//Rotate Left
	case 16: {
		_dir = _dir - 3;
		_object setDir (_dir - getDir player);
		player setVariable ["constructionItem", _object];
	};
	//Rotate Right
	case 18: {
		_dir = _dir + 3;
		_object setDir (_dir - getDir player);
		player setVariable ["constructionItem", _object];
	};
};