class RemoveQue < ActiveRecord::Migration[5.0]
  def change
    drop_table :que_jobs
  end
end
