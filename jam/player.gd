extends CharacterBody3D
@onready var cam = $cameraPoint
@onready var endMenu = $winMenu
@onready var animTree = $animationControl/AnimationTree
var levelComplete = false

var stick = false
var airSpeed = 4.0
var bounced = false
var bouncedBody 
var stickFall = false
var direction
var momentum = 0
var tripleJumpStreak = 0
var camRotx = 0.0
var camRoty = 0.0
var SPEED = 7.0
var canTripleJump = false
const JUMP_VELOCITY = 13
var onPlat = false
var currentPlatform = StaticBody3D
func _ready() -> void:
	$AudioStreamPlayer.play(Global.musicProgress)   
	if Global.currentLevel == 2:
		$tutorial.text = "Jump up to 3 times in succession to boost
		 the height of the jump"
	elif Global.currentLevel == 3:
		$tutorial.text = "Green walls are sticky,
		You can jump off them"
	elif Global.currentLevel == 4:
		$tutorial.text = "Landing on a green wall
		will maintain the
		momentum you had
		before sticking onto it"
	elif Global.currentLevel == 5:
		$tutorial.text = "Red platforms move between
		2 locations, stepping on
		one retains your momentum
		until you get off"
	elif Global.currentLevel == 6:
		$tutorial.text = "Blue platforms bounce you"
	elif Global.currentLevel != 1:
		$tutorial.visible = false
	if $tutorial.visible == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	levelComplete = false
	if Global.currentLevel == 8:
		$winMenu/Label.text = "Thank you for playing! :)"
		$winMenu/Button.visible = false
	

func _input(event: InputEvent) -> void:
	if levelComplete == false and $tutorial.visible == false:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion:
			camRotx += event.relative.x * .001
			camRoty += event.relative.y * .001
			cam.transform.basis = Basis() # reset rotation
			cam.rotation.x += -camRoty
			cam.rotation.y += -camRotx

func _physics_process(delta: float) -> void:
	if self.global_position.y < -40 and Global.currentLevel != 6:
		self.global_position = Vector3(0,0,0)
	elif self.global_position.y < -40:
		self.global_position = Vector3(14,14,0)
	if momentum == 2:
		$momentumTimer.stop()
	if onPlat == true:
		onPlatform(currentPlatform)
	if stickFall == true:
		if is_on_floor():
			stickFall = false
	if bounced == true:
		if is_on_floor():
			bounced = false
			bouncedBody = null
			
	if levelComplete == true:
		endMenu.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	# Add the gravity.
	if not is_on_floor():
		if stick == false:
			velocity += get_gravity() * delta * 2.5
		$tripleJumpTimer.stop()
	if is_on_floor():    
		if canTripleJump:
			if $tripleJumpTimer.is_stopped():
				$tripleJumpTimer.start(.4)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if stick == false and is_on_floor():
			await get_tree().create_timer(.2).timeout
			$AudioStreamPlayer3D.play()
			
			velocity.y = JUMP_VELOCITY + (3.0 * tripleJumpStreak)
			if tripleJumpStreak <2:
				tripleJumpStreak+=1
				if tripleJumpStreak == 2:
					canTripleJump = true
		elif stick == true and bounced == false:
			stickFall = true
			stick = false

			velocity.y = JUMP_VELOCITY + (3.0)

	if velocity.y < 0 and tripleJumpStreak == 3:
		tripleJumpStreak = 0

	
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	
	direction = (cam.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if bounced:
		if direction.x or direction.z:
			velocity.x = direction.x * 5 + -bouncedBody.rotation.z * 20
			velocity.z = direction.z * 5 + -bouncedBody.rotation.x * 20
		else:
			velocity.x = 20 * -bouncedBody.rotation.z
			velocity.z = 20 * -bouncedBody.rotation.x
	if direction and levelComplete == false:
		if cam.position.x != .5* direction.x:
			cam.position.x = lerp_angle(cam.position.x,.5* direction.x, .1)

		if cam.position.z != .5*direction.z:
			cam.position.z = lerp_angle(cam.position.z,.5 * direction.z,.1)
		if stick == false and is_on_floor():
			if momentum < 2:
				momentum += delta
				
			velocity.x = direction.x * (SPEED +(2.0 * momentum))
			velocity.z = direction.z * (SPEED+ (2.0* momentum))
		elif stick == false and bounced == false and !is_on_floor():
			velocity.x = (direction.x)* (airSpeed* momentum)
			velocity.z = (direction.z)* (airSpeed* momentum)
		elif stickFall == true and bounced == false:
			velocity.x = direction.x * (10.0* momentum)
			velocity.z = direction.z * (10.0* momentum)
		
	elif !bounced:
		cam.position.x = lerp_angle(cam.position.x,0,.1)
		cam.position.z = lerp_angle(cam.position.z,0,.1)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		if stick == false and onPlat == false:
			momentum = 0

	if direction and is_on_floor():
		$Armature.look_at(global_position + -direction, Vector3.UP)
	$Armature.rotation.x = 0
	$Armature.rotation.z = 0
	move_and_slide()
	
func stuck():
	stickFall = false
	stick = true
	velocity = Vector3()
	
func onPlatform(platform):
	currentPlatform = platform
	velocity += platform.velocity

func _on_button_pressed() -> void:
	Global.currentLevel +=1
	levelComplete = false
	endMenu.visible = false
	Global.musicProgress = $AudioStreamPlayer.get_playback_position()  
	get_tree().change_scene_to_file("res://level"+str(Global.currentLevel)+".tscn")


func _on_triple_jump_timer_timeout() -> void:
	canTripleJump = false
	tripleJumpStreak = 0


func _on_button_2_pressed() -> void:
	get_tree().quit()


func onTutorialPressed() -> void:
	$tutorial.hide()
