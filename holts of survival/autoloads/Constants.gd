extends Node

enum Type {
	STORAGE,
	RESOURCE,
	DEFENCE,
}

enum Building {
	TOWN_HALL=0,
	WOOD_MILL,
	STONE_MINE,
	WOOD_STORAGE,
	STONE_STORAGE,
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
				"wood": 1000,
				"stone": 1000,
			},
			"cost": {
				"amount": 0,
				"resource": "wood"
			},
			"build_time": 0
		},
		Level_2: {
			"sprites": {
				"idle": "res://assets/sprites/townhall/townhall_level_2.png"
			},
			"hitpoint": 400,
			"capacity": {
				"wood": 1500,
				"stone": 1500,
			},
			"cost": {
				"amount": 500,
				"resource": "wood"
			},
			"build_time": 10
		},
		Level_3: {
			"sprites": {
				"idle": "res://assets/sprites/townhall/townhall_level_3.png"
			},
			"hitpoint": 500,
			"capacity": {
				"wood": 2000,
				"stone": 2000,
			},
			"cost": {
				"amount": 750,
				"resource": "wood"
			},
			"build_time": 30
		},
	},
	Building.WOOD_MILL: {
		"type": Type.RESOURCE,
		"name": "Wood mill",
		"icon": "res://assets/sprites/wood_mill/wood_mill_icon.png",
		"scene": "res://scenes/Buldings/wood_mill/wood_mill.tscn",
		"count": {
			Level_1: 1,
			Level_2: 2,
			Level_3: 4
		},
		Level_1: {
			"sprites": {
				"idle": "res://assets/sprites/wood_mill/wood_mill_level_1.png"
			},
			"hitpoint": 80,
			"capacity": 500,
			"production": 200,
			"townhall_required": 1,
			"cost": {
				"amount": 250,
				"resource": "wood"
			},
			"build_time": 10
		},
		Level_2: {
			"sprites": {
				"idle": "res://assets/sprites/wood_mill/wood_mill_level_2.png"
			},
			"hitpoint": 120,
			"capacity": 1000,
			"production": 400,
			"townhall_required": 2,
			"cost": {
				"amount": 500,
				"resource": "wood"
			},
			"build_time": 60
		},
	},
	Building.STONE_MINE: {
		"type": Type.RESOURCE,
		"name": "Stone mine",
		"icon": "res://assets/sprites/stone_mine/stone_mine_icon.png",
		"scene": "res://scenes/Buldings/stone_mine/stone_mine.tscn",
		"count": {
			Level_1: 1,
			Level_2: 2,
			Level_3: 4
		},
		Level_1: {
			"sprites": {
				"idle": "res://assets/sprites/stone_mine/stone_mine_level_1.png"
			},
			"hitpoint": 80,
			"capacity": 500,
			"production": 1000,
			"townhall_required": 1,
			"cost": {
				"amount": 250,
				"resource": "wood"
			},
			"build_time": 10
		},
		Level_2: {
			"sprites": {
				"idle": "res://assets/sprites/stone_mine/stone_mine_level_2.png"
			},
			"hitpoint": 120,
			"capacity": 1000,
			"production": 2000,
			"townhall_required": 2,
			"cost": {
				"amount": 500,
				"resource": "wood"
			},
			"build_time": 20
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
				"amount": 50,
				"resource": "wood"
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
				"amount": 100,
				"resource": "wood"
			},
			"build_time": 0
		},
	}
}
