extends Node

enum Type {
	STORAGE,
	RESOURCE,
	DEFENCE,
}

enum Building {
	TOWN_HALL=0,
	GOLD_COLLECTOR,
	OIL_COLLECTOR,
	GOLD_STORAGE,
	OIL_STORAGE,
	WALL
}

enum {
	Level_1 = 1,
	Level_2,
	Level_3,
	Level_4,
}

const Boundaries = Rect2(0, 0, 43, 43)

const Tile = {
	"width": 64,
	"height": 64
}

const Buildings = {
	Building.TOWN_HALL : {
		"type": Type.STORAGE,
		"name": "Townhall",
		"icon": "res://assets/sprites/townhall/townhall_icon.png",
		"scene": "res://scenes/Buldings/town_hall/town_hall.tscn",
		Level_1: {
			"sprites": {
				"idle": "res://assets/sprites/townhall/townhall_level_1.png",
			},
			"hitpoint": 200,
			"capacity": {
				"gold": 500,
				"oil": 500,
			},
			"cost": {
				"amount": 0,
				"resource": "gold"
			},
			"build_time": 0
		},
		Level_2: {
			"sprites": {
				"idle": "res://assets/sprites/townhall/townhall_level_2.png"
			},
			"hitpoint": 400,
			"capacity": {
				"gold": 1000,
				"oil": 1000,
			},
			"cost": {
				"amount": 1000,
				"resource": "gold"
			},
			"build_time": 50
		},
		Level_3: {
			"sprites": {
				"idle": "res://assets/sprites/townhall/townhall_level_3.png"
			},
			"hitpoint": 500,
			"capacity": {
				"gold": 1500,
				"oil": 1500,
			},
			"cost": {
				"amount": 1500,
				"resource": "gold"
			},
			"build_time": 50
		},
	},
	Building.GOLD_COLLECTOR: {
		"type": Type.RESOURCE,
		"name": "Gold mine",
		"icon": "res://assets/sprites/gold_collector/gold_mine_icon.png",
		"scene": "res://scenes/Buldings/gold_collector/gold_collector.tscn",
		"count": {
			Level_1: 2,
			Level_2: 3,
			Level_3: 4
		},
		Level_1: {
			"sprites": {
				"idle": "res://assets/sprites/gold_collector/gold_mine_level_1.png"	
			},
			"hitpoint": 80,
			"capacity": 2000,
			"townhall_required": 1,
			"cost": {
				"amount": 250,
				"resource": "gold"
			},
			"build_time": 5
		},
		Level_2: {
			"sprites": {
				"idle": "res://assets/sprites/gold_collector/gold_mine_level_2.png"
			},
			"hitpoint": 120,
			"capacity": 4000,
			"townhall_required": 2,
			"cost": {
				"amount": 500,
				"resource": "gold"
			},
			"build_time": 10
		},
	},
	Building.OIL_COLLECTOR : {
		"type": Type.RESOURCE,
		"name": "Oil collector",
		"icon": "res://assets/sprites/oil_collector/oil_mine_icon.png",
		"scene": "res://scenes/Buldings/oil_collector/oil_collector.tscn",
		"count": {
			Level_1: 2,
			Level_2: 3,
			Level_3: 4
		},
		Level_1: {
			"sprites": {
				"idle": "res://assets/sprites/oil_collector/oil_mine_level_1.png"
			},
			"hitpoint": 80,
			"capacity": 2000,
			"townhall_required": 1,
			"cost": {
				"amount": 250,
				"resource": "gold"
			},
			"build_time": 5
		},
		Level_2: {
			"sprites": {
				"idle": "res://assets/sprites/oil_collector/oil_mine_level_2.png"
			},
			"hitpoint": 120,
			"capacity": 4000,
			"townhall_required": 2,
			"cost": {
				"amount": 500,
				"resource": "gold"
			},
			"build_time": 10
		},
	},
	Building.WALL: {
		"type": Type.DEFENCE,
		"name": "Wall",
		"icon": "res://assets/sprites/wall/wall_level_1_idle.png",
		"scene": "res://scenes/Buldings/wall/wall.tscn",
		"count": {
			Level_1: 0,
			Level_2: 25,
			Level_3: 50
		},
		Level_1: {
			"sprites": {
				"idle": "res://assets/sprites/wall/wall_level_1_idle.png",
				"left": "res://assets/sprites/wall/wall_level_1_left.png",
				"bottom": "res://assets/sprites/wall/wall_level_1_bottom.png",
				"left_bottom": "res://assets/sprites/wall/wall_level_1_left_bottom.png"
				},
			"hitpoints": "50",
			"townhall_required": 2,
			"cost": {
				"amount": 100,
				"resource": "gold"
			},
			"build_time": 0
		},
		Level_2: {
			"sprites": {
				"idle": "res://assets/sprites/wall/wall_level_2_idle.png",
				"left": "res://assets/sprites/wall/wall_level_2_left.png",
				"bottom": "res://assets/sprites/wall/wall_level_2_bottom.png",
				"left_bottom": "res://assets/sprites/wall/wall_level_2_left_bottom.png"
				},
			"hitpoints": "80",
			"townhall_required": 3,
			"cost": {
				"amount": 250,
				"resource": "gold"
			},
			"build_time": 0
		},
	}
}

const SAVE_GAME_PATH = "user://save.json"

var _file = File.new()

func save_exist():
	return _file.file_exists(SAVE_GAME_PATH)

func saveDictionary(var thing_to_save):
	_file.open(SAVE_GAME_PATH, File.WRITE)
	_file.store_string(to_json(thing_to_save))
	_file.close()
	
func loadDictionary() -> Dictionary:
	_file.open(SAVE_GAME_PATH, File.READ)
	var theDict = parse_json(_file.get_as_text())
	_file.close()
	return theDict
	
