extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	pass


func on_player_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("player"):
		body.bounced = true
		body.bouncedBody = self
		if self.rotation.z < 0 and !body.direction:	
			body.velocity.x = 1.2 * self.rotation.z * 20.0
		elif !body.direction and self.rotation.z > 0:
			body.velocity.x = 1.2 * -self.rotation.z * 20.0
		elif self.rotation.z < 0:
			body.velocity.x = body.direction.x * 1.2 * self.rotation.z * 20.0
		else:
			body.velocity.x = body.direction.x * 1.2 * -self.rotation.z * 20.0
		if self.rotation.x < 0 and !body.direction:	
			body.velocity.z = 1.2 * self.rotation.x * 20.0
		elif !body.direction and self.rotation.x > 0:
			body.velocity.z = 1.2 * -self.rotation.x * 20.0
		elif self.rotation.x < 0:
			body.velocity.z = body.direction.z * 1.2 * self.rotation.x * 20.0
		else:
			body.velocity.z = body.direction.z * 1.2 * -self.rotation.x * 20.0
		body.velocity.y = -body.velocity.y * 1.2
		$AudioStreamPlayer3D.play()
			#body.direction = -body.direction
		
		
