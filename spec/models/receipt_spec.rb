# == Schema Information
#
# Table name: receipts
#
#  id          :bigint           not null, primary key
#  for_month   :date
#  receipt_url :string
#  signed      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
require 'rails_helper'

RSpec.describe Receipt, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
