class_name LevelRes
extends Resource

## displays the upcoming day and allows for story integration
@export var day_start_scene : PackedScene

## amount of machines available in this level
@export var machine_amount : int = 1

## amount of baskets available in this level
@export var baskset_amount : int = 1

## all customers visiting in this level
@export var customer_array : Array[CustomerProfile]
