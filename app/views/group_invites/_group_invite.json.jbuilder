json.extract! group_invite, :id, :group_id, :first_name, :email, :last_emailed, :user_id, :notes, :created_at, :updated_at
json.url group_invite_url(group_invite, format: :json)
