extends TabBar
@onready var limit_fps_option = $BoxContainer/LimitFPS/LimitFPSOption
@onready var resolution_option_button = $BoxContainer/Resolution/OptionButton

var res: Dictionary = {
	"1920x1080":Vector2(1920,1080),
	"1366x760":Vector2(1366,768),
	"1536x864":Vector2(1536,864),
	"1280x720":Vector2(1280,720),
	"1440x900":Vector2(1440,900),
	"1600x900":Vector2(1600,900),
	"1024x600":Vector2(1024,600),
	"800x600":Vector2(800,600)} #Resolusi

func _ready():
	AddRes()
	AddFPS()

func AddRes():
	for i in res:
		resolution_option_button.add_item(i)

func AddFPS():
	limit_fps_option.add_item("30fps")
	limit_fps_option.add_item("45fps")
	limit_fps_option.add_item("60fps")
	limit_fps_option.add_item("Unlimited")

func _on_option_button_item_selected(index): # ini seharusnya opsi resolusi
	var win_size = res.get(resolution_option_button.get_item_text(index))
	get_window().size = Vector2i(win_size)



func _on_limit_fps_option_item_selected(index):
	var selected_fps = limit_fps_option.get_item_text(index)
	match selected_fps:
		"30fps":
			Engine.max_fps = 30
		"45fps":
			Engine.max_fps = 45
		"60fps":
			Engine.max_fps = 6
		"Unlimited":
			Engine.max_fps = 0 #0 = unlimited
