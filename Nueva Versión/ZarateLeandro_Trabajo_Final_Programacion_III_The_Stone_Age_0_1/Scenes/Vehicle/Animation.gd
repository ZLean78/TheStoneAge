extends Node2D



func _animate(sprite,velocity,target_position):
	
	if velocity.y < 0:
		if abs(velocity.y) > abs(velocity.x):
			sprite.animation = "vertical"
			sprite.flip_v=false	
		else:
			sprite.animation = "horizontal"
			sprite.flip_v=false
	if velocity.x < 0:
		if abs(velocity.y) > abs(velocity.x):
			sprite.animation = "vertical"
			sprite.flip_v=false
		else:
			sprite.animation = "horizontal"
			sprite.flip_v=false
		
						
	if velocity.y > 0:
		if abs(velocity.y) > abs(velocity.x):
			sprite.animation = "vertical"
			sprite.flip_v=true	
		else:
			sprite.animation = "horizontal"
			sprite.flip_v=false
			
	if velocity.x > 0:
		if abs(velocity.y) > abs(velocity.x):
			sprite.animation = "vertical"
			sprite.flip_v=false
		else:
			sprite.animation = "horizontal"
			sprite.flip_v=false	
