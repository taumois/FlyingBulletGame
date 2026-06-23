extends Node2D

const FULL_ROTATION = 2 * PI
const CHUNK_SIZE = 500
const HOUSES_PER_CHUNK = 1
const HOUSES_SCALE = Vector2(0.3, 0.3)
const CHUNK_HOUSE = preload("res://scenes/house.tscn")
const CHUNK_BACKDROP = preload("res://scenes/white_backdrop.tscn")

var bullet: CharacterBody2D
var loaded_chunks: Array[Chunk]
var house_bank: Array[StaticBody2D]
var seeds: Array[float]
var bullet_chunk: Chunk

func _ready() -> void:
	bullet = %Bullet
	for i in seeds.size():
		seeds[i] = randf()
	loaded_chunks.resize(9)
	house_bank.resize(9 * HOUSES_PER_CHUNK)
	for i in house_bank.size():
		var house = CHUNK_HOUSE.instantiate()
		house.scale = HOUSES_SCALE
		house_bank[i] = house
	bullet_chunk = get_bullet_current_chunk()
	for i in loaded_chunks.size():
		var chunk = Chunk.new(Vector2i.ZERO)
		loaded_chunks[i] = chunk


func get_bullet_current_chunk() -> Chunk:
	var chunk_position = Vector2i(roundi(bullet.position.x / CHUNK_SIZE), roundi(bullet.position.y / CHUNK_SIZE))
	var chunk = Chunk.new(chunk_position)
	return chunk


func _process(delta: float) -> void:
	var bullet_current_chunk = get_bullet_current_chunk()
	if bullet_current_chunk.is_chunk(bullet_chunk):
		return
	bullet_chunk = bullet_current_chunk
	for i in loaded_chunks.size():
		remove_child(loaded_chunks[i].houses[0])
		loaded_chunks[i].houses.clear()
		var chunk = Chunk.new(Vector2i((i % 3) - 1 + bullet_chunk.position.x, roundi(i / 3 - 1.25) + bullet_chunk.position.y))
		var house = get_house_from_bank()
		house.position = chunk.real_position
		add_child(house)
		chunk.houses[0] = house
		loaded_chunks[i] = chunk


func get_house_from_bank() -> StaticBody2D:
	for house in house_bank:
		if house.get_parent() == null:
			return house
	print("This shouldn't be printed")
	return null


class Chunk:
	var position: Vector2i
	var real_position: Vector2
	var houses: Array[StaticBody2D]
	var key
	
	func _init(position: Vector2i) -> void:
		self.position = position
		self.real_position = position * CHUNK_SIZE
		key = rand_from_seed((position.x + 2) * position.y + position.x)[0] % HOUSES_PER_CHUNK * 9
		houses.resize(HOUSES_PER_CHUNK)
	
	
	func is_chunk(chunk: Chunk) -> bool:
		return position == chunk.position
