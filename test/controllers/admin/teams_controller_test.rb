require 'test_helper'

module Admin
  class TeamsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :teams, :residents

    setup do
      @team = teams(:staff)
      sign_in(residents(:staff_member))
    end

    test 'should get index' do
      get admin_teams_url
      assert_response :success
    end

    test 'should get new' do
      get new_admin_team_url
      assert_response :success
    end

    test 'should create team' do
      assert_difference('Team.count') do
        post admin_teams_url, params: { team: { name: @team.name } }
      end

      assert_redirected_to admin_team_url(Team.last)
    end

    test 'should show team' do
      get admin_team_url(@team)
      assert_response :success
    end

    test 'should get edit' do
      get edit_admin_team_url(@team)
      assert_response :success
    end

    test 'should update team' do
      patch admin_team_url(@team), params: { team: { name: @team.name } }
      assert_redirected_to admin_team_url(@team)
    end

    test 'should destroy team' do
      assert_difference('Team.count', -1) do
        delete admin_team_url(@team)
      end

      assert_redirected_to admin_teams_url
    end
  end
end
