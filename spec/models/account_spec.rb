require 'rails_helper'
require 'util'
include Util
RSpec.describe Account, :type => :model do
  before :each do
    @brazil = create(:team)
    @argentina = create(:team)
  end
  it "should dole to account whose funds less than 100 and no frozen values" do
    expect([nil,100]).to include(get_value_from_config("dole_value"))
    user = double('User', :email => 'fake@email.com')
    allow_any_instance_of(Account).to receive(:user).and_return(user)
    ac1=Account.create(:available => 200, :frozen_value => 100)
    ac2=Account.create(:available => 55, :frozen_value => 2)
    ac3=Account.create(:available => 0, :frozen_value => 100)
    ac4=Account.create(:available => 44, :frozen_value => 0)
    ac5=Account.create(:available => 4, :frozen_value => 0)

    2.times do
      Account.dole
      ac1.reload
      expect(ac1.available).to eq 200
      expect(ac1.frozen_value).to eq 100
      ac2.reload
      expect(ac2.available).to eq 55
      expect(ac2.frozen_value).to eq 2
      ac3.reload
      expect(ac3.available).to eq 0
      expect(ac3.frozen_value).to eq 100
      ac4.reload
      expect(ac4.available).to eq 100
      expect(ac4.frozen_value).to eq 0
      expect(ac4.logs[-1].change).to eq 56
      expect(ac4.logs[-1].source).to eq AccountLog::DOLE
      expect(ac4.logs.size).to eq 1
      ac5.reload
      expect(ac5.available).to eq 100
      expect(ac5.frozen_value).to eq 0
      expect(ac5.logs[-1].change).to eq 96
      expect(ac5.logs[-1].source).to eq AccountLog::DOLE
      expect(ac5.logs.size).to eq 1
    end
  end

  it "should take tax from people who bet less than 50%" do
    game=Game.create(:host_id => @brazil.id, :guest_id => @argentina.id, :date => Time.now+10.hours, :host_win_odds => 1.8, :draw_odds => 2.7, :guest_win_odds => 3.8, :balance => 1)
    user = double('User', :email => 'fake@email.com', :is_dealer? => false)
    allow_any_instance_of(Account).to receive(:user).and_return(user)
    ac1=Account.create(:available => 200, :frozen_value => 100)
    ac1=Account.create(:available => 1000, :frozen_value => 2000)
    ac2=Account.create(:available => 1000, :frozen_value => 1000)
    ac3=Account.create(:available => 1000, :frozen_value => 999)
    ac4=Account.create(:available => 1000, :frozen_value => 0)
    ac5=Account.create(:available => 0, :frozen_value => 100)

    [ac1,ac2,ac3,ac4,ac5].each do|ac|
      expect(ac.taxed_in_last_cycle?).not_to be true
    end

    2.times do
      Account.tax
      ac1.reload
      expect(ac1.available).to eq 1000
      expect(ac1.frozen_value).to eq 2000
      ac2.reload
      expect(ac2.available).to eq 1000
      expect(ac2.frozen_value).to eq 1000
      ac3.reload
      expect(ac3.available).to eq 900
      expect(ac3.frozen_value).to eq 999
      ac4.reload
      expect(ac4.available).to eq 900
      expect(ac4.frozen_value).to eq 0
      expect(ac4.logs[-1].change).to eq -100
      expect(ac4.logs[-1].source).to eq AccountLog::TAX
      ac5.reload
      expect(ac5.available).to eq 0
      expect(ac5.frozen_value).to eq 100
      [ac1,ac2,ac5].each do|ac|
        expect(ac.taxed_in_last_cycle?).to be false
      end
      [ac3,ac4].each do|ac|
        expect(ac.taxed_in_last_cycle?).to be true
      end
    end
  end
end
