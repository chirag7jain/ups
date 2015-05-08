require "spec_helper"

describe UPS::Builders::AddressBuilder do
  context "when passed a US Address" do
    let(:address_hash) { {
      address_line_1: '1600 Amphitheatre Parkway',
      city: 'Mountain View',
      state: 'California',
      postal_code: '94043',
      country: 'US',
    } }

    context "with a non-abbreviated state" do
      subject { UPS::Builders::AddressBuilder.new address_hash }

      it "should change the state to be the abbreviated state name" do
        expect(subject.opts[:state]).to eql 'CA'
      end
    end

    context "with a non-abbreviated state with mixed casing" do
      subject { UPS::Builders::AddressBuilder.new address_hash.merge({ state: 'CaLiFoRnIa' }) }

      it "should change the state to be the abbreviated state name" do
        expect(subject.opts[:state]).to eql 'CA'
      end
    end

    context "with an abbreviated state" do
      subject { UPS::Builders::AddressBuilder.new address_hash.merge({ state: 'ca' }) }

      it "should retrun the abbreviated state" do
        expect(subject.opts[:state]).to eql 'CA'
      end
    end
  end

  context "when passed a IE address" do
    let(:address_hash) { {
      address_line_1: 'Barrow Street',
      city: 'Dublin 4',
      state: 'County Dublin',
      postal_code: '',
      country: 'IE',
    } }

    subject { UPS::Builders::AddressBuilder.new address_hash }

    context "normalizes the state field" do

      it "should change the state to be the abbreviated state name" do
        expect(subject.opts[:state]).to eql 'Dublin'
      end
    end

  end
end
