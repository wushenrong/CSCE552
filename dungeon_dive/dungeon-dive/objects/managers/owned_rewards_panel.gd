extends PanelContainer


@onready var reward_list: VBoxContainer = $RewardScroll/RewardList
@onready var rewards_manager = $"../RewardsManager"


func _ready() -> void:
	rewards_manager.rewards_changed.connect(refresh_rewards.bind())
	refresh_rewards()


func refresh_rewards() -> void:
	for child in reward_list.get_children():
		child.queue_free()

	var rewards = rewards_manager.get_rewards()

	if rewards.is_empty():
		return

	for reward in rewards:
		var reward_button = Button.new()
		reward_button.text = reward["name"]
		reward_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		reward_button.tooltip_text = reward["description"]
		reward_list.add_child(reward_button)
