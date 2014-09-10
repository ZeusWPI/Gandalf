require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  setup do
    @ticket = tickets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tickets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ticket" do
    assert_difference('Ticket.count') do
      post :create, ticket: { barcode: @ticket.barcode, barcode_data: @ticket.barcode_data, checked_in_at: @ticket.checked_in_at, comment: @ticket.comment, email: @ticket.email, event_id: @ticket.event_id, gsm: @ticket.gsm, name: @ticket.name, order_id: @ticket.order_id, student_number: @ticket.student_number }
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should show ticket" do
    get :show, id: @ticket
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ticket
    assert_response :success
  end

  test "should update ticket" do
    patch :update, id: @ticket, ticket: { barcode: @ticket.barcode, barcode_data: @ticket.barcode_data, checked_in_at: @ticket.checked_in_at, comment: @ticket.comment, email: @ticket.email, event_id: @ticket.event_id, gsm: @ticket.gsm, name: @ticket.name, order_id: @ticket.order_id, student_number: @ticket.student_number }
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  test "should destroy ticket" do
    assert_difference('Ticket.count', -1) do
      delete :destroy, id: @ticket
    end

    assert_redirected_to tickets_path
  end
end
