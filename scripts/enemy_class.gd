class_name EnemyClass extends CharacterBody2D

var health = 10
var attack_dmg = 2

const FOV = 5
const RAYCAST_AMOUNT = 40
const RAYCAST_DISTANCE = 500
const SPEED =300
const ray = preload("res://scenes/ray.tscn")
var node : Node2D 

const wait_decrease = 3
var wait_time
var wander_time = 300
const wonder_decrease = 8

var direction =1
var timer_wait : Timer
var timer_walk : Timer
var timer_lose_sight: Timer


enum State {Idle, Wandering, Chasing}
var state = State.Idle
var player_in_vision = false
@onready var player = $"%Player"
@onready var ground_left: Area2D =$ground_left
@onready var ground_right  : Area2D = $ground_right
func get_ray():
	var ray = ray.instantiate()
	#ray.enemy = self
	return ray
func show_raycast_line(target):
	var line = Line2D.new()
	node.add_child(line)	
	line.width =1		
	line.add_point(Vector2.ZERO)
	line.add_point(target)
	line.visible =  true
		
func  look(dir: Vector2):
	var i = 0
	player_in_vision = false
	for ray: RayCast2D in node.get_children():
		var angle_rad = deg_to_rad(20  - i * 2)
		var vector = dir.rotated(angle_rad)
		var target = Vector2(vector.x, vector.y) * RAYCAST_DISTANCE 
		if ray.is_colliding():
			if ray.get_collider() is Player:
				set_state(State.Chasing)
				player_in_vision = true
		ray.target_position = target
		ray.position = Vector2.ZERO
		ray.force_raycast_update()
		
	
		i+=1

func get_wait_time():
	return  randi_range(0.2, 0.5)
func get_walk_time():
	return  randi_range(0.3, 0.7)

func has_floor(obj: Area2D)-> bool:
	return obj.has_overlapping_bodies()
	#return !obj.get_overlapping_bodies().size()==0
	
func wonder():
	var multipier = randf_range(0.5, 1)
	if !has_floor(ground_right):
		direction = -1 
	elif !has_floor(ground_left): 
		direction = 1
	else:
		direction = [-1, 1].pick_random()		
	velocity.x  = direction * SPEED * multipier
	timer_walk.wait_time = get_walk_time()
	timer_walk.start()
	timer_walk.timeout.connect(wait)
func wait():
	velocity = Vector2.ZERO
	timer_wait.wait_time =get_wait_time()
	timer_wait.start()
	timer_wait.timeout.connect( wonder)
			
	
func set_state(new_state: State):
	if state == new_state:
		return

	if new_state == State.Idle:
		state = State.Idle	
	if new_state == State.Wandering:
		state = State.Wandering
	if new_state == State.Chasing:
		state = State.Chasing
	
	

	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer_wait  =  Timer.new()
	timer_wait.one_shot = true
	timer_wait.wait_time = get_wait_time()
	timer_walk = Timer.new()
	timer_walk.one_shot = true
	timer_walk.wait_time = get_walk_time()
	timer_lose_sight = Timer.new()
	timer_lose_sight.one_shot = true
	timer_lose_sight.wait_time = 1
	add_child(timer_wait)
	add_child(timer_walk)
	add_child(timer_lose_sight)
	timer_lose_sight.timeout.connect(func():
		set_state (State.Idle)
	)
	node = Node2D.new()
	add_child(node)
	node.position = Vector2.ZERO
	for i in range(RAYCAST_AMOUNT):
		node.add_child(get_ray())
		pass
	pass
	wonder()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if state == State.Chasing:
		var vector =   player.position - position
		look(vector.normalized()) 
		if player_in_vision == false:		
			velocity.x = 0
		else:
			timer_lose_sight.start()

			var dir = 1
			if vector.x < 0:
				dir = -1
			velocity.x = dir * SPEED
	else:
		look(Vector2(direction, velocity.y).normalized())
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	if velocity.x > 0:
		if !has_floor(ground_right):
			velocity.x = 0
	if velocity.x < 0:
		if !has_floor(ground_left):
			velocity.x = 0
	
	move_and_slide()
