extends ColorRect

func change(oldScene, newScene):
	visible = true
	get_node("Animation").play("FadeOut") 
	yield(get_tree().create_timer(0.25), "timeout")
	oldScene.visible = false
	get_node("Animation").play("FadeIn")
	yield(get_tree().create_timer(0.25), "timeout")
	visible = false
	newScene.visible = true
