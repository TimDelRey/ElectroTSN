# == Schema Information
#
# Table name: tariffs
#
#  id                :bigint           not null, primary key
#  discription       :text
#  first_step_value  :float
#  is_default        :boolean
#  second_step_value :float
#  third_step_value  :float
#  title             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
require 'rails_helper'

RSpec.describe Tariff, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
