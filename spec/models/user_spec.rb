require 'spec_helper'

describe User do
  it { should_not allow_mass_assignment_of(:faculty_number) }
  it { should_not allow_mass_assignment_of(:full_name) }
  it { should_not allow_mass_assignment_of(:email) }
  it { should_not allow_mass_assignment_of(:admin) }

  it "displays only first and last name" do
    Factory.build(:user, :full_name => 'Петър Иванов').name.should == 'Петър Иванов'
    Factory.build(:user, :full_name => 'Петър Петров Иванов').name.should == 'Петър Иванов'
    Factory.build(:user, :full_name => 'Петър Петров Петров Иванов').name.should == 'Петър Иванов'
  end

  describe "pagination" do
    it "sorts by creation time, older users first" do
      second = User.make :created_at => 2.days.ago
      third  = User.make :created_at => 1.day.ago
      first  = User.make :created_at => 3.days.ago

      User.page(1).should == [first, second, third]
    end

    it "puts users with photos before users without photos" do
      second = User.make :created_at => 2.days.ago
      first  = User.make :created_at => 1.day.ago, :photo => uploaded_photo

      User.page(1).should == [first, second]
    end
  end
end
