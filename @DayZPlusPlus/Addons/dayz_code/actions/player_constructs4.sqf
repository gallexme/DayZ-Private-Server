private["_item"];
disableSerialization;
_item = 	_this;
_config =	configFile >> "CfgMagazines" >> _item;

_consume = 	getArray (_config >> "ItemActions" >> "ReloadMag4" >> "use");
_create = 	getArray (_config >> "ItemActions" >> "ReloadMag4" >> "output");

_textConsume =	getText(configFile >> "CfgMagazines" >> (_consume select 0) >> "displayName");
_textCreate =	getText(configFile >> "CfgMagazines" >> (_create select 0) >> "displayName");

_amountNeed = count _consume;
_amountHas = 0;
_tempConsume = _consume;
_countTempConsume = count _tempConsume;

while {_countTempConsume != 0} do {
    _itemConsumeCount = {_x == (_tempConsume select 0)} count _consume;
        _tempCount = {_x == (_tempConsume select 0)} count magazines player;
    if (_tempCount >= _itemConsumeCount) then {
        _amountHas = _amountHas + _itemConsumeCount;
    };
        _tempSelect = _tempConsume select 0;
        _tempConsume = _tempConsume - [_tempSelect];
        _countTempConsume = count _tempConsume;
};

_amountMake = count _create;

_qty = 0;
if (_amountNeed == 1 and _amountMake == 1) then {
	_qty = gearSlotAmmoCount uiControl;
};

_hasInput = (_amountHas >= _amountNeed);
player playActionNow "PutDown";
if (_hasInput) then {
	//Take Items
	{
		player removeMagazine _x;
	} forEach _consume;
	sleep 1;
	//Give Items
	{
		if (_qty > 0) then {
			player addMagazine [_x,_qty];
		} else {
			player addMagazine _x;
		};
	} forEach _create;
	cutText [format[(localize  "str_player_101"),_amountMake,_textCreate], "PLAIN DOWN"];
} else {
	cutText [format[(localize  "str_player_100"),_amountNeed,_textConsume], "PLAIN DOWN"];
};

