require 'test_helper'

class MemberTest < ActiveSupport::TestCase

  test "get role names, one role" do
    admin = members :admin
    admin.roles << roles(:admin)
    assert admin.role_names.include?(:admin)
  end

  test "get role names, two role" do
    admin = members :admin
    admin.roles << roles(:admin)
    admin.roles << roles(:publisher)
    role_names = admin.role_names
    assert admin.role_names.include?(:admin)
    assert admin.role_names.include?(:publisher)
  end

  test "get role names, exclude invalid roles" do
    contract = Factory.create :publisher_contract
    publisher = Factory.create :member, :party=>contract.party
    publisher.roles << roles(:ad_owner)
    role_names = publisher.role_names
    assert_equal 1, role_names.size
    assert role_names.include?(:member)
  end

  test "admin is system super admin" do
    admin = members :admin
    assert admin.role_names.include?(:super_admin)
  end

  test "other party's admin is not super admin" do
    publisher = Factory.create :member
    publisher.roles << Role.find_by_code('admin')
    assert ! publisher.role_names.include?(:super_admin)
  end

  test "everyone has role 'member'" do
    Member.all.each { |m| assert m.role_names.include?(:member) }
  end

  context "Member#delegated_ad_owners" do
    context "when self's party is ad owner" do
      setup { 
        @ad_owner = Factory.create(:party, :ad_maintained_by=>Party::AD_MAINTAINED_BY_CUSTOMER)
        ad_owner_contract = Factory.create(:ad_owner_contract, :party=>@ad_owner)
        @member = Factory.create :member, :party=>@ad_owner
      }

      context "and has no role" do
        should "return empty result" do
          assert @member.delegated_ad_owners.empty?
        end
      end

      context "and has ad_owner role" do
        setup { @member.roles <<  roles(:ad_owner) }
       
        should "include own party only" do
          delegated_ad_owners = @member.delegated_ad_owners
          assert_equal 1, delegated_ad_owners.size
          assert @ad_owner, delegated_ad_owners[0]
        end
      end
    end

    context "when member's party is an agent" do
      setup { 
        @ad_owner = Factory.create(:ad_owner_contract).party
        @member = Factory.create :member, :party=>Factory.create(:agent_contract).party
      }      

      should "return empty if there are no customers " do
        assert @member.delegated_ad_owners.empty?
      end

      should "return empty event if member has role 'ad_owner' " do
        @member.roles << roles(:ad_owner)
        assert @member.delegated_ad_owners.empty?        
      end

      context "and given a customer delegate ad maintaining to sales" do
        setup {
          @ad_owner.update_attributes! :ad_maintained_by=>Party::AD_MAINTAINED_BY_SALES, :sales=>@member
        }

        should "include that customer when member has role 'sales' " do
          @member.roles << roles(:sales)
          delegate_ad_owners = @member.delegated_ad_owners
          assert_equal 1, delegate_ad_owners.size
          assert delegate_ad_owners.include?(@ad_owner)
        end

        should "return empty result if member has role 'sales' but not this customer's sales" do
          @member.roles << roles(:sales)
          @ad_owner.update_attributes! :sales => Factory.create (:member)
          assert @member.delegated_ad_owners.empty?
        end

        should "return empty result if member has no role 'sales' " do
          assert @member.delegated_ad_owners.empty?
        end

        should "return empty result even if member has role 'agent' " do
          @member.roles << roles(:agent)
          assert @member.delegated_ad_owners.empty?
        end
      end

      context 'when given a customer delegate ad maintainin to agent' do
        setup {
          @ad_owner.update_attributes! :ad_maintained_by=>Party::AD_MAINTAINED_BY_ADMIN
        }        

        should "include that customer if member has role 'agent' " do
          @member.roles << roles(:agent)
          delegate_ad_owners = @member.delegated_ad_owners
          assert_equal 1, delegate_ad_owners.size
          assert delegate_ad_owners.include?(@ad_owner)
        end

        should "return empty result if member has no role 'agent' " do
          assert @member.delegated_ad_owners.empty?
        end
      end
    end
  end
end
