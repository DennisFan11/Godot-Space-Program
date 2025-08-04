class_name WallMovement
extends Node2D

enum {IDLE, CLIMB, IN_DASH}

@export var target: CharacterBody2D

## 最大速度
@export var MAX_SPEED:Vector2 = Vector2(1000, 2700)

## 加速時間
## 在某些行動方式中不會使用此參數
@export var INCREASE := 70.0

## 減速時間
## 在某些行動方式中不會使用此參數
@export var DECREASE := 20.0 #0.17


func _physics_process(delta: float) -> void:
	var new_velocity = target.velocity
	var vec = Input.get_vector("left", "right", "up", "down")
	
	var state = IDLE
	if _is_climb() and _vec2global(new_velocity).y > 0.0:
		state = CLIMB
	elif _is_dash():
		state = IN_DASH
		
	## 轉向
	if %ClimbRaycast.is_colliding():
		target.rotation = lerp_angle(
			target.rotation, _get_climb_vec().angle() - PI/2.0, delta*15.0)
	else:
		target.rotation = lerp_angle(target.rotation, target.velocity.angle(), delta*1.0)
	
	## 重力歸 0
	if %ClimbRaycast.is_colliding():
		var global_new_velocity = _vec2global(new_velocity)
		if global_new_velocity.y > 0.0:
			global_new_velocity.y = 0.0
			new_velocity = _vec2local(global_new_velocity)
	
	
	match state:
		IDLE:
			# 施加重力
			new_velocity += target.get_gravity() * delta * 10.0

			# 处理左右移动 - 使用動態速度
			if vec.x != 0:
				new_velocity.x = lerp(new_velocity.x, MAX_SPEED.x * vec.x, INCREASE * delta)
			else: # 停止移动
				new_velocity.x = lerp(new_velocity.x, 0.0, DECREASE * delta)

			# 处理跳跃 - 使用動態跳躍力
			if %ClimbRaycast.is_colliding():
				if Input.is_action_just_pressed("space"): 
					new_velocity.y = - MAX_SPEED.y
		
		CLIMB:
			
			var global_new_velocity = _vec2global(new_velocity)
			
			## 牆壁吸附力
			global_new_velocity.y  = 50.0

			## 左右移動
			
			if vec.x != 0:
				global_new_velocity.x = lerp(
					global_new_velocity.x,
				 	MAX_SPEED.x * vec.x, 
					INCREASE * delta)
			else:
				global_new_velocity.x = lerp(
					global_new_velocity.x,
					0.0, 
					DECREASE * delta)
			
			if Input.is_action_just_pressed("space"):
				global_new_velocity.y = 0.0
				global_new_velocity += MAX_SPEED * Vector2.UP
				_dash()
			
			new_velocity = _vec2local(global_new_velocity)
			
		IN_DASH:
			# 施加重力
			new_velocity += target.get_gravity() * delta * 10.0

			# 处理左右移动 - 使用動態速度
			if vec.x != 0:
				new_velocity.x = lerp(new_velocity.x, MAX_SPEED.x * vec.x, INCREASE * delta)
	%Arrow.set_vec(new_velocity)
	target.velocity = new_velocity
	target.move_and_slide()




## 座標轉換 到 輸入坐標系 
func _vec2global(vec: Vector2)-> Vector2:
	return vec.rotated(-target.rotation)

func _vec2local(vec: Vector2)-> Vector2:
	return vec.rotated(target.rotation)

func _get_up_vec()-> Vector2:
	return _vec2local(Vector2.UP)


func _get_climb_vec()-> Vector2:
	var body = (target as CharacterBody2D)
	if body.get_last_slide_collision():
		return body.get_last_slide_collision().get_normal().rotated(PI)
	return %ClimbRaycast.get_closet_point()-target.global_position

func _is_climb()-> bool:
	return %ClimbRaycast.is_colliding() and Input.is_action_pressed("shift")


var in_dash_timer: CooldownTimer = CooldownTimer.new()
func _dash():
	in_dash_timer.trigger(0.5)
func _is_dash()-> bool:
	return not in_dash_timer.is_ready()
