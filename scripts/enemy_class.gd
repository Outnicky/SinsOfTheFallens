class_name EnemyClass extends CharacterBody2D

const FOV = 5
const RAYCAST_AMOUNT = 40
const RAYCAST_DISTANCE = 200
const SPEED =100
const ray = preload("res://scenes/ray.tscn")
var node : Node2D = null

const wait_decrease = 3
var wait_time
var wander_time = 300
const wonder_decrease = 8

var direction =1

func get_ray():
	return ray.instantiate()
	
func  show_rays():
	if node:
		node.queue_free()
	node = Node2D.new()
	var i = 0
	while (i < RAYCAST_AMOUNT):
		var ray = get_ray()
		var angle_rad = deg_to_rad(20  - i * 2)
		var target = Vector2(cos(angle_rad), sin(angle_rad)) * RAYCAST_DISTANCE * direction
		#var line = Line2D.new()
		add_child(node)
		node.position  =  Vector2.ZERO
	#	node.add_child(line)	
		node.add_child(ray)
	#	line.width =1		
	#	line.add_point(Vector2.ZERO)
	#	line.add_point(target)
		ray.target_position = target
		ray.position = Vector2.ZERO
	#	line.visible =  true
		i+=1
		

	
func wonder():
	var timer = get_tree().create_timer(randi_range(0.1, 1))
	timer.timeout.connect(func():
		var multipier = randf_range(0, 1)
		direction = [-1, 1].pick_random()
		var time  = randf_range(0.1, 1)
		
		velocity.x  = direction * SPEED
		var new_timer = get_tree().create_timer(time)
		new_timer.timeout.connect(func():
			velocity = Vector2.ZERO
			wonder()
		))
		
			
			
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wonder()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	move_and_slide()
