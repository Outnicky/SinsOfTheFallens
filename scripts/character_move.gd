class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY =-500.0
const Dash_Speed = 900.0
var double_jump = true
var dashing = false 
var can_dash = true	
var hp = 3

var is_attacking : bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction = 0
	var timer = $Timer
	
	#var dash = 4
	#var dashing = true 
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			double_jump = true
			velocity.y = JUMP_VELOCITY
		elif double_jump:
			double_jump = false
			velocity.y = JUMP_VELOCITY
	
	
		
	if Input.is_action_pressed("left"):
		direction = -1
	if Input.is_action_pressed("right"):
		direction = 1
	if Input.is_action_just_pressed("dash") and can_dash:
		can_dash = false
		dashing = true
		$dash_timer.start()	
		$dash_again_timer.start()	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if direction:
		if dashing :
			velocity.x = direction * Dash_Speed 
		else:
			velocity.x = direction * SPEED
		 
		
	if Input.is_action_just_pressed("attack"):
		is_attacking = true
		
		
			
			
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
		
