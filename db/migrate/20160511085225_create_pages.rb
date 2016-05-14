class CreatePages < ActiveRecord::Migration
  def up

    create_table :pages do |t|
      t.string    :title
      t.string    :subtitle
      t.string    :slug,              index: true
      t.text      :body
      t.text      :short_body
      t.integer   :page_id
      t.date      :publish_date
      t.boolean   :active,            default: true
      t.integer   :display_order
      t.boolean   :show_in_menu,      default: true
      t.boolean   :is_required,       default: false
      t.boolean   :is_root,           default: false
      t.boolean   :is_contact,        default: false
      t.string    :page_type,         default: 'page'
      t.string    :published_by
      t.boolean   :is_featured,       default: false
      t.attachment :photo
      t.text      :meta_description
      t.string    :meta_title
      t.integer   :created_by
      t.integer   :last_updated_by
      t.timestamps null: false
    end

  end

  def down
    drop_table :pages
  end
end
