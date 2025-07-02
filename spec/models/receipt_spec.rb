# == Schema Information
#
# Table name: receipts
#
#  id               :bigint           not null, primary key
#  receipt_instance :text
#  signed           :boolean          default(TRUE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer          not null
#
require 'rails_helper'

RSpec.describe Receipt, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
