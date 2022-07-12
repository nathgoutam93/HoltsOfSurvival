extends TileMap

func _ready():
	_export_as_img()
	
	
func _export_as_img():
	yield(VisualServer,"frame_post_draw")
	var img2=get_viewport().get_texture().get_data()

	img2.flip_y()
	img2.convert(Image.FORMAT_ETC2_RGBA8)
	img2.save_png("forest.png")	
