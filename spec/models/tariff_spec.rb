# == Schema Information
#
# Table name: tariffs
#
#  id           :bigint           not null, primary key
#  discription  :text
#  tariff_value :float            not null
#  title        :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe Tariff, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
