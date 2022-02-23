extends Node
class_name BaseWeapon

enum WeaponSlot {
	ONE,
	TWO,
	THREE
}

var player: Player
var weaponSlot: WeaponSlot = WeaponSlot.ONE

func on_switch_in():
	pass

func on_switch_out():
	pass
