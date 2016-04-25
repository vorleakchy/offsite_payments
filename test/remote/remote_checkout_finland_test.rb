require 'test_helper'
require 'remote_test_helper'

class RemoteCheckoutFinlandTest < Test::Unit::TestCase
  include RemoteTestHelper

  def setup
    @stamp = Time.now.to_i.to_s # Unique identifier for the payment with all information
    @stamp2 = (Time.now.to_i+1000).to_s # Unique identifier for the payment with minimal
    @amount = "200" # Amount in cents
    @currency = "EUR"
    @credential = "375917" # Account number
    @credential2 = "SAIPPUAKAUPPIAS" # Account secret
  end

  def test_valid_payment_page_minimal_fields
    payment_page = submit %(
        <% payment_service_for('#{@stamp}', '#{@credential}', :service => :checkout_finland, :amount => #{@amount}, :currency => '#{@currency}',:credential2 => '#{@credential2}') do |service| %>
          <% service.language = 'FI' %>
          <% service.reference = '123123123' %>
          <% service.content = '1' %>
          <% service.delivery_date = '20140110' %>
          <% service.notify_url = 'http://example.org/return' %>
          <% service.reject_url = 'http://example.org/return' %>
          <% service.return_url = 'http://example.org/return' %>
          <% service.cancel_return_url = 'http://example.org/return' %>
        <% end %>
      )

      assert_match(%r(Testi Oy)i, payment_page.body)
      assert_match(%r(Testikuja 1)i, payment_page.body)
      assert_match(%r(12345 Testi)i, payment_page.body)
  end

  def test_valid_payment_page_all_fields
    payment_page = submit %(
        <% payment_service_for('#{@stamp2}', '#{@credential}', :service => :checkout_finland, :amount => #{@amount}, :currency => '#{@currency}',:credential2 => '#{@credential2}') do |service| %>
          <% service.customer :first_name => "Tero",
            :last_name => 'Testaaja',
            :phone => '0800 552 010',
            :email => 'support@checkout.fi' %>
          <% service.language = 'FI' %>
          <% service.billing_address :address1 => 'Testikatu 1 A 10',
            :city => 'Helsinki',
            :zip => '00100',
            :country => 'FIN' %>
          <% service.reference = '123123123' %>
          <% service.content = '1' %>
          <% service.delivery_date = '20140110' %>
          <% service.description = 'Remote test items' %>
          <% service.notify_url = 'http://example.org/return' %>
          <% service.reject_url = 'http://example.org/return' %>
          <% service.return_url = 'http://example.org/return' %>
          <% service.cancel_return_url = 'http://example.org/return' %>
        <% end %>
      )

      assert_match(%r(Tero Testaaja)i, payment_page.body)
      assert_match(%r(Testikatu 1 A 10)i, payment_page.body)
      assert_match(%r(Remote test items)i, payment_page.body)
  end

end
