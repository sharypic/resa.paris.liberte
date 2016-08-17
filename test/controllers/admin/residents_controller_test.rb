require 'test_helper'
module Admin
  class AdminResidentsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :teams, :residents

    setup do
      @team = teams(:staff)
      @resident = residents(:staff_member)
      sign_in(@resident)
    end

    test 'should get index' do
      get admin_team_residents_url(@team)
      assert_response :success
    end

    test 'should get new' do
      get new_admin_team_resident_url(@team)
      assert_response :success
    end

    test 'should create resident' do
      assert_difference('Resident.count') do
        post admin_team_residents_url(@team), params: {
          resident: {
            email: 'Hello@world.net',
            firstname: 'hellp',
            lastname: 'world',
            password: 'kthxbye',
            team_id: @team.id
          }
        }
      end
      assert_redirected_to admin_team_resident_path(Resident.last.team,
                                                    Resident.last)
    end

    test 'should show resident' do
      get admin_team_resident_url(@resident.team, @resident)
      assert_response :success
    end

    test 'should get edit' do
      get edit_admin_team_resident_path(@resident.team, @resident)
      assert_response :success
    end

    test 'should update resident' do
      patch admin_team_resident_url(@team, @resident), params: {
        resident: {
          email: @resident.email,
          firstname: @resident.firstname,
          lastname: @resident.lastname,
          admin: true,
          team_id: 1
        }
      }
      assert_redirected_to admin_team_resident_url(@team, @resident)
    end

    test 'should destroy resident' do
      assert_difference('Resident.count', -1) do
        delete admin_team_resident_url(@team, @resident)
      end

      assert_redirected_to admin_team_residents_url
    end
  end
end
