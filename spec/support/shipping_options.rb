RSpec.shared_context 'Shipping Options', :a => :b do
  let(:shipper) { {
    company_name: 'Veeqo Limited',
    phone_number: '01792 123456',
    address_line_1: '11 Wind Street',
    city: 'Swansea',
    state: 'Wales',
    postal_code: 'SA1 1DA',
    country: 'GB',
    shipper_number: ENV['UPS_ACCOUNT_NUMBER']
  } }
  let(:ship_to) { {
    company_name: 'Google Inc.',
    phone_number: '0207 031 3000',
    address_line_1: '1 St Giles High Street',
    city: 'London',
    state: 'England',
    postal_code: 'WC2H 8AG',
    country: 'GB'
  } }
  let(:package) { {
    weight: '0.5',
    unit: 'KGS'
  } }
end
