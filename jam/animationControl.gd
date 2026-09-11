extends Node
@onready var animTree = get_node("AnimationTree")
@onready var player = get_parent()

func _physics_process(delta: float) -> void:
	
	if player.stick:
		animTree.set("parameters/conditions/stuck", true)
		animTree.set("parameters/conditions/stickFall", false)
	if player.stickFall:
		animTree.set("parameters/conditions/stickFall", true)
		animTree.set("parameters/conditions/stuck", false)

	if not player.is_on_floor():
		if player.velocity.y < 0:
			animTree.set("parameters/conditions/fall", true)
			animTree.set("parameters/conditions/ground", false)
	if player.is_on_floor():
		animTree.set("parameters/conditions/ground", true)
		if player.tripleJumpStreak == 3:
			player.tripleJumpStreak = 0
		animTree.set("parameters/conditions/fall", false)
	if Input.is_action_just_pressed("ui_accept") and player.is_on_floor():
		await get_tree().create_timer(.2).timeout
		animTree.set("parameters/conditions/tjumpstreak0", false)
		animTree.set("parameters/conditions/tjumpstreak1", false)
		animTree.set("parameters/conditions/tjumpstreak2", false)
		animTree.set("parameters/conditions/jumped", true)
		animTree.set("parameters/conditions/idle", false)
		animTree.set("parameters/conditions/moving", false)
		print(player.tripleJumpStreak)
		if player.tripleJumpStreak == 0:
			await get_tree().create_timer(.1).timeout
			animTree.set("parameters/conditions/tjumpstreak0", true)
			animTree.set("parameters/conditions/tjumpstreak1", false)
			animTree.set("parameters/conditions/tjumpstreak2", false)
			animTree.set("parameters/conditions/jumped", false)
		
		elif player.tripleJumpStreak == 1:
			await get_tree().create_timer(.1).timeout
			animTree.set("parameters/conditions/tjumpstreak0", false)
			animTree.set("parameters/conditions/tjumpstreak1", true)
			animTree.set("parameters/conditions/tjumpstreak2", false)
			animTree.set("parameters/conditions/jumped", false)
		elif player.tripleJumpStreak ==2:
			await get_tree().create_timer(.1).timeout
			animTree.set("parameters/conditions/tjumpstreak0", false)
			animTree.set("parameters/conditions/tjumpstreak1", false)
			animTree.set("parameters/conditions/tjumpstreak2", true)
			animTree.set("parameters/conditions/jumped", false)
			#player.tripleJumpStreak = 0

	if player.direction and player.levelComplete == false:
		animTree.set("parameters/conditions/moving", true)
		animTree.set("parameters/conditions/idle", false)
	else:
		animTree.set("parameters/conditions/idle", true)
		animTree.set("parameters/conditions/moving", false)
