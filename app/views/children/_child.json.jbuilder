json.extract! child, :id, :first_name, :birthday, :notes, :user_id, :created_at, :updated_at
json.url child_url(child, format: :json)
