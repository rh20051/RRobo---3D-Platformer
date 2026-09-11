extends CharacterBody3D
@export var movePoint1: Node3D
@export var movePoint2: Node3D
var nextPos = self.global_position
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y = 0
	if (self.global_position - movePoint1.global_position).length() < .2:
		await get_tree().create_timer(2).timeout
		nextPos = movePoint2.global_position
	elif (self.global_position - movePoint2.global_position).length() < .2:
		await get_tree().create_timer(2).timeout
		nextPos = movePoint1.global_position
	if nextPos != self.global_position:
		self.global_position = lerp(self.global_position, nextPos, delta * .5)
	


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("player"):
		body.onPlat = true
		body.currentPlatform = self
