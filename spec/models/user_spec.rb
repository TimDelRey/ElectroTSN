# == Schema Information
#
# Table name: users
#
#  id           :bigint           not null, primary key
#  first_name   :string           not null
#  last_name    :string
#  name         :string
#  place_number :integer          not null
#  users_tariff :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
