@tool
extends Node3D
## Tool scene to automatically prepare scene files for all exhibits
##

## JSON file containing base path and properties of all exhibits.
@export_file("*.json") var library_file : String = "":
	set(new_file):
		library_file = new_file
		if Engine.is_editor_hint():
			update_exhibits()
		
## Size in meter to which all exhibits may be scaled for spawning
@export var uniform_size : float = 0.3

## Spacing of the imported scenes. Just for visualization inside the importer
## scene.
@export var visual_distance : float = 0.2

## Keep processed scenes to visualize them in the editor
var scenes = []

## Create a new scene file with collision for a single exhibit
##
## Required information will be extracted from the dictionary.
## A glb with the scene name will be loaded. Afterwards a static body with
## a convex collision shape will be generated.
##
func create_scene(e:Dictionary):
	var filename = Library.base_path+e["scene"]
	var src : PackedScene = load(filename+".glb")
	
	# Check success of file loading
	if not src:
		return
	
	# Instatiate the scene for editing
	var exhibit : Exhibit = Exhibit.new()
	exhibit.name = e["name"]
	
	var scale_node = Node3D.new()
	scale_node.name = "ScaleNode"
	exhibit.add_child(scale_node)
	scale_node.owner = exhibit
	exhibit.scale_node = scale_node
	
	var model = src.instantiate()
	scale_node.add_child(model)
	model.owner = exhibit
	
	# Start with an empty AABB to determine the models size
	var aabb = AABB()
	
	# Create collision for all mesh instances
	for c in model.get_children():
		if c is MeshInstance3D:
			if aabb.has_volume():
				aabb.merge(c.mesh.get_aabb())
			else:
				aabb = c.mesh.get_aabb()
			c.create_convex_collision(true, true)
			
			for s in c.get_children():
				if s is StaticBody3D:
					for col in s.get_children():
						col.owner = null
						s.remove_child(col)
						exhibit.add_child(col)
						col.owner = exhibit
						#col.disabled = true
						exhibit.collision_original.append(col)
					c.remove_child(s)
	
	# Assign the final AABB to measure the models dimensions
	exhibit.aabb = aabb
	exhibit.custom_scale = uniform_size / aabb.get_longest_axis_size()
	
	# Create scaled copies of the collision shapes
	for col in exhibit.collision_original:
		#var col_scaled = CollisionShape3D.new()
		var shape : ConvexPolygonShape3D = col.shape#.duplicate()
		
		for i in range(len(shape.points)):
			shape.points[i] = shape.points[i]*exhibit.custom_scale
		
	
	# Convert the result into a packed scene and save it as scene file
	var scene = PackedScene.new()
	var result = scene.pack(exhibit)
	if result == OK:
		# Only save if scene packing was successful
		var error = ResourceSaver.save(scene, filename+".tscn")
		if error != OK:
			push_error("An error occurred while saving the scene '%s' to disk."%filename)
		else:
			print("Successfully saved scene '%s' to disk."%filename)
			self.scenes.append(scene)

## Read the current library file and procedurally create scene files
##
## For every exhibit [method create_scene] will be called.
##
func update_exhibits():
	if library_file.is_empty():
		return
	
	# Read the complete JSON file
	if !Library.load_from_file(library_file):
		return
	
	scenes = []
	
	# Create scene files
	for e in Library.exhibits:
		create_scene(e)
	
	# Clear all children
	for c in get_children():
		remove_child(c)
		c.queue_free()
	# Insert all loaded models into the importer scene for visualization
	for i in len(scenes):
		var node : Node3D = scenes[i].instantiate()
		add_child(node)
		node.position.x = i * visual_distance
		
