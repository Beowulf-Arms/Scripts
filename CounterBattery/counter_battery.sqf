// version 1

if (!isServer) exitWith {};

params [
    ["_ai_side", nil, [west]],
    ["_vehicle_class", nil, [""]],
    ["_vehicle_weapon", "", [""]],
    ["_chance", 0.5, [0]],
    ["_delay", 60, [0, []]],
    ["_rounds", 3, [0, []]],
    ["_accuracy", 100, [0]]
];

isNil {
    tba_cb_params = missionNamespace getVariable ["tba_cb_params", createHashMap];
    tba_cb_last_fire_mission = missionNameSpace getVariable ["tba_cb_last_fire_mission", -999999];
};
tba_cb_params set [_vehicle_class, _this];

_fired_eh = {
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile", "_gunner"];
    
    private _instigator = getShotParents _projectile select 1;
    if (!isPlayer _instigator) exitWith {};
    
    private _cb_params = tba_cb_params get typeOf _unit;
    _cb_params params ["_ai_side", "_vehicle_class", "_vehicle_weapon", "_chance", "_delay", "_rounds", "_accuracy"];

    if (_vehicle_weapon != "" && _weapon != _vehicle_weapon) exitWith {};
    if (side group _instigator == _ai_side) exitWith {};
    if (random 1 >= _chance) exitWith {};

    private _fnc_from_interval = {
        params ["_min", "_max"];
        private _mid = (_min + _max) / 2;
        random [_min, _mid, _max];
    };

    if (_delay isEqualType []) then {
        _delay = _delay call _fnc_from_interval;
    };

    if (time - tba_cb_last_fire_mission < _delay) exitWith {};

    tba_cb_last_fire_mission = time;

    if (_rounds isEqualType []) then {
        _rounds = _rounds call _fnc_from_interval;
    };

    [_delay, _ai_side, _rounds, _accuracy, getPos _unit] spawn {
        params ["_delay", "_side", "_rounds", "_accuracy", "_pos"];
        sleep _delay;
        // if they are busy, so be it. No need to check if there are guns available.
        [_side, _pos, objNull, _rounds, _accuracy, true] call lambs_wp_fnc_taskArtillery;
    };
};

// server should see all fired events anyways. so we don't introduce network overhead. and the processing overhead from the occasional self propelled gun with other weapons should be pretty small as well
[_vehicle_class, "fired", _fired_eh, false, [], true] call CBA_fnc_addClassEventHandler;
