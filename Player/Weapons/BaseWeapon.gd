extends Node
class_name BaseWeapon

enum WeaponSlot {
	MELEE,
	PRIMARY,
	SECONDARY
}

var player: Player
var weaponSlot: WeaponSlot = WeaponSlot.PRIMARY

