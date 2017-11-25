extends Node

# Global constants
const GRAVITY = 1000
const TERMINAL_VEL = 400


var score = 0 setget _update_score
var has_key = false setget _update_key
var boss_fight = false

#---------------------------
# act specific
#---------------------------
enum ACTS { HELL, GRAVEYARD }
var act_specific = {
	ACTS.HELL : { "scene": 1, "persistent": [] },
	ACTS.GRAVEYARD : { "scene": 2, "persistent": [] } }

#---------------------------
# player info
#---------------------------
enum PLAYER_CHAR { HUMAN, HUMAN_SWORD, HUMAN_GUN, MONSTER_1, MONSTER_2, MONSTER_3, SATAN }
const CHAR_SCENES = { \
	PLAYER_CHAR.HUMAN: "res://scenes/player_human.tscn", \
	PLAYER_CHAR.HUMAN_SWORD: "res://scenes/player_sword.tscn", \
	PLAYER_CHAR.MONSTER_1: "res://scenes/player_monster_1.tscn", \
	PLAYER_CHAR.MONSTER_2: "res://scenes/player_monster_2.tscn", \
	PLAYER_CHAR.MONSTER_3: "res://scenes/player_monster_3.tscn", \
	PLAYER_CHAR.SATAN: "res://scenes/player_satan.tscn"  }

enum WEAPONS { NONE, SWORD, GUN }
var player = null
var player_spawnpos = Vector2()
var player_char = PLAYER_CHAR.HUMAN_SWORD

#---------------------------
# camera
#---------------------------
var camera
var camera_target = null
var camera_target_zoom = 1
#---------------------------
# main scene
#---------------------------
var main = null

#---------------------------
# pause control
#---------------------------
#var pause_timer = 0


#---------------------------
# control floor
#---------------------------
var floor_tilemap = null



func _ready():
	set_pause_mode( Node.PAUSE_MODE_PROCESS )
	# main scene
	var _root = get_tree().get_root()
	main = _root.get_child( _root.get_child_count() - 1 )
	if main.get_name() != "main":
		main = null
	#set_fixed_process( true )


func reset_settings():
	player_char = PLAYER_CHAR.HUMAN
	act_specific = [ \
		{ "scene": 1, "persistent": [] }, \
		{ "scene": 1, "persistent": [] } ]



#func _fixed_process( delta ):
#	# hit Esc to quit
#	if Input.is_key_pressed( KEY_ESCAPE ):
#		get_tree().quit()



func _update_score( v ):
	score = v
	if main != null:
		main.score_nxt = score

func _update_key( v ):
	has_key = v
	if main != null:
		main.set_key( v )










func findweak( obj, arr ):
	for idx in range( arr.size() ):
		var aux = arr[idx].get_ref()
		if aux != null and aux == obj:
			return idx
	return -1



func check_fall_area( obj, pos ):
	var space_state = obj.get_world_2d().get_direct_space_state()
	var results = space_state.intersect_point( pos, 32, [], 524288, 16 )
	if not results.empty():
		for r in results:
			if r.collider.is_in_group( "fall_area" ):
				if r.collider.is_in_group( "up_fall" ):
					return 1
				return -1
	return 0


func get_floor_at( gpos ):
	if floor_tilemap != null and floor_tilemap.get_ref() != null:
		var tile_coordinates = floor_tilemap.get_ref().world_to_map( gpos )
		return floor_tilemap.get_ref().get_cell( tile_coordinates.x, tile_coordinates.y )
	return -1