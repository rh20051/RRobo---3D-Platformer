extends Node3D
@onready var player = get_tree().get_first_node_in_group("player")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationTree.set("parameters/conditions/levelComplete", false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if player.levelComplete == true:
		$AnimationTree.set("parameters/conditions/levelComplete", true)
