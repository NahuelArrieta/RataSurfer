extends Node3D

const MODULE_1 = preload("res://Level/module_1.tscn")
const MODULE_2 = preload("res://level/module_2.tscn")
const MODULE_3 = preload("res://level/module_3.tscn")
const MODULE_4 = preload("res://level/module_4.tscn")
const MODULE_5 = preload("res://level/module_5.tscn")
const MODULE_6 = preload("res://level/module_6.tscn")
const MODULE_7 = preload("res://level/module_7.tscn")
const MODULE_8 = preload("res://level/module_8.tscn")
const MODULE_9 = preload("res://level/module_9.tscn")
const MODULE_10 = preload("res://level/module_10.tscn")
const MODULE_11 = preload("res://level/module_11.tscn")
const MODULE_12 = preload("res://level/module_12.tscn")
const MODULE_13 = preload("res://level/module_13.tscn")
const MODULE_14 = preload("res://level/module_14.tscn")
const MODULE_15 = preload("res://level/module_15.tscn")
const MODULE_16 = preload("res://level/module_16.tscn")
const MODULE_17 = preload("res://level/module_17.tscn")

const MODULE_DEPTH := 30.8

var module_array := [MODULE_1, MODULE_2, MODULE_3, MODULE_4, MODULE_5, MODULE_6,
	MODULE_7, MODULE_8, MODULE_9, MODULE_10, MODULE_11, MODULE_12, MODULE_13, MODULE_14, MODULE_15, MODULE_16]
var marker : Marker3D


func _ready() -> void:
	_spawn_modules(15)

func _spawn_modules(n):
	var z_position
	if marker:
		z_position = marker.global_position.z
	else:
		z_position = 0
	
	for i in range(n): # cambia 10 por la cantidad que quieras de inicio
		var module_instance = module_array.pick_random().instantiate()
		add_child(module_instance)
		module_instance.global_position.z = z_position
		
		z_position -= MODULE_DEPTH
		
		if i == n-1:
			marker = Marker3D.new()
			module_instance.add_child(marker)
			marker.position.z -= MODULE_DEPTH 


func _on_timer_timeout() -> void:
	var removed: int = 0
	for child in get_children():
		var module := child as Node3D
		if !module: 
			continue
		
		var z_position := module.global_position.z
		if z_position > MODULE_DEPTH:
			removed += 1
			module.queue_free()
	
	
	if removed > 0:
		_spawn_modules(removed)
