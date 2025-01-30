extends Control

@onready var label : Label = $Panel/Label_Visibility
@onready var imposter : Imposter

func _ready() -> void:
	imposter = get_tree().get_first_node_in_group("Imposter")
	imposter.notify_visibility.connect(_change_label)
	#pass

func _change_label(text: String) -> void:
	label.text = text
