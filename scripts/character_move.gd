
class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY =-500.0
const Dash_Speed = 900.0
var double_jump = true
var dashing = false 
var can_dash = true	



enum Actions {Jump, Attack, Move, Nothing}
var action =  Actions.Nothing
var taking_damage = false

@onready var animation_player = $PlayerSprite

#func set_state(new_state: State):
	#if new_state == state:
	#	return
#	pass

func set_action(new_action: Actions):
	if new_action == Actions.Nothing and is_on_floor():
		animation_player.play("Idle")
	if new_action ==  action:
		return
	print("new state")
	if new_action == Actions.Jump:
		animation_player.play("Jump")
		animation_player.animation_finished.connect(func():
			animation_player.play("Fall"))
	
	elif new_action == Actions.Move and is_on_floor():
		animation_player.play("Walk") 
	
	action = new_action
	
		


	


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction = 0
	var timer = $Timer
	
	#var dash = 4
	#var dashing = true 
	
	# Handle jump.
	if is_on_floor():
		double_jump = true
	var jumping = false
	if Input.is_action_just_pressed("jump"):
		if is_on_floor(): 
			set_action(Actions.Jump)
			jumping = true
			velocity.y = JUMP_VELOCITY
		elif !is_on_floor():
			if double_jump== true:
				double_jump  = false
				velocity.y = JUMP_VELOCITY
				jumping = true
				set_action(Actions.Jump)

	
	   
	if Input.is_action_pressed("left"):
		if is_on_floor() and !jumping:
			set_action(Actions.Move)
		direction = -1
	elif Input.is_action_pressed("right"):
		if is_on_floor() and !jumping:
			set_action(Actions.Move)
		direction = 1
	else:
		if !jumping and velocity == Vector2.ZERO:
			set_action(Actions.Nothing)
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		dashing = true
		$dash_timer.start()	
		$dash_again_timer.start()	
	
	if action != Actions.Move and jumping:
		set_action(Actions.Jump)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		if dashing :
			velocity.x = direction * Dash_Speed 
		else:
			velocity.x = direction * SPEED
		
		
		
			
			
	else:
		velocity.x = 0
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		

	move_and_slide()


#func _on_timer_timeout() -> void: 
	
	#pass # Replace with function body.


func _on_dash_timer_timeout() -> void:
	dashing = false
	


func _on_dash_again_timer_timeout() -> void:
	can_dash = true


func _on_sword_hit_area_entered(area: Area2D) -> void:
	if area.is_in_group("hurtBox"):
		area.take_damage()
		
