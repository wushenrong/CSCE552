extends Node2D


var on_wave_cleared: Callable
var on_wave_failed: Callable


func _on_wave_manager_wave_cleared(wave: int, owned_rewards: Array) -> void:
	on_wave_cleared.call(wave, owned_rewards)


func _on_wave_manager_wave_failed(wave: int, owned_rewards: Array) -> void:
	on_wave_failed.call(wave, owned_rewards)
