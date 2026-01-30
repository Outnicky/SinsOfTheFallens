class_name AngrySoul extends EnemyClass

@onready var animation_player: AnimatedSprite2D= $AnimatedSprite2D

func flip_character():
	var a = direction
	if a == -1:
		a = 0
	animation_player.flip_h  = a

func _process(delta: float) -> void:
	flip_character()
	

func set_state(new_state: State):
	if state == new_state:
		return
	

	if new_state == State.Idle:
		animation_player.play("Idle")
		
		state = State.Idle	
	if new_state == State.Wandering:
		animation_player.play("Walk")

		state = State.Wandering
	if new_state == State.Chasing:
		animation_player.play("Attack")
		state = State.Chasing
	


	
