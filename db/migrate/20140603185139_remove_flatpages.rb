class RemoveFlatpages < ActiveRecord::Migration
  def change
    drop_table :flatpages

    p = Permission.find_by_resource("Flatpage")
    UserPermission.where(permission_id: p.id).delete_all
    p.delete
  end
end
