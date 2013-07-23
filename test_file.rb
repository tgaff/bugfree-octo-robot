require 'rspec/autorun'
require 'rr'

class Demo1
  def doit
    3.times { puts 'did it' }
  end
end

RSpec::describe 'thing' do
  let(:d1) { Demo1 }

  it 'works if the exception is not a variable' do
    #exc = Exception.new('dear God')

    RR::stub(d1).doit { raise 'lord almighty' }

    expect { d1.doit }.to raise_error( 'lord almighty' )
  end

  it 'works if the exception is not a variable' do
    #exc = Exception.new('dear God')

    stub(d1).doit { raise Exception.new('for the love of pete') }

    expect { d1.doit }.to raise_error( 'for the love of pete' )
  end

  it 'works if the exception is not a variable' do
    #exc = Exception.new('dear God')

    stub(d1).doit { raise 'lord almighty' }

    expect { d1.doit }.to raise_error( 'lord almighty' )
  end




  it 'tests my silly code' do
    exc = Exception.new('dear God')

    stub(d1).doit { raise exc }

    expect { d1.doit }.to raise_error( exc )
  end
end

puts 'i finished'
