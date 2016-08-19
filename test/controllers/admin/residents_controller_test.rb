require 'test_helper'

module Admin
  class ResidentsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :teams, :residents

    setup do
      @team = teams(:staff)
      @resident = residents(:staff_member)
    end

    include AssertAuthAdmin
    test 'authentication' do
      url = admin_team_residents_url(@team)
      redirects_to_root_url_non_authenticate_admin(url)
    end

    test 'should get index' do
      sign_in(@resident)
      get admin_team_residents_url(@team)
      assert_response :success
    end

    test 'should get new' do
      sign_in(@resident)
      get new_admin_team_resident_url(@team)
      assert_response :success
    end

    test 'should create resident' do
      sign_in(@resident)
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
      assert_redirected_to admin_team_residents_path(Resident.last.team)
    end

    test 'should get edit' do
      sign_in(@resident)
      get edit_admin_team_resident_path(@resident.team, @resident)
      assert_response :success
    end

    test 'should update resident' do
      sign_in(@resident)
      patch admin_team_resident_url(@team, @resident), params: {
        resident: {
          email: @resident.email,
          firstname: @resident.firstname,
          lastname: @resident.lastname,
          admin: true,
          team_id: 1
        }
      }
      assert_redirected_to admin_team_residents_url(@team)
    end

    test 'should destroy resident' do
      sign_in(@resident)
      assert_difference('Resident.count', -1) do
        delete admin_team_resident_url(@team, @resident)
      end

      assert_redirected_to admin_team_residents_url
    end
  end
end
