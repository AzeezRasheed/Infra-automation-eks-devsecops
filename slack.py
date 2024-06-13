
slack_message = "Can I get some assistance with my account?"
user_id = "U12345"
channel_id = "C67890"
event_ts = "1624380000.000400"

keywords = {
    ("help", "assistance", "support", "guide", "resolve", "reconciliation"): {
        "summary": "Help request from Slack",
        "description": "User  asked for help:",
        "response": "Thanks for reaching out,  We're here to help you.",
        "issue_type": "Task",
    },
    # You can add more keyword sets and configurations here
}

# print(keywords.items())

for keyword_set, config in keywords.items():
    if any(keyword in slack_message.lower() for keyword in keyword_set):
        try:
            # Respond to the user in Slack
            print(keyword_set)
            print(config)
            break
        except Exception as e:
            print(f"Error: {e}")