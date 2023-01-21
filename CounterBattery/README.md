# COUNTER BATTERY #

Make ai do counter-battery missions. Requires some AI artillery to be registered.

Basic idea: When a player fires artillery (directly, not remote controlled etc.), the AI will execute a counter-battery missions.

Needs to be executed on the server (executing it elsewhere has no effect).

If you want different sides/vehciels/..., execute it multiple times with different settings. Just make sure they don't overlap.

Doesn't consider AI unit collateral damage.

Parameters:

- The side doing the counter-battery missions. Needs to have artillery units registered. Won't fire on players on that same side.
- The exact class name of the artillery piece that can trigger a counter battery mission when firing
- The weapon of the artillery piece that triggers the counter-battery mission. Empty string for any weapon.
- Chance that any single firing event of the player vehicle will trigger a counter-battery mission.
- Delay in seconds from the player firing to the counter-battery mission starting, or between missions targeting the same unit. Number or array of [min, max] Default 60.
- Number of rounds. Number or array of [min, max]. Default 3
- Dispersiopn accuracy in meters. Default 100.

## Usage example: ##

 `[east, "B_T_MBT_01_arty_F", "", 0.5, [30-120], [3, 6], 100] execVm "counter_battery.sqf";`

If a blufor player in a Sholef fires a round, there's a 50% chance that the opfor will start a counter-battery mission after 30s-120s, using 3-6 rounds, with a spread of about a 100m (the actual target area shape is a bit weird tbh, so it's not like an exact radius).
