# == Schema Information
#
# Table name: indications
#
#  id                 :bigint           not null, primary key
#  all_day_reading    :float
#  day_time_reading   :float
#  for_month          :date             not null
#  is_correct         :boolean          default(TRUE)
#  night_time_reading :float
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer          not null
#
require 'rails_helper'

RSpec.describe Indication, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
