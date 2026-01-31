
class_name Player extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY =-500.0
const Dash_Speed = 900.0
var double_jump = true
var dashing = false 
var can_dash = true	
var crouching = false
var direction = 0
var block_actions = false

var first_frame = false
@onready var area : Area2D = $AreaSword

enum Actions {Jump, Attack, Move, Nothing, Dash}
var action =  Actions.Nothing
var taking_damage = false
var health = 10
@onready var animation_player = $PlayerSprite


#func set_state(new_state: State):
	#if new_state == state:
	#	return
#	pass
var push = 0
const push_back_force = 100
const immunity_time = 1
var immune = false
func take_damage(enemy: EnemyClass):
	print('damagaea ')
	if immune:
		return
	var dir = enemy.position - position
	#velocity.x = -dir.x * push_back_force
	immune = true
	get_tree().create_timer(immunity_time).timeout.connect(func():
		immune = false)

	health -= enemy.attack_dmg
	print('Player take damagead')
	var tween = get_tree().create_tween()
	push = -900
	tween.tween_property(self, "push", 0, 0.3)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	if health <= 0:
		queue_free()
func _process(delta: float) -> void:
	get_inputs()

func set_action(new_action: Actions):
	if new_action == Actions.Dash:
		if !can_dash:
			return
		animation_player.play("Dash")
		block_actions = true
		get_tree().create_timer(0.1).timeout.connect(func():
			block_actions = false)	
		action = new_action
		return
		
	if block_actions:
		return
	if new_action ==  action:
		return
	if new_action == Actions.Jump:
		animation_player.play("Jump")
		animation_player.animation_finished.connect(func():
			animation_player.play("Fall"))
	
	elif new_action == Actions.Move and is_on_floor():
		animation_player.play("Walk") 
	elif new_action == Actions.Attack:
		animation_player.play("Attack")
		block_actions = true
		animation_player.animation_finished.connect(func():
				block_actions = false)
	elif new_action == Actions.Nothing and is_on_floor():
		animation_player.play("Idle")
	action = new_action
	
func get_inputs():
	var vectory = Vector2.ZERO
	var jumping = false
	direction = 0
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
	if Input.is_action_pressed("crouch") and (crouching == false):
		velocity.y = -JUMP_VELOCITY
		$CrouchingShape.disabled = false
		$CollisionShape2D.disabled = true
		if Input.is_action_pressed("left"):
			direction = -0.2
		if Input.is_action_pressed("right"):
			direction = 0.2
	else:
		$CrouchingShape.disabled = true
		$CollisionShape2D.disabled = false
	
	if Input.is_action_pressed("attack") and !action == Actions.Attack :
	
		set_action(Actions.Attack)
		
		for body in area.get_overlapping_bodies():
			if body is EnemyHitbox:
					body.take_damage(2)	
					
	if action != Actions.Move and jumping:
		set_action(Actions.Jump)
	if direction!= 0:
		if dashing :
			velocity.x = direction * Dash_Speed 
		else:
			velocity.x = direction * SPEED				
	else:
		velocity.x = 0	
		
	first_frame = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	first_frame = true
	if not is_on_floor():
		velocity += get_gravity() * delta
	if is_on_floor():
		double_jump = true
	velocity.x += push
	#if immune== false:
	#	for i in range(get_slide_collision_count()):
	#		var body = get_slide_collision(i)
			
	#		if body is EnemyHitbox:
	#			print(body)
	#			take_damage(body.s)
		
	move_and_slide()


func _on_dash_timer_timeout() -> void:
	dashing = false
	


func _on_dash_again_timer_timeout() -> void:
	can_dash = true


func _on_sword_hit_area_entered(area: Area2D) -> void:
	pass
#	if area is EnemyClass:
		
	##	area.take_damage()
		
