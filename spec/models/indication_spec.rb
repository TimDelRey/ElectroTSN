# == Schema Information
#
# Table name: indications
#
#  id          :bigint           not null, primary key
#  reading     :float            not null
#  tariff_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer          not null
#
require 'rails_helper'

RSpec.describe Indication, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
