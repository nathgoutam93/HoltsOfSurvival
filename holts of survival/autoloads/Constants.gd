extends Node

enum Building {
	TOWN_HALL,
	GOLD_STORAGE,
	ELIXER_STORAGE
}

enum {
	Level_1 = 1,
	Level_2,
	Level_3,
	Level_4,
}

const Boundaries := Rect2(0, 0, 496, 496)

const Buildings = {
	Building.TOWN_HALL : {
		"max_level": 2,
		Level_1: {
			"sprite": "res://assets/townhall/townhall.png",
			"hitpoint": 200,
		},
		Level_2: {
			"sprite": "res://assets/townhall/townhall.png",
			"hitpoint": 400,
		}
	},
	Building.GOLD_STORAGE: {
		"max_level": 2,
		Level_1: {
			"sprite": "res://assets/gold_storage/gold_storage.png",
			"hitpoint": 80,
			"capacity": 2000
		},
		Level_2: {
			"sprite": "res://assets/gold_storage/gold_storage2.png",
			"hitpoint": 120,
			"capacity": 4000
		}
	},
	Building.ELIXER_STORAGE : {
		"max_level": 2,
		Level_1: {
			"sprite": "res://assets/elixer_storage/elixer_storage.png",
			"hitpoint": 80,
			"capacity": 2000
		},
		Level_2: {
			"sprite": "res://assets/elixer_storage/elixer_storage2.png",
			"hitpoint": 120,
			"capacity": 4000
		}
	}
}

