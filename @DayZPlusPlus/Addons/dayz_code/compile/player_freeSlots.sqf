/*
	File: player_freeSlots.sqf
	Author: Kane "Alby" Stone

	Description:
	Returns how many slots remain "free" in the players inventory.
*/
private["_magCount","_x","_slotsRemaining"];
_magCount = 0;

{
	_magCount = _magCount + (_x call player_getSlots);
}foreach (magazines player);

_slotsRemaining =  12 - _magCount;

diag_log format["DEBUG: REMAINING: %1", _slotsRemaining];

_slotsRemaining