json.extract! message, :id, :room_id, :user_id, :text, :created_at, :updated_at
json.user do
  json.partial! message.user, partial: "users/user", as: :user
end