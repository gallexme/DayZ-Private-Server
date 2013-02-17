if (isServer) then {
	dayzPublishObj call server_publishObj;
} else {
	private["_location","_onLadder","_isWater","_item","_classname","_text","_hasbuilditem","_id","_object","_keyEvents","_actionBuild","_actionCancel"];
	_onLadder =		(getNumber (configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1;
	_isWater = 		(surfaceIsWater _location) or dayz_isSwimming;
	
	call gear_ui_init;

	if(_isWater) exitWith {
		cutText [localize "str_player_26", "PLAIN DOWN"];
	};

	if(_onLadder) exitWith {
		cutText [localize "str_player_21", "PLAIN DOWN"];
	};
	
	if (!isNull (player getVariable "constructionObject")) exitWith {
		cutText [localize "str_already_building", "PLAIN DOWN"];
	};
	
	if (!("ItemToolbox" in items player)) exitWith {
		cutText ["Toolbox required to build objects.", "PLAIN DOWN"];
	};

	_item =				_this;
	_classname = 		getText (configFile >> "CfgMagazines" >> _item >> "ItemActions" >> "Build" >> "create");
	_text = 			getText (configFile >> "CfgVehicles" >> _classname >> "displayName");
	_hasbuilditem = 	_this in magazines player;
	
	if (!_hasbuilditem) exitWith {
		cutText [format[(localize "str_player_31"),_text,"build"] , "PLAIN DOWN"];
	};

	player removeMagazine _item;

	_id = [player,50,true,(getPosATL player)] spawn player_alertZombies;

	cutText ["Use Q and E to rotate the object then select desired action", "PLAIN DOWN"];
	//_location =	[(getPos vehicle player select 0) + (5.5 * sin(getDir player)), (getPos vehicle player select 1) + (5.5 * cos(getDir player)), 0];
	_location = getMarkerpos "respawn_west";
	_object = createVehicle [_classname, _location, [], 0, "NONE"];
	_boundingBox = boundingBox _object;
	_maxPoint = ((_boundingBox select 1) select 0) max ((_boundingBox select 1) select 1);
	_object attachTo [player, [0, _maxPoint + 1, ((_boundingBox select 1) select 2)]];
	player setVariable ["constructionObject", _object];
	_object setVariable ["characterID",dayz_characterID,true];
	//_keyEvents = (findDisplay 46) displayAddEventHandler ["KeyDown", "_this spawn construction_key_override"];
	_actionBuild = player addAction ["Complete Build", "\z\addons\dayz_code\actions\object_build.sqf", [_object, _item, _classname, _text, true], 1, true];
	_actionCancel = player addAction ["Cancel Build", "\z\addons\dayz_code\actions\object_build.sqf", [_object, _item, _classname, _text, false], 1, true];

	while {!isNull (player getVariable "constructionObject")} do {
		if (vehicle player != player) then {
			player action ["eject", vehicle player];
		};
		
		if (speed player > 10 or speed player <= -8) then {
			cutText ["You are moving too fast!", "PLAIN DOWN"];
			player playMove "amovpercmstpssurwnondnon";
		};

		sleep 0.2;
			
		if (!alive player) then {
			[[],[],[],[_object, _item, _classname, _text, false]] call object_build; 
		};
	};

	player removeAction _actionBuild;
	player removeAction _actionCancel;
	//(findDisplay 46) displayRemoveEventHandler ["KeyDown", _keyEvents];
};