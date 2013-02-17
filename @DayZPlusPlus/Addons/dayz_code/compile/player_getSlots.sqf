/*
	File: player_getSlots.sqf
	Author: Kane "Alby" Stone

	Description:
	Returns how many slots a magazine uses in player inventory.
		
	Parameter:
	_item: The magazine to check.
*/
private["_item","_type","_base","_slots"];
_item = _this;
_slots = 1;
_type = 0;
_isNumber = false;
diag_log format["DEBUG: ITEM: %1", _item];

_isNumber = isNumber (configFile >> "CfgMagazines" >> _item >> "type");
_isText = isText (configFile >> "CfgMagazines" >> _item >> "type");

diag_log format["DEBUG: NUMBER: %1", _isNumber];
if (_isNumber)  then {
	_type = getNumber (configFile >> "CfgMagazines" >> _item >> "type");
	_isNumber = true;
};

diag_log format["DEBUG: TEXT: %1", _isText];
if (_isText) then {
	_text = getText (configFile >> "CfgMagazines" >> _item >> "type");
	diag_log format["DEBUG: TEXT: %1 ARRAY: %2", _text, toArray _text];
	_multiplicand = [];
	_multiplier = [];
	{
		if (_x >= 48 and _x <= 57) then {
			if (count _multiplicand < 3) then {
				_multiplicand set [count _multiplicand, _x];
			} else {
				_multiplier set [count _multiplier, _x];
			};
		};
	}foreach (toArray _text);
	_type = (parseNumber  (toString _multiplicand)) * (parseNumber  (toString _multiplier));
	_isNumber = true;
};

diag_log format["DEBUG: TYPE: %1", _type];

if (_isNumber) then {
	if (_type mod 256 == 0) then {
		_slots = _type / 256;
	};
} else {
	_base = inheritsFrom (configFile >> "CfgMagazines" >> _item);
	_base = configName _base;
	_slots = _base call player_getSlots;
};

diag_log format["DEBUG: COUNT: %1", _slots];

_slots